module frame_buffer (
    input wire clk,
    input wire we,
    input wire [18:0] addr,
    input wire [7:0] din,
    output reg [7:0] dout
);
    reg [7:0] mem [0:307199]; // 640*480 = 307200

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;
        dout <= mem[addr];
    end
endmodule
