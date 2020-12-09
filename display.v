`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 20:46:34
// Design Name: 
// Module Name: display
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


module display(
    input clk, BTNU,
    input [3:0] state,
//    input [15:0] balance_dollars_out,
//    input [15:0] balance_btc,
//    input [15:0] balance_eth,
//    input [15:0] balance_xrp,
//    input [15:0] balance_ltc,
    output  reg[7:0] AN,
    output  reg[6:0] led
    );
    
    wire [7:0] AN_menu, AN_const, AN_mov;
    wire [6:0] led_menu, led_const, led_mov;
    
    const_instruction inst_const(clk, BTNU,state, AN_const,led_const);
    menu menu_selection(clk,BTNU, state, AN_menu, led_menu);
    moving_ins mi(clk, state, AN_mov, led_mov);
    
    
    
    
    always@(*)
    begin
        case(state)
            4'b0000:
            begin
                AN = AN_const;
                led = led_const;
            end
            4'b0001:
            begin
                AN = AN_mov;
               led = led_mov;
            end
            4'b0010:
            begin
               AN = AN_mov;
               led = led_mov;
            end
            4'b0011:
            begin
                AN = AN_menu;
                led = led_menu;
            end
            4'b0100:
            begin
            end
            4'b0101:
            begin
            end
            4'b0110:
            begin
            end
            4'b0111:
            begin
            end
            4'b1000:
            begin
                AN = AN_mov;
               led = led_mov;
            end
            4'b1001:
            begin
            end
            4'b1010:
            begin
                AN = AN_mov;
                led = led_mov;
            end
            4'b1011:
            begin
                AN = AN_const;
                led = led_const;
            end
            4'b1100:
            begin
            end
            4'b1101:
            begin
                AN = AN_const;
                led = led_const;
            end
            4'b1110:
            begin
                AN = AN_const;
                led = led_const;
            end
        endcase
    end
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
endmodule
