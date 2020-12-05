import 'package:flutter/material.dart';

PageRouteBuilder<T> customPageRoute<T>(WidgetBuilder builder) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.ease));
      final anim = animation.drive(tween);
      
      return AnimatedBuilder(
        animation: anim,
        builder: (_, __) {
          return Opacity(
            opacity: anim.value,
            child: Transform.translate(
              offset: Offset(50 - anim.value * 50, 0),
              child: child,
            )
          );
        }
      );
    }
  );
}

PageRouteBuilder<T> popPageRoute<T>(WidgetBuilder builder) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.ease));
      final anim = animation.drive(tween);
      
      return AnimatedBuilder(
        animation: anim,
        builder: (_, __) {
          return Opacity(
            opacity: anim.value,
            child: Transform.scale(
              scale: 1.025 - (anim.value * 0.025),
              child: child,
            )
          );
        }
      );
    }
  );
}