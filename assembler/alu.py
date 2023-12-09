# from lists import *

# def alu_handeling(instr):
#     op = "00"
#     src1 = ''
#     src2 = ''
#     dst = ''
#     immidiate = ''
#     func = ''

#     is_imm = False
#     is_one = '0'
#     is_two = '0'
#     is_three = '0'
    
#     if instr[0] in is_immidiate:
#         is_imm = True
#     else:
#         is_imm = False
#     if instr[0] in one_operand_insts:
#         is_one = True
#     else:
#         is_one = False
#     if instr[0] in two_operand_insts:
#         is_two = True
#     else:
#         is_two = False
#     if instr[0] in three_operand_insts:
#         is_three = True
#     else:
#         is_three = False

#     if is_one:
#         src1 = register_bank[instr[1]]
#         src2 = '000'
#         dst =  src1
    
#     if is_two:
#         src1 = register_bank[instr[1]]
#         src2 = register_bank[instr[2]]
#         dst = src1

#     if is_three:
#         src1 = register_bank[instr[1]]
#         src2 = register_bank[instr[2]]
#         dst = register_bank[instr[3]]

    

#     func = function_set[instr[0]]

#     return op + immidiate + src1 + src2 + func
        