module behavioral(clock, data_a, out);
    input clock;
    input [7:0] data_a;
    reg [31:0] out;

    

    always@(posedge clock) begin
        out = 2.718**data_a;
    end

endmodule