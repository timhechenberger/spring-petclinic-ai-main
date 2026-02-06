import 'package:flutter/material.dart';

class CenteredContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const CenteredContent({
    super.key,
    required this.child,
    this.maxWidth = 1100,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
