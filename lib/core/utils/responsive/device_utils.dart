import 'package:flutter/material.dart';

class DeviceUtils {
  DeviceUtils._(); // يمنع إنشاء object من الكلاس

  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.shortestSide >= 600;
  }
}
