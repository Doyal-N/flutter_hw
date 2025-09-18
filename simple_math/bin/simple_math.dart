import 'package:simple_math/simple_parser.dart';

void main(List<String> arguments) {
  try {
    final parser = SimpleParser('-2+3*4', {});
    final result = parser.evaluate();
    print('Result: $result');
  } catch (e) {
    print('Error: $e');
  }
}
