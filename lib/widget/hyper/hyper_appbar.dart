import 'package:flutter/material.dart';

class HyperAppbar extends StatelessWidget {
  const HyperAppbar({super.key, this.title, this.bottom, this.actions, this.forceElevated = false});

  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool forceElevated;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
      title: title,
      pinned: true,
      actions: actions,
      forceElevated: forceElevated,
      bottom: bottom,
      // flexibleSpace: FlexibleSpaceBar(
      //     collapseMode: CollapseMode.pin,
      //     background: Stack(
      //       children: [
      //         Container(
      //           alignment: Alignment.bottomLeft,
      //           margin: EdgeInsets.only(bottom: bottom?.preferredSize.height ?? 0),
      //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      //           child: AnimatedDefaultTextStyle(
      //             style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 28) ?? TextStyle(),
      //             maxLines: 1,
      //             overflow: TextOverflow.ellipsis,
      //             duration: kThemeChangeDuration,
      //             child: title!,
      //           ),
      //         ),
      //       ],
      //     )),
    );
  }
}
