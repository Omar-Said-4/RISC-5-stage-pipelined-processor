one_operand_insts = ['not', 'neg','dec','inc', 'out', 'in', 'jz', 'jmp', 'call', 'protect', 'free', 'push', 'pop']
no_operand_insts = ['nop', 'ret', 'rti']
two_operand_insts = ['swap', 'cmp', 'bitset', 'rcl', 'rcr', 'ldm', 'ldd', 'std', 'std']
thirty2_bit_inst=  ['addi','bitset','rcr','rcl', 'ldm','std','ldd','ldm', 'ldd', 'std', 'std']
three_operand_insts = ['add', 'addi', 'sub', 'and', 'or', 'xor']

is_immidiate = ['addi', 'rcl', 'rcr', 'bitset', 'ldm', 'ldd', 'std']

regs = ['r0', 'r1', 'r2', 'r3', 'r4', 'r5', 'r6', 'r7']

rdest= ['not', 'neg', 'dec', 'inc', 'add', 'addi', 'sub', 'and', 'or', 'xor', 'bitset', 'rcl', 'rcr', 'ldm', 'ldd', 'pop', 'in']

rscr1= ['swap', 'add', 'addi', 'sub', 'and', 'or', 'xor', 'cmp', 'rcl', 'rcr', 'std', 'push', 'out', 'jz', 'jmp', 'call', 'protect', 'free']
rdst_eq_rsrc1 = ['not', 'neg', 'dec', 'inc']
rdst_eq_rsrc_imm = ['bitset', 'rcl', 'rcr']

rscr2= ['add', 'sub', 'and', 'or', 'xor', 'cmp','swap']
ealow = ['std','ldd']
eacat=['push', 'pop','std','ldd','protect','free']
instruction_set = {
    "not": "00",
    "neg": "00",
    "inc": "00",
    "dec": "00",
    "add": "00",
    "addi": "00",
    "sub": "00",
    "and": "00",
    "xor": "00",
    "or": "00",
    "cmp": "00",
    "bitset": "00",
    "rcr": "00",
    "rcl": "00",
    "swap": "00",
    "ldm": "00",
    "push":"01",
    "pop":"01",
    "std":"01",
    "ldd":"01",
    "protect":"01",
    "free":"01",
    "in":"10",
    "out":"10",
    "call":"11",
    "jmp":"11",
    "jz":"11",
    "ret":"11",
    "rti":"11",
    "nop": "11",
}

# function set is 4 bits long
function_set = {
    "not": "0000",
    "neg": "0001",
    "inc": "0010",
    "dec": "0011",
    "add": "0100",
    "addi": "0101",
    "sub": "0110",
    "and": "0111",
    "xor": "1000",
    "or": "1001",
    "cmp": "1010",
    "bitset": "1011",
    "rcr": "1100",
    "rcl": "1101",
    "swap": "1110",
    "ldm": "1111",
    "push":"110",
    "pop":"111",
    "std":"010",
    "ldd":"011",
    "protect":"100",
    "free":"000",
    "in":"000",
    "out":"001",
    "call":"000",
    "jmp":"110",
    "jz":"010",
    "ret":"101",
    "rti":"001"
}

register_bank = {}
for i in range(8):
    register_bank[f"r{i}"] = f"{i:03b}"
