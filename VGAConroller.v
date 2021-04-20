module VGAController(clock, reset, in0, in1, in2, in3, in4, in5, in6, in7, clkin, clkout, outSignal, A, B, C, D, E, F, G);
    input clock, reset, clkin, in0, in1, in2, in3, in4, in5, in6, in7;
    output clkout, outSignal, A, B, C, D, E, F, G;

    wire [31:0] data_temp;
    Wrapper wrapper(.clock(clock), .reset(reset), .in0(in0), .in1(in1), .in2(in2), .in3(in3), .in4(in4), .in5(in5), .in6(in6), .in7(in7), .clkin(clkin), .outSignal(outSignal), .clkout(clkout), .data_out(data_temp));



    // logic to determine if A, B, C, D, E, F, G should be on or off

    wire [6:0] cathodeA, cathodeB;
    
    if(data_temp[4:0] == 5'b00000)
    begin
        assign cathodeA = 7'b0000001;
        assign cathodeB = 7'b0000001;
    end
    if(data_temp[4:0] == 5'10111)
    begin
        assign cathodeA = 7'b0010010;
        assign cathodeB = 7'b0000110;
    end
    if(data_temp[4:0] == 5'b11000)
    begin
        assign cathodeA = 7'0010010;
        assign cathodeB = 7'b0100100;
    end
    if(data_temp[4:0] == 5'b11001)
    begin
        assign cathodeA = 7'b0010010;
        assign cathodeB = 7'b0100000;
    end


endmodule