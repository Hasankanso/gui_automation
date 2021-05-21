import 'package:automation/commands/Command.dart';
import 'package:automation/main.dart';
import 'package:flutter/material.dart';

class CommandTile extends StatefulWidget {
  int id;

  final void Function(int id)? onSelect;
  Command? command;

  Key? key;
  final Widget? child;
  final Color unselectedColor = Colors.white54;
  final Color selectedColor = Colors.lightBlueAccent.shade700;

  Color? _backgroundColor;

  void select() {
    _backgroundColor = selectedColor;
  }

  void unselect() {
    _backgroundColor = unselectedColor;
  }

  CommandTile({this.key, this.onSelect, this.child, this.id = -1}) {
    _backgroundColor = unselectedColor;
    command = child as Command?;
  }

  @override
  _CommandTileState createState() => _CommandTileState();
}

class _CommandTileState extends State<CommandTile> {
  void select() {
    if (widget.onSelect != null) {
      widget.onSelect!(widget.id);
    }
    setState(() {
      widget._backgroundColor = widget.selectedColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        select();
      },
      child: ValueListenableBuilder(
          valueListenable: MyApp.selectedItem,
          builder: (context, dynamic value, child) {
            if (value != widget.id) {
              widget.unselect();
            }
            return Card(
              color: widget._backgroundColor,
              key: this.widget.key,
              child: child,
            );
          },
          child: this.widget.child),
    );
  }
}

class CommandIconButton extends StatelessWidget {
  final void Function(CommandTile)? callback;
  final CommandTile Function()? creator;
  final IconData? iconData;
  final String? message;

  const CommandIconButton({Key? key, this.creator, this.iconData, this.callback, this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: this.message!,
      child: InkWell(
          onTap: () {
            callback!(creator!());
          },
          child: Icon(iconData)),
    );
  }
}
