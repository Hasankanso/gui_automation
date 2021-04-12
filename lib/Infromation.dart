import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Information"),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Automate boring repetitive pc tasks using this tool. Create a "
                  "list of commands and execute them using the run button.\n\n",
                  style: TextStyle(fontSize: 25),
                  overflow: TextOverflow.fade,
                ),
                Text(
                  "Shortcuts:\nDelete a list-item:\n"
                  "Click on it and press delete key in the keyboard.\n\nChange item position:\nClick "
                  "on the "
                  "item and hold Shift + arrowUp or arrowDown\n\nTo move item selection up and "
                  "down:"
                  "\nArrowUp or "
                  "arrowDown after highlighting an item using mouse click\n\n",
                  style: TextStyle(fontSize: 25, color: Colors.blueAccent.shade700),
                  overflow: TextOverflow.fade,
                ),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.yellow.shade200,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.red,
                            size: 60,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Warning!",
                            style: TextStyle(fontSize: 25, color: Colors.red),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Text(
                          "While running an automation, if something unexpected happened and you "
                          "want to stop the automation, just move the mouse cursor to a screen "
                          "corner, "
                          "backend will stop the execution then.\nIf a sleep command is running you have to keep"
                          " the mouse cursor in the corner until it finishes, only after that "
                          "backend will read your force stop signal.",
                          style: TextStyle(fontSize: 25),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\n\nThere are some features I "
                  "would like to "
                  "implement "
                  "like steps-recorder, "
                  "save/load json commands file through an open Dialog (this is a flutter "
                  "limitation), "
                  "save sequence of commands as one "
                  "command and add it to the commands palette..."
                  ".\n\nAs a "
                  "workaround "
                  "to "
                  "save and load json files I made a json inspection page, you can copy the json data"
                  "from there and save it on your machine, you can paste your saved json file as "
                  "well "
                  "in order to execute it.\n\n\nHave a smart and safe automation :)\nHassan Kanso",
                  style: TextStyle(fontSize: 25),
                  overflow: TextOverflow.fade,
                ),
              ],
            )),
      ),
    );
  }
}
