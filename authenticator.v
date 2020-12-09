`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2020 04:39:25 PM
// Design Name: 
// Module Name: authenticator
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


module authenticator(
    input [15:0] acc_number,
    input [15:0] pin,
    input action,
    input deAuth,
    output reg wasSuccessful,
    output reg [3:0] accIndex
    );
    
    parameter 
        FIND = 1'b0,
        AUTHENTICATE = 1'b1;
    
    reg [15:0] acc_database [0:9];
    reg [15:0] pin_database [0:9];
    
    initial begin
    acc_database[0] = 16'd2749; pin_database[0] = 16'b0000;
    acc_database[1] = 16'd2175; pin_database[1] = 16'b0001;
    acc_database[2] = 16'd2429; pin_database[2] = 16'b0010;
    acc_database[3] = 16'd2125; pin_database[3] = 16'b0011;
    acc_database[4] = 16'd2178; pin_database[4] = 16'b0100;
    acc_database[5] = 16'd2647; pin_database[5] = 16'b0101;
    acc_database[6] = 16'd2816; pin_database[6] = 16'b0110;
    acc_database[7] = 16'd2910; pin_database[7] = 16'b0111;
    acc_database[8] = 16'd2299; pin_database[8] = 16'b1000;
    acc_database[9] = 16'd2689; pin_database[9] = 16'b1001;
    end
    
    always @(deAuth) begin
        if (deAuth == 1'b1)
            wasSuccessful = 1'bx;
    end
    
    integer i;
    always @(acc_number or pin) begin
      wasSuccessful = 1'b0;
      accIndex = 0;

      //loop through the data base
      for(i = 0; i < 10; i = i+1) begin

          //found a match for acc_number
          if(acc_number == acc_database[i]) begin
              
              if(action == FIND) begin
                wasSuccessful = 1'b1;
                accIndex = i;
              end

              if(action == AUTHENTICATE) begin
                if(pin == pin_database[i]) begin
                  wasSuccessful = 1'b1;
                  accIndex = i;

                end
              end
          end    
      end
  end
    
endmodule
