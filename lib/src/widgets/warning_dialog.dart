import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarningYesNo extends StatelessWidget {
  final String title;
  final String msg;
  final String yesMsg;

  const WarningYesNo({Key? key, required this.title, required this.msg, required this.yesMsg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Text(
        msg,
      ),
      actions: <Widget>[
        Container(
          decoration: const BoxDecoration(),
          child: MaterialButton(
            onPressed: () {
              debugPrint('WarningYesNo >> true');
              Get.back(result: true);
            },
            child: Text(yesMsg),
          ),
        ),
      ],
    );
  }
}
