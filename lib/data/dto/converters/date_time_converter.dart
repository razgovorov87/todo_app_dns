import 'package:freezed_annotation/freezed_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, int> {
  const DateTimeConverter();

  @override
  DateTime fromJson(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  @override
  int toJson(DateTime data) => data.millisecondsSinceEpoch;
}
