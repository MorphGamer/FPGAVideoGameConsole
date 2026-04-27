`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2026 11:14:04 AM
// Design Name: 
// Module Name: randomNumber
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

//Linear-feedback shift register
module randomNumber#(
   OFFSET = 18108,
   BITS =  16,
   FBB0 = 10,
   FBB1 = 12,
   FBB2 = 13,
   FBB3 = 15
)
(
    input wire        clk,reset,
    input wire [15:0] seed,
    output wire [BITS:0] lfsr_number
    );
    
    reg [BITS:0] lfsr_reg;
    assign lfsr_number = lfsr_reg;
    wire feedback = lfsr_reg[FBB0] ^ lfsr_reg[FBB2] ^ lfsr_reg[FBB3] ^ lfsr_reg[FBB0];

    always_ff @(negedge clk) begin
        if (reset) 
            lfsr_reg <= seed + OFFSET;
         else 
            lfsr_reg <= {lfsr_reg[BITS-1:0], feedback};
    end
    
endmodule
