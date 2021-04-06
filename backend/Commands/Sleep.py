import sys
from datetime import time

from Commands.Command import Command, auto


class Sleep(Command):
    type = "sleep"

    def __init__(self, json):
        super().__init__(json)
        try:
            self.duration = json["duration"]
        except KeyError:
            print("Backend: Error: duration parameter is not found in:\n ", json)
            sys.exit(1)

    def execute(self, commands, commands_counter):
        auto.sleep(self.duration)

    def is_valid(self):
        return isinstance(self.duration, float)
