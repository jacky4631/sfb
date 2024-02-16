/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:sufenbao/me/styles.dart';

class SelectTextItem extends StatelessWidget {
  const SelectTextItem({
    Key? key,
    this.onTap,
    this.title,
    this.content: "",
    this.contentWidget,
    this.textAlign: TextAlign.end,
    this.style,
    this.leading,
    this.subTitle: "",
    this.height: 55.0,
    this.trailing,
    this.margin,
    this.bgColor,
    this.textStyle,
  })  : assert(title != null, height >= 50.0),
        super(key: key);

  final GestureTapCallback? onTap;
  final String? title;
  final String? content;
  final Widget? contentWidget;
  final TextAlign textAlign;
  final TextStyle? style;
  final Widget? leading;
  final IconData? trailing;
  final String subTitle;
  final double height;
  final EdgeInsetsGeometry? margin;
  final Color? bgColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor ?? Colors.white,
      child: InkWell(
          onTap: onTap,
          child: Container(
              height: height,
              margin: margin ?? EdgeInsets.only(right: 8.0, left: 8.0),
              width: double.infinity,
              child: Row(children: <Widget>[
                Offstage(
                    offstage: leading == null,
                    child: Row(children: <Widget>[
                      leading??SizedBox(),
                      PWidget.boxw(8)
                    ])),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(title ?? "",
                          style: textStyle ?? TextStyles.textDark14,
                          maxLines: 1),
                      Offstage(
                          offstage: subTitle.isEmpty,
                          child: Text(subTitle,
                              style: TextStyles.textGrey12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis))
                    ]),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: contentWidget??Text(content ?? '',
                            maxLines: 1,
                            textAlign: textAlign,
                            overflow: TextOverflow.ellipsis,
                            style: style ?? TextStyles.textGrey12))),
                Offstage(
                    offstage: onTap == null,
                    child: Icon(trailing ?? Icons.chevron_right, size: 22.0))
              ]))),
    );
  }
}
