module voltage(v_therm, temp_therm);
    input [7:0] v_therm;
    output [7:0] temp_therm;

    wire w1, w2, w3, w4, w5, w6, R, B, T0, R0;
    
    assign T0 = 6'b011001; // 25 = 011001 , R0
    assign R0 = 16'b0000011111010000;   // 2000 
    assign B = 16'b0000110111010011;   // 3539 , B
    assign w1 = 16'b10011100010000; //10000
    assign w2 = 4'b11.01;   // 3.25 .. technically 3.3 tho

    assign w3 = w1 / w2;
    assign w4 = v_therm / w2;
    assign w5 = 1 - w4;
    assign w6 = w3 * w5;

    assign R = w6*v_therm; // R

    wire q1, q2, q3, q4, q5, q6;

    assign q1 = R / R0;
    assign q2 = $ln(q1);
    assign q3 = q2 / B;
    assign q4 = q3 + q5;
    assign temp_therm = 1 / T0; // T

endmodule