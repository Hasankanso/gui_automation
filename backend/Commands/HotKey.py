import sys

from Commands.Command import Command, auto


class HotKey(Command):
    type = "hot_key"

    def __init__(self, json):
        super().__init__(json)
        self.keys = ()
        array = []
        try:
            for key in json["keys"]:
                array.append(key)
            self.keys = tuple(array)
        except KeyError:
            print("Backend: Error: 'keys' parameter is not found in:\n ", json)
            sys.exit(1)

    def execute(self, commands, commands_counter):
        auto.hotkey(*self.keys)

    def is_valid(self):
        for key in self.keys:
            if not isinstance(key, str):
                return False
        return True

