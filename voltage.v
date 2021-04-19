module voltage(v_therm, temp_therm);
    input [7:0] v_therm;
    output [7:0] temp_therm;

    wire w1, w2, w3, w4, w5, w6, R, B, T0, R0;
    
    assign T0 = 6'd25;
    assign R0 = 12'd2000;
    assign B = 32'd3539; 
    assign w1 = 32'd10000;
    assign w2 = 3'd3.3;

    assign w3 = w1 / w2;
    assign w4 = v_therm / w2;
    assign w5 = 1 - w4;
    assign w6 = w3 * w5;

    assign R = w6*v_therm; // R

    



//R = (10000 / 3.3)*(1 - V/3.3)*V
// T = 1 / ((ln(R/R0) / B) + ( 1 / T0))
// voltage from thermistor = 3.3(R thermistor) /(R thermistor + 10000)

endmodule