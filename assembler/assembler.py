import re
from validator import *

def check_EA_Immediate(regex):
    # Check if the line starts with a hexadecimal number followed by 'h
    if re.match(r'^[0-9a-fA-F]+\'h', regex):
        # Extract the hexadecimal number
        hex_number = re.findall(r'^([0-9a-fA-F]+)\'h', regex)[0]
        # Convert the hexadecimal number to binary
        binary_number = bin(int(hex_number, 16))[2:]
        return True, binary_number
    else:
        return False,-1


def convert_to_EA(binary_number):
    return binary_number.zfill(20)

def convert_to_Immediate(binary_number):
    return binary_number.zfill(16)

binary_instructions=[]
# Convert the instructions to binary
def convert_to_binary(processed_lines):
    for line in processed_lines:
        validate, binary_number = check_EA_Immediate(line[-1])
        if validate:
            print(convert_to_EA(binary_number))
        if line[0] in instruction_set:
          if  instruction_set[line[0]] == "00":
              pass
        else:
            print(f"Error: {line[0]} is not a valid instruction")



processed_lines = []
# Read the file
def read_from_file(file_name):
    with open(file_name, 'r') as file:
        lines = file.readlines()
        # Replace commas with spaces, extract each line, and split by space
        for line in lines:
            if line.strip() and not line.startswith('#'):
                line = line.lower().replace(',', ' ')
                processed_lines.append(line.split())



# Open the file in write mode
def write_to_file(file_name, lines):
    with open(file_name, 'w') as file:
        for line in lines:
            file.write(line + '\n')

def extract_op_code(instr):
    return instruction_set[instr]



read_from_file("inst.txt")

for line in processed_lines:
    if not validate_instruction(line):
        print("Error", line)
    else:
        print("ACCEPTED + RESPECT", line)    
