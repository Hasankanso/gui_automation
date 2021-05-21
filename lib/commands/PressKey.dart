import 'package:automation/commands/Command.dart';
import 'package:automation/commands/CommandTile.dart';
import 'package:flutter/material.dart';

class PressKey extends StatelessWidget with Command {
  final TextEditingController keyController = new TextEditingController();

  @override
  String toJson() {
    return '{"type" : "press_key", "key" : "${this.keyController.text}" }';
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Row(
          children: [
            Spacer(flex: 1),
            Expanded(flex: 6, child: Text("Press Key")),
          ],
        ),
      ),
      Expanded(
        flex: 5,
        child: TextField(
            textInputAction: TextInputAction.none,
            decoration: InputDecoration(labelText: "Key Name"),
            controller: keyController),
      ),
      Spacer(flex: 1),
    ]);
  }

  @override
  bool isValid() {
    return this.keyController.text.isNotEmpty;
  }

  static createTile({Function(int p1)? onSelect}) {
    return () => CommandTile(key: UniqueKey(), onSelect: onSelect, child: PressKey());
  }
}
