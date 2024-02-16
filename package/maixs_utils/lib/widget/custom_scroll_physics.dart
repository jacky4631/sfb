import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

///页面滑动物理
class PagePhysics extends PageScrollPhysics {
  const PagePhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  PagePhysics applyTo(ScrollPhysics? ancestor) {
    return PagePhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring {
    return SpringDescription.withDampingRatio(
      mass: 0.1,
      stiffness: 50.0,
      ratio: 1,
    );
  }
}