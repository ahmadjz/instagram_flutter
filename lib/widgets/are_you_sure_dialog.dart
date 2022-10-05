import 'package:flutter/material.dart';
import 'package:instagram_flutter/widgets/my_alert_dialog.dart';
import 'package:instagram_flutter/widgets/my_cancel_button.dart';

class AreYouSureDialog extends StatelessWidget {
  const AreYouSureDialog(
      {Key? key, required this.onSubmit, this.title = "Are you sure?"})
      : super(key: key);
  final String title;
  final void Function() onSubmit;
  @override
  Widget build(BuildContext context) {
    return MyAlertDialog(
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width * 0.80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const MyCancelButton(),
                ElevatedButton(
                  onPressed: onSubmit,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    fixedSize: MaterialStateProperty.all<Size>(
                        Size(MediaQuery.of(context).size.width * 0.50, 30)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
