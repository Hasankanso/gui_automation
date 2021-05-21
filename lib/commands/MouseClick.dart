import 'package:automation/commands/Command.dart';
import 'package:automation/commands/CommandTile.dart';
import 'package:flutter/material.dart';

class MouseClick extends StatefulWidget with Command {
  String? dropdownValue = "left_click";
  bool left = true;

  @override
  _MouseClickState createState() => _MouseClickState();

  @override
  bool isValid() {
    return true;
  }

  @override
  String toJson() {
    if (left) {
      return '{"type" : "left_click"}';
    } else {
      return '{"type" : "right_click"}';
    }
  }

  static createTile({Function(int p1)? onSelect}) {
    return () => CommandTile(key: UniqueKey(), onSelect: onSelect, child: MouseClick());
  }
}

class _MouseClickState extends State<MouseClick> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Row(
          children: [
            Spacer(flex: 1),
            Expanded(flex: 6, child: Text("Mouse Click")),
          ],
        ),
      ),
      Expanded(
        flex: 5,
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
          onChanged: (String? newValue) {
            setState(() {
              widget.dropdownValue = newValue;
              if (newValue == "left_click")
                widget.left = true;
              else if (newValue == "right_click") widget.left = false;
            });
          },
          items:
              <String>['left_click', 'right_click'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
      Spacer(flex: 1),
    ]);
  }
}
