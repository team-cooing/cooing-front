import 'package:flutter/material.dart';

void networkDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('네트워크 오류'),
          content: Text('네트워크를 확인하세요.'),
          actions: <Widget>[
            OutlinedButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
