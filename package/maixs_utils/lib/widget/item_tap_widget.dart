import 'package:flutter/material.dart';

class ItemTapWidget extends StatelessWidget {
  final Widget? child;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Color bgColor;
  final double padding;

  const ItemTapWidget({
    Key? key,
    this.child,
    this.onTap,
    this.onLongPress,
    this.bgColor = Colors.white,
    this.padding = 16.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      child: InkWell(
        // highlightColor: Theme.of(context).primaryColor,
        hoverColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: child,
        ),
        onTap: onTap,
      ),
    );
  }
}
