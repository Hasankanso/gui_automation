from Commands.Command import Command, auto


class LeftClick(Command):
    type = "left_click"

    def __init__(self):
        super().__init__('{"type" : "left_click"}')

    def execute(self, commands, commands_counter):
        auto.leftClick()

    def is_valid(self):
        return True

    def print(self):
        return ""


class RightClick(Command):
    type = "right_click"

    def __init__(self):
        super().__init__('{"type" : "right_click"}')

    def execute(self, commands, commands_counter):
        auto.rightClick()

    def is_valid(self):
        return True
