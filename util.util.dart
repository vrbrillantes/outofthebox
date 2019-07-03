//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class StringUtil {
  static String randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(26);
    });
    return new String.fromCharCodes(codeUnits);
  }
}

class DateUtil {
  static String getOrderIDDate() {
    return DateFormat("yyMM").format(DateTime.now());
  }
  static DateTime getSLADate(int modifier, {DateTime date}) {
    DateTime cancel = date == null ? DateTime.now() : date;
    cancel = cancel.add(Duration(days: modifier));
    if (cancel.weekday == 7) {
      cancel = cancel.add(Duration(days: 1)); //SUNDAY
    } else if (cancel.weekday  == 6) {
      cancel = cancel.add(Duration(days: 2)); //SATURDAY
    }
    return cancel;
  }
  static String getDateSuperSimple(DateTime date) {
    return DateFormat("M d yyyy").format(date);
  }
}
