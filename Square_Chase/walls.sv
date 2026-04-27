`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2026 11:24:23 PM
// Design Name: 
// Module Name: walls
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


module walls #(
    parameter HEIGHT = 32,
    parameter WIDTH = 32,
    parameter MIN_X = 10,
    parameter MIN_Y = 20,
    parameter MAX_X = 630,
    parameter MAX_Y = 470,
    parameter NUM_WALLS = 10,
    parameter OFFSEED_0 = 6585,
    parameter OFFSEED_1 = 2865,
    parameter OFFSEED_2 = 96585
) (
    input   logic        clk,
    input   logic        reset,
    input   logic [15:0] seed,
    output  reg [9:0]  wall_x_l [NUM_WALLS],
    output  reg [9:0]  wall_x_r [NUM_WALLS],
    output  reg [9:0]  wall_y_t [NUM_WALLS],
    output  reg [9:0]  wall_y_b [NUM_WALLS]
);
    logic [15:0] lfsr_reg0,lfsr_reg1,lfsr_reg2;
    randomNumber #(.OFFSET(OFFSEED_0)) RN0 (.clk(clk),.reset(reset),.seed(seed),.lfsr_number(lfsr_reg0));
    randomNumber #(.OFFSET(OFFSEED_1)) RN1 (.clk(clk),.reset(reset),.seed(seed),.lfsr_number(lfsr_reg1));
    randomNumber #(.OFFSET(OFFSEED_2)) RN2 (.clk(clk),.reset(reset),.seed(seed),.lfsr_number(lfsr_reg2));
    int count = 0;
    int clk2wait = 0;
    
    logic [9:0]x_l,x_r,y_t,y_b,width, length;
    assign width = {5'b0,1'b1,lfsr_reg2[11:8]};
    assign length = {3'b0,lfsr_reg2[7:0]};
    assign x_l = lfsr_reg0[8:0] + MIN_X;
    assign x_r = x_l + (lfsr_reg2[0] ? width: length);
    assign y_t = lfsr_reg1[8:0] + MIN_Y;
    assign y_b = y_t + (lfsr_reg2[0] ? length:width);
    

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 0;
            clk2wait <= 0;
            for (int i = 1; i <NUM_WALLS; i++) begin
                wall_x_l[i] <= 0;
                wall_x_r[i] <= 0;
                wall_y_t[i] <= 0;
                wall_y_b[i] <= 0;
            end 
        end else 
            clk2wait <= clk2wait + 1;
            if (count < NUM_WALLS ) begin
            clk2wait <= 0;
            wall_x_l[count] <= x_l;
            wall_x_r[count] <= x_r;
            wall_y_t[count] <= y_t;
            wall_y_b[count] <= y_b;
            
            count <= count + 1;
        end
    end
endmodule

