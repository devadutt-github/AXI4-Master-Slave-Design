`timescale 1ns / 1ps


module axi4_lite_slave #(
parameter ADDRESS = 32,
parameter DATA_WIDTH = 32
)
(
//Global Signals
input                           ACLK,
input                           ARESETN,
input                           LAST,
////Read Address Channel INPUTS
input           [ADDRESS-1:0]   S_ARADDR,
input                           S_ARVALID,
//Read Data Channel INPUTS
input                           S_RREADY,
//Write Address Channel INPUTS
input           [ADDRESS-1:0]   S_AWADDR,
input                           S_AWVALID,
//Write Data  Channel INPUTS
input          [DATA_WIDTH-1:0] S_WDATA,
input          [3:0]            S_WSTRB,
input                           S_WVALID,
//Write Response Channel INPUTS
input                           S_BREADY,	

//Read Address Channel OUTPUTS
output logic                    S_ARREADY,
//Read Data Channel OUTPUTS
output logic    [DATA_WIDTH-1:0]S_RDATA,
output logic         [1:0]      S_RRESP,
output logic                    S_RVALID,
//Write Address Channel OUTPUTS
output logic                    S_AWREADY,
output logic                    S_WREADY,
//Write Response Channel OUTPUTS
output logic         [1:0]      S_BRESP,
output logic                    S_BVALID,

//Memory Control Signals
output logic  mem_enable,
output logic  mem_rw,
output logic [31:0] mem_ADDRESS,
input        [31:0] mem_DATA_out,
output logic [31:0] mem_DATA_in,
 );


logic [31:0]    addr;
  
logic  write_addr,write_data;
typedef enum logic [2 : 0] {IDLE,WRITE_CHANNEL,WRESP__CHANNEL, RADDR_CHANNEL, RDATA__CHANNEL} state_type;
state_type state, next_state;

always_comb begin
  
  if (state == WRITE_CHANNEL || state == RDATA__CHANNEL)
        mem_enable = 1;
  else
        mem_enable = 0;
  
  if(state == WRITE_CHANNEL)begin
    //faddr = S_AWADDR;
    mem_ADDRESS = addr;
    mem_rw = 1;
    mem_DATA_in = S_WDATA;
  end else if( state == RDATA__CHANNEL)begin
   // faddr = S_ARADDR;
    mem_ADDRESS = addr;
    mem_rw = 0;
  end else if (state == IDLE)begin 
    mem_ADDRESS = 0;
  end
  
end


 // AR
assign S_ARREADY = (state == RADDR_CHANNEL) ? 1 : 0;
//// R
assign S_RVALID = (state == RDATA__CHANNEL) ? 1 : 0;
assign S_RDATA  = ((state == RDATA__CHANNEL || state == RADDR_CHANNEL) && rdata_ready ) ? mem_DATA_out : 0;
assign S_RRESP  = (state == RDATA__CHANNEL) ?2'b00:0;
//// AW
assign S_AWREADY = (state == WRITE_CHANNEL) ? 1 : 0;
// W
assign S_WREADY = (state == WRITE_CHANNEL) ? 1 : 0;
assign write_addr = S_AWVALID && S_AWREADY;
assign write_data = S_WREADY &&S_WVALID;
// B
assign S_BVALID = (state == WRESP__CHANNEL) ? 1 : 0;
assign S_BRESP  = (state == WRESP__CHANNEL )? 0:0;

integer i;
reg addr_inc, rdata_ready;

always_ff @(posedge ACLK) begin
    if (~ARESETN) begin 
        addr <= 0;
        addr_inc <= 0;
        rdata_ready <= 0;
    end
    else if (state == IDLE) begin
       addr_inc <= 0;
       rdata_ready <= 0;
    end
    else if (state == RADDR_CHANNEL) begin
                if (~addr_inc) begin
                addr <= S_ARADDR;
                end else begin
                addr <= addr + 1;
                end
    end
    else if (state == RDATA__CHANNEL) begin
             rdata_ready <= 1;  
             addr_inc <= 1;
    end
    else begin
                if (state == WRITE_CHANNEL) begin
                     if (~addr_inc) begin
                       addr <= S_AWADDR;
                       addr_inc <= 1;
                     end else begin
                       addr <= addr + 1;
                 end
            end
        end
end

always_ff @(posedge ACLK) begin
	if (~ARESETN) begin
		state <= IDLE;
	end else begin
		state <= next_state;
	end
end

always_comb begin
		   case (state)
       IDLE : begin
           if (S_AWVALID) begin
               next_state = WRITE_CHANNEL;
           end else if (S_ARVALID) begin
               next_state = RADDR_CHANNEL;
           end else begin
               next_state = IDLE;
       end
   end
	   RADDR_CHANNEL   : if (S_ARVALID && S_ARREADY) next_state = RDATA__CHANNEL;

	   RDATA__CHANNEL   :begin if (S_RVALID  && S_RREADY && LAST)
                                 next_state = IDLE;
                                 else if (S_ARVALID) begin
                                     next_state = RADDR_CHANNEL;
                                  end
                        end

       WRITE_CHANNEL  : begin if (write_addr &&write_data && LAST)
                                 next_state = WRESP__CHANNEL;
                               else
                                 next_state = WRITE_CHANNEL;  
                        end
       WRESP__CHANNEL  :begin 
                          if (S_BVALID  && S_BREADY ) next_state = IDLE;
                        end
	   default : next_state = IDLE;
    endcase
end

endmodule