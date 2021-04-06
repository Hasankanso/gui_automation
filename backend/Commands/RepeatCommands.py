import sys

from Commands.Command import Command, auto


class RepeatCommands(Command):
    type = "repeat_commands"

    def __init__(self, json):
        super().__init__(json)
        try:
            self.times = json["times"]
            self.side = json["side"]
        except KeyError:
            print("Backend: Error: some parameters are not found in:\n ", json)
            sys.exit(1)

    def execute(self, commands, curr_index):
        for x in range(0, self.times):
            counter = -1
            if self.side == "all_above":
                counter = 0
            else:
                counter = curr_index + 1

            if counter >= len(commands) or counter < 0:
                pass

            while counter < len(commands):
                if counter == curr_index:
                    break
                commands[counter].execute(commands, counter)
                counter += 1

    def is_valid(self):
        return (self.side == "all_above" or self.side == "all_below") and isinstance(self.times, int) and self.times > 0

