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

def convert_to_three_bits_binary(number):
    binary_representation = bin(number)[2:]
    
    three_bits_binary = binary_representation.zfill(3)

    return three_bits_binary

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
def write_to_file(file_name, bits):
    with open(file_name, 'w') as file:
       filtered_list = [item for item in bits if item != ""]
       for item in filtered_list:
        if item == "$":
            file.write("\n")  
        else:
            file.write(str(item))

def extract_op_code(instr):
    return instruction_set[instr]

def extract_32bit_value(instr):
    return int(instr in is_immidiate)

def extract_Rdest(instr):
    if (instr[0] in rdest):
        return convert_to_three_bits_binary(regs.index(instr[1]))
    else:
        return "000"
def extract_Rsrc1(instr):
    if (instr[0] in rscr1):
        if not instr[0] in one_operand_insts:
           return convert_to_three_bits_binary(regs.index(instr[2]))
        else:
            return convert_to_three_bits_binary(regs.index(instr[1]))
    elif (instr[0] in rdst_eq_rsrc1 or instr[0] in rdst_eq_rsrc_imm):
        return convert_to_three_bits_binary(regs.index(instr[1]))
    else :
        return "000"
def extract_Rsrc2(instr):
    if (instr[0]=="cmp"):
        return convert_to_three_bits_binary(regs.index(instr[1]))
    if (instr[0] in rscr2):
        return convert_to_three_bits_binary(regs.index(instr[3]))
    else :
        return ""
def extract_EA(instr):
    if (instr[0] in ealow):
        return convert_to_EA(instr[2])
    elif (instr[0] in eacat):
        return "0000"
    elif (instr[0] in is_immidiate):
        return "000"
    elif (instr[0] in rdst_eq_rsrc1):
        return "000"
    elif not instr[0] in rscr2:
        return "0000"
def extract_function(instr):
    return function_set[instr]
def get_bin(hexs):
     hex_part = hexs.split("'h")[0]
     decimal_number = int(hex_part, 16)
     binary_string = bin(decimal_number)[2:]
     return binary_string

def extract_16bits(instr,bits):
    if (instr[0] in is_immidiate):
        bits.append("$")
        if (instr[0] =="addi"):
            bits.append(convert_to_Immediate(get_bin(instr[3])))
        else:
            bits.append(convert_to_Immediate(get_bin(instr[2])))

read_from_file("inst.txt")

bits=[]
for line in processed_lines:
    if not validate_instruction(line):
        print("Error", line)
    else:
        if line[0]=="nop":
            bits.append("1111111111111111")
            continue
        if line[0]=="ret":
            bits.append("1100000000000101")
            continue
        if line[0]=="rti":
            bits.append("1100000000000001")
        bits.append(extract_op_code(line[0]))
        bits.append(extract_32bit_value(line[0]))
        bits.append(extract_Rdest(line))
        bits.append(extract_Rsrc1(line))
        bits.append(extract_Rsrc2(line))
        bits.append(extract_EA(line))
        bits.append(extract_function(line[0]))
        extract_16bits(line,bits)
        bits.append('$')


write_to_file("binary.txt", bits)
