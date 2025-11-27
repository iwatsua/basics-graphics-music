// Asynchronous reset here is needed for some FPGA boards we use

`include "config.svh"

module snail_mealy_fsm0101
(
    input  clk,
    input  rst,
    input  en,
    input  a,
    output y
);

    typedef enum logic bit
    {
        S0 = 2'd0,
        S1 = 2'd1,
        S2 = 2'd2,
        S3 = 2'd3        
    }
    state_e;

    state_e state, next_state;

    // State register

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            state <= S0;
        else if (en)
            state <= next_state;

    // Next state logic

    always_comb
    begin
        next_state = state;

        case (state)
        S0: if (~ a) next_state = S1;
        S1: if (  a) next_state = S2;
        S2: if (~ a) next_state = S3;
        S3: if (  a) next_state = S0;        
        endcase
    end

    // Output logic based on current state and inputs

    assign y = (a & state == S3);

endmodule
