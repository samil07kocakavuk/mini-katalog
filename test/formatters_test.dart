import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/utils/formatters.dart';

void main() {
  group('formatUsd', () {
    test('adds thousands separators', () {
      expect(formatUsd(2499), r'$2,499');
      expect(formatUsd(1998), r'$1,998');
    });

    test('keeps cents only when needed', () {
      expect(formatUsd(1299), r'$1,299');
      expect(formatUsd(1299.5), r'$1,299.50');
    });

    test('handles zero', () {
      expect(formatUsd(0), r'$0');
    });
  });
}
