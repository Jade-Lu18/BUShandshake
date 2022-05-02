
module master(clk,reset,response,ready,data,valid,dout);

input clk,reset;
input response;
input ready;
input [31:0] data;
output valid;
output [31:0] dout;

parameter idle_m = 2'b00, valid_m = 2'b01, resp_m = 2'b11;
reg state_m,nxt_state_m;
reg va;

always@(*)begin
	case(state_m)
	idle_m: va = 1'b1;
	        nxt_state_m = valid_m;
		
	valid_m:if (ready == 1'b1)
			nxt_state = resp_m;
		else
			nxt_state_m = valid_m;
			
	resp_m: va = 1'b0;		
		if (response)
			nxt_state_m = idle_m;
		else
		   nxt_state_m = resp_m;
	default: nxt_state_m = idle_m;
	endcase
end


always@(posedge clk)begin
	if(~reset)begin
		state_m <= idle_m;
		va <= 1'b0;
		end
	else state_m <= nxt_state_m;
end


assign dout = va? data:'h0;
assign valid = va;

endmodule


module slave(clk,reset,data,valid,response,ready);

input clk,reset;
input [31:0] data;
input valid;
output response;
output ready;


parameter idle_s = 2'b00, ready_s = 2'b01, resp_s = 2'b11;
reg state_s,nxt_state_s;
reg re,res;
reg [31:0] s_data;

always@(*)begin
	case(state_s)
	idle_s: res = 1'b0;
		if (ready)
			nxt_state_s = ready_s;
		else nxt_state_s = idle_s;
	
	ready_s: if(valid)
			nxt_state_s = resp_s;
			s_data = data;
		else
			nxt_state_s = ready_s;
			
	resp_s: re = 1'b0;
		res = 1'b1;
		nxt_state_s = idle_s;
	default: nxt_state_s = idle_s;
	endcase

end

always@(posedge clk)begin
	if(~reset)begin
		re <= 1'b0;
		re <= 1'b0;
		state_s <= idle_s;
		end
	else state_s <= nxt_state_s;

end

assign ready = re;
assign response = res;

endmodule



