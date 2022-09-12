library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;


entity stage_tb is
end stage_tb;

architecture behavior of stage_tb is
    component stage is
        generic ( din_size: integer:=8; dout_size: integer:=8);
        port (
          clk_i: in std_logic;
          rst_i: in std_logic;
          vld_i: in std_logic;
          stall_i: in std_logic;
          data_i: in std_logic_vector(1 to din_size);
      
          data_o: out std_logic_vector(1 to dout_size);
          vld_o: out std_logic
        ) ;
      end component stage;

      signal clk  : std_logic := '1';
      signal rst  : std_logic := '1';
      signal vld  : std_logic := '0';
      signal stalled : std_logic := '0';
      signal vldout  : std_logic;
      signal s2_vldout  : std_logic;

      signal input_data: std_logic_vector(1 to 16) := (others => '0');
      signal output_data: std_logic_vector(1 to 16); 
      signal s2_output: std_logic_vector(1 to 16);
begin
    s1: stage 
    generic  map ( din_size => 16, dout_size => 16)
    port map (
        clk_i => clk,
        rst_i => rst,
        vld_i => vld,
        data_i => input_data,
        data_o => output_data,
        vld_o => vldout,
        stall_i => stalled
    );

    s2: stage 
    generic  map ( din_size => 16, dout_size => 16)
    port map (
        clk_i => clk,
        rst_i => rst,
        vld_i => vldout,
        data_i => output_data,
        data_o => s2_output,
        vld_o => s2_vldout,
        stall_i => stalled
    );


    clk <= not clk after 5 ns;

    stim_proc: process
    begin  
        stalled <= '0';
        wait until rising_edge(clk);
        rst <= '0';
        input_data <= "0100010001000100";
        vld <= '1';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
    end process;
end;