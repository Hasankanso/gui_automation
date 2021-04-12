import sys

from Commands.Command import Command, auto


class MoveMouseAbsolute(Command):
    type = "move_mouse_absolute"

    def __init__(self, json):
        super().__init__(json)
        try:
            self.x = json["x"]
            self.y = json["y"]
        except KeyError:
            print("Backend: Error: either 'x' or 'y' is not found in:\n ", json)
            sys.exit(1)

    def execute(self, commands, commands_counter):
        assert(self.x != -1 and self.y != -1)
        auto.moveTo(self.x, self.y)

    def is_valid(self):
        return isinstance(self.x, int) and isinstance(self.y, int)

