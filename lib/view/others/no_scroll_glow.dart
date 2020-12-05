import 'package:flutter/material.dart';

class NoScrollGlowBehavoir extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection)
    => child;
}