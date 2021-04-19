module voltage(v_therm, temp_therm);
    input [3:0] v_therm;
    output [31:0] temp_therm;

    // real v1;
    // assign v1 = v_therm;

    wire [31:0] w1, w2, w3, w4, w5, w6, R, B, T0, R0;
    // 0000000000000000 
    assign T0 = 32'b000000000000000000000000011001; // 25 = 011001 , R0
    assign R0 = 32'b000000000000000000011111010000;   // 2000 
    assign B2 = 32'b000000000000000000110111010011;   // 3539 , B
    assign w1 = 32'b000000000000000010011100010000; //10000
    assign w2 = 32'b000000000000000000000000000011;   // 3.25 .. technically 3.3 tho

    assign w3 = w1 / w2;
    assign w4 = v_therm / w2;
    assign w5 = 1 + w4;
    assign w6 = w3 * w5;

    assign R = w6*v_therm; // R

    wire q1, q2, q3, q4, q5, q6;

    assign q1 = R / R0;
    assign q2 = $ln(q1);
    assign q3 = q2 / B;
    assign q4 = q3 + q5;
    // assign temp_therm = 1 / T0; // T
    assign temp_therm = R / 150; // to at least have output
endmodule