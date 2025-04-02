///////////////////////////////////////////
// video_controller_apb.sv
//
// Written: Nathan Fant nathan.fant@okstate.edu
// Created: February 22th, 2025
//
// Purpose: Video Controller for interfacing with external displays utilizing the DVI protocol.
// 
// A component of the Wally configurable RISC-V project.
// 
// Copyright (C) 2021-25 Harvey Mudd College & Oklahoma State University
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”); you may not use this file 
// except in compliance with the License, or, at your option, the Apache License version 2.0. You 
// may obtain a copy of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work distributed under the 
// License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
// either express or implied. See the License for the specific language governing permissions 
// and limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////

module video_controller_apb import cvw::*; #(parameter cvw_t P) (
  input  logic                PCLK,
  input  logic                clk_640, clk_1280,
  input  logic                PRESETn,
  input  logic                PSEL,
  input  logic [7:0]          PADDR,
  input  logic [P.XLEN-1:0]   PWDATA,
  input  logic [P.XLEN/8-1:0] PSTRB,
  input  logic                PWRITE,
  input  logic                PENABLE,
  output logic                PREADY,
  output logic [P.XLEN-1:0]   PRDATA, 
  output logic                ch0,
  output logic                ch1,
  output logic                ch2,
  output logic                chc
);

  //Register map
  localparam RES_SWITCH = 8'h00;

  //Registers
  logic [1:0] res_switch;
  logic [23:0] frame;
  logic [7:0] ENTRY;
  logic      memwrite;
   

  assign memwrite = PWRITE & PENABLE & PSEL;  // only write in access phase
  assign PREADY   = 1'b1; //CLINT shouldn't take more than one cycle?
  assign PRDATA   = 0; //Video controller is an output only device, so read data is tied to zero.
  assign ENTRY = {PADDR[7:2], 2'b00}; //What register is being accessed

  always_ff @(posedge PCLK) begin
    if(~PRESETn) begin
      res_switch <= 2'b0; //Defaults to 640x480
      frame <= 24'b0;
    end else begin
      if(memwrite) begin
        case(ENTRY)
          RES_SWITCH: res_switch <= PWDATA[1:0];
          default: frame <= PWDATA[23:0];
        endcase
      end
    end
  end

  //Controller call
  video_controller controller (PCLK, clk_640, clk_1280, PRESETn, res_switch, frame, ch0, ch1, ch2, chc);
  
endmodule
