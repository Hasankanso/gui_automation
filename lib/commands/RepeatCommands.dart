import 'package:automation/commands/Command.dart';
import 'package:flutter/material.dart';

class RepeatCommands extends StatefulWidget with Command {
  @override
  _RepeatCommandsState createState() => _RepeatCommandsState();
  final TextEditingController timesTextController = new TextEditingController(text: "2");
  String dropdownValue = 'all_above';

  @override
  bool isValid() {
    return this.timesTextController.text.isNotEmpty &&
        int.tryParse(this.timesTextController.text) != null;
  }

  @override
  String toJson() {
    return '{"type" : "repeat_commands", "times" : ${this.timesTextController.text}, "side" : "${this.dropdownValue}" }';
  }
}

class _RepeatCommandsState extends State<RepeatCommands> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Row(
          children: [
            Spacer(flex: 1),
            Expanded(flex: 6, child: Text("Repeat")),
          ],
        ),
      ),
      Expanded(
        flex: 5,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: DropdownButton<String>(
                value: widget.dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    widget.dropdownValue = newValue;
                  });
                },
                items: <String>['all_above', 'all_below']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Spacer(flex: 1),
            Expanded(
                flex: 3,
                child: TextField(
                  decoration: InputDecoration(labelText: "Times"),
                  controller: widget.timesTextController,
                )),
          ],
        ),
      ),
      Spacer(flex: 1),
    ]);
  }
}
