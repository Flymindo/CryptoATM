`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/03 20:27:35
// Design Name: 
// Module Name: menu
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


module menu(
    input clk,
    input BTNU, BTND,
    output reg [7:0] AN,
    output reg [6:0] led,
    output [1:0] lght
    );
    wire s_clock;
    wire [39:0] inst_balance;
    wire [39:0] inst_withdraw;
    wire [39:0] inst_currency;
    wire [39:0] inst_transfer;
    
    wire [7:0] AN1,AN2,AN3,AN4;
    wire [6:0] led1,led2,led3,led4;
    
    reg [1:0] button_op;
    reg rst1,rst2,rst3,rst4;
    wire up,down;
    
    sec_clock sec(clk,s_clock);

    inst_balance ib(s_clock,rst1,inst_balance);
    withdraw withdr(s_clock,rst2,inst_withdraw);
    convert_currency cc(s_clock, rst3, inst_currency);
    inst_transfer tf(s_clock, rst4, inst_transfer);
    
    instruction_seven_seg_display issd1(clk,inst_balance,AN1,led1);
    instruction_seven_seg_display issd2(clk,inst_withdraw,AN2,led2);
    instruction_seven_seg_display issd3(clk,inst_currency,AN3,led3);
    instruction_seven_seg_display issd(clk,inst_transfer,AN4,led4);

    debounce d1(BTNU,clk,up);
    debounce d2(BTND,clk,down);
    
    
    always@(posedge down or posedge up)
    begin
        if (down)
        begin
            if (button_op == 2'b11)
                button_op <= 2'b00;
            else
                button_op <= button_op + 1'b1;
        end
        else if(up)
        begin
            if (button_op == 2'b00)
                button_op = 2'b11;
            else
                button_op <= button_op - 1'b1;
        end
    end
    
    
    assign lght = button_op;
    
    
    always@(*)
    begin
        case(button_op)
        2'b00:
            begin
                AN = AN1;
                rst1 = 0;
                rst2 = 1;
                rst3 = 1;
                rst4 = 1;
                led = led1;
            end 
        2'b01:
            begin
                AN = AN2;
                rst1 = 1;
                rst2 = 0;
                rst3 = 1;
                rst4 = 1;
                led = led2;
            end
        2'b10:
            begin
                AN = AN3;
                rst1 = 1;
                rst2 = 1;
                rst3 = 0;
                rst4 = 1;
                led = led3;
            end
        2'b11:
            begin
                AN = AN4;
                rst1 = 1;
                rst2 = 1;
                rst3 = 1;
                rst4 = 0;
                led = led4;
            end
        
        endcase
    end
    
endmodule
