import 'package:test/test.dart';
import 'package:simple_math/simple_math.dart';

void main() {
  group('SimpleMath Tests', () {
    test('Without variables', () {
      final math = SimpleMath('2 + 3 * 4');
      expect(math.decide(), equals(14.0));

      final math2 = SimpleMath('(5 + 3) * 2 - 10 / 2');
      expect(math2.decide(), equals(11.0));
    });

    test('With unary minus', () {
      final math = SimpleMath('-4 + 3 * 4');
      expect(math.decide(), equals(8.0));
    });

    test('With single variable', () {
      final math = SimpleMath('x * 2 + 5');
      expect(math.decide({'x': 10}), equals(25.0));
      expect(math.decide({'x': 0}), equals(5.0));
      expect(math.decide({'x': -3}), equals(-1.0));
    });

    test('With multiple variables', () {
      final math = SimpleMath('a * b + c / d');

      expect(math.decide({'a': 2, 'b': 3, 'c': 10, 'd': 2}), equals(11.0));
      expect(math.decide({'a': 5, 'b': 4, 'c': 20, 'd': 5}), equals(24.0));
    });

    test('With error handling', () {
      final math1 = SimpleMath('x / 0');
      expect(math1.decide({'x': 5}), equals(double.infinity));

      final math2 = SimpleMath('2 + 2');
      expect(math2.decide({'unused': 999}), equals(4.0));
      expect(() => SimpleMath('').decide(), throwsA(isA<ArgumentError>()));
      expect(
        () => SimpleMath('2 + * 3').decide(),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Operator order', () {
      final math = SimpleMath('2 + 3 * 4 / 2 - 1');
      expect(math.decide(), equals(7.0));
    });
  });
}
