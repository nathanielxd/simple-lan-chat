import 'package:flutter/material.dart';

enum MessageAnimationSide { left, right }

class MessageAnimation extends StatelessWidget {
  const MessageAnimation({
    required this.animation,
    required this.child,
    this.side = MessageAnimationSide.right,
    Key? key,
  }) : super(key: key);

  final Animation<double> animation;
  final Widget child;
  final MessageAnimationSide side;

  @override
  Widget build(BuildContext context) {
    final rightSided = side == MessageAnimationSide.right;
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
      child: ScaleTransition(
        alignment: rightSided ? Alignment.bottomRight : Alignment.bottomLeft,
        scale: animation,
        child: SlideTransition(
          position: animation.drive(
            Tween(begin: Offset(rightSided ? 0.2 : -0.2, 0), end: Offset.zero),
          ),
          child: child,
        ),
      ),
    );
  }
}
