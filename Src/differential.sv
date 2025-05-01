module differential (
    input       logic I,     // TMDS signal
    output      logic O,    // positive differential signal pin
    output      logic OB     // negative differential signal pin
    );

OBUFDS #(
   .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
   .SLEW("SLOW")           // Specify the output slew rate
) OBUFDS_inst (
   .O(O),     // Diff_p output (connect directly to top-level port)
   .OB(OB),   // Diff_n output (connect directly to top-level port)
   .I(I)      // Buffer input
);

// End of OBUFDS_inst instantiation

endmodule
