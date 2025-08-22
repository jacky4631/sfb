/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

///菜单组件
class PddMenuWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Function? onRefresh;
  final int count;
  final Function(Map<String, dynamic>)? onTap;

  const PddMenuWidget(
    this.data, {
    Key? key,
    this.count = 10,
    this.onRefresh,
    this.onTap,
  }) : super(key: key);

  @override
  State<PddMenuWidget> createState() => _PddMenuWidgetState();
}

class _PddMenuWidgetState extends State<PddMenuWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
      child: Wrap(
        children: widget.data.map((icon) {
          final width = (MediaQuery.of(context).size.width - 16) / 5;
          return GestureDetector(
            onTap: () => widget.onTap?.call(icon),
            child: SizedBox(
              width: width,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    icon['img'] ?? '',
                    width: 56,
                    height: 56,
                    errorBuilder: (_, __, ___) => const Icon(Icons.error),
                  ),
                  const SizedBox(height: 4),
                  Text(icon['title'] ?? ''),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
