import 'package:automation/commands/CommandTile.dart';
import 'package:automation/commands/MouseClick.dart';
import 'package:automation/commands/MoveMouseAbsolute.dart';
import 'package:automation/commands/PressKey.dart';
import 'package:automation/commands/RepeatCommands.dart';
import 'package:automation/commands/SleepCommand.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'commands/EnterTextCommand.dart';
import 'commands/HotKeyCommand.dart';

class CommandsPalette extends StatelessWidget {
  final void Function(CommandTile) onPick;
  List<Widget> _children;
  final int itemsCount;
  final Function(int) onSelect;

  CommandsPalette({Key key, @required this.onPick, @required this.itemsCount, this.onSelect})
      : super(key: key) {
    Key key = UniqueKey();
    _children = [
      CommandIconButton(
        commandTile: CommandTile(
            key: key, id: itemsCount, onSelect: this.onSelect, child: MoveMouseAbsolute()),
        iconData: Icons.mouse,
        callback: onPick,
        message: "Move Mouse, Absolute position",
      ),
      CommandIconButton(
        commandTile:
            CommandTile(key: key, id: itemsCount, onSelect: this.onSelect, child: PressKey()),
        iconData: Icons.keyboard,
        callback: onPick,
        message: "Press Keyboard Key",
      ),
      CommandIconButton(
        commandTile:
            CommandTile(key: key, id: itemsCount, onSelect: this.onSelect, child: SleepCommand()),
        iconData: Icons.watch_later,
        callback: onPick,
        message: "do nothing for amount of time",
      ),
      CommandIconButton(
        commandTile:
            CommandTile(key: key, id: itemsCount, onSelect: this.onSelect, child: HotKeyCommand()),
        iconData: Icons.local_fire_department,
        callback: onPick,
        message: "hotkey, keys combination",
      ),
      CommandIconButton(
        commandTile: CommandTile(
            key: key, id: itemsCount, onSelect: this.onSelect, child: EnterTextCommand()),
        iconData: Icons.text_fields,
        callback: onPick,
        message: "enter text, wherever it's focused",
      ),
      CommandIconButton(
        commandTile:
            CommandTile(key: key, id: itemsCount, onSelect: this.onSelect, child: RepeatCommands()),
        iconData: Icons.repeat,
        callback: onPick,
        message: "repeat commands for an amount for times",
      ),
      CommandIconButton(
        commandTile:
            CommandTile(key: key, id: itemsCount, onSelect: this.onSelect, child: MouseClick()),
        iconData: Icons.touch_app,
        callback: onPick,
        message: "click left or "
            "right mouse button",
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: 2, children: _children);
  }
}
