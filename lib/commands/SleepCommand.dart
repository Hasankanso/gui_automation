import 'package:automation/commands/Command.dart';
import 'package:automation/commands/CommandTile.dart';
import 'package:flutter/material.dart';

class SleepCommand extends StatelessWidget with Command {
  final TextEditingController keyController = new TextEditingController();

  @override
  String toJson() {
    return '{"type" : "sleep", "duration" : ${this.keyController.text} }';
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 1,
          child: Row(
            children: [
              Spacer(flex: 1),
              Expanded(flex: 6, child: Text("Sleep (sec)")),
            ],
          )),
      Expanded(
        flex: 5,
        child: TextField(
            decoration: InputDecoration(labelText: "Seconds"),
            controller: keyController,
            keyboardType: TextInputType.number),
      ),
      Spacer(flex: 1),
    ]);
  }

  @override
  bool isValid() {
    return this.keyController.text.isNotEmpty && double.tryParse(this.keyController.text) != null;
  }

  static createTile({Function(int p1)? onSelect}) {
    return () => CommandTile(key: UniqueKey(), onSelect: onSelect, child: SleepCommand());
  }
}
