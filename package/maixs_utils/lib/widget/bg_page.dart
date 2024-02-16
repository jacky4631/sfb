import 'package:flutter/material.dart';

class BgPage extends StatefulWidget {
  final Widget child;

  const BgPage(this.child, {Key? key}) : super(key: key);
  @override
  _BgPageState createState() => _BgPageState();
}

class _BgPageState extends State<BgPage> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
