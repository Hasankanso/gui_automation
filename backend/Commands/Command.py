import pyautogui as auto


class Command:
    def __init__(self, json):
        self.json = json

    def execute(self, commands, counter):
        pass

    def print(self):
        return self.json

    def is_valid(self):
        pass
