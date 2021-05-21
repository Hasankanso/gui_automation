import json
from Commands.CommandsParser import parse, load_classes
import argparse
import sys

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", help='enter the json commands file')
    parser.add_argument("--commands", help="enter json commands as string")
    args = parser.parse_args()

    # load commands either from commands argument or from a provided json file.
    if args.commands is not None:
        commands = json.loads(args.commands)
    else:
        with open(args.file) as json_file:
            if json_file is None:
                print("cannot find provided json file.")
                sys.exit(1)
            commands = json.load(json_file)

    print("Backend: received commands: ", commands, "\n\n")

    # sub routines will be parsed also.
    commands = parse(commands, load_classes())

    # validate commands before any execution, this may reduce runtime unexpected behavior.
    valid = True
    for command in commands:
        if not command.is_valid():
            valid = False
            print("the following command is not valid: ", command.print())

    # exit only if at least one command is not valid and after checking all commands and gave
    # feedback to user
    if not valid:
        sys.exit(0)

    # pass commands_counter (similar to program counter, pc), and the list of commands to every
    # execution, this will help the repeat command to repeat a chunk of the commands list.
    commands_counter = 0
    for command in commands:
        command.execute(commands, commands_counter)
        commands_counter += 1

    sys.exit(0)
# TODO: defensive programming, implement record feature. make requirements file to install through pip
