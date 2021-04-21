module vga_controller(clock, reset, in0, in1, in2, in3, in4, in5, in6, in7, clkin, clkout, outSignal, out_cathode, out_anode);
    input clock, reset, clkin, in0, in1, in2, in3, in4, in5, in6, in7;
    output clkout, outSignal;

    wire [31:0] data_temp;
    Wrapper wrapper(.clock(clock), .reset(reset), .in0(in0), .in1(in1), .in2(in2), .in3(in3), .in4(in4), .in5(in5), .in6(in6), .in7(in7), .clkin(clkin), .outSignal(outSignal), .clkout(clkout), .temp_out(data_temp));



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


 
    output [7:0] out_anode;
    output [6:0] out_cathode;

    assign out_cathode = clock ? cathodeA : cathodeB; 
    assign out_anode = clock ? 7'b01111111 : 7'b10111111;

    
    
    
        


endmodule