from commonfunctions import *


processed_lines=read_from_file("inst.txt")

bits=convert_to_binary(processed_lines)

write_to_file("binary.txt", bits)
