`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 21:44:41
// Design Name: 
// Module Name: seven_seg_decoder
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


module seven_seg_decoder(
    input clk,
    input [31:0] balance,
    output reg [7:0] AN,
    output reg [6:0] led
    );
    reg [19:0]refresh_counter = 0;
    reg [3:0] selected_anode;
    wire [2:0] LED_counter;

    
    always @(posedge clk)
    refresh_counter <= refresh_counter +1;
    assign LED_counter = refresh_counter[19:17];
    always @(LED_counter)
    begin
        case(LED_counter)
            3'b000:
                AN = 8'b11111110;
            3'b001:
                AN = 8'b11111101;
            3'b010:
                AN = 8'b11111011;
            3'b011:
                AN = 8'b11110111;
            3'b100:
                AN = 8'b11101111;
            3'b101:
                AN = 8'b11011111;
            3'b110:
                AN = 8'b10111111;
            3'b111:
                AN = 8'b01111111;     
        endcase
    end
    


    always @(*)
    begin
            case(LED_counter)
                3'b000: 
                    selected_anode = balance%10;
                3'b001:
                    selected_anode = (balance/10)%10;
                3'b010:
                    selected_anode = (balance/100)%10;
                3'b011:
                    selected_anode = (balance/1000)%10;
                3'b100:
                    selected_anode = (balance/10000)%10;
                3'b101:
                    selected_anode = (balance/100000)%10;
                3'b110:
                    selected_anode = (balance/1000000)%10;
                3'b111:
                    selected_anode = (balance/10000000)%10;                        
            endcase
    end

    
    always@(*)
    begin
        case(selected_anode)
        4'b0000: led = 7'b0000001;
        4'b0001: led = 7'b1001111;
        4'b0010: led = 7'b0010010;
        4'b0011: led = 7'b0000110;
        4'b0100: led = 7'b1001100;
        4'b0101: led = 7'b0100100;
        4'b0110: led = 7'b0100000;
        4'b0111: led = 7'b0001111;
        4'b1000: led = 7'b0000000;
        4'b1001: led = 7'b0000100;
        default: led = 7'b0000001;
    endcase

    end
    
    
endmodule

