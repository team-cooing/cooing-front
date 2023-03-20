import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  var _time = 0;
  var _isTimering = false;
  final List<String> _saveTimes = [];
  double _timerFontSize = 12;

  setter(double value) => setState(() {
        _timerFontSize = value;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _timerBody());
  }

  Widget _timerBody() {
    var sec = _time ~/ 100;
    var minute = _time ~/ 10000;
    var hour = _time ~/ 100000;

    return Text('남은 시간 $hour: $minute: $sec',
        style: TextStyle(
          color: Colors.white,
          backgroundColor: const Color(0xff9754FB),
          fontSize: _timerFontSize,
        ));
  }

  void _click() {
    _isTimering = !_isTimering;

    if (_isTimering) {
      _start();
    } else {
      _pause();
    }
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  void _pause() {
    _timer?.cancel();
  }

  void _reset() {
    setState(() {
      _isTimering = false;
      _timer?.cancel();
      _saveTimes.clear();
      _time = 0;
    });
  }

  // void _saveTime(String Time){
  //   _saveTimes.insert(0, )
  // }
}
