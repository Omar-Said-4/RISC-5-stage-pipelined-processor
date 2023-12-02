force -freeze sim:/ALU/src1 32'hFFFFFFFF 0
force -freeze sim:/ALU/src2 32'h00000005 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b0110 0
run 100ps
