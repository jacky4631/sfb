import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/utils.dart';
import '../widget/views.dart';
import 'item_tap_widget.dart';
import 'mylistview.dart';
import 'mytext.dart';
import 'button.dart';

const Duration _kMenuDuration = Duration(milliseconds: 250);
const double _kMenuVerticalPadding = 8.0;
const double _kMenuScreenPadding = 8.0;

class _PopupMenu<T> extends StatelessWidget {
  const _PopupMenu({
    Key? key,
    required this.route,
    required this.semanticLabel,
  }) : super(key: key);

  final _PopupMenuRoute<T> route;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final double unit = 1.0 / (route.items!.length + 1.5); // 1.0 for the width and 0.5 for the last item's fade.
    final CurveTween opacity = CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    // ignore: unused_local_variable
    final CurveTween height = CurveTween(curve: Interval(0.0, unit * route.items!.length));

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: opacity.evaluate(route.animation!),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  color: Color(0x20000000),
                  // offset: Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              width: size(context).width / 2.75,
              color: route.color ?? Color(0xFFFAFAFA),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Align(
                  widthFactor: route.animation!.value,
                  heightFactor: route.animation!.value,
                  alignment: route.alignment ?? Alignment.topCenter,
                  child: Align(
                    alignment: route.alignment ?? Alignment.topCenter,
                    // widthFactor: 1.0,
                    // heightFactor: height.evaluate(route.animation),
                    widthFactor: route.animation!.value,
                    heightFactor: route.animation!.value,
                    child: MyListView(
                      isShuaxin: false,
                      animationDelayed: 0,
                      itemCount: route.items!.length,
                      animationType: AnimationType.close,
                      item: (i) {
                        return ItemTapWidget(
                          padding: 0,
                          bgColor: Colors.transparent,
                          onTap: () {
                            pop(context);
                            route.onTap!(i);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 8),
                            child: MyText(
                              route.items![i],
                              size: 16,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(this.position, this.itemSizes, this.selectedItemIndex, this.textDirection);
  final RelativeRect position;
  List<Size> itemSizes;
  final int selectedItemIndex;
  final TextDirection textDirection;
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(
      constraints.biggest - const Offset(_kMenuScreenPadding * 2.0, _kMenuScreenPadding * 2.0) as Size,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double y = position.top;
    if (selectedItemIndex != null && itemSizes != null) {
      double selectedItemOffset = _kMenuVerticalPadding;
      for (int index = 0; index < selectedItemIndex; index += 1) selectedItemOffset += itemSizes[index].height;
      selectedItemOffset += itemSizes[selectedItemIndex].height / 2;
      y = position.top + (size.height - position.top - position.bottom) / 2.0 - selectedItemOffset;
    }

    double x;
    if (position.left > position.right) {
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      x = position.left;
    } else {
      assert(textDirection != null);
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }
    if (x < _kMenuScreenPadding)
      x = _kMenuScreenPadding;
    else if (x + childSize.width > size.width - _kMenuScreenPadding) x = size.width - childSize.width - _kMenuScreenPadding;
    if (y < _kMenuScreenPadding)
      y = _kMenuScreenPadding;
    else if (y + childSize.height > size.height - _kMenuScreenPadding) y = size.height - childSize.height - _kMenuScreenPadding;
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position || selectedItemIndex != oldDelegate.selectedItemIndex || textDirection != oldDelegate.textDirection || !listEquals(itemSizes, oldDelegate.itemSizes);
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    this.alignment,
    this.onTap,
    this.position,
    this.items,
    this.initialValue,
    this.elevation,
    this.theme,
    this.popupMenuTheme,
    this.barrierLabel,
    this.semanticLabel,
    this.shape,
    this.color,
    this.showMenuContext,
    this.captureInheritedThemes,
    // ignore: deprecated_member_use
  }) : itemSizes = [];

  final RelativeRect? position;
  final Alignment? alignment;
  final List<String>? items;
  final List<Size> itemSizes;
  final T? initialValue;
  final double? elevation;
  final ThemeData? theme;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final Color? color;
  final PopupMenuThemeData? popupMenuTheme;
  final BuildContext? showMenuContext;
  final bool? captureInheritedThemes;
  final void Function(int)? onTap;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInQuart,
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    int? selectedItemIndex;

    Widget menu = _PopupMenu<T>(route: this, semanticLabel: semanticLabel!);
    if (captureInheritedThemes!) {
      menu = InheritedTheme.captureAll(showMenuContext!, menu);
    } else {
      if (theme != null) menu = Theme(data: theme!, child: menu);
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
              position!,
              itemSizes,
              selectedItemIndex!,
              Directionality.of(context),
            ),
            child: menu,
          );
        },
      ),
    );
  }
}

Future<T?> showMenuWidget<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<String> items,
  Color? color,
  void Function(int)? onTap,
  Alignment? alignment,
}) {
  assert(context != null);
  assert(position != null);
  assert(items != null && items.isNotEmpty);
  assert(debugCheckHasMaterialLocalizations(context));

  return Navigator.of(context, rootNavigator: false).push(_PopupMenuRoute<T>(
    alignment: alignment!,
    position: position,
    onTap: onTap ?? (i) {},
    items: items,
    theme: Theme.of(context),
    popupMenuTheme: PopupMenuTheme.of(context),
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    color: color!,
    showMenuContext: context,
    captureInheritedThemes: true,
  ));
}

class MenuButton extends StatefulWidget {
  final String text;
  final bool isFill;
  final double? size;
  final Color? color;
  final Widget? icon;
  final double vertical;
  final List<String>? menus;
  final void Function(int)? onTap;
  final void Function()? onError;
  final Alignment alignment;

  const MenuButton({
    Key? key,
    this.text = '请选择',
    this.icon,
    this.menus,
    this.onTap,
    this.size,
    this.color,
    this.isFill = false,
    this.vertical = 4.0,
    this.alignment = Alignment.center,
    this.onError,
  }) : super(key: key);
  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  var key = GlobalKey();

  var text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: widget.vertical),
      child: Button(
        key: key,
        onPressed: () {
          if (widget.menus!.isNotEmpty) {
            RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
            var offset = box.localToGlobal(Offset.zero);
            print(offset);
            showMenuWidget(
              context: context,
              alignment: widget.alignment,
              position: RelativeRect.fromSize(Rect.fromLTRB(offset.dx, offset.dy +
                  (!widget.isFill ? key.currentContext?.size?.height : 0)!, 0, 0), Size.infinite),
              items: widget.menus ?? ['1', '2', '3', '4', '5'],
              onTap: (i) {
                setState(() => text = widget.menus![i]);
                widget.onTap!(i);
              },
            );
          } else {
            widget.onError!();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyText(
              text ?? widget.text,
              color: widget.color ?? Colors.grey,
              size: widget.size ?? 14,
            ),
            widget.icon ??
                Row(
                  children: <Widget>[
                    SizedBox(width: 2),
                    SvgPicture.asset(
                      'assets/svg/shaixuan.svg',
                      width: 12,
                      height: 12,
                      color: Colors.black26,
                    )
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
