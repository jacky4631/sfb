import 'package:flutter/material.dart';

class BtmBtnWidget extends StatelessWidget {
  final bool? isTwo;
  final bool isFill;
  final bool isNoShowBorder;
  final String text;
  final String? textTwo;
  final IconData? icon;
  final Color iconColor;
  final Color color;
  final Color? btnColor;
  final Color flatcolor;
  final void Function()? callback;
  final void Function()? callbackTwo;

  const BtmBtnWidget({
    Key? key,
    this.isFill = true,
    this.callback,
    this.text = '完成',
    this.icon,
    this.iconColor = Colors.black,
    this.color = const Color(0xffffffff),
    this.isTwo,
    this.textTwo,
    this.callbackTwo,
    this.flatcolor = const Color(0xffcccccc),
    this.isNoShowBorder = false,
    this.btnColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isTwo == true)
      return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5, color: Color(0x20000000)),
          ),
          color: color,
        ),
        height: 52,
        alignment: isFill ? null : Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: isFill ? 16 : 0,
        ),
        child: Container(
          height: 52,
          child: Row(
            children: <Widget>[
              Expanded(
                // ignore: deprecated_member_use

                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: btnColor ?? Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: callback,

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (icon != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(icon, color: iconColor, size: 20),
                        ),
                      Text(
                        icon != null ? '\t\t' + text : text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                // ignore: deprecated_member_use
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: btnColor ?? Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: callbackTwo,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (icon != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(icon, color: iconColor, size: 20),
                        ),
                      Text(
                        icon != null ? '\t\t' + textTwo! : textTwo!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5, color: isNoShowBorder ? Colors.transparent : Color(0x20000000)),
        ),
        color: color,
      ),
      height: 52,
      alignment: isFill ? null : Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: isFill ? 16 : 0,
      ),
      child: Container(
        height: 52,
        // ignore: deprecated_member_use
        child: TextButton(
          style: TextButton.styleFrom(
              primary: btnColor ?? Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          onPressed: callback,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
              Text(
                icon != null ? '\t\t' + text : text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
