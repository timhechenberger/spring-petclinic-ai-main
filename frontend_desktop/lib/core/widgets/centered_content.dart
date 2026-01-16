import 'package:flutter/material.dart';

class CenteredContent extends StatelessWidget {
  final Widget child;
  final double width;

  const CenteredContent({
    super.key,
    required this.child,
    this.width = 1100,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: child,
      ),
    );
  }
}
