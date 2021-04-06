import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class Settings extends StatelessWidget {
  final TextEditingController pythonPathController = new TextEditingController();
  Future<Box<String>> hiveBoxFuture;
  Box<String> box;
  static final String pythonCodePathKey = "pythonCodePath";

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
              pythonPathController.text = box.get(pythonCodePathKey);
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
                          child: IconButton(icon: Icon(Icons.more_horiz), onPressed: null),
                        )
                      ],
                    )),
                Spacer(flex: 4),
              ]);
            } else if (snapshot.hasError) {
              return Center(
                  child:
                      Text("Something is wrong with storage, error: " + snapshot.error.toString()));
            }
            return Center(child: CircularProgressIndicator());
          }),
      bottomNavigationBar: Container(
        height: 50,
        width: 100,
        child: MaterialButton(
          color: Colors.blue,
          child: Text("Save"),
          onPressed: () {
            box.put(pythonCodePathKey, pythonPathController.text);
          },
        ),
      ),
    );
  }
}
