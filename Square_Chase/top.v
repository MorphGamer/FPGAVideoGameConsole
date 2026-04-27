`timescale 1ns / 1ps

module top(
    input clk_100MHz,       // from Basys 3
    input reset,            // btnC on Basys 3
    input [3:0] move,       // movement keys
    input [15:0] sw,
    input float,
	input MISO,
	output SS,					// Slave Select, Pin 1, Port JA
	output MOSI,				// Master Out Slave In, Pin 2, Port JA
	output SCLK,
    output hsync,           // VGA port on Basys 3
    output vsync,           // VGA port on Basys 3
    output [11:0] rgb,       // to DAC, 3 bits to VGA port on Basys 3
    output [3:0] Anode_Activate, // anode signals of the 7-segment LED display
    output [6:0] LED_out// cathode patterns of the 7-segment LED display
    );
    parameter  offset_x = 150;
    parameter  offset_y = 150;
    wire [9:0] move_x,move_y;
    reg [9:0] center_x, center_y;
        always @(posedge clk_100MHz)
        if(move[0])begin
            center_x <= move_x;
            center_y <= move_y;
            end
    wire move_l = move_x > (center_x + offset_x);
    wire move_r = move_x < (center_x - offset_x);
    wire move_u = move_y > (center_y + offset_y);
    wire move_d = move_y < (center_y - offset_y);
    wire [3:0] move1 = {move_r,move_l,move_u,move_d};//fix later
    //x//815-207//526
    //y//861-207//540
    
    wire w_video_on, w_p_tick;
    wire [9:0] w_x, w_y;
    reg [11:0] rgb_reg;
    wire[11:0] rgb_next;
    
    Seven_segment_LED_Display_Controller(.clk_100MHz(clk_100MHz),.reset(reset),.Anode_Activate(Anode_Activate),.LED_out(LED_out));
    vga_controller vc(.clk_100MHz(clk_100MHz), .reset(reset), .video_on(w_video_on), .hsync(hsync), 
                      .vsync(vsync), .p_tick(w_p_tick), .x(w_x), .y(w_y));
    pixel_generation pg(.clk(clk_100MHz), .reset(reset), .video_on(w_video_on), .move(sw[15] ? move :move1),.switch(sw),
                        .x(w_x), .y(w_y), .rgb(rgb_next));
    
    always @(posedge clk_100MHz)
        if(w_p_tick)
            rgb_reg <= rgb_next;
            
    assign rgb = rgb_reg;
    
    PmodJSTK_Demo joystick0 (
    .CLK(clk_100MHz),
    .RST(reset),
    .MISO(MISO),
	.SW(sw),
    .SS(SS),
    .MOSI(MOSI),
    .SCLK(SCLK),
	.move_x(move_x),
	.move_y(move_y));
    
    
 
endmodule
