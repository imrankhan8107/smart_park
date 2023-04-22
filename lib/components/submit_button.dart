import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  const BottomButton(
      {Key? key,
        required this.buttonText,
        required this.onTapButton, required this.decor})
      : super(key: key);
  final String buttonText;
  final void Function() onTapButton;
  final BoxDecoration decor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapButton,
      child: Container(
        decoration: decor,
        width: MediaQuery.of(context).size.width/1.2,
        height: 60,
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
