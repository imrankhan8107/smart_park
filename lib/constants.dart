import 'package:flutter/material.dart';


const kAuthScreenBgColor = Color(0xFF120B2B);

var kInputDecoration = InputDecoration(
  hintText: 'Enter text',
  filled: true,
  hintStyle: const TextStyle(
    color: Colors.black54,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(
      color: Colors.yellow.shade700,
      width: 2.0,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: Colors.indigo.shade400,
      width: 2.0,
    ),
  ),
);

const kTextDecor = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);

var kSubmitBtnDecor = BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  gradient: const LinearGradient(
    colors: [
      Colors.blue,
      Colors.indigo,
    ],
  ),
);

var kSelectBtnDecor = BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  border: Border.all(
    color: Colors.cyan,
    width: 2.0,
    style: BorderStyle.solid,
  ),
);
