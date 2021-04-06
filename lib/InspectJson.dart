import 'package:automation/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class InspectJson extends StatelessWidget {
  final String jsonString;

  TextEditingController jsonTextController = new TextEditingController();

  static final String pythonCodePathKey = "pythonCodePath";

  InspectJson({this.jsonString}) {
    jsonTextController.text = jsonString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Json Inspection"), actions: [
        MaterialButton(
          color: Colors.blue,
          child: Row(
            children: [
              Icon(
                Icons.play_arrow,
                color: Colors.green,
              ),
              Text("Run"),
            ],
          ),
          onPressed: () {
            FocusScope.of(context).unfocus();
            MyApp.runPythonBackend(jsonTextController.text);
          },
        ),
        IconButton(
          tooltip: "Copy to Clipboard",
          icon: Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(new ClipboardData(text: jsonString));
          },
        )
      ]),
      body: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextField(
            maxLines: 30,
            controller: jsonTextController,
            style: TextStyle(fontSize: 15),
          )),
    );
  }
}
