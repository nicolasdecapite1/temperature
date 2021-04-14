nop
nop
nop
nop
nop
nop
# B = ln(R/R0) / (1/T-1/T0) , B = 3539, R0 = 2000, T0 = 25
# B*(1/T-1/T0) = ln(R/R0)
# e ^ (B*(1/T-1/T0)) * R0 = R , r29 holds T

addi $r1, $r1, 3539 # B
addi $r2, $r2, 2000 # R0
addi $r3, $r3, 25   # T0
addi $r10, $r10, 1  # 1

div $r4, $r10, $r3 # 1/T0
div $r5, $r10, $r29 # 1/T
sub $r6, $r5, $r4 # 1/T-1/T0
mul $r7, $r1m $r6 # B*(1/T-1/T0)
# custom instruction for exponential ni r8

mul $r9, $r8, $r2 # r0 holds R

# voltage from thermistor = 3.3(R thermistor) /(R thermistor + 10000) so we use input voltage from thermistor to find R thermistor

addi $r11, $r11, 3.3 # 3.3
addi $r12, $r12, 10000 # 10000

add $r13, $r9, $r12
div $r14, $r9, $r13 
mul $r15, $r14, $r11 # r15 holds V
 