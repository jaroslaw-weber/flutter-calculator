import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(new CalculatorApp());
}

//calculator widget. need to be stateful
class CalculatorWidget extends StatefulWidget {
  //creating state for stateful widget
  @override
  _CalculatorWidgetState createState() => new _CalculatorWidgetState();
}

//stage of the calculator widget
class _CalculatorWidgetState extends State<CalculatorWidget> {
  //expression
  String input = "";

  //evaluate expression and show in dialog
  void OnButtonClicked(String value) {
    setState(() {
      if (value == "=") {
        String result = Evaluate(input);
        AlertDialog dialog = new AlertDialog(
            content: new Text("Expression: $input \n"
                "Result: $result"));
        showDialog(context: context, child: dialog);
        input = "";
      } else {
        input += value;
      }
    });
  }

  //evaluate. in case of invalid expression return error message
  String Evaluate(String expression) {
    String result = "Invalid Expression";
    try {
      Parser p = new Parser();
      Expression exp = p.parse(expression);
      var cm = new ContextModel();
      var evaluated = exp.evaluate(EvaluationType.REAL, cm);
      result = evaluated.toString();
    } catch (e) {
      print("Failed to evaluate expression");
    }
    return result;
  }

  Text getBoldText(String txt) {
    var textStyle = new TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.0
    );
    return new Text(txt, style: textStyle);
  }

  Container getButton(String txt) {
    var btn = new RaisedButton(
        color: Colors.blue[500],
        child: new Text(txt, style: new TextStyle(color: Colors.grey[300])),
        onPressed: () {
          OnButtonClicked(txt);
        });
    var margin = const EdgeInsets.all(1.0);
    var c = new Container(padding: margin, child: btn);
    return c;
  }

  Widget getInputSection() {
    return new Container(
      padding: const EdgeInsets.all(32.0),
      child: getBoldText(input == "" ? "Please enter expression" : input),
    );
  }

  Row getButtonsRow(String threeButtonsContent) {
    var tbc = threeButtonsContent;
    //center the row
    return new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      getButton(tbc[0]),
      getButton(tbc[1]),
      getButton(tbc[2]),
    ]);
  }

  Container getKeyboardSection() {
    return new Container(
        child: new Column(children: [
      getButtonsRow("123"),
      getButtonsRow("456"),
      getButtonsRow("789"),
      getButtonsRow("0.+"),
      getButtonsRow("-*/"),
      getButtonsRow("()="),
    ]));
  }

  //build the widget. using methods ("get") for buttons listeners to work
  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Column(children: [
      getInputSection(),
      getKeyboardSection(),
    ]));
  }
}

//main widget. can be stateless, even if widgets inside are not
class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget calculatorSection = new CalculatorWidget();

    return new MaterialApp(
      title: 'Flutter Calculator',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter Calculator'),
        ),
        body: new ListView(
          children: [
            calculatorSection,
          ],
        ),
      ),
    );
  }
}
