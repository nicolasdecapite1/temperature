module VGAController(clock, reset, in_data, in0, in1, in2, in3, in4, in5, in6, in7, clkin, clkout, outSignal, A, B, C, D, E, F, G);
    input clock, reset, in_data, clkin, in0, in1, in2, in3, in4, in5, in6, in7,;
    output clkout, outSignal, A, B, C, D, E, F, G;

    Wrapper wrapper(.clock(clock), .reset(reset), .in0(in0), .in1(in1), .in2(in2), .in3(in3), .in4(in4), .in5(in5), .in6(in6), .in7(in7), .clkin(clkin), .outSignal(outSignal), .clkout(clkout));


endmodule