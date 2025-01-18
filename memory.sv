module memory(
    input enable,
    input clk,
    input rw,
    input ARESETN,
    input [31:0] address,
    input [31:0] data_in,
    output logic [31:0] data_out
);

    logic [31:0]mem[0:31];
    integer i;

    always_ff @ (posedge clk or negedge ARESETN) begin
        if(~ARSETN) begin
            // Reset memory to zeros
          for(i = 0; i < 32; i++) begin
                mem[i] <= 32'b0; 
            end
        end else if (enable && !rw) begin
            data_out <= mem[address];
            $display("addr : %0d, data : %0d", &address, &data_out);
        end else if (enable && rw) begin
            mem[address] <= data_in;
            $display(" *w* addr : %0d, data : %0d", &address, &data_in);
        end
    end

endmodule