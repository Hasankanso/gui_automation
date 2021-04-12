import json
from Commands.CommandsParser import parse
import argparse
import sys

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", help='enter the json commands file')
    parser.add_argument("--commands", help="enter json commands as string")
    args = parser.parse_args()

    print("Backend: received commands: ", args.commands)
    if args.commands is not None:
        commands = json.loads(args.commands)
    else:
        with open(args.file) as json_file:
            if json_file is None:
                print("cannot find provided json file.")
                sys.exit(1)
            commands = json.load(json_file)

    commands = parse(commands)

    valid = True
    for command in commands:
        if not command.is_valid():
            valid = False
            print("the following command is not valid: ", command.print())

    if not valid:
        sys.exit(0)

    commands_counter = 0
    for command in commands:
        command.execute(commands, commands_counter)
        commands_counter += 1

    sys.exit(0)
# TODO: defensive programming, implement record feature. make requirements file to install through pip
