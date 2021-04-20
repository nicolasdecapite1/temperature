module voltage(v_therm, temp_therm);
    input [31:0] v_therm;
    output [31:0] temp_therm;

    // real v1;
    // assign v1 = v_therm;

    wire [31:0] w1, w2, w3, w4, w5, w6, R, R_ext, B, T0, R0;
    // 0000000000000000 
    // initial begin
    //     T0 <= 25;
    //     R0 <= 3539;
    //     B <= 10000;
    //     w1 <= 10000;
    //     w2 <= 3;
        
    //     w4 <= v_therm / w2;
    //     w5 <= 1 + w4;
    //     w6 <= w3 * w5;

    //     R <= w6*v_therm; // R
    //     R_ext <= R * 100000;

    // end
    // real_div real_div(.a(w1), .b(w2), .c(w3));
    assign T0 = 32'd25; // 25 = 011001 , R0
    assign R0 = 32'b000000000000000000011111010000;   // 2000 
    assign B = 32'b000000000000000000110111010011;   // 3539 , B
    assign w1 = 32'b000000000000000010011100010000; //10000
    assign w2 = 32'b000000000000000000000000000011_01;   // 3.25 .. technically 3.3 tho

    assign w3 = w1 / w2;
    assign w4 = v_therm / w2;
    assign w5 = 1 + w4;
    assign w6 = w3 * w5;

    assign R = w6*v_therm; // R
    assign R_ext = R * 10000;

    wire [31:0] q1, q2, q3, q4, q5, q6, q7;
    // initial begin
    //     q1 <= R_ext / R0;
    //     q2 <= $ln(q1);
    //     q3 <= q2 / B;
    //     q4 <= q3 + q5;
    //     q5 <= 1 / T0;
    //     q6 <= q4 + q5; 
    //     q7 <= 1 / q6;
    // end
    assign q1 = (R_ext / R0) + 1;
    assign q2 = $ln(q1) * 10000;
    assign q3 = q2 / B;
    assign q4 = q3 + q5;
    assign q5 = 1 / T0;
    assign q6 = q4 + q5; 
    assign temp_therm = q6;
    // assign temp_therm = 1 / q6; // T
    // assign temp_therm = R / 150; // to at least have output
endmodule