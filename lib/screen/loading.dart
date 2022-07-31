import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kLight,
        body: Center(
          child: SizedBox(
            height: 45.0,
            child: LoadingIndicator(
              indicatorType: Indicator.circleStrokeSpin,
              colors: [kPrimary],
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }
}
