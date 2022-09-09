library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;


entity nregister_tb is
end nregister_tb;

architecture behavior of nregister_tb is
    component nregister is
        generic ( nbits: integer:=8);
        port (
          clock: in std_logic;
          rst: in std_logic;
          data_in: in std_ulogic_vector(1 to nbits);
          data_out: out std_ulogic_vector(1 to nbits);
          ld: in std_logic
        ) ;
    end component nregister;
    signal clk  : std_logic := '1';
    signal rst  : std_logic := '1';
    signal data: std_ulogic_vector(1 to 4);
    signal en: std_logic;
    signal data_probe: std_ulogic_vector(1 to 4);
    signal data_probe2: std_ulogic_vector(1 to 4);

begin
    ntt: nregister 
    generic  map ( nbits => 4)
    port map (
        clock => clk,
        rst => rst,
        data_in => data,
        ld => en,
        data_out => data_probe
    );

    ntt2: nregister
    generic map (nbits => 4)
    port map (
        clock => clk,
        rst => rst,
        data_in => data_probe,
        data_out => data_probe2,
        ld => en
    );

    clk <= not clk after 5 ns;

    stim_proc: process
    begin  
        wait until rising_edge(clk);        
        rst <= '0';
        en <= '1';
        data <= "0100";
        wait until rising_edge(clk);        
        data <= "0101";
        wait until rising_edge(clk);        
        data <= "0111";
    end process;
end;