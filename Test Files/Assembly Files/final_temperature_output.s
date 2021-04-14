nop
nop
nop
nop
nop
nop
# B = ln(R/R0) / (1/T-1/T0) , B = 3539, R0 = 2000, T0 = 25
# B*(1/T-1/T0) = ln(R/R0) 
# (ln(R/R0) / B) + 1/T0 = 1/T
# T = 1 / (ln(R/R0) / B) + 1/T0 , R from register 29

addi $r1, $r1, 3539 # B
addi $r2, $r2, 2000 # R0
addi $r3, $r3, 25   # T0
addi $r10, $r10, 1  # 1

div $r4, $r29, $r2 3 # (ln(R/R0) r2
div $r5, $r4, $r1 # ln(R/R0) / B)
div $r6, $r10, $r3 # 1/T0

add $r7, $r5, $r6 # (ln(R/R0) / B) + 1/T0 
div $r8, $r10, $r7 # T



 