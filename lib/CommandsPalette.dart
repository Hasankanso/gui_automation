import 'package:automation/commands/CommandTile.dart';
import 'package:automation/commands/EnterTextCommand.dart';
import 'package:automation/commands/HotKeyCommand.dart';
import 'package:automation/commands/MouseClick.dart';
import 'package:automation/commands/MoveMouseAbsolute.dart';
import 'package:automation/commands/PressKey.dart';
import 'package:automation/commands/RepeatCommands.dart';
import 'package:automation/commands/SleepCommand.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommandsPalette extends StatefulWidget {
  final void Function(CommandTile) onPick;
  final Function(int)? onSelect;

  CommandsPalette({Key? key, required this.onPick, this.onSelect}) : super(key: key);

  @override
  _CommandsPaletteState createState() =>
      _CommandsPaletteState(onPick: this.onPick, onSelect: this.onSelect);
}

class _CommandsPaletteState extends State<CommandsPalette> {
  final void Function(CommandTile)? onPick;
  late List<Widget> _children;
  final List<CommandTile>? items;
  final Function(int)? onSelect;

  _CommandsPaletteState({this.onPick, this.items, this.onSelect});

  void initState() {
    _children = [
      CommandIconButton(
        creator: MoveMouseAbsolute.createTile(onSelect: onSelect),
        iconData: Icons.mouse,
        callback: onPick,
        message: "Move Mouse, Absolute position",
      ),
      CommandIconButton(
        creator: PressKey.createTile(onSelect: onSelect),
        iconData: Icons.keyboard,
        callback: onPick,
        message: "Press Keyboard Key",
      ),
      CommandIconButton(
        creator: SleepCommand.createTile(onSelect: onSelect),
        iconData: Icons.watch_later,
        callback: onPick,
        message: "do nothing for amount of time",
      ),
      CommandIconButton(
        creator: HotKeyCommand.createTile(onSelect: onSelect),
        iconData: Icons.local_fire_department,
        callback: onPick,
        message: "hotkey, keys combination",
      ),
      CommandIconButton(
        creator: EnterTextCommand.createTile(onSelect: onSelect),
        iconData: Icons.text_fields,
        callback: onPick,
        message: "enter text, wherever it's focused",
      ),
      CommandIconButton(
        creator: RepeatCommands.createTile(onSelect: onSelect),
        iconData: Icons.repeat,
        callback: onPick,
        message: "repeat commands for an amount for times",
      ),
      CommandIconButton(
        creator: MouseClick.createTile(onSelect: onSelect),
        iconData: Icons.touch_app,
        callback: onPick,
        message: "click left or "
            "right mouse button",
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: 2, children: _children);
  }
}
