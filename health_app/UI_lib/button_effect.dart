import 'dart:math';
import 'package:flutter/material.dart';

class CircularRevealRoute extends PageRouteBuilder {
  final Widget page;
  final Offset center;
  final Color fillColor;

  CircularRevealRoute({
    required this.page,
    required this.center,
    required this.fillColor,
  }) : super(
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => page,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Calculate final radius to cover the screen.
    final Size screenSize = MediaQuery.of(context).size;
    final double finalRadius =
        sqrt(pow(screenSize.width, 2) + pow(screenSize.height, 2));

    return Stack(
      children: [
        // Fill the background with the blue color.
        Positioned.fill(child: Container(color: fillColor)),
        // Reveal the new page with a circular clip.
        ClipPath(
          clipper: CircularRevealClipper(
            center: center,
            radius: animation.value * finalRadius,
          ),
          child: child,
        ),
      ],
    );
  }
}

class CircularRevealClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  CircularRevealClipper({required this.center, required this.radius});

  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return radius != oldClipper.radius || center != oldClipper.center;
  }
}
