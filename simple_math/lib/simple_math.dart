import 'package:math_expressions/math_expressions.dart';

class SimpleMath {
  String _expression;

  SimpleMath(this._expression);

  double decide() {
    Parser parser = Parser();
    ContextModel context = ContextModel();
    Expression exp = parser.parse(_expression);

    return exp.evaluate(EvaluationType.REAL, context);
  }
}
