import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../style/size_config.dart';
import 'clock_painter.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Container(
            height: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width / 250),
            width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width / 250),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  color: kShadowColor.withOpacity(0.14),
                  blurRadius: 64,
                ),
              ],
            ),
            child: Transform.rotate(
              angle: -pi / 2,
              child: CustomPaint(
                painter: ClockPainter(context, _dateTime),
              ),
            ),
          ),
        ),
      ],
    );
  }
}