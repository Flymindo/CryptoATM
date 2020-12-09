`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 21:51:11
// Design Name: 
// Module Name: inst_enter_amount
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


module inst_enter_amount(
    input sec_clock,
    input rst,
    output [39:0] instruction
    );
    
    reg[39:0] temp = 40'b0000000000000000000000000000000000000000;
    reg[7:0] count;
    
    
    always@(posedge sec_clock)
    begin
        if (rst == 1)
        begin
            count <= 0;
            temp = 40'b0000000000000000000000000000000000000000;
        end
        else
        begin
            count <= count + 1;
            if (count == 1)
            begin
                temp = { temp[34:0], 5'b01001};
            end
            else if (count == 2)
            begin
                temp = { temp[34:0], 5'b01110};
            end
            else if (count == 3)
            begin
                temp = { temp[34:0], 5'b10000};
            end
            else if (count == 4)
            begin
                temp = { temp[34:0], 5'b10101};
            end
            else if (count == 5)
            begin
                temp = { temp[34:0], 5'b10100};
            end
            else if (count == 6)
            begin
                temp = { temp[34:0], 5'b00000};
            end
            else if (count == 7)
            begin
                temp = { temp[34:0], 5'b00001};
            end
            else if (count == 8)
            begin
                temp = { temp[34:0], 5'b01101};
            end
            else if (count == 9)
            begin
                temp = { temp[34:0], 5'b01111};
            end
            else if (count == 10)
            begin
                temp = { temp[34:0], 5'b10101};
            end
            else if (count == 11)
            begin
                temp = { temp[34:0], 5'b01110};
            end
            else if (count == 12)
            begin
                temp = { temp[34:0], 5'b10100};
            end
            else
            begin
                if( count<= 19)
                    temp <= { temp[34:0],5'b00000};
                else
                    count <= 0;
            end
        end
    end
    
    assign instruction = temp;
endmodule
