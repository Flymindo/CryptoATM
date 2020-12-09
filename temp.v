`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 21:12:43
// Design Name: 
// Module Name: temp
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


module temp(
    input clk, BTNU, 
    input [1:0] usr_input, //Input from user (probably going to change as the input format is still up in the air)
                     //Maybe Instead of forwarding user input to this module there is another module in the middle
                     //that verifies account numbers and pin numbers
    input [3:0] status_code,
    output [7:0] AN,
    output [6:0] led
    );
    wire [15:0] current_state;
    wire [15:0] a,b,c,d,e,f;
    
    assign a = 16'd7777;
    assign b = 16'd1111;
    assign c = 16'd22;
    assign d = 16'd333;
    assign e = 16'd4444;
    
    FSM fsm1(clk, usr_input, status_code, current_state);
    
    display disp(clk, BTNU,current_state, a,b,c,d,e, AN, led);
    
    
    
endmodule
