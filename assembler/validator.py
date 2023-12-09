import re
from lists import *

def check_regix(regex):
    # Check if the line starts with a hexadecimal number followed by 'h
    if re.match(r'^[0-9a-fA-F]+\'h', regex):
        return True
    else:
        return False


def validate_instruction(instr):
    if instr[0] in no_operand_insts:
        if len(instr) != 1:
            return False
        return True
    elif instr[0] in one_operand_insts:
        if len(instr) != 2:
            return False
        if not instr[1] in regs:
            return False
        return True
           
    elif instr[0] in two_operand_insts:
        if len(instr) != 3:
            return False
        if not instr[1] in regs:
            return False
        if instr[0] not in is_immidiate:
            if not instr[2] in regs:
                return False
        else:
            return check_regix(instr[2])
        return True

    elif instr[0] in three_operand_insts:
        if len(instr) != 4:
            return False
        if not instr[1] in regs:
            return False
        if not instr[2] in regs:
            return False
        if instr[0] not in is_immidiate:
            if not instr[3] in regs:
                return False
        else:
            return check_regix(instr[3])
        return True
    else:
        return False           




