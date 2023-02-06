`timescale 1ns / 1ps

module tlc_controller_ver1(
    output wire[1:0] highwaySignal, farmSignal,
    /* Let's output state for debugging */
    output wire [3:0] JB,
    input wire Clk,
    /* the buttons provide input to our top level circuit */
    input wire Rst, // use as reset
    // experiment 2
    input wire Sensor
    );
    /* Intermediate nets */
    wire RstSync;
    wire RstCount;
    reg [30:0] Count;
    
    assign JB[3] = RstCount;
    
    /* synchronize button inputs */
    synchronizer syncRst(RstSync, Rst, Clk);
    /* instantiate FSM */
    tlc_fsm FSM(
        .state(JB[2:0]), // wire state up to JB
        .RstCount(RstCount),
        .highwaySignal(highwaySignal),
        .farmSignal(farmSignal),
        .Count(Count),
        .Clk(Clk),
        .Rst(RstSync),
        .farmSensor(Sensor)
    );
    /* describe counter with a synchronous reset */
    always@ (posedge Clk)
        if (Rst)
            Count = 0;
        else 
            Count = Count + 1;
endmodule
