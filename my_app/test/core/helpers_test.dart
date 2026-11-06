import "package:flutter_test/flutter_test.dart";
import "package:my_app/core/helpers.dart";

void main() {
  ParsingHelper helper = ParsingHelper();
  test("Parsing des valeurs numériques classique", () {
    expect(helper.toDouble(12), 12.0);
    expect(helper.toDouble("12.5"), 12.5);
    expect(helper.toInt(12.9), 12);
    expect(helper.toInt("12"), 12);
  });
  test("Verification du retour null pour les cas défaillants", () {
    expect(helper.toDouble("aze"), isNull);
    expect(helper.toInt("aze"), isNull);
    expect(helper.toBool("aze"), isNull);
  });
  test("Verification du parsing des boolean", () {
    expect(helper.toBool("TRUE"), isTrue);
    expect(helper.toBool("trUe"), isTrue);
    expect(helper.toBool("true"), isTrue);

    expect(helper.toBool("FALSE"), isFalse);
    expect(helper.toBool("falsE"), isFalse);
    expect(helper.toBool("false"), isFalse);
  });
  test("Vérification de la gestion des erreurs en cas de mauvais format", () {
    expect(() => helper.parseRequiredString(value: null, field: "name"),
        throwsFormatException);
    expect(() => helper.parseRequiredInt(value: null, field: "value"),
        throwsFormatException);
    expect(() => helper.parseRequiredBool(value: null, field: "boolean"),
        throwsFormatException);
    expect(() => helper.parseRequired(value: null, field: "name"),
        throwsFormatException);
    expect(() => helper.parseDate(value: null, field: "date"),
        throwsFormatException);
  });
}
