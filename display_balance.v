`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/10 05:10:01
// Design Name: 
// Module Name: display_balance
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


module display_balance(
    input clk,
    input BTNU,
    input [15:0] balance_dollars_out,
    input [15:0] balance_btc,
    input [15:0] balance_eth,
    input [15:0] balance_xrp,
    input [15:0] balance_ltc,
    output reg [7:0] AN,
    output reg [6:0] led
    );
    wire s_clock,up;
    
    wire [7:0] AN1,AN2,AN3,AN4,AN5;
    wire [6:0] led1,led2,led3,led4,led5;
    reg [2:0] button_op;
    
    sec_clock sec1(clk,s_clock);
    debounce d2(BTNU,clk,up);
    
    seven_seg_decoder dollar(clk,balance_dollars_out,AN1,led1);
    seven_seg_decoder btc(clk,balance_btc,AN2,led2);
    seven_seg_decoder eth(clk,balance_eth,AN3,led3);
    seven_seg_decoder xrp(clk,balance_xrp,AN4,led4);
    seven_seg_decoder ltc(clk,balance_ltc,AN5,led5);
    
    always@(posedge up)
    begin
        if(up)
        begin
            if (button_op == 3'b100)
                button_op <= 3'b000;
            else
                button_op <= button_op + 1'b1;
        end
    end
    
    
    always@(*)
    begin
        case(button_op)
        3'b000:
            begin
                AN = AN1;
                led = led1;
            end 
        3'b001:
            begin
                AN = AN2;
                led = led2;
            end
        3'b010:
            begin
                AN = AN3;
                led = led3;
            end
        3'b011:
            begin
                AN = AN4;
                led = led4;
            end
        3'b100:
            begin
                AN = AN5;
                led = led5;
            end

        endcase    
    end
    
    
    
    
    
endmodule
