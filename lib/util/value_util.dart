class ValueUtil {
  static int toInt(dynamic value) {
    if (value is String) {
      if (value.isNotEmpty) {
        return int.parse(value);
      } else {
        return 0;
      }
    } else if (value is num) {
      return value.toInt();
    } else {
      return 0;
    }
  }

  static double toDouble(dynamic value) {
    if (value is String) {
      if (value.isNotEmpty) {
        return double.parse(value);
      } else {
        return 0.0;
      }
    } else if (value is num) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }

  static String toStr(dynamic value, {String def = ''}) {
    if (value is String) {
      return value;
    } else if (value is num) {
      return value.toString();
    } else {
      return def;
    }
  }

  static List toList(dynamic value) {
    if (value is List) {
      return value;
    } else {
      return [];
    }
  }

  static Map toMap(dynamic value) {
    if (value is Map) {
      return value;
    } else {
      return {};
    }
  }

  static num toNum(dynamic value) {
    if (value is num) {
      return value;
    } else if (value is String) {
      if (value.contains(".")) {
        return double.parse(value);
      } else {
        return int.parse(value);
      }
    } else {
      return -666;
    }
  }

  static bool toBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      if (value.length == 0) return false;
      if (value == 'true') return true;
      if (value == 'false') return false;
      return toNum(value) > 0;
    } else if (value is num) {
      return value > 0;
    } else {
      return false;
    }
  }
}
