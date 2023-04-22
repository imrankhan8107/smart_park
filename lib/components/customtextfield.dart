import 'package:flutter/material.dart';
import 'package:parking_app/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    required this.textInputType,
    required this.maxLines,
    this.validatorText,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final String hintText;
  final TextInputType textInputType;
  final int maxLines;
  final String? validatorText;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        decoration: kInputDecoration.copyWith(
          hintText: hintText,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return validatorText;
          }
          return null;
        },
        onSaved: (value) {
          textEditingController.text = value!.trim();
        },
      ),
    );
  }
}


// TextFormField(
// // validator: (value) {
// //   if (value!.isEmpty) {
// //     return 'Please enter some value';
// //   }
// // },
// autofocus: true,
// initialValue: initialText,
// maxLines: maxlines,
// controller: textEditingController,
// obscuringCharacter: '*',
// decoration: InputDecoration(
// hintText: hinttext,
// border: inputBorder,
// focusedBorder: inputBorder,
// enabledBorder: inputBorder,
// filled: true,
// contentPadding: const EdgeInsets.all(15),
// ),
// obscureText: ispass,
// keyboardType: textInputType,
// )