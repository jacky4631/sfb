import 'package:flutter/material.dart';

class InkBtn extends StatelessWidget {
  final double size;
  final GestureTapCallback onTap;
  final Widget child;
  final Color bwColor;

  const InkBtn({
    Key? key,
    this.size = 56,
    required this.onTap,
    this.child = const Icon(Icons.settings, color: Colors.white),
    this.bwColor = Colors.white10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: bwColor,
          radius: (size - 16) / 2,
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}
