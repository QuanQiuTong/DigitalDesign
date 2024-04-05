// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Fri Dec 22 16:44:36 2023
// Host        : LAPTOP-HKFFG58C running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/Fu_Quantong/project_15/project_15.gen/sources_1/ip/ASCII_ROM/ASCII_ROM_stub.v
// Design      : ASCII_ROM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_14,Vivado 2023.2" *)
module ASCII_ROM(a, spo)
/* synthesis syn_black_box black_box_pad_pin="a[10:0],spo[7:0]" */;
  input [10:0]a;
  output [7:0]spo;
endmodule
