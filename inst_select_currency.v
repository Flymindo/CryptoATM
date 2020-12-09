`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 23:52:20
// Design Name: 
// Module Name: inst_select_currency
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


module inst_select_currency(
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
                temp = { temp[34:0], 5'b10101};
            end
            else if (count == 2)
            begin
                temp = { temp[34:0], 5'b10011};
            end
            else if (count == 3)
            begin
                temp = { temp[34:0], 5'b00100};
            end
            else if (count == 4)
            begin
                temp = { temp[34:0], 5'b00000};
            end
            else if (count == 5)
            begin
                temp = { temp[34:0], 5'b01111};
            end
            else if (count == 6)
            begin
                temp = { temp[34:0], 5'b10010};
            end
            else if (count == 7)
            begin
                temp = { temp[34:0], 5'b00000};
            end
            else if (count == 8)
            begin
                temp = { temp[34:0], 5'b00010};
            end
            else if (count == 9)
            begin
                temp = { temp[34:0], 5'b10100};
            end
            else if (count == 10)
            begin
                temp = { temp[34:0], 5'b00011};
            end
            else if (count == 11)
            begin
                temp = { temp[34:0], 5'b00000};
            end
            else if (count == 12)
            begin
                temp = { temp[34:0], 5'b01111};
            end
            else if (count == 13)
            begin
                temp = { temp[34:0], 5'b10010};
            end
            else if (count == 14)
            begin
                temp = { temp[34:0], 5'b00000};
            end
            else if (count == 15)
            begin
                temp = { temp[34:0], 5'b00101};
            end
            else if (count == 16)
            begin
                temp = { temp[34:0], 5'b10100};
            end
            else if (count == 17)
            begin
                temp = { temp[34:0], 5'b01000};
            end
            else if (count == 18)
            begin
                temp = { temp[34:0], 5'b00000};
            end
            else if (count == 19)
            begin
                temp = { temp[34:0], 5'b01111};
            end
            else if (count == 20)
            begin
                temp = { temp[34:0], 5'b10010};
            end
            else if (count == 21)
            begin
                temp = { temp[34:0], 5'b00000};
            end
            else if (count == 22)
            begin
                temp = { temp[34:0], 5'b11000};
            end
            else if (count == 23)
            begin
                temp = { temp[34:0], 5'b10010};
            end
            else if (count == 24)
            begin
                temp = { temp[34:0], 5'b10000};
            end
            else if (count == 25)
            begin
                temp = { temp[34:0], 5'b00000};
            end
            else if (count == 26)
            begin
                temp = { temp[34:0], 5'b01111};
            end
            else if (count == 27)
            begin
                temp = { temp[34:0], 5'b10010};
            end
            else if (count == 28)
            begin
                temp = { temp[34:0], 5'b00000};
            end
            else if (count == 29)
            begin
                temp = { temp[34:0], 5'b01100};
            end
            else if (count == 30)
            begin
                temp = { temp[34:0], 5'b10100};
            end
            else if (count == 31)
            begin
                temp = { temp[34:0], 5'b00011};
            end
            else
            begin
                if( count<= 39)
                    temp <= { temp[34:0],5'b00000};
                else
                    count <= 0;
            end
        end
    end
    
    assign instruction = temp;
endmodule
