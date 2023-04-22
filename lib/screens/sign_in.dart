import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parking_app/components/submit_button.dart';
import 'package:parking_app/constants.dart';
import 'package:parking_app/components/customtextfield.dart';
import 'package:parking_app/screens/booking_slot.dart';
import 'package:parking_app/screens/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign In"),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height*0.2),
                  CustomTextField(textEditingController: _email, hintText: "Enter Your Email", textInputType: TextInputType.text, maxLines: 1),
                  CustomTextField(textEditingController: _password, hintText: "Enter Password", textInputType: TextInputType.text, maxLines: 1),
                  const SizedBox(
                    height: 13,
                  ),
                  BottomButton(
                    buttonText: 'SIGN IN',
                    onTapButton: () async {
                      String result = await _submit(_email.text,_password.text);
                      if(result=='Yes'){
                        // Navigator.pushReplacement(context, newRoute)
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BookSlotScreen()));
                      }
                      else{
                        Fluttertoast.showToast(msg: result.toString());
                      }
                    },
                    decor: kSubmitBtnDecor,
                  ),
                  const SizedBox(height: 10,),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));

                  }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Don't have an account?"),
                      Text("Sign up"),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<String> _submit(email,password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'Yes';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          return 'Invalid Email.';
        case "wrong-password":
          return 'Wrong Password,\nPlease enter correct password';
        case "user-not-found":
          return 'User Not Found,\nPlease Sign Up';
        default:
          return e.toString();
      }
    }
  }
}
