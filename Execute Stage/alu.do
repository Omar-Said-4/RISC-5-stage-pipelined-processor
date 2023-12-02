force -freeze sim:/ALU/src1 8'h01 0
force -freeze sim:/ALU/src2 8'h01 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b1011 0
run 100ps


force -freeze sim:/ALU/src1 8'hF2 0
force -freeze sim:/ALU/src2 8'h02 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b0000 0
run 100ps

force -freeze sim:/ALU/src1 8'h03 0
force -freeze sim:/ALU/src2 8'h02 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b0001 0
run 100ps

force -freeze sim:/ALU/src1 8'hFF 0
force -freeze sim:/ALU/src2 8'hFF 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b0010 0
run 100ps

force -freeze sim:/ALU/src1 8'hFF 0
force -freeze sim:/ALU/src2 8'h02 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b0011 0
run 100ps

force -freeze sim:/ALU/src1 8'h0F 0
force -freeze sim:/ALU/src2 8'h0F 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b0100 0
run 100ps

force -freeze sim:/ALU/src1 8'hFF 0
force -freeze sim:/ALU/src2 8'h00 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b0110 0
run 100ps

force -freeze sim:/ALU/src1 8'h01 0
force -freeze sim:/ALU/src2 8'h01 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b1011 0
run 100ps

force -freeze sim:/ALU/src1 8'h0F 0
force -freeze sim:/ALU/src2 8'h03 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b1100 0
run 100ps

force -freeze sim:/ALU/src1 8'h0F 0
force -freeze sim:/ALU/src2 8'h03 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b1101 0
run 100ps

force -freeze sim:/ALU/src1 8'h0F 0
force -freeze sim:/ALU/src2 8'hF0 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b1110 0
run 100ps

force -freeze sim:/ALU/src1 8'h1F 0
force -freeze sim:/ALU/src2 8'hF1 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b1111 0
run 100ps

force -freeze sim:/ALU/src1 8'hF1 0
force -freeze sim:/ALU/src2 8'h01 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b1010 0
run 100ps
force -freeze sim:/ALU/src1 8'h1F 0
force -freeze sim:/ALU/src2 8'hF1 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b1010 0
run 100ps
force -freeze sim:/ALU/src1 8'hF1 0
force -freeze sim:/ALU/src2 8'hF1 0
force -freeze sim:/ALU/AluOp 1 0
force -freeze sim:/ALU/func  4'b1010 0
run 100ps
