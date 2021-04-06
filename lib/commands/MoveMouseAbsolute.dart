import 'package:automation/commands/Command.dart';
import 'package:flutter/material.dart';

class MoveMouseAbsolute extends StatelessWidget with Command {
  final TextEditingController xController = new TextEditingController(),
      yController = new TextEditingController();

  @override
  String toJson() {
    return '{"type" : "move_mouse_absolute", "x" : ${this.xController.text}, "y" : ${this.yController.text} }';
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Row(
          children: [
            Spacer(flex: 1),
            Expanded(flex: 6, child: Text("Move To")),
          ],
        ),
      ),
      Expanded(
        flex: 5,
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: TextField(
                  decoration: InputDecoration(labelText: "X"),
                  controller: xController,
                  keyboardType: TextInputType.number),
            ),
            Spacer(flex: 1),
            Expanded(
              flex: 9,
              child: TextField(
                decoration: InputDecoration(labelText: "Y"),
                controller: yController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
      Spacer(flex: 1),
    ]);
  }

  @override
  bool isValid() {
    return this.xController.text.isNotEmpty &&
        this.yController.text.isNotEmpty &&
        double.tryParse(this.xController.text) != null &&
        double.tryParse(this.yController.text) != null;
  }
}
