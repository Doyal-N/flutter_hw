class SimpleParser {
  final String _expression;
  final Map<String, double> _variables;

  SimpleParser(this._expression, this._variables);

  double evaluate() {
    final tokens = tokenize(_expression);
    final rpn = fillRpnStack(tokens);
    return _evaluateRpn(rpn);
  }

  List<String> tokenize(String expression) {
    expression = expression.replaceAll(' ', '');
    final tokens = <String>[];
    final buffer = StringBuffer();

    for (int i = 0; i < expression.length; i++) {
      final char = expression[i];

      if (_isOperator(char) || char == '(' || char == ')') {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }

        if (char == '-' && _isUnaryMinus(tokens, i == 0)) {
          tokens.add('u-'); // Помечаем как унарный
        } else {
          tokens.add(char);
        }
      } else if (_isDigit(char) || char == '.') {
        buffer.write(char);
      } else if (_isLetter(char)) {
        buffer.write(char);
      }
    }

    if (buffer.isNotEmpty) {
      tokens.add(buffer.toString());
    }

    return tokens;
  }

  List<String> fillRpnStack(List<String> tokens) {
    final output = <String>[];
    final operators = <String>[];

    for (final token in tokens) {
      if (_isNumber(token) || _isVariable(token)) {
        output.add(token);
      } else if (_isOperator(token) || token == 'u-') {
        while (operators.isNotEmpty &&
            operators.last != '(' &&
            _getPrecedence(operators.last) >= _getPrecedence(token)) {
          output.add(operators.removeLast());
        }
        operators.add(token);
      } else if (token == '(') {
        operators.add(token);
      } else if (token == ')') {
        while (operators.isNotEmpty && operators.last != '(') {
          output.add(operators.removeLast());
        }
        if (operators.isNotEmpty && operators.last == '(') {
          operators.removeLast();
        }
      }
    }

    while (operators.isNotEmpty) {
      output.add(operators.removeLast());
    }

    return output;
  }

  double _evaluateRpn(List<String> rpn) {
    final stack = <double>[];

    for (final token in rpn) {
      if (_isNumber(token)) {
        stack.add(double.parse(token));
      } else if (_isVariable(token)) {
        if (_variables.containsKey(token)) {
          stack.add(_variables[token]!);
        } else {
          throw ArgumentError('Переменная "$token" не определена');
        }
      } else if (_isOperator(token) || token == 'u-') {
        if (token == 'u-') {
          if (stack.isEmpty) {
            throw ArgumentError('Недостаточно операндов для унарного минуса');
          }
          final a = stack.removeLast();
          stack.add(-a);
        } else {
          if (stack.length < 2) {
            throw ArgumentError('Недостаточно операндов для оператора $token');
          }
          final b = stack.removeLast();
          final a = stack.removeLast();
          final result = _applyOperation(a, b, token);
          stack.add(result);
        }
      }
    }

    if (stack.length != 1) {
      throw ArgumentError('Некорректное выражение');
    }

    return stack.first;
  }

  bool _isDigit(String s) =>
      s.length == 1 && s.codeUnitAt(0) >= 48 && s.codeUnitAt(0) <= 57;
  bool _isLetter(String s) =>
      s.length == 1 &&
      ((s.codeUnitAt(0) >= 65 && s.codeUnitAt(0) <= 90) ||
          (s.codeUnitAt(0) >= 97 && s.codeUnitAt(0) <= 122));
  bool _isOperator(String s) => ['+', '-', '*', '/'].contains(s);
  bool _isNumber(String s) => double.tryParse(s) != null;
  bool _isVariable(String s) => s.isNotEmpty && _isLetter(s[0]) && s != 'u-';
  bool _isUnaryMinus(List<String> tokens, bool isFirstCharacter) {
    if (isFirstCharacter) return true;
    if (tokens.isEmpty) return true;

    final lastToken = tokens.last;
    return _isOperator(lastToken) || lastToken == '(' || lastToken == 'u-';
  }

  int _getPrecedence(String operator) {
    return switch (operator) {
      'u-' => 3,
      '*' || '/' => 2,
      '+' || '-' => 1,
      _ => 0,
    };
  }

  double _applyOperation(double arg1, double arg2, String operator) {
    return switch (operator) {
      '+' => arg1 + arg2,
      '-' => arg1 - arg2,
      '*' => arg1 * arg2,
      '/' => arg2 != 0 ? arg1 / arg2 : double.infinity,
      _ => throw ArgumentError('Неизвестный оператор: $operator'),
    };
  }
}
