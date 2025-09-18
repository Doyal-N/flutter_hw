import 'package:simple_math/simple_math.dart';

void main(List<String> arguments) {
  var expr = SimpleMath(arguments[0]);
  print(expr.decide());
}
