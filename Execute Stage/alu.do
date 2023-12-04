force -freeze sim:/ALU/src1 32'h00000002 0
force -freeze sim:/ALU/src2 32'h0000000F 0
force -freeze sim:/ALU/func  4'b0101 0
run 100ps
