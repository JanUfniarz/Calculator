import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(fontFamily: "Gajraj One"),
  home: Calculator()
));


class Calculator extends StatefulWidget {

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

String operation = "";
num? result;

num calculate(String operation) {
  List<String> tokens = operation.split(' ');
  List<num> numbers = [];
  List<String> operators = [];

  tokens.removeWhere((str) => (str == "" || str == " "));
  tokens.forEach((str) => str.trim);

  tokens = _joined(tokens);

  tokens.removeWhere((str) => (str == "" || str == " "));
  tokens.forEach((str) => str.trim);

  for (String token in tokens) {
    if (double.tryParse(token) != null) {
      numbers.add(double.parse(token));
    } else if (token == '(') {
      operators.add(token);
    } else if (token == ')') {
      while (operators.isNotEmpty && operators.last != '(') {
        _applyOperation(numbers, operators.removeLast());
      }
      operators.removeLast();
    } else {
      while (operators.isNotEmpty
          && _precedence(token) <= _precedence(operators.last)) {
        _applyOperation(numbers, operators.removeLast());
      }
      operators.add(token);
    }
  }
  while (operators.isNotEmpty) {
    _applyOperation(numbers, operators.removeLast());
  }
  return numbers.first;
}

List<String> _joined(List<String> tokens) {
  List<String> res = [];
  String t = "";
  for (String str in tokens) {
    if (double.tryParse(str) != null) {
      t = t + str;
    } else if (str == "." || str == " .") {
      t = "$t.";
    } else if (str == "-" &&  t == "") {
      t = "-";
    } else {
      res.add(t);
      t = "";
      res.add(str);
    }
  }
  if (t != "") res.add(t);
  return res;
}

void _applyOperation(List<num> numbers, String operator) {
  num num2 = numbers.removeLast();
  num num1 = numbers.removeLast();

  switch (operator) {
    case '+':
      numbers.add(num1 + num2);
      break;
    case '-':
      numbers.add(num1 - num2);
      break;
    case '×':
      numbers.add(num1 * num2);
      break;
    case '÷':
      numbers.add(num1 / num2);
      break;
    default:
  }
}

int _precedence(String operator) {
  switch (operator) {
    case '(':
    case ')':
      return 0;
    case '+':
    case '-':
      return 1;
    case '×':
    case '÷':
      return 2;
    default:
      return 0;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8),
        child: AppBar(
          backgroundColor: Colors.black87,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            flex: 5,
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Scaffold(
                    backgroundColor: Colors.brown[50],
                    body: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            operation.contains(" ")
                                ? operation.replaceAll(" ", "")
                                : operation,
                            style: TextStyle(
                              fontSize: 70,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            result !=  null ? result.toString() : "",
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.grey[700],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 13,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              child: Scaffold(
                backgroundColor: Colors.black,
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0x61D0F500),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.center,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0x615C45FE),
                          Colors.transparent,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.center,
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: GridView.count(
                        crossAxisCount: 4,
                        children: <Widget>[
                          // AC
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "";
                                    result = null;
                                  });
                                },
                                child: Text(
                                  "AC",
                                  style: TextStyle(
                                    fontSize: 35,
                                    color: Color(0xFF5C45FE),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFD0F500),
                                ),
                              ),
                            ),
                          ),
                          // ()
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    List<String> barcs = operation
                                        .split("")
                                        .where((ch) => ch == ")" || ch == "(")
                                        .toList();
                                    if (barcs.isNotEmpty) {
                                      if (barcs.last == "(") {
                                        operation = operation + " )";
                                        try {
                                          result = calculate(operation);
                                        } catch (ignored) {}
                                      } else operation = operation + " (";
                                    } else operation = operation + " (";
                                  });
                                },
                                child: Text(
                                  "(  )",
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Color(0xFFD0F500),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF5C45FE),
                                ),
                              ),
                            ),
                          ),
                          // %
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  List<String> chars = operation.split("");
                                  List<String> stack = [""];
                                  while (chars.isNotEmpty) {
                                    if (double.tryParse(chars.last) != null
                                        || chars.last == ".")
                                      stack.add(chars.removeLast());
                                    else if (chars.last == " ")
                                      chars.removeLast();
                                    else break;
                                  }
                                  chars.add((
                                      double.parse(
                                          stack.reversed.join()) / 100)
                                      .toString());
                                  if (stack.isNotEmpty) {
                                    setState(() {
                                      operation = chars.join();
                                      try {
                                        result = calculate(operation);
                                      } catch (ignored) {}
                                    });
                                  }
                                },
                                child: Text(
                                  "%",
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Color(0xFFD0F500),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF5C45FE),
                                ),
                              ),
                            ),
                          ),
                          // \
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation ÷";
                                  });
                                },
                                child: Text(
                                  "÷",
                                  style: TextStyle(
                                    height: 1.15,
                                    fontSize: 80,
                                    color: Color(0xFFD0F500),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF5C45FE),
                                ),
                              ),
                            ),
                          ),
                          // 7
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation 7";
                                    try {
                                      result = calculate(operation);
                                    } catch (ignored) {}
                                  });
                                },
                                child: Text(
                                  "7",
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          // 8
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation 8";
                                    try {
                                      result = calculate(operation);
                                    } catch (ignored) {}
                                  });
                                },
                                child: Text(
                                  "8",
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          // 9
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation 9";
                                    try {
                                      result = calculate(operation);
                                    } catch (ignored) {}
                                  });
                                },
                                child: Text(
                                  "9",
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          // X
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation ×";
                                  });
                                },
                                child: Text(
                                  "×",
                                  style: TextStyle(
                                    height: 1.15,
                                    fontSize: 80,
                                    color: Color(0xFFD0F500),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF5C45FE),
                                ),
                              ),
                            ),
                          ),
                          // 4
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation 4";
                                    try {
                                      result = calculate(operation);
                                    } catch (ignored) {}
                                  });
                                },
                                child: Text(
                                  "4",
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          // 5
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation 5";
                                    try {
                                      result = calculate(operation);
                                    } catch (ignored) {}
                                  });
                                },
                                child: Text(
                                  "5",
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          // 6
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation 6";
                                    try {
                                      result = calculate(operation);
                                    } catch (ignored) {}
                                  });
                                },
                                child: Text(
                                  "6",
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          // -
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation -";
                                  });
                                },
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    height: 1.15,
                                    fontSize: 80,
                                    color: Color(0xFFD0F500),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF5C45FE),
                                ),
                              ),
                            ),
                          ),
                          // 1
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation 1";
                                    try {
                                      result = calculate(operation);
                                    } catch (ignored) {}
                                  });
                                },
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          // 2
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation 2";
                                    try {
                                      result = calculate(operation);
                                    } catch (ignored) {}
                                  });
                                },
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          // 3
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation 3";
                                    try {
                                      result = calculate(operation);
                                    } catch (ignored) {}
                                  });
                                },
                                child: Text(
                                  "3",
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          // +
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation +";
                                  });
                                },
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    height: 1.15,
                                    fontSize: 80,
                                    color: Color(0xFFD0F500),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF5C45FE),
                                ),
                              ),
                            ),
                          ),
                          // 0
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation 0";
                                    try {
                                      result = calculate(operation);
                                    } catch (ignored) {}
                                  });
                                },
                                child: Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          // ,
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    operation = "$operation .";
                                  });
                                },
                                child: Text(
                                  ",",
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          // <-
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    List<String> chars = operation.split("");
                                    if (chars.length > 2) {
                                      chars.removeLast();
                                      if (chars.last == " ") chars.removeLast();
                                      operation = chars.join();
                                      if (double.tryParse(chars.last) != null)
                                        result = calculate(operation);
                                    } else {
                                      operation = "";
                                      result = null;
                                    }
                                  });
                                },
                                child: Text(
                                  "«",
                                  style: TextStyle(
                                    height: 1.15,
                                    fontSize: 80,
                                    color: Color(0xFF5C45FE),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFD0F500),
                                ),
                              ),
                            ),
                          ),
                          // =
                          Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (result != null)
                                      operation = result.toString();
                                    result = null;
                                  });
                                },
                                child: Text(
                                  "=",
                                  style: TextStyle(
                                    height: 1.15,
                                    fontSize: 80,
                                    color: Color(0xFF5C45FE),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFD0F500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}
