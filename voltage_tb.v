`timescale 1 ns / 100 ps
module voltage_tb;

    reg [31:0] input_voltage; // input
    wire [31:0] output_temp; // output

    voltage voltage(.v_therm(input_voltage), .temp_therm(output_temp));

    // initialize
    initial begin
        input_voltage = 0;

        // Output file name
		$dumpfile("voltage.vcd");
		// Module to capture and what level, 0 means all wires
		$dumpvars(0, voltage_tb);

        #80
        $finish;
    end

    always 
        #10 input_voltage += 1;

    always @(input_voltage) begin
        #1;
        $display("input_voltage:%d ---> output_temp:%d", input_voltage, output_temp);
    end

    
endmodule