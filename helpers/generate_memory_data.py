import random

file_path = "flash_ram_content_hex.txt"

num_words = 4096 

with open(file_path, "w") as file:
    for i in range(num_words):
        hex_val = format(0, '016X')
        file.write(hex_val)
        if i < num_words - 1:
          file.write('\n')

print(f"File '{file_path}' generated successfully.")
