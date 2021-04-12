import 'dart:io';

import 'package:automation/CommandsPalette.dart';
import 'package:automation/Infromation.dart';
import 'package:automation/InspectJson.dart';
import 'package:automation/commands/Command.dart';
import 'package:automation/commands/CommandTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'Settings.dart';

//TODO:
//1.make multiple commands lists possible (through tabs),
//2.settings page (with cache) save recent opened files, and location of python backend.
//3.save commands as a file.
//4.panel of available commands, on click add to the list.
//5.defensive programming, check input types and highlight if a required command parameter is not assigned.

void main() async {
  var path = Directory.current.path;
  Hive.init(path);
  await Hive.openBox<String>("settings");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<int> selectedItem = ValueNotifier<int>(-1);
  static bool pyRunning = false;

  static void runPythonBackend(String commands) async {
    Box<String> settings = Hive.box<String>("settings");
    String path = settings.get(Settings.pythonCodePathKey);
    if (path == null || path.isEmpty) {
      path = Settings.defaultPythonCodePath;
      settings.put(Settings.pythonCodePathKey, Settings.defaultPythonCodePath);
    }

    if (!MyApp.pyRunning) {
      MyApp.pyRunning = true;
      Process.run(
        "python",
        [path, '--commands', commands],
      ).then((result) {
        MyApp.pyRunning = false;
        stdout.write(result.stdout);
        stderr.write(result.stderr);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<CommandTile> items = [];
  bool isShiftHeld = false;

  String commands2Json() {
    String json = "[";

    if (items.isEmpty) return "{}";

    Command first = items[0].command;

    if (!first.isValid()) return "{}";

    json += first.toJson();
    for (int i = 1; i < items.length; i++) {
      Command item = items[i].command;

      if (!item.isValid()) break;

      json += ", " + item.toJson();
    }

    json += "]";

    return json;
  }

  void onItemSelect(int newId) {
    MyApp.selectedItem.value = newId;
  }

  void _onPick(CommandTile newCommand) {
    setState(() {
      items.add(newCommand);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Expanded(
              flex: 2,
              child: CommandsPalette(
                  onPick: _onPick, onSelect: onItemSelect, itemsCount: items.length)),
          Expanded(
            flex: 10,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Spacer(flex: 8),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(Icons.info_outline),
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Information()));
                            },
                          )),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Settings()));
                            },
                          )),
                      Spacer(flex: 1),
                      Expanded(
                        flex: 5,
                        child: MaterialButton(
                          color: Colors.blue,
                          child: Text("Result in Json"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InspectJson(jsonString: commands2Json())));
                          },
                        ),
                      ),
                      Spacer(flex: 1),
                      Expanded(
                        flex: 5,
                        child: MaterialButton(
                          color: Colors.blue,
                          child: Row(
                            children: [
                              Icon(
                                Icons.play_arrow,
                                color: Colors.green,
                              ),
                              Text("Run"),
                            ],
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            MyApp.runPythonBackend(commands2Json());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: SizedBox(
                  height: 20,
                )),
                Expanded(
                  flex: 20,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    autofocus: true,
                    onKey: onKeyboardKeyPressed,
                    child: items.length == 0
                        ? Text("List is empty. Add commands from the palette left")
                        : ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return items[index];
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(flex: 1),
        ],
      ),
    );
  }

  void onKeyboardKeyPressed(RawKeyEvent event) {
    final int position = MyApp.selectedItem.value;
    if (position < 0) return;
    assert(position == 0 || position < items.length);

    if (event.isKeyPressed(LogicalKeyboardKey.delete)) {
      if (position >= 0 && position < items.length) {
        setState(() {
          items.removeAt(position);

          for (int i = position; i < items.length; i++) {
            items[i].id -= 1;
          }

          if (position < items.length) {
            items[position].select();
            onItemSelect(position);
          } else if (position > 0) {
            items[position - 1].select();
            onItemSelect(position - 1);
          }
        });
      }
    } else if (isShiftHeld && event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      if (position > 0) {
        CommandTile currTile = items[position];
        setState(() {
          items[position - 1].id = position;
          currTile.id = position - 1;

          items[position] = items[position - 1];
          items[position - 1] = currTile;
          onItemSelect(position - 1);
        });
      }
    } else if (isShiftHeld && event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      if (position < items.length - 1) {
        CommandTile currTile = items[position];
        setState(() {
          items[position + 1].id = position;
          currTile.id = position + 1;

          items[position] = items[position + 1];
          items[position + 1] = currTile;
          onItemSelect(position + 1);
        });
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      if (position >= 1 && position < items.length) {
        setState(() {
          items[position - 1].select();
          items[position].unselect();
          onItemSelect(position - 1);
        });
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      if (position >= 0 && position < items.length - 1) {
        setState(() {
          items[position + 1].select();
          items[position].unselect();
          onItemSelect(position + 1);
        });
      }
    }
    if (event.logicalKey.keyId == LogicalKeyboardKey.shiftLeft.keyId) {
      if (event.runtimeType.toString() == 'RawKeyDownEvent') {
        isShiftHeld = true;
      }
      if (event.runtimeType.toString() == 'RawKeyUpEvent') {
        isShiftHeld = false;
      }
    }
  }
}
