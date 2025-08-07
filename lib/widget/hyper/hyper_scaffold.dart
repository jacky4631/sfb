import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sufenbao/widget/ext.dart';

class HyperScaffold extends StatefulWidget {
  const HyperScaffold({
    Key? key,
    this.backgroundColor,
    this.leftWidth = 400,
    this.centerWidth = 400,
    this.left,
    this.floatingActionButton,
    this.center,
  }) : super(key: key);

  final Color? backgroundColor;
  final double leftWidth;
  final double? centerWidth;
  final Widget? left;
  final Widget? floatingActionButton;

  final Widget? center;

  @override
  _HyperScaffoldState createState() => _HyperScaffoldState();
}

class _HyperScaffoldState extends State<HyperScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      floatingActionButton: widget.floatingActionButton,
      body: Row(children: [
        SizedBox(
          width: widget.leftWidth.autoValue(condition: widget.center == null || 1.w < widget.leftWidth + 300, def: 1.w),
          child: widget.left,
        ),
        Container(
          width: (1.w < 1600) ? null : widget.centerWidth,
          child: widget.center,
        ).flexible(enable: 1.w < 1300).autoValue(condition: 1.w < widget.leftWidth + 300, def: Container()),
      ]),
    );
  }
}
