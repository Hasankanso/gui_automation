import pyautogui as auto

class Command:

    # list to create track of all instantiated objects
    instances = []
    instance_count = 0

    def __init__(self, json):
        self.json = json
        # append instance of class
        Command.instances.append(json['type'])
        try:
            self.name = json['name']
        except KeyError:
            # tally up count of instances of said object
            for instance in self.instances:
                if instance == json['type']:
                    self.instance_count += 1
            # name command with generic command name + instance count
            self.name = json['type'] + str(self.instance_count)

    def execute(self, commands, counter):
        pass

    def print(self):
        return self.json

    def is_valid(self):
        pass
