module camera_interface #(
    parameter FRAME_WIDTH = 640,
    parameter FRAME_HEIGHT = 480
)(
    input wire pclk,
    input wire vsync,
    input wire href,
    input wire [7:0] cam_data,
    output reg [18:0] addr,
    output reg [7:0] pixel_data,
    output reg we
);

    reg [18:0] pixel_count;

    always @(posedge pclk) begin
        if (vsync) begin
            pixel_count <= 0;
            addr <= 0;
            we <= 0;
        end else if (href) begin
            we <= 1;
            pixel_data <= cam_data;
            addr <= pixel_count;
            pixel_count <= pixel_count + 1;
        end else begin
            we <= 0;
        end
    end
endmodule
