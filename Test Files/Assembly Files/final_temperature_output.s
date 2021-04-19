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
addi $r4, $r4, 3 # is technically 3.3
addi $r5, $r5, 10000 # 10000
addi $r10, $r10, 1  # 1

# R = (10000 / 3.3)*(1 - V/3.3)*V
div $r6, $r5, $r4 # (10000 / 3.3)
div $r7, $r25, $r4 # V/3.3
sub $r8, $r10, $r7 # (1 - V/3.3)
mul $r9, $r6, $r8 # (10000 / 3.3)*(1 - V/3.3)
mul $r11, $r9, $r25 # r11 holds R

# T = 1 / ((ln(R/R0) / B) + ( 1 / T0))
customLN # ln (R / R0) , put into r12
div $r13, $r12, $r1 # ((ln(R/R0) / B)
div $r14, $r10, $r25


mul $r9, $r8, $r2 # r0 holds R

# voltage from thermistor = 3.3(R thermistor) /(R thermistor + 10000) so we use input voltage from thermistor to find R thermistor

addi $r11, $r11, 3.3 # 3.3
addi $r12, $r12, 10000 # 10000

add $r13, $r9, $r12
div $r14, $r9, $r13 
mul $r15, $r14, $r11 # r15 holds V

blt $r15, r20, turnHeaterOn
bgt $r15, r21, turn HeaterOff

jump loop
 
turnHeaterOn:
# custom instruction to turn heater on
jump loop

turnHeaterOff:
# custom instruction to turn heater off
jump loop
