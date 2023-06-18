import 'package:cooing_front/model/config/palette.dart';
import 'package:flutter/material.dart';

Widget loadingView() {
  return WillPopScope(
    onWillPop: () async {
      return false;
    },
    child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
                child: CircularProgressIndicator(
                  color: Palette.mainPurple,
                )),
          ),
        ],
      ),
    ),
  );
}