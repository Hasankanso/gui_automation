import sys

from Commands.Command import Command, auto


class MoveMouseAbsolute(Command):
    type = "move_mouse_absolute"

    def __init__(self, json):
        super().__init__(json)
        try:
            self.result = json["result"]
            self.get_result = True
            self.valid_result = False
        except KeyError:
            try:
                self.x = json["x"]
                self.y = json["y"]
                self.get_result = False

            except KeyError:
                print("Backend: Error: either 'x' or 'y' is not found in:\n ", json)
                sys.exit(1)

    def execute(self, commands, commands_counter):
        if self.get_result:
            for command in commands:
                command_to_find = self.result.split(".")
                if command.name == command_to_find[0]:
                    self.x, self.y = getattr(command, command_to_find[1])
                    self.valid_result = True
                    break

                if not self.valid_result:
                    print("Backend: Error: invalid result name and/or attribute:\n ", self.result)
                    sys.exit(1)

        assert(self.x != -1 and self.y != -1)
        auto.moveTo(self.x, self.y)

    def is_valid(self):
        if self.get_result:
            return isinstance(self.result, str)
        else:
            return isinstance(self.x, int) and isinstance(self.y, int)

