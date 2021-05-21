import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class Settings extends StatelessWidget {
  final TextEditingController pythonPathController = new TextEditingController();
  Future<Box<String>>? hiveBoxFuture;
  Box<String>? box;
  static final String pythonCodePathKey = "pythonCodePath";
  static final String defaultPythonCodePath = Directory.current.path + "/backend/main.py";

  Settings() {
    hiveBoxFuture = Hive.openBox("settings");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: FutureBuilder<Box<String>>(
          future: hiveBoxFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              box = snapshot.data;
              pythonPathController.text =
                  box!.get(pythonCodePathKey, defaultValue: defaultPythonCodePath)!;
              return Column(children: [
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Spacer(flex: 1),
                        Expanded(flex: 4, child: Text("Python Code Path:")),
                        Expanded(
                            flex: 10,
                            child: TextField(
                              controller: pythonPathController,
                            )),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                              icon: Icon(Icons.more_horiz),
                              tooltip: "not "
                                  "implemented yet",
                              onPressed: null),
                        )
                      ],
                    )),
                Spacer(flex: 3),
                Expanded(
                  flex: 1,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      MaterialButton(
                        color: Colors.blue,
                        child: Text("Save"),
                        onPressed: () {
                          box!.put(pythonCodePathKey, pythonPathController.text);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      MaterialButton(
                        color: Colors.grey,
                        child: Text("Reset Default"),
                        onPressed: () {
                          pythonPathController.text = defaultPythonCodePath;
                          box!.put(pythonCodePathKey, pythonPathController.text);
                        },
                      ),
                    ],
                  ),
                ),
              ]);
            } else if (snapshot.hasError) {
              return Center(
                  child:
                      Text("Something is wrong with storage, error: " + snapshot.error.toString()));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
