nop
nop
nop
nop
nop
nop
# B = ln(R/R0) / (1/T-1/T0) , B = 3539, R0 = 2000, T0 = 25
# B*(1/T-1/T0) = ln(R/R0)
# e ^ (B*(1/T-1/T0)) * R0 = R , r29 holds T

addi $r20, $r0, 10 #r20 will hold the low temperature boundary (if less than 10, turn heater on)
addi $r21, $r0, 20 #r21 will hold the high temperature boundary (if greater than 20, turn heater off)
	
loop:	
addi $r1, $r1, 3539 # B
addi $r2, $r2, 2000 # R0
addi $r3, $r3, 25   # T0
addi $r10, $r10, 1  # 1

div $r4, $r10, $r3 # 1/T0
div $r5, $r10, $r29 # 1/T
sub $r6, $r5, $r4 # 1/T-1/T0
mul $r7, $r10 $r6 # B*(1/T-1/T0)
# insert working custom instruction for exponential in r8

mul $r9, $r8, $r2 # r0 holds R

# voltage from thermistor = 3.3(R thermistor) /(R thermistor + 10000) so we use input voltage from thermistor to find R thermistor

addi $r11, $r11, 3.3 # 3.3
addi $r12, $r12, 10000 # 10000

add $r13, $r9, $r12
div $r14, $r9, $r13 
mul $r15, $r14, $r11 # r15 holds V

blt $r15, r20, turnHeaterOn
blt $r15, r21, turn HeaterOff

jump loop
 
turnHeaterOn:
addi $r22, r0, 1 #r22 will hold output signal
jump loop

turnHeaterOff:
addi $r22, r0, 0 
jump loop
