import 'package:automation/commands/Command.dart';
import 'package:automation/commands/CommandTile.dart';
import 'package:flutter/material.dart';

class HotKeyCommand extends StatelessWidget with Command {
  _AutoExtensionListController listController = new _AutoExtensionListController();

  @override
  String toJson() {
    String keys = "[";
    if (this.listController.controllers!.isNotEmpty) {
      keys += '"' + this.listController.controllers!.first.text + '"';
    }
    for (int i = 1; i < this.listController.controllers!.length; i++) {
      String keyText = this.listController.controllers![i].text;
      if (keyText.isEmpty) break;

      keys += ", " + '"' + keyText + '"';
    }
    keys += "]";

    return '{"type" : "hot_key", "keys" : $keys }';
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Row(
          children: [
            Spacer(flex: 1),
            Expanded(
                flex: 6,
                child: Text(
                  "HotKey (case insensitive)",
                  overflow: TextOverflow.visible,
                )),
          ],
        ),
      ),
      Expanded(
          flex: 5,
          child: Container(height: 50, child: _AutoExtensionList(controller: listController))),
      Spacer(flex: 1),
    ]);
  }

  @override
  bool isValid() {
    for (int i = 0; i < this.listController.controllers!.length; i++) {
      if (this.listController.controllers!.isEmpty) return false;
    }

    return true;
  }

  static createTile({Function(int p1)? onSelect}) {
    return () => CommandTile(key: UniqueKey(), onSelect: onSelect, child: HotKeyCommand());
  }
}

class _AutoExtensionList extends StatefulWidget {
  List<TextEditingController>? controllers;
  final _AutoExtensionListController? controller;

  _AutoExtensionList({this.controller}) {
    if (controllers == null) {
      controllers = [];
    }
    controller!.controllers = controllers;
  }

  @override
  __AutoExtensionListState createState() => __AutoExtensionListState();
}

class __AutoExtensionListState extends State<_AutoExtensionList> {
  late List<Widget> _keyItems;

  @override
  void initState() {
    TextEditingController tec = TextEditingController();
    _keyItems = [
      _TextField(
        key: Key(widget.controllers!.length.toString()),
        controller: tec,
        allControllers: widget.controllers,
        addItem: addItem,
        removeItem: removeItem,
      )
    ];

    widget.controllers!.add(tec);

    super.initState();
  }

  void removeItem() {
    setState(() {
      _keyItems.removeLast();
      widget.controllers!.removeLast();

      for (int i = _keyItems.length - 1; i >= 1; i--) {
        if (widget.controllers![i].text.isNotEmpty) {
          break;
        }
        _keyItems.removeLast();
        widget.controllers!.removeLast();
      }
    });
  }

  void addItem() {
    TextEditingController tec = new TextEditingController();
    setState(() {
      _keyItems.add(_TextField(
        key: Key(widget.controllers!.length.toString()),
        controller: tec,
        allControllers: widget.controllers,
        addItem: addItem,
        removeItem: removeItem,
      ));
      widget.controllers!.add(tec);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _keyItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _keyItems[index];
        });
  }
}

class _AutoExtensionListController {
  List<TextEditingController>? controllers;
}

class _TextField extends StatelessWidget {
  final Function()? addItem;
  final Function()? removeItem;
  final TextEditingController? controller;
  final List<TextEditingController>? allControllers;
  final Key? key;

  _TextField({this.key, this.controller, this.allControllers, this.addItem, this.removeItem});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: TextField(
        key: key,
        decoration: InputDecoration(labelText: "Key"),
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          if (allControllers!.last.text.isNotEmpty) {
            addItem!();
          } else if (allControllers!.length > 1 &&
              allControllers![allControllers!.length - 1].text.isEmpty &&
              allControllers![allControllers!.length - 2].text.isEmpty) {
            removeItem!();
          }
        },
      ),
    );
  }
}
