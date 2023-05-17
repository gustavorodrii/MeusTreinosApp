import 'package:hive/hive.dart';

String todaysDateYYYYMMDD() {
  Hive.openBox("workout_datebase1");

  var dateTimeObject = DateTime.now();

  String year = dateTimeObject.year.toString();

  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  String yyyymmdd = year + month + day;

  return yyyymmdd;
}

DateTime createDateTimeObject(String yyyymmdd) {
  int yyyy = int.parse(yyyymmdd.substring(0, 4));
  int mm = int.parse(yyyymmdd.substring(4, 6));
  int dd = int.parse(yyyymmdd.substring(6, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

String convertDateTimeToYYYYMMDD(DateTime dateTime) {
  String year = dateTime.year.toString();

  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
