`default_nettype none
/* From pre-lab, clock cycles */
`define one_sec 50000000
`define three_sec 150000000
`define fifteen_sec 750000000
`define thirty_sec 1500000000

    module tlc_fsm(
    output reg [2:0] state, // output for debugging
    output reg RstCount, // use an always blcok
    output reg [1:0] highwaySignal, farmSignal,
    /* another always block for these as well */
    input wire [30:0] Count, // use n computed earlier
    input wire Clk, Rst, // clock and reset
    // experiment part 2
    input wire farmSensor
    );
    // states
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011,
              S4 = 3'b100,
              S5 = 3'b101,
              red = 2'b01, // red  is 01
              yellow = 2'b10, // yellow is 10
              green = 2'b11; // green is 11
    /* Intermediate nets */
    reg [2:0] nextState;
    always@(Count)
        case (state)
            S0: begin
            if (Count == `three_sec) // next state
                begin
                    highwaySignal = red;
                    farmSignal = red;
                    RstCount = 1;
                    nextState = S1;
                end
            else // otherwise stay
                begin
                    highwaySignal = red;
                    farmSignal = red;
                    RstCount = 0;
                    nextState = S0;
                end
           end
           S1: begin
           if ((Count >= `thirty_sec) && (farmSensor == 1)) // next state
              begin
                highwaySignal = green;
                farmSignal = red;
                RstCount = 1;
                nextState = S2;
              end
           else // otherwise stay
              begin
                highwaySignal = green;
                farmSignal = red;
                RstCount = 0;
                nextState = S1;
              end
           end
           S2: begin
           if (Count == `three_sec) // next state
              begin
                highwaySignal = yellow;
                farmSignal = red;
                RstCount = 1;
                nextState = S3;
              end
           else // otherwise stay
              begin
                highwaySignal = yellow;
                farmSignal = red;
                RstCount = 0;
                nextState = S2;
              end
           end
           S3: begin
           if (Count == `one_sec) // next state
              begin
                highwaySignal = red;
                farmSignal = red;
                RstCount = 1;
                nextState = S4;
              end
           else // otherwise stay
              begin
                highwaySignal = red;
                farmSignal = red;
                RstCount = 0;
                nextState = S3;
              end
           end
           S4: begin
           if ((Count == `fifteen_sec) || ((farmSensor == 0) && (Count == `three_sec))) // next state
              begin
                highwaySignal = red;
                farmSignal = green;
                RstCount = 1;
                nextState = S5;
              end
           else // otherwise stay
              begin
                highwaySignal = red;
                farmSignal = green;
                RstCount = 0;
                nextState = S4;  
              end
           end
           S5: begin
           if (Count == `three_sec) // next state
              begin
                highwaySignal = red;
                farmSignal = yellow;
                RstCount = 1;
                nextState = S0;
              end
           else // otherwise stay
              begin
                highwaySignal = red;
                farmSignal = yellow;
                RstCount = 1;
                nextState = S5;
              end
           end
        endcase
    always@ (posedge Clk)
        if (Rst) // if Reset == 1
            state <= S0;
        else // otherwise next state
            state <= nextState;
endmodule
