import importlib
import os
import sys
import inspect


def parse(data):
    # blank dictionary of all possible command references
    command_references = {}
    # list of all commands to run
    command_list = []


    path = os.path.dirname(os.path.realpath(__file__))
    files = os.listdir(path)
    # get list of all .py files in directory except this script
    command_filenames = [x for x in files if x.endswith('.py') and x != os.path.basename(__file__)]
    # bring the Command.py to the front of the list to be loaded in first
    command_filenames.insert(0, command_filenames.pop(command_filenames.index('Command.py')))

    for cmd_file in command_filenames:
        # get rid of extension
        command_name = os.path.splitext(cmd_file)[0]

        # load module Commands.'classname'
        module = importlib.import_module('Commands.{0}'.format(command_name))

        # iterate over attributes of each module and add classes only
        for attribute_name in dir(module):
            attribute = getattr(module, attribute_name)
            if inspect.isclass(attribute):
                try:
                    # try to get its type, in order to add it to the dictionary for instant access
                    command_type = getattr(attribute, 'type')
                    command_references[command_type] = attribute
                except AttributeError:
                    # class has no type, ignore it, since Command class has no type.
                    pass

    # iterate through list of commands given from main
    for command in data:
        try:
            command_type = command["type"]
        except KeyError:
            print("Backend: Error: command type is not found in json item:\n ", command)
            sys.exit(1)

        # search through list of commands to instantiate object
        try:
            print('command data {}'.format(command))
            constructor = command_references[command_type]
            command_list.append(constructor(command))
        except KeyError:
            print(
                f"Backend : Error: command type '{command_type}' has no implementation yet. perhaps there's a typo in "
                f"type name")
            pass

    return command_list
