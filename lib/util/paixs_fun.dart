/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
class PFun {
  ///组件list快速生成
  static List lg([top, bottom, left, right]) => [top, bottom, left, right];
  static List<T> lg1<T>([top]) => [top];
  static List<T> lg2<T>([top, bottom]) => [top, bottom];
  static List<T> lg3<T>([top, bottom, left]) => [top, bottom, left];

  ///从上往下渐变list快速生成
  static List tbGd(startColor, endColor) {
    return [startColor, endColor, 0, -1, 0, 1];
  }

  ///从左上往右下渐变list快速生成
  static List tl2brGd(startColor, endColor) {
    return [startColor, endColor, -1, -1, 1, 1];
  }

  ///从右上往左下渐变list快速生成
  static List tr2blGd(startColor, endColor) {
    return [startColor, endColor, 1, -1, -1, 1];
  }

  ///从左往右渐变list快速生成
  static List cl2crGd(startColor, endColor) {
    return [startColor, endColor, -1, 0, 1, 0];
  }

  ///边框list快速生成
  static List bdLg(color, [t = 0, b = 0, l = 0, f = 0]) {
    return [color, t, b, l, f];
  }

  ///全部边框list快速生成
  static List bdAllLg(color, [all = 1]) {
    return [color, all, all, all, all];
  }

  ///阴影list快速生成
  static List sdLg(color, [shadow = 2, x = 0, y = 1, zoom = 0]) {
    return [color, shadow, x, y, zoom];
  }
}
