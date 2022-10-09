import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final VoidCallback? onEditingComplete;
  final TextInputType textInputType;
  final FocusNode? focusNode;
  const TextFieldInput(
      {super.key,
      this.focusNode,
      required this.hintText,
      this.onEditingComplete,
      this.isPass = false,
      required this.textEditingController,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      focusNode: focusNode,
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      onEditingComplete: onEditingComplete,
    );
  }
}
