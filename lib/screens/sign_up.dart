import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parking_app/components/customtextfield.dart';
import 'package:parking_app/components/submit_button.dart';
import 'package:parking_app/constants.dart';
import 'package:parking_app/screens/booking_slot.dart';
import 'package:parking_app/user_model.dart' as model;


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _vehicleNo = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),

                CustomTextField(
                    textEditingController: _name,
                    hintText: "Enter Your Name",
                    textInputType: TextInputType.text,
                    maxLines: 1),
                CustomTextField(
                    textEditingController: _age,
                    hintText: "Enter Your Age",
                    textInputType: TextInputType.text,
                    maxLines: 1),
                CustomTextField(
                    textEditingController: _vehicleNo,
                    hintText: "Enter Vehicle Number",
                    textInputType: TextInputType.text,
                    maxLines: 1),
                CustomTextField(
                    textEditingController: _email,
                    hintText: "Enter Your Email",
                    textInputType: TextInputType.text,
                    maxLines: 1),
                CustomTextField(
                    textEditingController: _password,
                    hintText: "Enter Password",
                    textInputType: TextInputType.text,
                    maxLines: 1),
                const SizedBox(
                  height: 10,
                ),
                BottomButton(
                  buttonText: 'Get started',
                  onTapButton: () async {
                    String res = await _submit();
                    if(res=="success"){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BookSlotScreen()));
                    }
                    else{
                      Fluttertoast.showToast(msg: res.toString());
                    }
                  },
                  decor: kSubmitBtnDecor,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Already Have an account?"),
                      Text("Sign In"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _submit() async {
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      model.User user = model.User(
        name: _name.text,
        uid: credential.user!.uid,
        email: _email.text,
        age: int.parse(_age.text),
        vehicleNo: _vehicleNo.text,
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toJson());

      _auth.authStateChanges();
      return "success";
    } on FirebaseAuthException catch (e) {
      switch(e.code){
        case "email-already-in-use":
          return     "Thrown if there already exists an account with the given email address";
        case  "invalid-email":
          return "Thrown if the email address is not valid.";
        case "operation-not-allowed":
          return "Thrown if email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.";
        case "weak-password":
          return "Thrown if the password is not strong enough.";
        default:
          return e.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }
}
