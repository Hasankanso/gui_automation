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
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Text(
            "Automate boring repetitive pc tasks using this tool. create a "
            "list of commands and execute them using the run button, don't forget to specify the "
            "backend python script from the settings page.\n\n\nShortcuts:\nDelete a list-item:\n"
            "Click on it and press delete key from the keyboard.\n\nChange item position:\nClick "
            "on the "
            "item and hold Shift + arrowUp or arrowDown\n\nTo move item selection up and "
            "down:"
            "\nArrowUp or "
            "arrowDown after highlighting an item using mouse click\n"
            "\n\nWhile running an automation, if something unexpected happened and you "
            "want to stop the automation, just move the mouse cursor to a screen corner, the "
            "backend will stop the execution then.\nIf a sleep command is running you have to keep"
            " the mouse cursor in the corner till it finishes, only after that the backend "
            "will be able to terminate.\n\n\n"
            "There are some features I "
            "would like to "
            "implement "
            "like steps-recorder and "
            "save/load json file commands, for now you can do neither.\n\nAs a workaround to "
            "save and load json files I made a json inspection page, you can copy from there "
            "the json text and save it on your machine, you can paste your saved json file as well "
            "in order to execute it.\n\n\nHave a smart and safe automation :)\nHassan Kanso",
            style: TextStyle(fontSize: 25),
            overflow: TextOverflow.fade,
          ),
        ),
      ),
    );
  }
}
