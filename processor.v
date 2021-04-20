/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB,
    in0, in1, in2, in3, in4, in5, in6, in7, out                   // I: Data from port B of RegFile
	);

   // Control signals
   input clock, reset, in0, in1, in2, in3, in4, in5, in6, in7;
   
   output out;
   wire   outInt, outInt2;
   wire [31:0] thermistorVoltage;
   
   wire [31:0] inputFromThermistor;
   
   assign inputFromThermistor[7] = in7;
   assign inputFromThermistor[6] = in6;
   assign inputFromThermistor[5] = in5;
   assign inputFromThermistor[4] = in4;
   assign inputFromThermistor[3] = in3;
   assign inputFromThermistor[2] = in2;
   assign inputFromThermistor[1] = in1;
   assign inputFromThermistor[0] = in0;
   assign inputFromThermistor[31:8] = 24'b0;

  
   assign thermistorVoltage = (inputFromThermistor * 5) / 255;
  // assign outInt =0;
   
   
   // Imem
   output [31:0] address_imem; //address of the PC (out of PC)
   input [31:0]  q_imem; //instruction at address of the PC (out of IMEM)

   // Dmem
   output [31:0] address_dmem, data; //output of Data Mem
   output 	 wren; //M/W to Data MeM
   input [31:0]  q_dmem; //output of Data Mem

   // Regfile
   output 	 ctrl_writeEnable;
   output [4:0]  ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   output [31:0] data_writeReg;
   input [31:0]  data_readRegA, data_readRegB;

   /* YOUR CODE STARTS HERE */


   // calculate Temperature based on input voltage, put 
   wire [31:0] temp_therm;
   wire  [31:0]      temp_thermInt, temp_thermInt1, temp_thermInt2;
   
   //voltage voltage(.v_therm(thermistorVoltage), .temp_therm(temp_therm));
 
  
   
   assign temp_thermInt = (thermistorVoltage[1:0] == 2'b11) ? 32'd26 : 32'd0;
   
   assign temp_thermInt1 = (thermistorVoltage[1:0]==2'b10) ? 32'd25 : temp_thermInt;
   assign temp_thermInt2 = (thermistorVoltage[1:0] ==2'b01) ? 32'd23 : temp_thermInt1;
   assign temp_therm = temp_thermInt2;
   
   
   //FETCH STAGE
   wire [31:0] 	 PC_plus1;
   wire [31:0] 	 O_out;
   wire 	 lwDX, jrXM;
   wire [31:0] 	 PCoutstart;
   wire [31:0] 	 PCtoUse, PCtoUseInt, PCtoUseInt2,PCtoUseInt3, PCout2, signExtendedImmediate;

   wire 	 jumpORjal;
   wire 	 jump, mult, div, multFD, divFD;
   wire 	 jal ;
   wire 	 jr, bne, blt, branchTakenforBNE, branchTakenforBLT, branchTakenforBEX;
   wire [4:0] 	 jrRD, memRD;
   wire 	 data_resultRDYMULTDIV, writeEnableForLatches;
   wire [31:0] 	 setxMEMtarget, dataA_out, jrXMtarget, ALU_out;
   wire 		 setxMEM;
   assign jrRD = instruction[26:22]; 
   assign jr =  (instruction[31:27] == 5'b00100);
   assign jump =  (instruction[31:27] == 5'b00001);
   assign jal = (instruction[31:27] == 5'b00011);
   wire [31:0] 	 BEXdataToUse;
   mux_2 bexdatamux(BEXdataToUse, setxMEM, dataA_out, setxMEMtarget);
   
   assign branchTakenforBEX = (instruction_out2[31:27]==5'b10110) && !(BEXdataToUse==32'b0);
   
   assign jumpORjal = (instruction[31:27] == 5'b00001) ||  (instruction[31:27] == 5'b00011);
   wire [26:0]	 target;
   assign target = instruction[26:0];
   wire [31:0] 	 signExtendedTarget, bexsignExtendedTarget;
   signExtenderTarget targetextender(target, signExtendedTarget);
   signExtenderTarget bextargetextender(instruction_out2[26:0], bexsignExtendedTarget);
   mux_2 PCtousemux(PCtoUse, (jumpORjal), PC_plus1, signExtendedTarget);
   mux_2 PCtouseforbex(PCtoUseInt, branchTakenforBEX, PCtoUse, bexsignExtendedTarget);
   
   mux_2 PCtousemuxforBNE(PCtoUseInt2, (branchTakenforBNE||branchTakenforBLT), PCtoUseInt, (PCout2 + signExtendedImmediate));
  //mux_2 PCtousemuxforJR(PCtoUseInt3, jrXM, PCtoUseInt2, jrXMtarget);
   
   
   wire 	 jumpORjal2;
   assign writeEnableForLatches = (mult||div) && !data_resultRDYMULTDIV ? 0 : 1;
   wire [31:0] 	 address_imemInt, PC_plus1Int, PC_plus1Int2;
   
   
   PC_latch PC_latch(clock, reset, writeEnableForLatches, PCtoUseInt2, jumpORjal, PCoutstart, jumpORjal2); //Store PC in the PC latch
   assign address_imemInt = (branchTakenforBNE||branchTakenforBLT||branchTakenforBEX)? (PCout2+signExtendedImmediate-1) : PCoutstart;
   mux_2 addrforJR(address_imem, jrXM, address_imemInt, 0);
   
   assign PC_plus1Int = lwDX||lwFD ? PCoutstart :  PCoutstart + 32'b1; //Add one to the PC
   mux_2 PCforMULTDIV(PC_plus1Int2, ((multFD||divFD) && !data_resultRDYMULTDIV) || multFD, PC_plus1Int, PCoutstart);
   
   mux_2 PCforJR(PC_plus1, jrXM, PC_plus1Int2, jrXMtarget);
   wire [31:0] 	 instruction, instruction_out, PC_out, instructionInt, instructionInt2;
 
   mux_2 flushInst(instruction, jrXM||jumpORjal2, q_imem, 32'b00000000000000000000000000000000);
   
  
   
   mux_2 branchBNEFD(instructionInt, (branchTakenforBNE||branchTakenforBLT||branchTakenforBEX), instruction, 32'b00000000000000000000000000000000);
   mux_2 nopforlwindx(instructionInt2, lwDX, instructionInt, 32'b00000000000000000000000000000000);
   
  
 //assign instruction to be output of IMEM (q_imem)
   FD_latch FD_latch(PC_plus1, instructionInt2, clock, reset, writeEnableForLatches&&!lwDX, PC_out, instruction_out); //put PC and instruction in FD latch

   
   //DECODE STAGE
   //Parsing for R instruction
   //wire [4:0]	 opcode;
   wire [4:0] 	 RD;
   wire [4:0] 	 RS;
   wire [4:0] 	 RT;
   wire 	 isIint0;
   
  // wire [4:0] 	 shiftamt;
  // wire [4:0] 	 ALUop;
  // wire [1:0] 	 Zeros;

   //assign opcode = instruction_out[31:27];
   //assign RD = instruction_out[26:22];
   //assign RS = instruction_out[21:17];
   //assign RT = instruction_out[16:12];
  // assign shiftamt = instruction_out[11:7];
  // assign ALUop = instruction_out[6:2];
  // assign Zeros = instruction_out[1:0];
   wire 	 isSWinst0;
   wire 	 lwFD;
   
   assign ctrl_writeEnable = 1; //set ctrl_writeReg to be 0 for just add instruction
   assign isSWinst0 = (instruction_out[31:27] == 5'b00111);
   wire 	 bneFD, bltFD, bexFD, jrFD;
   assign bneFD =  (instruction_out[31:27] == 5'b00010);
   assign bltFD =  (instruction_out[31:27] == 5'b00110);
   assign bexFD =  (instruction_out[31:27] == 5'b10110);
   assign lwFD =  (instruction_out[31:27] == 5'b01000);
   assign jrFD =  (instruction_out[31:27] == 5'b00100);
   assign multFD =((instruction_out[6:2] == 5'b00110) && (instruction_out[31:27]==5'b00000));
   assign divFD =((instruction_out[6:2] == 5'b00111) && (instruction_out[31:27]==5'b00000));

   wire [4:0] 	 ctrl_readRegBInt, ctrl_readRegAInt, ctrl_readRegAInt2;
   
   assign ctrl_readRegAInt =  (bneFD||bltFD)? instruction_out[26:22] : instruction_out[21:17];
   mux_2 ctrlRegforJR(ctrl_readRegAInt2, jrFD, ctrl_readRegAInt, instruction_out[26:22]);
   
   mux_2 ctrlRegforBex(ctrl_readRegA, bexFD, ctrl_readRegAInt2, 5'b11110);
   
   assign ctrl_readRegBInt =  isSWinst0 ? instruction_out[26:22]  :instruction_out[16:12];
   mux_2 ctrlRegforBNE(ctrl_readRegB, (bneFD||bltFD), ctrl_readRegBInt, instruction_out[21:17]);
   
   //NEED TO DO DATA_WRITEREG FOR OTHER PARTS
   
   wire [31:0] 	 instruction_out2, dataB_out;
   wire [31:0] 	 instruction_outInt, instruction_outInt2;
   
   mux_2 flushInst1(instruction_outInt, jrXM||jumpORjal2||branchTakenforBEX||branchTakenforBLT||branchTakenforBNE, instruction_out, 32'b00000000000000000000000000000000);
   mux_2 lwnop(instruction_outInt2, lwDX, instruction_outInt, 32'b00000000000000000000000000000000);
   
   //mux_2 branchBNE(instruction_outInt2, branchTakenforBNE, instruction_outInt, 32'b00000000000000000000000000000000);
   DX_latch DX_latch(PC_out, instruction_outInt2, data_readRegA, data_readRegB, clock, reset, writeEnableForLatches, PCout2, instruction_out2, dataA_out, dataB_out); //DX latch
  
   assign lwDX = instruction_out2[31:27] == 5'b01000;
   //EXECUTE STAGE
   //NEED TO DO SIGN EXTENDER AND MUX FOR OTHER INST
   wire [31:0] 	 data_result;
   wire 	 isNotEqual;
   wire 	 isLessThan;
   wire 	 overflow;
   wire [16:0]	 immediate;
   wire [4:0] 	 opcode1, shiftamt, ALUop;
   wire 	 isIinst;
   wire [2:0]	 ALUinA;
   wire [2:0]	 ALUinB;
   wire [31:0] 	 AtoUse;
   

   wire [4:0] 	 DX_RS1, XM_RD, MW_RD, DX_RS2, currRD, DX_RS1branch, DX_RS2branch;

   wire 	 setxXM,  swXM, bypassFromMemSW;
   wire [31:0] 	 setxXMtarget, jrXMtargetInt;
   assign jrXM =  (instruction_out2[31:27] == 5'b00100);
   assign swXM =  (instruction_out2[31:27] == 5'b00111);
   assign setxXM = (instruction_out2[31:27] == 5'b10101);
   signExtenderTarget setxXMtargetextend(instruction_out2[21:0], setxXMtarget);
   mux_2 jrtargetmux(jrXMtarget, memRD == 5'b11111, dataA_out, ALU_out);
   assign bypassFromMemSW = swXM && (DX_RS1 == ctrl_writeReg);
   
   assign DX_RS1= instruction_out2[21:17];
   assign DX_RS2= instruction_out2[16:12];
   assign DX_RS2branch= instruction_out2[26:22];
   assign DX_RS1branch= instruction_out2[21:17];
   assign XM_RD = instruction_out3[26:22];
   assign MW_RD = instruction_out4[26:22];
   assign currRD = instruction_out2[26:22];
   
   assign ALUinA[0] = (DX_RS1 == MW_RD) && (instruction_out2[31:27] == 5'b00111);
   assign ALUinA[1] = (DX_RS1 == XM_RD);
   assign ALUinA[2] = (DX_RS1 == MW_RD) && ! (instruction_out2[31:27] == 5'b00111); 
   assign ALUinB[0] = (DX_RS2 == MW_RD) || (DX_RS2branch ==MW_RD && bne);
   assign ALUinB[1] = (DX_RS2 == XM_RD && !blt) || (DX_RS2branch == XM_RD && blt && !(DX_RS2branch==5'b00000));
   wire 	 zeroRD;
   assign zeroRD = (instruction_out2[26:22]==5'b00000);
   
   assign isIint = ((instruction_out2[31:27] == 5'b00101) | (instruction_out2[31:27] == 5'b00111) | (instruction_out2[31:27] == 5'b01000)); //this needs to do used for lw or sw also 
   assign ALUinB[2] = isIint;
   
   assign opcode1 = instruction_out2[31:27];
   assign immediate = instruction_out2[16:0];
   assign shiftamt = instruction_out2[11:7];
  
   wire [31:0] 	 instruction_out3, dataB_out2;
   sign_extender SX(signExtendedImmediate, immediate);
   
   wire [31:0] 	 BtoUse, AtoUseInt, BtoUseInt2, BtoUseInt3;
   wire [31:0] 	 BtoUseoverflow, BtoUseInt, AtoUseInt2, AtoUseInt3;
   
  // assign BtoUse = isIint ? signExtendedImmediate : dataB_out;
   
   mux_8 BtoUsemux(BtoUse, ALUinB, dataB_out, O_out, ALU_out, dataB_out, signExtendedImmediate, signExtendedImmediate, signExtendedImmediate, signExtendedImmediate);
   assign BtoUseoverflow = overflowedXM ? 32'b1 : BtoUse;
   assign BtoUseInt = (bne||blt && !ALUinB[1]) ? dataB_out : BtoUseoverflow;
   mux_2 btouseforbltmw(BtoUseInt2, ((DX_RS2branch==MW_RD) && !(DX_RS2branch==5'b00000) && (bne||blt)), BtoUseInt, data_writeReg);
   mux_2 btouseformultbypass(BtoUseInt3, ((DX_RS2 == MW_RD) && (mult||div)), BtoUseInt2, data_writeReg) ;
   
 
   assign ALUop = isIint? 0: instruction_out2[6:2];
    wire 	 isWMBypass, isSWRD;
   assign isWMBypass = (instruction_out3[26:22] == instruction_out2[21:17]) && (instruction_out2 == 5'b00111);
   assign isSWRD = (instruction_out3[26:22] == instruction_out2[26:22]) && (instruction_out2 == 5'b00111);

   mux_8 Amux(AtoUse, ALUinA, dataA_out, dataA_out, ALU_out, dataA_out, data_writeReg, data_writeReg, ALU_out, data_writeReg);
   //wire [31:0] 	 AtoUse2;
  // mux_2 AtoUse2mux (AtoUse2, isWMBypass, AtoUse, ALU_out);
   mux_2 Amuxblt(AtoUseInt, blt && ALUinB[1]==1 , AtoUse, dataB_out);
   mux_2 Amuxblt2(AtoUseInt2, blt && DX_RS1branch == MW_RD, AtoUseInt, data_writeReg);
   mux_2 Amuxswbypass(AtoUseInt3, bypassFromMemSW, AtoUseInt2, data_writeReg);
   
  
   wire [31:0] 	 dataToUse, dataToUse2;
   assign bne =  (instruction_out2[31:27] == 5'b00010);
   assign blt =  (instruction_out2[31:27] == 5'b00110);
   assign mult =((instruction_out2[6:2] == 5'b00110) && (instruction_out2[31:27]==5'b00000));
  
   wire 	 multContinue, divContinue;
   dffe_ref multcontDFFE(multContinue, mult & !data_resultRDYMULTDIV, clock, mult||data_resultRDYMULTDIV, 0);
   dffe_ref divcontDFFE(divContinue, div & !data_resultRDYMULTDIV, clock, div||data_resultRDYMULTDIV, 0);

   assign div = ((instruction_out2[6:2] == 5'b00111) && (instruction_out2[31:27]==5'b00000));
   alu alu(AtoUseInt3, BtoUseInt3, ALUop, shiftamt, data_result, isNotEqual, isLessThan, overflow);
   wire [31:0] 	 data_resultMULTDIV;
   wire 	 data_exceptionMULTDIV;
  
   multdiv multdiv(AtoUseInt3, BtoUseInt3, mult&&!multContinue, div&&!divContinue, clock, data_resultMULTDIV, data_exceptionMULTDIV, data_resultRDYMULTDIV);
   
   and branchTakenBNE(branchTakenforBNE, isNotEqual, bne);
   and branchTakenBLT(branchTakenforBLT, isLessThan||(!isLessThan && isNotEqual && (ALUinB[1]||ALUinA[1])), blt);
   
   mux_2 zeroRD2(dataToUse, zeroRD, data_result, 32'b0);
   mux_2 multInstResult(dataToUse2, ((mult && data_resultRDYMULTDIV) || (div && data_resultRDYMULTDIV)), dataToUse, data_resultMULTDIV);
   
   wire [4:0] 	 ctrl_writeRegInst2, ctrl_writeRegXM;
   wire 	 overflowed, overflowedXM;
   assign overflowed = overflow || (data_exceptionMULTDIV&&(mult|div));
   
   assign ctrl_writeRegInst2 = overflowed ? 5'b11110 : instruction_out2[26:22];
    wire [31:0] 	 instruction_out2Int, instruction_out2Int2, dataB_outInt;
   
   mux_2 flushInst2(instruction_out2Int, jumpORjal2||jrXM||(jal && instruction_out2[26:22]==5'b11111), instruction_out2, 32'b00000000000000000000000000000000);
   mux_2 flushInstforBNE(instruction_out2Int2, (bne||blt), instruction_out2Int,  32'b00000000000000000000000000000000);
   mux_2 bypasstomemmux(dataB_outInt, (isLWSWinst[1] && swXM), dataB_out, data_writeReg);
   
   XM_latch XM_latch(instruction_out2Int2, ctrl_writeRegInst2, overflowed, dataToUse2, dataB_outInt, clock, reset, writeEnableForLatches, instruction_out3, ctrl_writeRegXM, overflowedXM, ALU_out, dataB_out2);

   //MEMORY STAGE
   wire 		 bypassToMem;
   
   assign bypassToMem = instruction_out3[31:27] == 5'b00111 && ((ALU_out == ctrl_writeReg) || instruction_out3[26:22] ==ctrl_writeReg);
   
   assign data = bypassToMem ? data_writeReg : dataB_out2;
   assign address_dmem = ALU_out;
   assign wren = (instruction_out3[31:27] == 5'b00111);
   wire 		 jrMW, multMW, divMW;
    assign jrMW =  (instruction_out3[31:27] == 5'b00100);
   assign multMW =((instruction_out3[6:2] == 5'b00110) && (instruction_out3[31:27]==5'b00000));
   assign divMW =((instruction_out3[6:2] == 5'b00111) && (instruction_out3[31:27]==5'b00000));
   assign memRD = instruction_out3[26:22];
   
   assign setxMEM = (instruction_out3[31:27] == 5'b10101);
 
   
   signExtenderTarget setxmemtargetextend(instruction_out3[26:0], setxMEMtarget);
   wire [31:0] 	 D_out, instruction_out4;
   wire [31:0] 	 ctrl_writeRegMW;
   wire 	 overflowMW;
   wire 	 SWprev, SWprev2;
   wire [31:0] 	 SWprevdata;
   
   assign SWprev = (instruction_out4[31:27] == 5'b00111);
   
 
   MW_latch MW_latch(ALU_out, dataB_out2, instruction_out3, ctrl_writeRegXM, overflowedXM, SWprev, clock, reset, writeEnableForLatches, O_out, D_out, instruction_out4, ctrl_writeRegMW, overflowMW, SWprev2);
   //NEED ternary output for lw sw
   
   wire 	 isSWinst, setxMW;
   wire [1:0]	 isLWSWinst;
   assign isLWSWinst[0] = (instruction_out4[31:27] == 5'b00111);
   assign isLWSWinst[1] = (instruction_out4[31:27] == 5'b01000);
   assign setxMW = (instruction_out4[31:27] == 5'b10101);
   wire [31:0]	 setxTarget;
   signExtenderTarget setxtargetextender(instruction_out4[26:0], setxTarget);
   
   assign isSWinst = (instruction_out4[31:27] == 5'b00111);
   wire [31:0] 	 ctrl_writeRegInt, ctrl_writeRegInt2, ctrl_writeRegInt3, ctrl_writeRegInt4;
   
   assign ctrl_writeRegInt = isSWinst? 5'b0000 : instruction_out4[26:22];
   mux_2 overflowctrl(ctrl_writeRegInt2, overflowMW, ctrl_writeRegInt, ctrl_writeRegMW);
   mux_2 setxctrl(ctrl_writeRegInt3, setxMW, ctrl_writeRegInt2, 5'b11110);
   mux_2 getReadingmux(ctrl_writeRegInt4, instruction_out4[31:27]==5'b11111, ctrl_writeRegInt3, 5'b11001);
   
   mux_2 jal31write(ctrl_writeReg, jal, ctrl_writeRegInt4, 5'b11111);
   
   //assign data_writeReg = isSWinst? D_out : O_out;
   wire [31:0] 	 data_writeRegInt,data_writeRegInt2, data_writeRegInt3, data_writeRegInt4, data_writeRegInt5, data_writeRegInt6;
   
   
   mux_4 LWSW(data_writeRegInt, isLWSWinst, O_out, D_out, q_dmem, O_out);
   mux_2 overflowdata(data_writeRegInt2, (overflowMW && ~(instruction_out4[31:27] == 5'b00000 && ((instruction_out4[6:2] == 5'b00111)||(instruction_out4[6:2] == 5'b00110)))), data_writeRegInt, 32'b1);
   mux_2 overflowdatamult(data_writeRegInt3, (overflowMW && instruction_out4[31:27] == 5'b00000 && (instruction_out4[6:2] == 5'b00110)), data_writeRegInt2, 32'b00000000000000000000000000000100);
   mux_2 overflowdatadiv(data_writeRegInt4, (overflowMW && instruction_out4[31:27] == 5'b00000 && (instruction_out4[6:2] == 5'b00111)), data_writeRegInt3,  32'b00000000000000000000000000000101x);

   mux_2 setxctrdatal(data_writeRegInt5, setxMW, data_writeRegInt4, setxTarget);
   mux_2 gerReeadingdatamux(data_writeRegInt6,  instruction_out4[31:27]==5'b11111, data_writeRegInt5, temp_therm);
   
   mux_2 jal31datawrite(data_writeReg, jal, data_writeRegInt6, (PCoutstart));

   assign out = ((instruction_out4[26:22] == 5'b10110) && (instruction_out4[31:27] == 5'b00101)) ? data_writeReg[0] : outInt; //if addi to r22, then set out to equal r22, else keep value of out
   and outIntAnd(outInt, out, 1);
   
   
   
   /* END CODE */
   
endmodule // processor


module signExtenderTargetJR(target, signExtendedTarget);
   input [21:0] target;
   output [31:0] signExtendedTarget;
   assign signExtendedTarget[21:0] = target;
    assign signExtendedTarget[22] = target[21];
    assign signExtendedTarget[23] = target[21];
   assign signExtendedTarget[24] = target[21];
    assign signExtendedTarget[25] = target[21];
   assign signExtendedTarget[26] = target[21];
   assign signExtendedTarget[27] = target[21];
   assign signExtendedTarget[28] = target[21];
   assign signExtendedTarget[29] = target[21];
   assign signExtendedTarget[30] = target[21];
   assign signExtendedTarget[31] = target[21];
endmodule
module signExtenderTarget(target, signExtendedTarget);
   input [26:0] target;
   output [31:0] signExtendedTarget;
   assign signExtendedTarget[26:0] = target;
   
   assign signExtendedTarget[27] = target[26];
   assign signExtendedTarget[28] = target[26];
   assign signExtendedTarget[29] = target[26];
   assign signExtendedTarget[30] = target[26];
   assign signExtendedTarget[31] = target[26];
endmodule 

module sign_extender(signExtendedImmediate, immediate);
   input [16:0] immediate;
   output [31:0] signExtendedImmediate;
   assign signExtendedImmediate[16:0] = immediate;
   assign signExtendedImmediate[17] = immediate[16];
   assign signExtendedImmediate[18] = immediate[16];
   assign signExtendedImmediate[19] = immediate[16];
   assign signExtendedImmediate[20] = immediate[16];
   assign signExtendedImmediate[21] = immediate[16];
   assign signExtendedImmediate[22] = immediate[16];
   assign signExtendedImmediate[23] = immediate[16];
   assign signExtendedImmediate[24] = immediate[16];
   assign signExtendedImmediate[25] = immediate[16];
   assign signExtendedImmediate[26] = immediate[16];
   assign signExtendedImmediate[27] = immediate[16];
   assign signExtendedImmediate[28] = immediate[16];
   assign signExtendedImmediate[29] = immediate[16];
   assign signExtendedImmediate[30] = immediate[16];
   assign signExtendedImmediate[31] = immediate[16];
endmodule // sign_extender

module PC_latch(clock, reset, writeen, input_val, jumpORjal, output_val, jumpORjal2); //only stores the PC
   input clock, reset, writeen;
   input [31:0]  input_val, jumpORjal;
   wire  input_enable, output_enable;
   assign input_enable = writeen;
   assign output_enable = 1;
   output [31:0]  output_val, jumpORjal2; 
   register PCreg(clock, input_enable, output_enable, input_val, output_val, reset);
    register jumporjalreg(clock, input_enable, output_enable, jumpORjal, jumpORjal2, reset);
endmodule // PC_latch

module FD_latch(PC, instruction, clock, reset, writeen, PCout, instruction_out); //stores the PC and the instruction
   input [31:0] PC, instruction;
   input 	clock, reset, writeen;
   output [31:0] instruction_out;
   wire 	 input_enable, output_enable;
   output [31:0] 	 PCout;
   
   assign input_enable =writeen;
   assign output_enable=1;
   
   register PCreg(clock, input_enable, output_enable, PC, PCout, reset);
   register instreg(clock, input_enable, output_enable, instruction, instruction_out, reset);
   
endmodule // FD_latch

module DX_latch(PC, instruction, dataA, dataB, clock, reset, writeen, PCout, instruction_out, dataA_out, dataB_out);
   input [31:0] PC, instruction, dataA, dataB;
   input 	clock, reset, writeen;
   output [31:0] PCout, instruction_out, dataA_out, dataB_out;
   wire 	 input_enable, output_enable;
   assign input_enable =writeen;
   assign output_enable =1;
   
   register PCreg(clock, input_enable, output_enable, PC, PCout, reset);
   register instrreg(clock, input_enable, output_enable, instruction, instruction_out, reset);
   register dataAreg(clock, input_enable, output_enable, dataA, dataA_out, reset);
   register dataBreg(clock, input_enable, output_enable, dataB, dataB_out, reset);
endmodule // DX_latch

module XM_latch(instruction_out2, ctrl_writeRegInst2, overflowed, dataToUse, dataB_out, clock, reset, writeen, instruction_out3, ctrl_writeRegXM, overflowedXM, ALU_out, dataB_out2);
   input [31:0] instruction_out2, ctrl_writeRegInst2, overflowed, dataToUse, dataB_out;
   input 	clock, reset, writeen;
   output [31:0] instruction_out3, ctrl_writeRegXM, overflowedXM, ALU_out, dataB_out2;
   wire 	 input_enable, output_enable;
   assign input_enable = writeen;
   assign output_enable =1;
   register instreg(clock, input_enable, output_enable, instruction_out2, instruction_out3, reset);
   register ALUreg(clock, input_enable, output_enable, dataToUse, ALU_out, reset);
   register dataBreg(clock, input_enable, output_enable, dataB_out, dataB_out2, reset);
   register ctrlwrite(clock, input_enable, output_enable, ctrl_writeRegInst2, ctrl_writeRegXM, reset);
   register overflowwrite(clock, input_enable, output_enable, overflowed, overflowedXM, reset);
 
endmodule // XM_latch

module MW_latch(O, D, IR, ctrl_writeRegXM, overflowedXM, SWprev, clock, reset, writeen, O_out, D_out, IR_out, ctrl_writeRegMW, overflowedMW, SWprev2);
   input [31:0] O, D, IR, ctrl_writeRegXM, overflowedXM;
   input 	clock, reset, writeen, SWprev;
   output [31:0] O_out, D_out, IR_out, ctrl_writeRegMW, overflowedMW;
   output 	 SWprev2;
		    
   wire 	 input_enable, output_enable;
   assign input_enable = writeen;
   assign output_enable = 1;
   register IRreg(clock, input_enable, output_enable, IR, IR_out, reset);
   register Oreg(clock, input_enable, output_enable, O, O_out, reset);
   register Dreg(clock, input_enable, output_enable, D, D_out, reset);
   register ctrl(clock, input_enable, output_enable, ctrl_writeRegXM, ctrl_writeRegMW, reset);
   register overflow(clock, input_enable, output_enable, overflowedXM, overflowedMW, reset);
   register SW(clock, input_enable, output_enable, SWprev, SWprev2, reset);

endmodule // MW_latch

module register(clock, input_enable, output_enable, input_val, output_val, reset);
   input clock, input_enable, output_enable, reset;
   input [31:0] input_val;
   output [31:0] output_val;
   wire [31:0]	 Q;
   dffe_ref mydffe0(Q[0], input_val[0], clock, input_enable, reset);
   my_tri triout0(Q[0], output_enable, output_val[0]);
   
   dffe_ref mydffe1(Q[1], input_val[1], clock, input_enable, reset);
   my_tri triout1(Q[1], output_enable, output_val[1]);

   dffe_ref mydffe2(Q[2], input_val[2], clock, input_enable, reset);
   my_tri triout2(Q[2], output_enable, output_val[2]);

   dffe_ref mydffe3(Q[3], input_val[3], clock, input_enable, reset);
   my_tri triout3(Q[3], output_enable, output_val[3]);

   dffe_ref mydffe4(Q[4], input_val[4], clock, input_enable, reset);
   my_tri triout4(Q[4], output_enable, output_val[4]);

   dffe_ref mydffe5(Q[5], input_val[5], clock, input_enable, reset);
   my_tri triout5(Q[5], output_enable, output_val[5]);

   dffe_ref mydffe6(Q[6], input_val[6], clock, input_enable, reset);
   my_tri triout6(Q[6], output_enable, output_val[6]);

   dffe_ref mydffe7(Q[7], input_val[7], clock, input_enable, reset);
   my_tri triout7(Q[7], output_enable, output_val[7]);

   dffe_ref mydffe8(Q[8], input_val[8], clock, input_enable, reset);
   my_tri triout8(Q[8], output_enable, output_val[8]);
    
   dffe_ref mydffe9(Q[9], input_val[9], clock, input_enable, reset);
   my_tri triout9(Q[9], output_enable, output_val[9]);

   dffe_ref mydffe10(Q[10], input_val[10], clock, input_enable, reset);
   my_tri triout10(Q[10], output_enable, output_val[10]);

   dffe_ref mydffe11(Q[11], input_val[11], clock, input_enable, reset);
   my_tri triout11(Q[11], output_enable, output_val[11]);

   dffe_ref mydffe12(Q[12], input_val[12], clock, input_enable, reset);
   my_tri triout12(Q[12], output_enable, output_val[12]);

   dffe_ref mydffe13(Q[13], input_val[13], clock, input_enable, reset);
   my_tri triout13(Q[13], output_enable, output_val[13]);

   dffe_ref mydffe14(Q[14], input_val[14], clock, input_enable, reset);
   my_tri triout14(Q[14], output_enable, output_val[14]);

   dffe_ref mydffe15(Q[15], input_val[15], clock, input_enable, reset);
   my_tri triout15(Q[15], output_enable, output_val[15]);

   dffe_ref mydffe16(Q[16], input_val[16], clock, input_enable, reset);
   my_tri triout16(Q[16], output_enable, output_val[16]);

   dffe_ref mydffe17(Q[17], input_val[17], clock, input_enable, reset);
   my_tri triout17(Q[17], output_enable, output_val[17]);

   dffe_ref mydffe18(Q[18], input_val[18], clock, input_enable, reset);
   my_tri triout18(Q[18], output_enable, output_val[18]);

   dffe_ref mydffe19(Q[19], input_val[19], clock, input_enable, reset);
   my_tri triout19(Q[19], output_enable, output_val[19]);

   dffe_ref mydffe20(Q[20], input_val[20], clock, input_enable, reset);
   my_tri triout20(Q[20], output_enable, output_val[20]);

   dffe_ref mydffe21(Q[21], input_val[21], clock, input_enable, reset);
   my_tri triout21(Q[21], output_enable, output_val[21]);

   dffe_ref mydffe22(Q[22], input_val[22], clock, input_enable, reset);
   my_tri triout22(Q[22], output_enable, output_val[22]);

   dffe_ref mydffe23(Q[23], input_val[23], clock, input_enable, reset);
   my_tri triout23(Q[23], output_enable, output_val[23]);

   dffe_ref mydffe24(Q[24], input_val[24], clock, input_enable, reset);
   my_tri triout24(Q[24], output_enable, output_val[24]);

   dffe_ref mydffe25(Q[25], input_val[25], clock, input_enable, reset);
   my_tri triout25(Q[25], output_enable, output_val[25]);

   dffe_ref mydffe26(Q[26], input_val[26], clock, input_enable, reset);
   my_tri triout26(Q[26], output_enable, output_val[26]);

   dffe_ref mydffe27(Q[27], input_val[27], clock, input_enable, reset);
   my_tri triout27(Q[27], output_enable, output_val[27]);
    
   dffe_ref mydffe28(Q[28], input_val[28], clock, input_enable, reset);
   my_tri triout28(Q[28], output_enable, output_val[28]);

   dffe_ref mydffe29(Q[29], input_val[29], clock, input_enable, reset);
   my_tri triout29(Q[29], output_enable, output_val[29]);

   dffe_ref mydffe30(Q[30], input_val[30], clock, input_enable, reset);
   my_tri triout30(Q[30], output_enable, output_val[30]);

   dffe_ref mydffe31(Q[31], input_val[31], clock, input_enable, reset);
   my_tri triout31(Q[31], output_enable, output_val[31]);
endmodule // register
module dffe_ref (q, d, clk, en, clr);
   
   //Inputs
   input d, clk, en, clr;
   
   //Internal wire
   wire clr;

   //Output
   output q;
   
   //Register
   reg q;

   //Intialize q to 0
   initial
   begin
       q = 1'b0;
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           q <= 1'b0;
       //If enable is high, set q to the value of d
       end else if (en) begin
           q <= d;
       end
   end
endmodule // dffe_ref

module my_tri(in, oe, out);
   input [31:0] in;
   input 	oe;
   output [31:0] out;
   mux_2 trimux(out, oe, 1'bz, in);		
endmodule // my_tri
module mux_2(out, select, in0, in1);
   input select;
   input [31:0] in0, in1;
   output [31:0] out;
   assign out = select ? in1:in0;
endmodule // mux_2
module mux_2one(out, select, in0, in1);
   input select;
   input  in0, in1;
   output  out;
   assign out = select ? in1:in0;
endmodule // mux_2
module mux_4(out, select, in0, in1, in2, in3);
   input[1:0] select;
   input [31:0] in0, in1, in2, in3;
   output [31:0] out;
   wire [31:0] w1, w2;

   mux_2 first_top(w1, select[0], in0, in1);
   mux_2 first_bottom(w2, select[0], in2, in3);
   mux_2 second(out, select[1], w1, w2);
endmodule // mux_4
module mux_8(out, select, in0, in1, in2, in3, in4, in5, in6, in7);
   input[2:0] select;
   input [31:0] in0, in1, in2, in3, in4, in5, in6, in7;
   output [31:0] out;
   wire [31:0] w1, w2;

   mux_4 first_top(w1, select[1:0], in0, in1, in2, in3);
   mux_4 first_bottom(w2, select[1:0], in4, in5, in6, in7);

   mux_2 second(out, select[2], w1, w2);
endmodule // mux_8
