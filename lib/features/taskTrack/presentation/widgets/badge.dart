// lib/widgets/custom_badge_widget.dart

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:iconly/iconly.dart';

class CustomBadge extends StatelessWidget {
  final int badgeCount;
  final VoidCallback onTap;

  const CustomBadge({
    Key? key,
    required this.badgeCount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: -8, end: -5),
      ignorePointer: false,
      onTap: onTap,
      badgeContent: Text(
        badgeCount.toString(),
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
      ),
      badgeAnimation: const badges.BadgeAnimation.rotation(
        animationDuration: Duration(seconds: 1),
        colorChangeAnimationDuration: Duration(seconds: 1),
        loopAnimation: false,
        curve: Curves.fastOutSlowIn,
        colorChangeAnimationCurve: Curves.easeInCubic,
      ),
      badgeStyle: const badges.BadgeStyle(
        shape: badges.BadgeShape.circle,
        padding: EdgeInsets.all(5),
        elevation: 5,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: const Icon(
          IconlyBroken.notification,
          size: 28,
        ),
      ),
    );
  }
}
