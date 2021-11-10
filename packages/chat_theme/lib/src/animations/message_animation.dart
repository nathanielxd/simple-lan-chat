import 'package:flutter/material.dart';

class MessageAnimation extends StatelessWidget {

  final Animation<double> animation;
  final Widget child;
  final bool right;

  const MessageAnimation({
    required this.animation,
    required this.child,
    this.right = true,
    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
      child: ScaleTransition(
        alignment: right ? Alignment.bottomRight : Alignment.bottomLeft,
        scale: animation,
        child: SlideTransition(
          position: animation.drive(Tween(begin: Offset(right ? 0.2 : -0.2, 0), end: Offset.zero)),
          child: child
        ),
      ),
    );
  }
}