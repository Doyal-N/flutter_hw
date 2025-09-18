import 'package:simple_math/simple_parser.dart';

class SimpleMath {
  final String _expression;

  SimpleMath(this._expression);

  double decide([Map<String, double> vars = const {}]) {
    try {
      final parser = SimpleParser(_expression, vars);
      return parser.evaluate();
    } catch (e) {
      throw ArgumentError('Invalid expression: $_expression');
    }
  }
}
