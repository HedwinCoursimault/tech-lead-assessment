class ParsingHelper {
  String parseRequiredString({required String? value, required String field}) {
    return parseRequired(value: value, field: field);
  }

  bool parseRequiredBool({required bool? value, required String field}) {
    return parseRequired<bool>(value: value, field: field);
  }

  double parseRequiredDouble({required double? value, required String field}) {
    return parseRequired<double>(value: value, field: field);
  }

  int parseRequiredInt({required int? value, required String field}) {
    return parseRequired<int>(value: value, field: field);
  }

  DateTime parseDate({required String? value, required String field}) {
    if (value == null) {
      throw FormatException("Wrong date format in field : $field");
    }

    DateTime date = DateTime.parse(value);

    if (value.length == 10) {
      return DateTime.utc(date.year, date.month, date.day);
    }

    return date.toUtc();
  }

  T parseRequired<T>({required T? value, required String field}) {
    if (value == null) {
      throw FormatException("Missing or invalid field : $field");
    }

    return value;
  }

  double? toDouble(dynamic value) {
    return switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s),
      _ => null,
    };
  }

  int? toInt(dynamic value) {
    return switch (value) {
      int n => n,
      double n => n.toInt(),
      String s => int.tryParse(s),
      _ => null,
    };
  }

  bool? toBool(dynamic value) {
    return switch (value) {
      bool b => b,
      String s when s.toLowerCase() == "true" => true,
      String s when s.toLowerCase() == "false" => false,
      _ => null,
    };
  }
}
