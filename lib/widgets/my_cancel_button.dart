import 'package:flutter/material.dart';

class MyCancelButton extends StatelessWidget {
  const MyCancelButton({Key? key, this.onTap}) : super(key: key);
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).pop(),
      child: const Text(
        'Cancel',
        style: TextStyle(
            fontSize: 14, color: Colors.red, fontWeight: FontWeight.w400),
      ),
    );
  }
}
