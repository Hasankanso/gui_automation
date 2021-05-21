import 'dart:io';

import 'package:automation/CommandsPalette.dart';
import 'package:automation/Infromation.dart';
import 'package:automation/InspectJson.dart';
import 'package:automation/Styles.dart';
import 'package:automation/commands/Command.dart';
import 'package:automation/commands/CommandTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'Settings.dart';

//TODO:
//1.make multiple commands lists possible (through tabs),
//2.settings page (with cache) save recent opened files, and location of python backend.
//3.save commands as a file.
//4.panel of available commands, on click add to the list.
//5.defensive programming, check input types and highlight if a required command parameter is not assigned.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  await Hive.openBox<String>("settings");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<int> selectedItem = ValueNotifier<int>(-3);
  static bool pyRunning = false;

  static void runPythonBackend(String commands) async {
    Box<String> settings = Hive.box<String>("settings");
    String? path = settings.get(Settings.pythonCodePathKey);
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
  bool showContextualActions = false;

  String commands2Json() {
    String json = "[";

    if (items.isEmpty) return "{}";

    Command first = items[0].command!;

    if (!first.isValid()) return "{}";

    json += first.toJson();
    for (int i = 1; i < items.length; i++) {
      Command item = items[i].command!;

      if (!item.isValid()) break;

      json += ", " + item.toJson();
    }

    json += "]";

    return json;
  }

  void onItemSelect(int newId) {
    if (newId >= 0)
      showContextualActions = true;
    else
      showContextualActions = false;

    if ((newId + 1) * (MyApp.selectedItem.value + 1) < 0) {
      // +1 to avoid 0 case
      setState(() {
        MyApp.selectedItem.value = newId;
      });
    } else {
      MyApp.selectedItem.value = newId;
    }
  }

  void _onPick(CommandTile newCommand) {
    setState(() {
      newCommand.id = items.length;
      items.add(newCommand);
    });
  }

  void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      setState(() {
        items.removeAt(index);

        for (int i = index; i < items.length; i++) {
          items[i].id -= 1;
        }

        if (index < items.length) {
          items[index].select();
          onItemSelect(index);
        } else if (index > 0) {
          items[index - 1].select();
          onItemSelect(index - 1);
        } else {
          onItemSelect(-3);
        }
      });
    }
  }

  void moveItemUp(int index) {
    if (index > 0) {
      CommandTile currTile = items[index];
      setState(() {
        items[index - 1].id = index;
        currTile.id = index - 1;

        items[index] = items[index - 1];
        items[index - 1] = currTile;
        onItemSelect(index - 1);
      });
    }
  }

  void moveItemDown(int index) {
    if (index < items.length - 1) {
      CommandTile currTile = items[index];
      setState(() {
        items[index + 1].id = index;
        currTile.id = index + 1;

        items[index] = items[index + 1];
        items[index + 1] = currTile;
        onItemSelect(index + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showContextualActions
          ? AppBar(
              actions: [
                IconButton(
                  icon: Icon(Icons.delete, size: Styles.iconSize(context), color: Colors.red),
                  onPressed: () {
                    removeItem(MyApp.selectedItem.value);
                  },
                ),
                IconButton(
                  icon:
                      Icon(Icons.arrow_upward, size: Styles.iconSize(context), color: Colors.white),
                  onPressed: () {
                    moveItemUp(MyApp.selectedItem.value);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward,
                      size: Styles.iconSize(context), color: Colors.white),
                  onPressed: () {
                    moveItemDown(MyApp.selectedItem.value);
                  },
                ),
              ],
            )
          : AppBar(),
      body: Row(
        children: [
          Expanded(flex: 2, child: CommandsPalette(onPick: _onPick, onSelect: onItemSelect)),
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
                      Spacer(flex: 2),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(Icons.info_outline, size: Styles.iconSize(context)),
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Information()));
                            },
                          )),
                      Spacer(),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.settings,
                              size: Styles.iconSize(context),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Settings()));
                            },
                          )),
                      Spacer(flex: 2),
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
      removeItem(position);
    } else if (isShiftHeld && event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      moveItemUp(position);
    } else if (isShiftHeld && event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      moveItemDown(position);
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
