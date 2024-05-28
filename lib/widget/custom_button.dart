/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/src/widgets/apple_logo_painter.dart';

/// The scale based on the height of the button
const _appleIconSizeScale = 28 / 44;

/// A `Sign in with Apple` button according to the Apple Guidelines.
///
/// https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/buttons/
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    this.text = 'Sign in with Apple',
    this.height = 44,
    this.style = CustomButtonStyle.black,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.iconAlignment = IconAlignment.center,
    this.icon,
    this.leftTextSize = 0,
    this.bgColor,
    this.textColor,
    this.showIcon = true
  }) : super(key: key);
  final bool showIcon;
  final Color? bgColor;
  final Color? textColor;
  final Icon? icon;
  final double leftTextSize;
  /// The callback that is be called when the button is pressed.
  final VoidCallback onPressed;

  /// The text to display next to the Apple logo.
  ///
  /// Defaults to `Sign in with Apple`.
  final String text;

  /// The height of the button.
  ///
  /// This defaults to `44` according to Apple's guidelines.
  final double height;

  /// The style of the button.
  ///
  /// Supported options are in line with Apple's guidelines.
  ///
  /// This defaults to [CustomButtonStyle.black].
  final CustomButtonStyle style;

  /// The border radius of the button.
  ///
  /// Defaults to `8` pixels.
  final BorderRadius borderRadius;

  /// The alignment of the Apple logo inside the button.
  ///
  /// This defaults to [IconAlignment.center].
  final IconAlignment iconAlignment;

  /// Returns the background color of the button based on the current [style].
  Color get _backgroundColor {
    switch (style) {
      case CustomButtonStyle.black:
        return Colors.black;
      case CustomButtonStyle.white:
      case CustomButtonStyle.whiteOutlined:
        return Colors.white;
      case CustomButtonStyle.wechat:
        return Colors.green;
    }
  }

  /// Returns the contrast color to the [_backgroundColor] derived from the current [style].
  ///
  /// This is used for the text and logo color.
  Color get _contrastColor {
    switch (style) {
      case CustomButtonStyle.black:
      case CustomButtonStyle.wechat:
        return Colors.white;
      case CustomButtonStyle.white:
      case CustomButtonStyle.whiteOutlined:
        return Colors.black;
    }
  }

  /// The decoration which should be applied to the inner container inside the button
  ///
  /// This allows to customize the border of the button
  Decoration? get _decoration {
    switch (style) {
      case CustomButtonStyle.black:
      case CustomButtonStyle.white:
        return null;

      case CustomButtonStyle.whiteOutlined:
        return BoxDecoration(
          border: Border.all(width: 1, color: textColor??_contrastColor),
          borderRadius: borderRadius,
        );
      case CustomButtonStyle.wechat:
      // TODO: Handle this case.
    }
  }

  @override
  Widget build(BuildContext context) {
    // per Apple's guidelines
    final fontSize = height * 0.43;

    final textWidget = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        inherit: false,
        fontSize: fontSize,
        color: textColor??_contrastColor,
        // defaults styles aligned with https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/cupertino/text_theme.dart#L16
        fontFamily: '.SF Pro Text',
        letterSpacing: -0.41,
      ),
    );

    final appleIcon = Container(
      width: _appleIconSizeScale * height,
      height: _appleIconSizeScale * height + 2,
      padding: EdgeInsets.only(
        // Properly aligns the Apple icon with the text of the button
        bottom: (4 / 44) * height,
      ),
      child: Center(
        child: SizedBox(
          width: fontSize * (25 / 31),
          height: fontSize,
          child: icon != null ? this.icon : CustomPaint(
            painter: AppleLogoPainter(
              color: textColor??_contrastColor,
            ),
          ),
        ),
      ),
    );

    var children = <Widget>[];

    switch (iconAlignment) {
      case IconAlignment.center:
        children = [
          showIcon ? appleIcon:SizedBox(),
          SizedBox(width: leftTextSize,),
          Flexible(
            child: textWidget,
          ),
        ];
        break;
      case IconAlignment.left:
        children = [
          showIcon ? appleIcon : SizedBox(),
          Expanded(
            child: textWidget,
          ),
          SizedBox(
            width: _appleIconSizeScale * height,
          ),
        ];
        break;
    }

    return SizedBox(
      height: height,
      child: SizedBox.expand(
        child: CupertinoButton(
          borderRadius: borderRadius,
          padding: EdgeInsets.zero,
          color: bgColor!=null ? bgColor : _backgroundColor,
          child: Container(
            decoration: _decoration,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            height: height,
            child: Row(
              children: children,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

/// The style of the button according to Apple's documentation.
///
/// https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/buttons/
enum CustomButtonStyle {
  /// A black button with white text and white icon
  ///
  /// ![Black Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/black_button.png)
  black,

  /// A white button with black text and black icon
  ///
  /// ![White Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/white_button.png)
  white,

  /// A white button which has a black outline
  ///
  /// ![White Outline Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/white_outlined_button.png)
  whiteOutlined,

  wechat
}

/// This controls the alignment of the Apple Logo on the [CustomButton]
enum IconAlignment {
  /// The icon will be centered together with the text
  ///
  /// ![Center Icon Alignment](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/center_aligned_icon.png)
  center,

  /// The icon will be on the left side, while the text will be centered accordingly
  ///
  /// ![Left Icon Alignment](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/left_aligned_icon.png)
  left,
}
