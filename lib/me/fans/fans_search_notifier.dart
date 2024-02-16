/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/cupertino.dart';

//
class FansSearchNotifier extends ValueNotifier<String> {
  FansSearchNotifier(value) : super(value);
}

FansSearchNotifier fansSearchNotifier = new FansSearchNotifier('');
