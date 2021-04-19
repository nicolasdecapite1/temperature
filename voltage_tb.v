`timescale 1 ns / 100 ps
module voltage_tb;

    reg input_voltage; // input
    wire output_temp; // output

    voltage voltage(.v_therm(input_voltage), .temp_therm(output_temp));

    // initialize
    begin
        input_voltage = 0;

        #80
        $finish
    end

    always 
        #20 input_voltage += 1;

    always @(input_voltage) begin
        #1;
        $display("input_voltage:%d ---> output_temp:%d", input_voltage, output_temp);
    end
endmodule