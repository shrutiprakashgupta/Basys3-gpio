`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2021 12:55:35 AM
// Design Name: 
// Module Name: receiver
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


module receiver(clk, rx, data_out, ack);

    input clk;
    input rx;
    output reg [7:0]data_out;
    output reg ack;
    
    reg [7:0]data;
    reg [1:0]state;
    reg [9:0]count;
    reg [3:0]bitcount;
    
    parameter CLK_RATE_PER_BIT = 868; //CLK_RATE / BAUD_RATE
    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter DATA = 2'b10;
    parameter STOP = 2'b11;
    
    always @(posedge clk) begin
        case(state)
            IDLE: begin
                if(!rx) begin
                    state <= START;
                end
                else begin
                    state <= IDLE;
                end
                count <= 0;
                bitcount <= 0;
                data <= 0;
                ack <= 0;
            end
            START: begin
                if(!rx) begin
                    if(count < (CLK_RATE_PER_BIT-1)/2) begin
                        count <= count + 1;
                        state <= START;
                    end
                    else begin
                        count <= 0;
                        state <= DATA;
                    end
                end
                else begin
                    count <= 0;
                    state <= IDLE;
                end
                bitcount <= 0;
                data <= 0;
                ack <= 0;
            end
            DATA: begin
                if(count < CLK_RATE_PER_BIT) begin
                    count <= count + 1;
                    state <= DATA;
                    ack <= 0;
                end
                else begin
                    if(bitcount == 4'b1000) begin
                        bitcount <= 0;
                        count <= 0;
                        state <= STOP;
                        ack <= 0;
                    end
                    else begin
                        data[bitcount] <= rx; 
                        bitcount <= bitcount + 1;                       
                        count <= 0;
                        state <= DATA;
                        ack <= 0;
                    end                
                end
            end
            STOP: begin
                if(count < CLK_RATE_PER_BIT) begin
                    count <= count + 1;
                    state <= STOP;
                    ack <= 0;
                end
                else begin
                    data_out <= data;
                    count <= 0;
                    state <= IDLE;
                    ack <= 1;
                end
                bitcount <= 0;
            end
            default: begin
                state <= IDLE;
                count <= 0;
                bitcount <= 0;
                data <= 0;
                data_out <= 0;
                ack <= 0;
            end
        endcase
    end

endmodule