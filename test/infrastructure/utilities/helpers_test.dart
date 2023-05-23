import 'package:flutter_test/flutter_test.dart';
import 'package:ui/infrastructure/utilities/helpers.dart';

void main() {
  test('Random PictureUrl Tests', () {
    String url = Helpers.randomPictureUrl();

    // Assert that the URL starts with 'https://picsum.photos/seed/'
    // followed by an integer between 0 and 999, and ends with '/300/300'
    RegExp regex = RegExp(r"https://picsum.photos/seed/[0-9]{1,3}/300/300");
    expect(regex.hasMatch(url), true);
  });

  test('Random DateTime Tests', () {
    DateTime result = Helpers.randomDateTime();

    // Assert that the returned DateTime is within a valid range
    DateTime currentDate = DateTime.now();
    DateTime minDate = currentDate.subtract(const Duration(seconds: 200000));
    DateTime maxDate = currentDate;
    expect(result.isAfter(minDate), true);
    expect(result.isBefore(maxDate), true);
  });

  group('Random Numeric Code Tests', () {
    const length = 5;
    test('returns a string with the specified length', () {
      final code = Helpers.randomNumericCode(length);
      expect(code.length, equals(length));
    });

    test('returns a string containing only digits', () {
      final code = Helpers.randomNumericCode(length);
      expect(RegExp(r'^\d+$').hasMatch(code), isTrue);
    });

    test('returns a different string on multiple invocations', () {
      final code1 = Helpers.randomNumericCode(length);
      final code2 = Helpers.randomNumericCode(length);
      expect(code1, isNot(equals(code2)));
    });
  });

  // group('Reference Generator Tests', () {
  //   const length = 20;
  //   test('returns a string with the specified length', () {
  //     final code = Helpers.randomReference(length);
  //     expect(code.length, equals(length));
  //   });

  //   test('returns a string containing only uppercase letters and digits', () {
  //     final code = Helpers.randomReference(length);
  //     expect(RegExp(r'^[A-Z0-9]+$').hasMatch(code), isTrue);
  //   });

  //   test('returns a different string on multiple invocations', () {
  //     final code1 = Helpers.randomReference(length);
  //     final code2 = Helpers.randomReference(length);
  //     expect(code1, isNot(equals(code2)));
  //   });
  // });

  group('Date Formatting Tests', () {
    test('formatDate should format the date correctly', () {
      String result = Helpers.formatDate('2023-05-18T12:34:56');
      expect(result, '18 may 2023');
    });

    test('formatDate should handle single-digit day and month correctly', () {
      String result = Helpers.formatDate('2023-02-03T09:05:00');
      expect(result, '3 feb 2023');
    });

    test('formatDate should handle invalid month correctly', () {
      String result = Helpers.formatDate('2023-13-01T00:00:00');
      expect(result, '1 jan 2024');
    });
  });
}
