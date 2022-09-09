library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity register_file_tb is
end register_file_tb;

architecture behavior of register_file_tb is
    component register_file is
        generic ( 
            rbits: integer:= 8; 
            nregs: integer := 32; 
            selbits: integer := integer(ceil(log2(real(nregs))))
        ) ;
        port (
            clk: in std_logic;
            rst: in std_logic;
            idx: in std_logic_vector(1 to selbits);
            din: in std_logic_vector(1 to rbits);
            dout: out std_logic_vector(1 to rbits)
        ) ;
    end component register_file;

    signal clk  : std_logic := '1';
    signal rst  : std_logic := '1';
    signal data: std_logic_vector(1 to 8);
    signal idx: std_logic_vector(1 to 2) := "XX";
    signal data_out: std_logic_vector(1 to 8);

begin
    
    rfile: register_file
    generic map (
        rbits => 8,
        nregs => 4
    )
    port map (
        clk => clk,
        rst => rst,
        din => data,
        idx => idx,
        dout => data_out
    );

    clk <= not clk after 5 ns;

    stim_proc: process
    begin  
        wait until rising_edge(clk);        
        rst <= '0';
        idx <= "00";
        data <= "01001000";
        wait until rising_edge(clk);  
        idx <= "01";
        wait until rising_edge(clk);        
        idx <= "10";
        wait until rising_edge(clk);        
        idx <= "11";
    end process;
end;