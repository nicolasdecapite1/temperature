module vga_controller(clock, reset, in0, in1, in2, in3, in4, in5, in6, in7, clkin, clkout, outSignal, out_cathode, anode);
    input clock, reset, clkin, in0, in1, in2, in3, in4, in5, in6, in7;
    output clkout, outSignal, A, B, C, D, E, F, G;

    wire [31:0] data_temp;
    Wrapper wrapper(.clock(clock), .reset(reset), .in0(in0), .in1(in1), .in2(in2), .in3(in3), .in4(in4), .in5(in5), .in6(in6), .in7(in7), .clkin(clkin), .outSignal(outSignal), .clkout(clkout), .data_out(data_temp));



    // logic to determine if A, B, C, D, E, F, G should be on or off

    reg [6:0] cathodeA, cathodeB;
    
    always @(posedge clock)
    begin
        case(data_temp[4:0])
        5'b00000: begin
            cathodeA = 7'b0000001;
            cathodeB = 7'b0000001;
            end
        5'b10111: begin
            cathodeA = 7'b0010010;
            cathodeB = 7'b0000110;
            end
        5'b11000: begin
            cathodeA = 7'b0010010;
            cathodeB = 7'b0100100;
            end
        5'b11001: begin
            cathodeA = 7'b0010010;
            cathodeB = 7'b0100000;
            end
        endcase
    end

    wire [6:0] out_cathodeA, out_cathodeB;
    reg [6:0] curr_cathode;
    reg [1:0] curr_anode;
    output [1:0] anode;
    output [6:0] out_cathode;

    assign out_cathodeA = cathodeA;
    assign out_cathodeB = cathodeB;

    assign out_cathode = curr_cathode;
    assign out_anode = curr_anode;

    always @(posedge clock)
    begin
        curr_cathode = out_cathodeA;
        curr_anode = 2'b10;
    end

    always @(negedge clock)
    begin
        curr_cathode = out_cathodeB;
        curr_anode = 2'b01;
    end

    
    
    
        


endmodule