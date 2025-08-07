import 'package:flutter/material.dart';

class HyperGroup extends StatelessWidget {
  const HyperGroup({super.key, this.children = const <Widget>[], this.title, this.inSliver = true, this.trailing, this.alpha = 0.7});

  final List<Widget> children;
  final Widget? title;
  final Widget? trailing;
  final bool inSliver;
  final double? alpha;

  @override
  Widget build(BuildContext context) {
    var child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          title != null
              ? Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      AnimatedDefaultTextStyle(
                        style: Theme.of(context).textTheme.labelMedium ?? TextStyle(),
                        duration: kThemeChangeDuration,
                        child: title!,
                      ),
                      Expanded(child: Container()),
                      trailing != null
                          ? AnimatedDefaultTextStyle(
                              style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary) ?? TextStyle(),
                              duration: kThemeChangeDuration,
                              child: trailing!,
                            )
                          : Container(),
                      // Text(
                      //   "刷新",
                      //   style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary),
                      // ),
                    ],
                  ))
              : Container(),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: alpha),
              child: Column(
                children: children,
              ),
            ),
          )
        ],
      ),
    );

    return inSliver ? SliverToBoxAdapter(child: child) : child;
  }
}
