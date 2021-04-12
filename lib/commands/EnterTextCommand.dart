import 'package:automation/commands/Command.dart';
import 'package:flutter/material.dart';

class EnterTextCommand extends StatelessWidget with Command {
  final TextEditingController textController = new TextEditingController();
  TextEditingController delayController = new TextEditingController();
  TextEditingController startDelayController = new TextEditingController();

  EnterTextCommand() {
    delayController.text = 20.toString();
    startDelayController.text = 0.toString();
  }

  @override
  String toJson() {
    return '{"type" : "enter_text", "text" : "${this.textController.text}", "delay"'
        ' : '
        '${int.parse(delayController.text)}, "press_enter" : false, "start_delay" : ${int.parse(this.startDelayController.text)} }';
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 2,
        child: Row(
          children: [
            Spacer(flex: 1),
            Expanded(flex: 6, child: Text("Enter Text")),
          ],
        ),
      ),
      Expanded(
        flex: 11,
        child: Row(children: [
          Expanded(
              flex: 4,
              child: TextField(
                controller: startDelayController,
                decoration: InputDecoration(labelText: "start delay (ms)"),
              )),
          Expanded(
              flex: 4,
              child: TextField(
                controller: delayController,
                decoration: InputDecoration(labelText: "delay (ms)"),
              )),
          Spacer(flex: 1),
          Expanded(
            flex: 15,
            child: TextField(
              decoration: InputDecoration(labelText: "Text"),
              controller: textController,
              keyboardType: TextInputType.text,
              maxLines: 3,
            ),
          ),
        ]),
      ),
      Spacer(flex: 1),
    ]);
  }

  @override
  bool isValid() {
    return this.textController.text.isNotEmpty &&
        this.startDelayController.text.isNotEmpty &&
        this.delayController.text.isNotEmpty &&
        int.tryParse(this.startDelayController.text) != null &&
        int.tryParse(this.delayController.text) != null;
  }
}
