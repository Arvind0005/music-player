import 'package:flutter/material.dart';

const pagestyling = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: FractionalOffset(
        0.3, 0.3), // 10% of the width, so there are ten blinds.
    colors: [
      const Color(0xFF414345),
      Colors.black38,
    ], // whitish to gray
    //tileMode: TileMode.repeated, // repeats the gradient over the canvas
  ),
);
