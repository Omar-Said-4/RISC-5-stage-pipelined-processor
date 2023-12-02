force -freeze sim:/execute/clk 1'b0 0
force -freeze sim:/execute/src1 8'hF2 0
force -freeze sim:/execute/src2 8'h00 0
force -freeze sim:/execute/AluOp 1 0
force -freeze sim:/execute/func  4'b1011 0
run 100ps
