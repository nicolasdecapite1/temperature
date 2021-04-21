module vga_controller(clock, reset, in0, in1, in2, in3, in4, in5, in6, in7, clkin, clkout, outSignal, out_cathode, out_anode);
    input clock, reset, clkin, in0, in1, in2, in3, in4, in5, in6, in7;
    output clkout, outSignal;

    wire [31:0] data_temp;
    Wrapper wrapper(.clock(clock), .reset(reset), .in0(in0), .in1(in1), .in2(in2), .in3(in3), .in4(in4), .in5(in5), .in6(in6), .in7(in7), .clkin(clkin), .outSignal(outSignal), .clkout(clkout), .temp_out(data_temp));

    reg [7:0] cathodeA, cathodeB;
   
    always @(data_temp)
    begin
        case(data_temp[4:0])
        5'b00000: begin
            //cathodeA <= 8'b00000011;
            cathodeA <= 8'b00000011;
            cathodeB <= 8'b00000010;
            end
        5'b10111: begin
            //cathodeA <= 8'b00100100;
            cathodeA <= 8'b10011111;
            cathodeB <= 8'b00001100;
            end
        5'b11000: begin
            //cathodeA <= 8'b00100100;
            cathodeA <= 8'b01100101;
            cathodeB <= 8'b01001000;
            end
        5'b11001: begin
            //cathodeA <= 8'b00100100;
            cathodeA <= 8'b00001101;
            cathodeB <= 8'b01000000;
            end
        endcase
    end

    output [7:0] out_anode;
    output [7:0] out_cathode;

    //assign out_cathode = clock ? cathodeA : cathodeB; 
    assign out_cathode = cathodeA;
    assign out_anode = clock ? 8'b01111111 : 8'b10111111;


endmodule