import 'package:flutter/material.dart';

import 'hyper_trailing.dart';

class HyperGroupBigTitle extends StatelessWidget {
  const HyperGroupBigTitle({
    super.key,
    this.children = const <Widget>[],
    this.title,
    this.subTitle,
    this.inSliver = true,
    this.alpha,
    this.onTap,
  });

  final List<Widget> children;
  final String? title;
  final String? subTitle;
  final bool inSliver;
  final GestureTapCallback? onTap;
  final double? alpha;

  @override
  Widget build(BuildContext context) {
    var child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: alpha),
          child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 12, left: 16),
                      child: Row(
                        children: [
                          title != null
                              ? AnimatedDefaultTextStyle(
                                  style: Theme.of(context).textTheme.titleMedium ?? TextStyle(),
                                  duration: kThemeChangeDuration,
                                  child: Text(title ?? ""),
                                )
                              : Container(),
                          Expanded(child: Container()),
                          subTitle != null
                              ? InkWell(
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: onTap,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        Text(
                                          subTitle ?? "",
                                          style: Theme.of(context).textTheme.labelMedium ?? TextStyle(),
                                        ),
                                        HyperTrailing()
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      )),
                  Container(height: 8),
                  ...children
                ],
              )),
        ),
      ),
    );

    return inSliver ? SliverToBoxAdapter(child: child) : child;
  }
}
