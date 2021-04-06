import sys

from Commands.Command import Command, auto


class EnterText(Command):
    type = "enter_text"

    def __init__(self, json):
        super().__init__(json)

        try:
            self.text = json["text"]
            self.delay = json["delay"]
            self.press_enter = json["press_enter"]
            self.start_delay = json["start_delay"]
        except KeyError:
            print("Backend: Error: some parameters are not found in:\n ", json)
            sys.exit(1)

    def execute(self, commands, commands_counter):
        auto.sleep(1 + self.start_delay)
        auto.write(self.text, interval=self.delay)
        if self.press_enter:
            auto.hotkey('enter')

    def is_valid(self):
        return isinstance(self.text, str) and isinstance(self.delay, int) and isinstance(self.start_delay, int) and type(self.press_enter) == bool

