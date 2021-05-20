import sys

from Commands.Command import Command, auto


class PressKey(Command):
    type = "press_key"

    def __init__(self, json):
        super().__init__(json)
        try:
            self.key = json["key"]
        except KeyError:
            print("Backend: Error: 'key' parameter is not found in:\n ", json)
            sys.exit(1)

    def execute(self, commands, commands_counter):
        assert(self.key != "")
        auto.press(self.key)

    def is_valid(self):
        return isinstance(self.key, str) and self.key != ""
