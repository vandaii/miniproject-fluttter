import 'package:flutter/material.dart';
import 'dart:ui';

class AnimatedSidebar extends StatelessWidget {
  final AnimationController controller;
  final bool isSidebarExpanded;
  final Widget child;

  const AnimatedSidebar({
    Key? key,
    required this.controller,
    required this.isSidebarExpanded,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final animValue = controller.value;
        if (animValue < 0.01) return const SizedBox.shrink();
        // Shadow & glow neon dinamis (lebih ringan)
        final boxShadow = [
          BoxShadow(
            color: Colors.black.withOpacity(0.13 + 0.18 * animValue),
            blurRadius: 28 + 18 * animValue,
            offset: Offset(0, 10 * animValue),
          ),
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.10 * animValue),
            blurRadius: 24 * animValue,
            spreadRadius: 2 * animValue,
            offset: Offset(0, 0),
          ),
        ];
        // Efek glassmorphism ringan
        final gradient = LinearGradient(
          colors: [
            Colors.white.withOpacity(0.60 + 0.13 * animValue),
            Colors.pinkAccent.withOpacity(0.07 * animValue),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        final allBoxShadow = [
          ...boxShadow,
          if (animValue > 0.95)
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(0.16),
              blurRadius: 18,
              spreadRadius: 3,
            ),
        ];
        // Content animasi (parallax subtle)
        final contentAnim = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.08, 1.0, curve: Curves.easeOut),
          ),
        );
        return IgnorePointer(
          ignoring: animValue < 0.98,
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(controller),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.12, 0),
                end: Offset.zero,
              ).animate(controller),
              child: Transform.scale(
                scale: Tween<double>(begin: 0.91, end: 1.0).evaluate(controller),
                alignment: Alignment.centerLeft,
                child: Container(
                  width: Tween<double>(begin: 70, end: 250).evaluate(controller),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    color: Colors.white.withOpacity(0.92 + 0.06 * animValue),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(28),
                    ),
                    boxShadow: allBoxShadow,
                    border: Border.all(
                      color: Colors.pinkAccent.withOpacity(0.13 * animValue),
                      width: 1.2 + 1.2 * animValue,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(28),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 14 * animValue + 6,
                        sigmaY: 14 * animValue + 6,
                      ),
                      child: (animValue > 0.08)
                          ? FadeTransition(
                              opacity: contentAnim,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-0.10, 0),
                                  end: Offset.zero,
                                ).animate(contentAnim),
                                child: child,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 