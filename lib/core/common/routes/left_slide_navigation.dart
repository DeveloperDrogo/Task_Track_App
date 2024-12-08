import 'package:flutter/material.dart';

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;

  SlideLeftRoute({required this.page})
      : super(
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            // Define the beginning and end offsets for the slide transition
            const begin = Offset(-1.0, 0.0); // Slide from the left
            const end = Offset.zero;
            const curve =
                Curves.easeInOut; // You can experiment with different curves

            // Define the tween and apply the curve
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            var offsetAnimation = animation.drive(tween);

            // Return the slide transition with an optional duration adjustment
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(
            milliseconds: 500,
          ), // Adjust the duration here
        );
}
