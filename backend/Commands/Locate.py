from Commands.Command import Command, auto
import sys
import os

class Locate(Command):
    type = "locate"

    def __init__(self, json):
        super().__init__(json)
        self.template_position = [0,0]
        self.valid_result = False

        # required parameters
        try:
            self.template_path = json["template_path"]
        except KeyError:
            print("Backend: Error: template path is not found in:\n ", self.name)
            sys.exit(1)

    def execute(self, commands, commands_counter):

       try:
           self.template_position = auto.locateCenterOnScreen(self.template_path)
       except auto.ImageNotFoundException:
            print('template image: {} not found'.format(os.path.split(self.template_path)[1]))

    def is_valid(self):
        try:
            open(self.template_path, 'r')
            return True
        except IOError:
            print('Invalid Path: {}'.format(self.template_path))
            return False

