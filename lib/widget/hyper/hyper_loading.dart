import 'package:flutter/material.dart';

class HyperLoading extends StatefulWidget {
  const HyperLoading({
    super.key,
    this.width,
    this.height,
    this.size,
    this.color,
  });

  final double? width;
  final double? height;
  final double? size;
  final Color? color;

  @override
  State<HyperLoading> createState() => _HyperLoadingState();
}

class _HyperLoadingState extends State<HyperLoading> {
  @override
  Widget build(BuildContext context) {
    final mainColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: CircularProgressIndicator(
          color: mainColor,
          year2023: false,
        ),
        // child: SpinKitFadingCube(
        //   color: color ?? Theme.of(context).colorScheme.primary,
        //   size: size ?? 25,
        // ),
      ),
    );
  }
}
