from typing import List

from Commands.ClickMouse import LeftClick, RightClick
from Commands.Command import Command
from Commands.EnterText import EnterText
from Commands.HotKey import HotKey
from Commands.MoveMouseAbsolute import MoveMouseAbsolute
from Commands.OpenTerminal import OpenTerminal
from Commands.PressKey import PressKey
from Commands.RepeatCommands import RepeatCommands
from Commands.Sleep import Sleep
import sys


def parse(data):
    commands_list: List[Command] = []
    for command in data:

        try:
            command_type = command["type"]
        except KeyError:
            print("Backend: Error: command type is not found in json item:\n ", command)
            sys.exit(1)

        if command_type == MoveMouseAbsolute.type:
            commands_list.append(MoveMouseAbsolute(command))
        elif command_type == OpenTerminal.type:
            commands_list.append(OpenTerminal())
        elif command_type == EnterText.type:
            commands_list.append(EnterText(command))
        elif command_type == PressKey.type:
            commands_list.append(PressKey(command))
        elif command_type == Sleep.type:
            commands_list.append(Sleep(command))
        elif command_type == LeftClick.type:
            commands_list.append(LeftClick())
        elif command_type == RightClick.type:
            commands_list.append(RightClick())
        elif command_type == HotKey.type:
            commands_list.append(HotKey(command))
        elif command_type == RepeatCommands.type:
            commands_list.append(RepeatCommands(command))
    return commands_list
