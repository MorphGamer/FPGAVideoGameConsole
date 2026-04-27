`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2026 10:10:01 AM
// Design Name: 
// Module Name: stats
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


module stats#(
    parameter EXPONENT = 5,
    parameter X_OFFSET = 600,
    parameter Y_OFFSET = 5,
    parameter BACKGROUND = 12'hFFF,
    parameter COLOR = 12'h00F,
    parameter THICKNESS = 1,
    parameter LENGTH = 4
    
)(
    input clk_100MHz, // 100 Mhz clock source on Basys 3 FPGA
    input reset, // reset
    input [9:0] x, y,
    input stop,
    output logic pixel_on,
    output logic [3:0] score_10[EXPONENT]
    );
    
    
logic one_second_enable;
logic display_number_carry[EXPONENT];
logic [3:0] displayed_number_10[EXPONENT],
            next_displayed_number_10[EXPONENT];

assign score_10 = displayed_number_10;


//Count for 1 second
//Pulse at 1 second
one_sec_timer(.clk_100MHz(clk_100MHz),.reset(reset),.one_second_enable(one_second_enable));

always @(posedge clk_100MHz or posedge reset)
begin
    if(reset==1)    for (int i =0; i < EXPONENT; i++) displayed_number_10[i] <= 9;
    else if ((one_second_enable == 1) && (!stop) ) for (int i = 0; i< EXPONENT; i++) displayed_number_10[i] <= next_displayed_number_10[i];
end
    
always_comb begin

next_displayed_number_10[0] = (display_number_carry[0]) ? 0 : displayed_number_10[0]+ 1;
display_number_carry[0] = (displayed_number_10[0] + 1 == 10);

for (int i = 1; i < EXPONENT; i++)begin
next_displayed_number_10[i] = (display_number_carry[i]) ? 0 : displayed_number_10[i] + display_number_carry[i-1];
display_number_carry[i] = (displayed_number_10[i] + display_number_carry[i-1] == 10);
end

end
    
    
logic [6:0] segment[EXPONENT];
    
// Cathode patterns of the 7-segment LED display 
    always_comb
    begin
    for (int i =0; i < EXPONENT; i++) begin
        case(displayed_number_10[i])
        4'b0000: segment[i] = 7'b0000001; // "0"
        4'b0001: segment[i] = 7'b1001111; // "1"
        4'b0010: segment[i] = 7'b0010010; // "2"
        4'b0011: segment[i] = 7'b0000110; // "3"
        4'b0100: segment[i] = 7'b1001100; // "4"
        4'b0101: segment[i] = 7'b0100100; // "5"
        4'b0110: segment[i] = 7'b0100000; // "6"
        4'b0111: segment[i] = 7'b0001111; // "7"
        4'b1000: segment[i] = 7'b0000000; // "8"
        4'b1001: segment[i] = 7'b0000100; // "9"
        default: segment[i] = 7'b0000001; // "0"
        endcase
        
    end
    end
    
    
    
always_comb begin

pixel_on = 0;

for (int i = 0; i <EXPONENT; i++) begin
    // Segment top
    if (!segment[i][6] && (x >= X_OFFSET -(LENGTH+5)*i+THICKNESS && x <= X_OFFSET-(LENGTH+5)*i+LENGTH) && (y >= Y_OFFSET && y <= Y_OFFSET+THICKNESS)) pixel_on = 1;
    // Segment 'b' (top-right)
    if (!segment[i][5] && (x >= X_OFFSET-(LENGTH+5)*i+LENGTH && x <= X_OFFSET-(LENGTH+5)*i+LENGTH+THICKNESS) && (y >= Y_OFFSET+THICKNESS && y <= Y_OFFSET+LENGTH)) pixel_on = 1;
    // Segment 'c' (bottom-right)
    if (!segment[i][4] && (x >= X_OFFSET-(LENGTH+5)*i+LENGTH && x <= X_OFFSET-(LENGTH+5)*i+LENGTH+THICKNESS) && (y >= Y_OFFSET+LENGTH+THICKNESS && y <= Y_OFFSET+2*LENGTH)) pixel_on = 1;
    // Segment 'd' (bottom)
    if (!segment[i][3] && (x >= X_OFFSET-(LENGTH+5)*i+THICKNESS && x <= X_OFFSET-(LENGTH+5)*i + LENGTH) && (y >= Y_OFFSET+2*LENGTH && y <= Y_OFFSET+2*LENGTH+THICKNESS)) pixel_on = 1;
    // Segment 'e' (bottom-left)
    if (!segment[i][2] && (x >= X_OFFSET-(LENGTH+5)*i && x <= X_OFFSET-(LENGTH+5)*i+THICKNESS) && (y >= Y_OFFSET+LENGTH+THICKNESS && y <= Y_OFFSET+2*LENGTH)) pixel_on = 1;
    // Segment 'f' (top-left)
    if (!segment[i][1] && (x >= X_OFFSET-(LENGTH+5)*i && x <= X_OFFSET-(LENGTH+5)*i+THICKNESS) && (y >= Y_OFFSET+THICKNESS && y <= Y_OFFSET+LENGTH)) pixel_on = 1;
    // Segment 'g' (middle)
    if (!segment[i][0] && (x >= X_OFFSET-(LENGTH+5)*i+THICKNESS && x <= X_OFFSET-(LENGTH+5)*i+LENGTH) && (y >= Y_OFFSET+LENGTH && y <= Y_OFFSET+LENGTH+THICKNESS)) pixel_on = 1;

end


end



    
    
endmodule
