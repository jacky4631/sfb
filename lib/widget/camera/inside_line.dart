/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
enum MaskForCameraViewCameraDescription { front, rear }
enum MaskForCameraViewBorderType { solid, dotted }
enum MaskForCameraViewInsideLineDirection { horizontal, vertical }

enum MaskForCameraViewInsideLinePosition {
  partOne,
  partTwo,
  partThree,
  partFour,
  center,
  endPartFour,
  endPartThree,
  endPartTwo,
  endPartOne
}
class MaskForCameraViewInsideLine {
  MaskForCameraViewInsideLine({this.direction, this.position});
  MaskForCameraViewInsideLineDirection? direction;
  MaskForCameraViewInsideLinePosition? position;
}
