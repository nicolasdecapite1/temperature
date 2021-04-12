module regfile (clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB);
   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;
   output [31:0] data_readRegA, data_readRegB;
   wire 	 write_reg0_val, write_reg1_val, write_reg2_val, write_reg3_val,  write_reg4_val, write_reg5_val, write_reg6_val, write_reg7_val,  write_reg8_val, write_reg9_val, write_reg10_val, write_reg11_val,  write_reg12_val, write_reg13_val, write_reg14_val, write_reg15_val,  write_reg16_val, write_reg17_val, write_reg18_val, write_reg19_val,  write_reg20_val, write_reg21_val, write_reg22_val, write_reg23_val,  write_reg24_val, write_reg25_val, write_reg26_val, write_reg27_val, write_reg28_val, write_reg29_val, write_reg30_val, write_reg31_val, writeEn0, writeEn1, writeEn2, writeEn3, writeEn4, writeEn5, writeEn6, writeEn7, writeEn8, writeEn9, writeEn10, writeEn11, writeEn12, writeEn13,writeEn14, writeEn15, writeEn16, writeEn17, writeEn18, writeEn19, writeEn20, writeEn21, writeEn22, writeEn23, writeEn24, writeEn25, writeEn26, writeEn27, writeEn28, writeEn29, writeEn30, writeEn31;
   wire [31:0] 	 reg0out, reg1out, reg2out, reg3out, reg4out, reg5out, reg6out, reg7out, reg8out, reg9out, reg10out, reg11out, reg12out, reg13out, reg14out, reg15out, reg16out, reg17out, reg18out, reg19out, reg20out, reg21out, reg22out, reg23out, reg24out, reg25out, reg26out, reg27out, reg28out, reg29out, reg30out, reg31out;
   
   
  
   decoder decodeWriteEn(ctrl_writeReg,  write_reg0_val, write_reg1_val, write_reg2_val, write_reg3_val,  write_reg4_val, write_reg5_val, write_reg6_val, write_reg7_val,  write_reg8_val, write_reg9_val, write_reg10_val, write_reg11_val,  write_reg12_val, write_reg13_val, write_reg14_val, write_reg15_val,  write_reg16_val, write_reg17_val, write_reg18_val, write_reg19_val,  write_reg20_val, write_reg21_val, write_reg22_val, write_reg23_val,  write_reg24_val, write_reg25_val, write_reg26_val, write_reg27_val, write_reg28_val, write_reg29_val, write_reg30_val, write_reg31_val);

   and writEn0(writeEn0, ctrl_writeEnable,  write_reg0_val);
   and writEn1(writeEn1, ctrl_writeEnable,  write_reg1_val);
   and writEn2(writeEn2, ctrl_writeEnable,  write_reg2_val);
   and writEn3(writeEn3, ctrl_writeEnable,  write_reg3_val);
   and writEn4(writeEn4, ctrl_writeEnable,  write_reg4_val);
   and writEn5(writeEn5, ctrl_writeEnable,  write_reg5_val);
   and writEn6(writeEn6, ctrl_writeEnable,  write_reg6_val);
   and writEn7(writeEn7, ctrl_writeEnable,  write_reg7_val);
   and writEn8(writeEn8, ctrl_writeEnable,  write_reg8_val);
   and writEn9(writeEn9, ctrl_writeEnable,  write_reg9_val);
   and writEn10(writeEn10, ctrl_writeEnable,  write_reg10_val);
   and writEn11(writeEn11, ctrl_writeEnable,  write_reg11_val);
   and writEn12(writeEn12, ctrl_writeEnable,  write_reg12_val);
   and writEn13(writeEn13, ctrl_writeEnable,  write_reg13_val);
   and writEn14(writeEn14, ctrl_writeEnable,  write_reg14_val);
   and writEn15(writeEn15, ctrl_writeEnable,  write_reg15_val);
   and writEn16(writeEn16, ctrl_writeEnable,  write_reg16_val);
   and writEn17(writeEn17, ctrl_writeEnable,  write_reg17_val);
   and writEn18(writeEn18, ctrl_writeEnable,  write_reg18_val);
   and writEn19(writeEn19, ctrl_writeEnable,  write_reg19_val);
   and writEn20(writeEn20, ctrl_writeEnable,  write_reg20_val);
   and writEn21(writeEn21, ctrl_writeEnable,  write_reg21_val);
   and writEn22(writeEn22, ctrl_writeEnable,  write_reg22_val);
   and writEn23(writeEn23, ctrl_writeEnable,  write_reg23_val);
   and writEn24(writeEn24, ctrl_writeEnable,  write_reg24_val);
   and writEn25(writeEn25, ctrl_writeEnable,  write_reg25_val);
   and writEn26(writeEn26, ctrl_writeEnable,  write_reg26_val);
   and writEn27(writeEn27, ctrl_writeEnable,  write_reg27_val);
   and writEn28(writeEn28, ctrl_writeEnable,  write_reg28_val);
   and writEn29(writeEn29, ctrl_writeEnable,  write_reg29_val);
   and writEn30(writeEn30, ctrl_writeEnable,  write_reg30_val);
   and writEn31(writeEn31, ctrl_writeEnable,  write_reg31_val);


   register reg0(~clock, writeEn0, 1, 0, reg0out, ctrl_reset); 
   register reg1(~clock, writeEn1, 1, data_writeReg, reg1out, ctrl_reset);
   register reg2(~clock, writeEn2, 1, data_writeReg, reg2out, ctrl_reset);
   register reg3(~clock, writeEn3, 1, data_writeReg, reg3out, ctrl_reset);
   register reg4(~clock, writeEn4, 1, data_writeReg, reg4out, ctrl_reset);
   register reg5(~clock, writeEn5, 1, data_writeReg, reg5out, ctrl_reset);
   register reg6(~clock, writeEn6, 1, data_writeReg, reg6out, ctrl_reset);
   register reg7(~clock, writeEn7, 1, data_writeReg, reg7out, ctrl_reset);
   register reg8(~clock, writeEn8, 1, data_writeReg, reg8out, ctrl_reset);
   register reg9(~clock, writeEn9, 1, data_writeReg, reg9out, ctrl_reset);
   register reg10(~clock, writeEn10, 1, data_writeReg, reg10out, ctrl_reset);
   register reg11(~clock, writeEn11, 1, data_writeReg, reg11out, ctrl_reset);
   register reg12(~clock, writeEn12, 1, data_writeReg, reg12out, ctrl_reset);
   register reg13(~clock, writeEn13, 1, data_writeReg, reg13out, ctrl_reset);
   register reg14(~clock, writeEn14, 1, data_writeReg, reg14out, ctrl_reset);
   register reg15(~clock, writeEn15, 1, data_writeReg, reg15out, ctrl_reset);
   register reg16(~clock, writeEn16, 1, data_writeReg, reg16out, ctrl_reset);
   register reg17(~clock, writeEn17, 1, data_writeReg, reg17out, ctrl_reset);
   register reg18(~clock, writeEn18, 1, data_writeReg, reg18out, ctrl_reset);
   register reg19(~clock, writeEn19, 1, data_writeReg, reg19out, ctrl_reset);
   register reg20(~clock, writeEn20, 1, data_writeReg, reg20out, ctrl_reset);
   register reg21(~clock, writeEn21, 1, data_writeReg, reg21out, ctrl_reset);
   register reg22(~clock, writeEn22, 1, data_writeReg, reg22out, ctrl_reset);
   register reg23(~clock, writeEn23, 1, data_writeReg, reg23out, ctrl_reset);
   register reg24(~clock, writeEn24, 1, data_writeReg, reg24out, ctrl_reset);
   register reg25(~clock, writeEn25, 1, data_writeReg, reg25out, ctrl_reset);
   register reg26(~clock, writeEn26, 1, data_writeReg, reg26out, ctrl_reset);
   register reg27(~clock, writeEn27, 1, data_writeReg, reg27out, ctrl_reset);
   register reg28(~clock, writeEn28, 1, data_writeReg, reg28out, ctrl_reset);
   register reg29(~clock, writeEn29, 1, data_writeReg, reg29out, ctrl_reset);
   register reg30(~clock, writeEn30, 1, data_writeReg, reg30out, ctrl_reset);
   register reg31(~clock, writeEn31, 1, data_writeReg, reg31out, ctrl_reset);
   
   mux_32 rs1mux(data_readRegA, ctrl_readRegA, reg0out, reg1out, reg2out, reg3out, reg4out, reg5out, reg6out, reg7out, reg8out, reg9out, reg10out, reg11out, reg12out, reg13out, reg14out, reg15out, reg16out, reg17out, reg18out, reg19out, reg20out, reg21out, reg22out, reg23out, reg24out, reg25out, reg26out, reg27out, reg28out, reg29out, reg30out, reg31out);

   mux_32 rs2mux(data_readRegB, ctrl_readRegB, reg0out, reg1out, reg2out, reg3out, reg4out, reg5out, reg6out, reg7out, reg8out, reg9out, reg10out, reg11out, reg12out, reg13out, reg14out, reg15out, reg16out, reg17out, reg18out, reg19out, reg20out, reg21out, reg22out, reg23out, reg24out, reg25out, reg26out, reg27out, reg28out, reg29out, reg30out, reg31out);
   
