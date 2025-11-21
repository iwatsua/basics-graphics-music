`include "config.svh"

module lab_top
# (
    parameter  clk_mhz       = 125,
               w_key         = 4,
               w_sw          = 8,
               w_led         = 8,
               w_digit       = 8,
               w_gpio        = 100,

               screen_width  = 640,
               screen_height = 480,

               w_red         = 4,
               w_green       = 4,
               w_blue        = 4,

               w_x           = $clog2 ( screen_width  ),
               w_y           = $clog2 ( screen_height )
)
(
    input                        clk,
    input                        slow_clk,
    input                        rst,

    // Keys, switches, LEDs

    input        [w_key   - 1:0] key,
    input        [w_sw    - 1:0] sw,
    output logic [w_led   - 1:0] led,

    // A dynamic seven-segment display

    output logic [          7:0] abcdefgh,
    output logic [w_digit - 1:0] digit,

    // Graphics

    input        [w_x     - 1:0] x,
    input        [w_y     - 1:0] y,

    output logic [w_red   - 1:0] red,
    output logic [w_green - 1:0] green,
    output logic [w_blue  - 1:0] blue,

    // Microphone, sound output and UART

    input        [         23:0] mic,
    output       [         15:0] sound,

    input                        uart_rx,
    output                       uart_tx,

    // General-purpose Input/Output

    inout        [w_gpio  - 1:0] gpio
);

    //------------------------------------------------------------------------

     assign led        = '0;
    //   assign abcdefgh   = '0;
    //   assign digit      = '0;
       assign red        = '0;
       assign green      = '0;
       assign blue       = '0;
       assign sound      = '0;
       assign uart_tx    = '1;

    //------------------------------------------------------------------------

    logic [31:0] cnt;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            cnt <= '0;
        else
            cnt <= cnt + 1'd1;

    wire enable = (cnt [22:0] == '0);

    //------------------------------------------------------------------------

    wire button_on = | (~key);

    //logic [w_led - 1:0] shift_reg;

/*    always_ff @ (posedge clk or posedge rst)
        if (rst)
            shift_reg <= '1;
        else if (enable)
            shift_reg <= { button_on, shift_reg [w_led - 1:1] };*/

    //assign led = shift_reg;

    // Exercise 1: Make the light move in the opposite direction.
/*    always_ff @ (posedge clk or posedge rst)
        if (rst)
            shift_reg <= '1;
        else if (enable)
            shift_reg <= { shift_reg [w_led - 2:0], button_on };*/

    // Exercise 2: Make the light moving in a loop.
    // Use another key to reset the moving lights back to no lights.
/*    wire a = ~key[0];
    wire b = ~key[1];
    logic a_old;    
    always_ff @ (posedge clk or posedge rst)
        if (rst)
            shift_reg <= 1;
        else if (enable & a)
            shift_reg <= { shift_reg [w_led - 2:0], shift_reg[w_led - 1]};            
        else if (~a)
            begin
                shift_reg <= 0;
                a_old <= '1;
            end
        else if (a & a_old)
            begin
                a_old <= '0;
                shift_reg <= 1;                    
            end*/

    // Exercise 3: Display the state of the shift register
    // on a seven-segment display, moving the light in a circle.
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--  h

    typedef enum bit [7:0]
    {
        a     = 8'b1000_0000,
        b     = 8'b0100_0000,
        c     = 8'b0010_0000,
        d     = 8'b0001_0000,
        e     = 8'b0000_1000,        
        f     = 8'b0000_0100,
        space = 8'b0000_0000              
    }
    seven_seg_encoding_e;

    seven_seg_encoding_e letter;

    always_comb
      case (6' (shift_reg))
      6'b100000: letter = a;
      6'b010000: letter = b;
      6'b001000: letter = c;
      6'b000100: letter = d;
      6'b000010: letter = e;
      6'b000001: letter = f;      
      default: letter = space;
      endcase

    logic [5:0] shift_reg;
    always_ff @ (posedge clk or posedge rst)
        if (rst)
            shift_reg <= 1;
        else if (enable)
            shift_reg <= { shift_reg [4:0], shift_reg[5]};

    assign abcdefgh = letter;    
    assign digit = 1;    

endmodule
