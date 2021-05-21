from Commands.Command import Command, auto
import sys


class click(Command):
    type = "click"

    def __init__(self, json):
        super().__init__(json)
        try:
            self.button = json["button"]
        except KeyError:
            print("Backend: Error: missing 'button' parameter, set default to left click" )
            self.button = "left"
            sys.exit(1)
        
    def execute(self, commands, commands_counter):
            try:
                if self.button != 'double':
                    auto.click(button=self.button)
                else:
                    auto.doubleClick()
            except  auto.PyAutoGUIException:
                print(auto.PyAutoGUIException)
                sys.exit(1)

    def is_valid(self):
        return self.button in ['left', 'right', 'middle', 'double']

    def print(self):
        return ""