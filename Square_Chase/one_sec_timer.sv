`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2026 09:35:31 AM
// Design Name: 
// Module Name: one_sec_timer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module one_sec_timer(
    input clk_100MHz, // 100 Mhz clock source on Basys 3 FPGA
    input reset, // reset
    output logic one_second_enable
    );
    reg [26:0] one_second_counter; // counter for generating 1 second clock enable

    //Count for 1 second
    always @(posedge clk_100MHz or posedge reset)
    begin
        if(reset==1)
            one_second_counter <= 0;
        else begin
            if(one_second_counter>=99999999) 
                 one_second_counter <= 0;
            else
                one_second_counter <= one_second_counter + 1;
        end
    end 
    
    //pulse at 1 second
    assign one_second_enable = (one_second_counter==99999999)?1:0;
    
endmodule
