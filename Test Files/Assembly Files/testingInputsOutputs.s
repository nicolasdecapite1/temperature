nop
nop
nop
nop
nop
nop
nop
nop
nop
nop

nop
nop
nop
nop
addi $r20, $r0, 23
addi $r21, $r1, 25
addi $r22, $r0, 4
nop
nop
nop
nop
nop
blt $r25, $r20, turnHeaterOn
blt $r25, $r21, end	
j turnHeaterOff

turnHeaterOn:
nop
nop
nop
nop
nop
addi $r22, $r0, 1
nop
nop
nop
nop
nop
j end	

turnHeaterOff:
nop
nop
nop
nop
nop 
addi $r22, $r0, 0
nop
nop
nop
nop


end:	
