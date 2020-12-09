`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 21:02:31
// Design Name: 
// Module Name: moving_ins
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


module moving_ins(
    input clk,
    input [3:0] state,
    output reg [7:0] AN,
    output reg [6:0] led
    );
    wire s_clock;
    wire [39:0] inst_acc_num,inst_pin_num,inst_enter_amount,inst_transfer;
    
    wire [7:0] AN1,AN2,AN3,AN4;
    wire [6:0] led1,led2,led3,led4;
    

    reg rst1,rst2,rst3,rst4;

    
    sec_clock sec(clk,s_clock);

    inst_input_acc_num iian(s_clock,rst1,inst_acc_num);
    inst_enter_pin_num iepn(s_clock,rst2,inst_pin_num);
    inst_enter_amount iea(s_clock, rst3, inst_enter_amount);
//    inst_transfer tf(s_clock, rst4, inst_transfer);
    
    
    
    
    instruction_seven_seg_display issd1(clk,inst_acc_num,AN1,led1);
    instruction_seven_seg_display issd2(clk,inst_pin_num,AN2,led2);
    instruction_seven_seg_display issd3(clk,inst_enter_amount,AN3,led3);
//    instruction_seven_seg_display issd4(clk,inst_transfer,AN4,led4);



    
    
    always@(*)
    begin
        case(state)
        4'b0001:
            begin
                AN = AN1;
                {rst1,rst2,rst3,rst4} = 4'b0111;
                led = led1;
            end 
        4'b0010:
            begin
                AN = AN2;
                {rst1,rst2,rst3,rst4} = 4'b1011;
                led = led2;
            end
        4'b1000:
            begin
                AN = AN3;
                {rst1,rst2,rst3,rst4} = 4'b1011;
                led = led3;
            end
        4'b1010:
            begin
                AN = AN1;
                {rst1,rst2,rst3,rst4} = 4'b0111;
                led = led1;
            end
        default:
                 {rst1,rst2,rst3,rst4} = 4'b1111;
        endcase
        
    end
    
endmodule
