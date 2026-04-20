`timescale 1ns / 1ps

module pixel_generation #(
    parameter X_MAX = 640,                  // right border of display area
    parameter Y_MAX = 480,                  // bottom border of display area
    parameter HEIGHT = 32,                   // height of line sides in pixels
    parameter WIDTH = 32,                   // width of line sides in pixels
    parameter NUM_WALLS = 5                 
)(
    input clk,                              // 100MHz from Basys 3
    input reset,                            // btnC
    input video_on,                         // from VGA controller
    input [9:0] x, y,                       // from VGA controller
    input [3:0] move,                       // movement keys
    output [3:0] Anode_Activate,         // anode signals of the 7-segment LED display
    output reg [6:0] LED_out,               // cathode patterns of the 7-segment LED display
    input [15:0] switch,
    output reg [11:0] rgb                   // to DAC, to VGA controller
    );
  

    
    // create a 60Hz refresh tick at the start of vsync 
    wire refresh_tick;
    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0;
    
    // square boundaries and position
    wire [9:0] sq_x_l, sq_x_r;              // square left and right boundary
    wire [9:0] sq_y_t, sq_y_b;              // square top and bottom boundary
    
    reg [9:0] sq_x_reg, sq_y_reg;           // regs to track left, top position
    logic [9:0] sq_x_next, sq_y_next;        // buffer wires
    
    logic [9:0] enemy_l,enemy_r, enemy_t,enemy_b;
    assign enemy_r = enemy_l + WIDTH-1;
    assign enemy_b = enemy_t + HEIGHT-1;
    
    //Walls
    logic [9:0] wall_x_l [NUM_WALLS];
    logic [9:0] wall_x_r [NUM_WALLS];
    logic [9:0] wall_y_t [NUM_WALLS];
    logic [9:0] wall_y_b [NUM_WALLS];
    //walls(.clk(clk),.reset(reset),.seed(switch),.wall_x_l(wall_x_l),.wall_x_r(wall_x_r),.wall_y_t(wall_y_t),.wall_y_b(wall_y_b));
//    initial begin 
//    for (int i = 1; i <NUM_WALLS; i++) begin
//        wall_x_l[i] = randomize();
//        wall_x_r[i] = wall_x_l[i] + randomize();
//        wall_y_t[i] = randomize();
//        wall_y_b[i] = wall_y_t[i] + randomize();
//    end
//    end

//    //wall 0
    assign wall_x_l[0] = 200;
    assign wall_x_r[0] = 250;
    assign wall_y_t[0] = 200;
    assign wall_y_b[0] = 400;
    
    assign wall_x_l[1] = 100;
    assign wall_x_r[1] = 125;
    assign wall_y_t[1] = 75;
    assign wall_y_b[1] = 250;
    
    assign wall_x_l[2] = 400;
    assign wall_x_r[2] = 500;
    assign wall_y_t[2] = 100;
    assign wall_y_b[2] = 135;
        
    assign wall_x_l[3] = 600;
    assign wall_x_r[3] = 650;
    assign wall_y_t[3] = 400;
    assign wall_y_b[3] = 440;
        
    assign wall_x_l[4] = 500;
    assign wall_x_r[4] = 510;
    assign wall_y_t[4] = 125;
    assign wall_y_b[4] = 480;
    
    logic x_overlap = (sq_x_l < enemy_l + WIDTH-1) && (sq_x_l + WIDTH-1 > enemy_l);
    logic y_overlap = (sq_y_t < enemy_t + HEIGHT-1) && (sq_y_t + HEIGHT-1 > enemy_t);
    
    logic game_over;
    assign game_over = (x_overlap && y_overlap);
    logic game_over_on;
    logic sign_x_l = 200;
    logic sign_x_r = X_MAX - 200;
    logic sign_y_t = 150;
    logic sign_y_b = Y_MAX - 150;
    assign game_over_on = (sign_x_l <= x) && (x <= sign_x_r) &&
                   (sign_y_t <= y) && (y <= sign_y_b);;
    
    enemy enemy0(.clk(clk),.reset(reset),.refresh_tick(refresh_tick),.switch(switch),.player_x(sq_x_l),.player_y(sq_y_t),
    .wall_x_l(wall_x_l),.wall_x_r(wall_x_r),.wall_y_t(wall_y_t),.wall_y_b(wall_y_b),.enemy_x(enemy_l),.enemy_y(enemy_t));
    // register control
    always @(posedge clk or posedge reset)
        if(reset) begin
            sq_x_reg <= 10;
            sq_y_reg <= 10;
        end
        else begin
            if (!game_over) begin
                sq_x_reg <= sq_x_next;
                sq_y_reg <= sq_y_next;
            end
        end
    
    // square boundaries
    assign sq_x_l = sq_x_reg;                   // left boundary
    assign sq_y_t = sq_y_reg;                   // top boundary
    assign sq_x_r = sq_x_l + WIDTH - 1;   // right boundary
    assign sq_y_b = sq_y_t + HEIGHT - 1;   // bottom boundary
    
    
    
    // square status signal
    wire sq_on;
    assign sq_on = (sq_x_l <= x) && (x <= sq_x_r) &&
                   (sq_y_t <= y) && (y <= sq_y_b);
   // square status signal
    wire enemy_on;
    assign enemy_on = (enemy_l <= x) && (x <= enemy_r) &&
                   (enemy_t <= y) && (y <= enemy_b);
                   
    logic wall_on;
    always_comb begin
        wall_on = 0;
        for (int i = 0; i < NUM_WALLS; i++) begin
            if ((x >= wall_x_l[i]) &&
                (x <= wall_x_r[i]) &&
                (y >= wall_y_t[i]) &&
                (y <= wall_y_b[i])) begin
                    wall_on = 1;
            end
        end
    end  
                   
    // new square position


    logic [9:0] next_x, next_y;
    wire [9:0] next_x_r = next_x + WIDTH - 1;
    wire [9:0] next_y_b = next_y + HEIGHT - 1;
    
    

    always_comb begin
        next_x = sq_x_reg;
        next_y = sq_y_reg;
    
        if (refresh_tick) begin
            next_x = sq_x_reg + move[1] - move[0];
            next_y = sq_y_reg + move[3] - move[2];
        end
    end
    
    wire hit_left   = (next_x <= 10);
    wire hit_right  = (next_x_r >= X_MAX-10);
    wire hit_top    = (next_y <= 20);
    wire hit_bottom = (next_y_b >= Y_MAX-10);
    
    logic collision_with_wall;
    
    always_comb begin
        collision_with_wall = 0;
        for (int i = 0; i < NUM_WALLS; i++) begin
            if ((next_x_r >= wall_x_l[i]) &&
                (next_x <= wall_x_r[i]) &&
                (next_y_b >= wall_y_t[i]) &&
                (next_y <= wall_y_b[i])) begin
                    collision_with_wall = 1;
            end
        end
    end
    
    always_comb begin
    sq_x_next = sq_x_reg;
    sq_y_next = sq_y_reg;

    if (refresh_tick) begin
        if (!collision_with_wall) begin
            //x
            if (hit_left) sq_x_next = next_x + 10;
            else if (hit_right) sq_x_next = next_x - 10;
            else sq_x_next = next_x;
            //y
            if (hit_top) sq_y_next = next_y + 10;
            else if (hit_bottom) sq_y_next = next_y - 10;
            else sq_y_next = next_y;
        end
    end
end


    wire timer_on;

    wire boarder_on;
    assign boarder_on = ((x <= 10) || ((X_MAX - 10 <= x) && (x <= X_MAX) )) || ((y <= 20) || ((Y_MAX - 10 <= y) && (y <= Y_MAX) ));
            
            
    Seven_segment_LED_Display_Controller(.clk_100MHz(clk),.reset(reset),.Anode_Activate(Anode_Activate),.LED_out(LED_out));

    wire stats_on;
    stats(.clk_100MHz(clk),.reset(reset), .Anode_Activate(Anode_Activate),.LED_out(LED_out),.x(x), .y(y),.pixel_on(stats_on));
    
    // RGB control
    always @*
        if(~video_on)
            rgb = 12'h000;          // black(no value) outside display area
        else
            if (stats_on)
                rgb = 12'h00F;
            else if (game_over_on)
                rgb = 12'h000;
            else if (boarder_on)
                rgb = 12'h888;
            else if(sq_on)
                rgb = 12'h0F0;      // Green Enemy
            else if (enemy_on)
                rgb = 12'h00F;      // Red Enemy
            else if (wall_on)
                rgb = 12'hF00;      // Blue Wall
            else if (timer_on)
                rgb = 12'h0F0;
            else
                rgb = 12'hFFF;      // White background
    
endmodule
