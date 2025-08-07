import 'package:flutter/material.dart';

class HyperListTile extends StatelessWidget {
  const HyperListTile({super.key, this.margin, this.leading, this.title, this.subtitle, this.onTap, this.trailing});

  final EdgeInsetsGeometry? margin;
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final GestureTapCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title ?? ""),
      subtitle: subtitle == null ? null : Text(subtitle ?? ""),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
