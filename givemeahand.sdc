create_clock -period 20000 [get_ports clk]
create_clock -period 62.5 -name clk_16
derive_pll_clocks
derive_clock_uncertainty
set_input_delay 0 -clock clk_16 [all_inputs]
set_output_delay 0 -clock clk_16 [all_outputs]
