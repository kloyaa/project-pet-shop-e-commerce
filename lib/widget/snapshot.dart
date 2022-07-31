import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget snapshotSpinner() {
  return Center(
    child: SizedBox(
      height: 45.0,
      child: LoadingIndicator(
        indicatorType: Indicator.circleStrokeSpin,
        colors: [kPrimary],
        strokeWidth: 3,
      ),
    ),
  );
}

Widget snapshotEmptyMessage(message) {
  return Center(
    child: Text(
      message,
      style: GoogleFonts.roboto(
        color: kDark.withOpacity(0.5),
        fontWeight: FontWeight.w300,
        fontSize: 12.0,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
