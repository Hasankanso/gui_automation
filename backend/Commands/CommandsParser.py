import importlib
import os
import sys

def parse(data):
    # blank list of all possible command references
    command_references = []
    # list of all commands to run
    command_list = []

    path = 'Commands'
    # get list of all .py files in directory except this script
    command_filenames = [x for x in os.listdir(path) if x.endswith('.py') and x != os.path.basename(__file__)]
    # bring the Command.py to the front of the list to be loaded in first
    command_filenames.insert(0, command_filenames.pop(command_filenames.index('Command.py')))

    for cmd_file in command_filenames:
        # get rid of extension
        command_name = os.path.splitext(cmd_file)[0]
        # load module Commands.'classname'
        module = importlib.import_module('{0}.{1}'.format(path, command_name))
        # add loaded module to list for later use
        command_references.append(getattr(module, command_name))

    # iterate through list of commands given from main
    for command in data:
        try:
            command_type = command["type"]
        except KeyError:
            print("Backend: Error: command type is not found in json item:\n ", command)
            sys.exit(1)
            
        # search through list of commands to instantiate object
        for command_ref in command_references:
            print('command name : {}'.format(command_ref))

            if command_type == getattr(command_ref, 'type'):
                print('command data {}'.format(command))
                command_list.append(command_ref(command))
                break

    return command_list