endmodule // regfile



module decoder(write_reg, write_reg0_val, write_reg1_val, write_reg2_val, write_reg3_val,  write_reg4_val, write_reg5_val, write_reg6_val, write_reg7_val,  write_reg8_val, write_reg9_val, write_reg10_val, write_reg11_val,  write_reg12_val, write_reg13_val, write_reg14_val, write_reg15_val,  write_reg16_val, write_reg17_val, write_reg18_val, write_reg19_val,  write_reg20_val, write_reg21_val, write_reg22_val, write_reg23_val,  write_reg24_val, write_reg25_val, write_reg26_val, write_reg27_val, write_reg28_val, write_reg29_val, write_reg30_val, write_reg31_val);
   input [4:0] write_reg;
   output      write_reg0_val, write_reg1_val, write_reg2_val, write_reg3_val,  write_reg4_val, write_reg5_val, write_reg6_val, write_reg7_val,  write_reg8_val, write_reg9_val, write_reg10_val, write_reg11_val,  write_reg12_val, write_reg13_val, write_reg14_val, write_reg15_val,  write_reg16_val, write_reg17_val, write_reg18_val, write_reg19_val,  write_reg20_val, write_reg21_val, write_reg22_val, write_reg23_val,  write_reg24_val, write_reg25_val, write_reg26_val, write_reg27_val, write_reg28_val, write_reg29_val, write_reg30_val, write_reg31_val;
   wire 	   notwritereg0, notwritereg1, notwritereg2, notwritereg3, notwritereg4;
   not not0(notwritereg0, write_reg[0]);
   not not1(notwritereg1, write_reg[1]);
   not not2(notwritereg2, write_reg[2]);
   not not3(notwritereg3, write_reg[3]);
   not not4(notwritereg4, write_reg[4]);
 
   
	   assign write_reg0_val = notwritereg4 & notwritereg3 & notwritereg2 & notwritereg1 & notwritereg0;
	   assign write_reg1_val = notwritereg4 & notwritereg3 & notwritereg2 & notwritereg1 & write_reg[0];
	   assign write_reg2_val = notwritereg4 & notwritereg3 & notwritereg2 & write_reg[1] & notwritereg0;
	   assign write_reg3_val = notwritereg4 & notwritereg3 & notwritereg2 & write_reg[1] & write_reg[0];
	   assign write_reg4_val = notwritereg4 & notwritereg3 & write_reg[2] & notwritereg1 & notwritereg0;
	   assign write_reg5_val = notwritereg4 & notwritereg3 & write_reg[2] & notwritereg1 & write_reg[0];
	   assign write_reg6_val = notwritereg4 & notwritereg3 & write_reg[2] & write_reg[1] & notwritereg0;
	   assign write_reg7_val = notwritereg4 & notwritereg3 & write_reg[2] & write_reg[1] & write_reg[0];
	   assign write_reg8_val = notwritereg4 & write_reg[3] & notwritereg2 & notwritereg1 & notwritereg0;
	   assign write_reg9_val = notwritereg4 & write_reg[3] & notwritereg2 & notwritereg1 & write_reg[0];
	   assign write_reg10_val = notwritereg4 & write_reg[3] & notwritereg2 & write_reg[1] & notwritereg0;
	   assign write_reg11_val = notwritereg4 & write_reg[3] & notwritereg2 & write_reg[1] & write_reg[0];
	   assign write_reg12_val = notwritereg4 & write_reg[3] & write_reg[2] & notwritereg1 & notwritereg0;
	   assign write_reg13_val = notwritereg4 & write_reg[3] & write_reg[2] & notwritereg1 & write_reg[0];
	   assign write_reg14_val = notwritereg4 & write_reg[3] & write_reg[2] & write_reg[1] & notwritereg0;
	   assign write_reg15_val = notwritereg4 & write_reg[3] & write_reg[2] & write_reg[1] & write_reg[0];
	   assign write_reg16_val = write_reg[4] & notwritereg3 & notwritereg2 & notwritereg1 & notwritereg0;
	   assign write_reg17_val = write_reg[4] & notwritereg3 & notwritereg2 & notwritereg1 & write_reg[0];
	   assign write_reg18_val = write_reg[4] & notwritereg3 & notwritereg2 & write_reg[1] & notwritereg0;
	   assign write_reg19_val = write_reg[4] & notwritereg3 & notwritereg2 & write_reg[1] & write_reg[0];
	   assign write_reg20_val = write_reg[4] & notwritereg3 & write_reg[2] & notwritereg1& notwritereg0;
	   assign write_reg21_val = write_reg[4] & notwritereg3 & write_reg[2] & notwritereg1 & write_reg[0];
	   assign write_reg22_val = write_reg[4] & notwritereg3 & write_reg[2] & write_reg[1] & notwritereg0;
	   assign write_reg23_val = write_reg[4] & notwritereg3 & write_reg[2] & write_reg[1] & write_reg[0];
	   assign write_reg24_val = write_reg[4] & write_reg[3] & notwritereg2 & notwritereg1 & notwritereg0;
	   assign write_reg25_val = write_reg[4] & write_reg[3] & notwritereg2 & notwritereg1 & write_reg[0];
	   assign write_reg26_val = write_reg[4] & write_reg[3] & notwritereg2 & write_reg[1] & notwritereg0;
	   assign write_reg27_val = write_reg[4] & write_reg[3] & notwritereg2 & write_reg[1] & write_reg[0];
	   assign write_reg28_val = write_reg[4] & write_reg[3] & write_reg[2] & notwritereg1 & notwritereg0;
	   assign write_reg29_val = write_reg[4] & write_reg[3] & write_reg[2] & notwritereg1 & write_reg[0];
	   assign write_reg30_val = write_reg[4] & write_reg[3] & write_reg[2] & write_reg[1] & notwritereg0;
	   assign write_reg31_val = write_reg[4] & write_reg[3] & write_reg[2] & write_reg[1] & write_reg[0];
endmodule // decoder


module mux_32(out, select, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31);
   input[4:0] select;
   input [31:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
   output [31:0] out;
   wire [31:0] w1, w2, w3, w4;

   mux_8 first_first(w1, select[2:0], in0, in1, in2, in3, in4, in5, in6, in7);
   mux_8 first_second(w2, select[2:0], in8, in9, in10, in11, in12, in13 ,in14, in15);
   mux_8 first_third(w3, select[2:0], in16, in17, in18, in19, in20, in21, in22, in23);
   mux_8 first_fourth(w4, select[2:0], in24, in25, in26, in27, in28, in29, in30, in31);

   mux_4 second(out, select[4:3], w1, w2, w3, w4);
  
endmodule // mux_32
