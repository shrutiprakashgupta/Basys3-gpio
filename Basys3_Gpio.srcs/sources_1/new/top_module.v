`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2021 01:09:43 AM
// Design Name: 
// Module Name: top_module
// Project Name: UART_on_FPGA
// Target Devices: Basys 3
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


module uart_top(clk, rx, tx, data_show);

    input clk;
    input rx;
    output tx;
    output [7:0]data_show;
    parameter data_count = 8;
    
    reg [7:0]data[7:0];

    reg [7:0]data_out;
    wire ack_rx;
    
    wire [7:0]data_in;
    reg ack_tx;
    wire sent;
    
    reg [2:0]state;
    parameter Init = 3'b000;
    parameter Ready = 3'b001; 
    parameter Read = 3'b010;
    parameter Process = 3'b011;
    parameter Write = 3'b100;
    
    reg [2:0]counter;
    integer i;
    
    assign data_show = data[counter];

    always @(posedge clk) begin
        case(state) 
            Init: begin
                if(!rx) begin
                    state <= Ready;
                    for (i=0; i<data_count; i=i+1) begin
                        data[i] <= 0;
                    end
                end
                else begin
                    state <= Init;
                end
                ack_tx <= 0;
                counter <= 0;
            end
            Ready: begin
                if(ack_rx) begin
                    state <= Read;
                end
                else begin
                    state <= Ready;
                end
                ack_tx <= 0;
                counter <= 0;
            end
            Read: begin
                if(ack_rx) begin
                    if(counter == (data_count-1)) begin
                        state <= Process;
                        ack_tx <= 0;
                        counter <= 0;   
                        data[counter] <= data_in;                   
                    end
                    else begin
                        state <= Read;
                        ack_tx <= 0;
                        counter <= counter + 1;
                        data[counter] <= data_in;
                    end
                end
                else begin
                    state <= Read;
                    ack_tx <= 0;
                end
            end
            Process: begin
                if(ack_rx) begin
                    if(counter < 3) begin   
                        state <= Process;
                        counter <= counter + 1;
                        ack_tx <= 0;
                    end
                    else begin
                        state <= Write;
                        counter <= 1;
                        data_out <= data[0];
                        ack_tx <= 1;
                    end
                end
                else begin
                    state <= Process;
                    ack_tx <= 0;
                end
            end
            Write: begin
                if(!sent) begin
                    state <= Write;
                    ack_tx <= 0;
                end
                else begin
                    if(counter == 0) begin
                        state <= Read;
                        ack_tx <= 0;
                        data_out <= 0;
                        counter <= 0;
                    end
                    else begin
                        counter <= counter + 1;
                        data_out <= data[counter];
                        state <= Write;
                        ack_tx <= 1;
                    end
                end
            end
            default: begin
                state <= Init;
                counter <= 0;
            end
        endcase
    end
    
    receiver rx_uut (.clk(clk), .rx(rx), .data_out(data_in), .ack(ack_rx));
    transmitter tx_uut (.clk(clk), .tx(tx), .data_in(data_out), .ack(ack_tx), .sent(sent));
endmodule