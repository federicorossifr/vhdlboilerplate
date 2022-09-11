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
            w:   in std_logic;
            idx_1: in std_logic_vector(selbits downto 1);
            idx_2: in std_logic_vector(selbits downto 1);
            din: in std_logic_vector(rbits downto 1);
            dout_1: out std_logic_vector(rbits downto 1);
            dout_2: out std_logic_vector(rbits downto 1)
        ) ;
    end component register_file;

    signal clk  : std_logic := '1';
    signal rst  : std_logic := '1';
    signal data: std_logic_vector(1 to 8);
    signal rs1: std_logic_vector(1 to 2) := "XX";
    signal rs2: std_logic_vector(1 to 2) := "XX";
    signal w  : std_logic := '0';
    signal r1: std_logic_vector(1 to 8);
    signal r2: std_logic_vector(1 to 8);

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
        idx_1 => rs1,
        idx_2 => rs2,
        dout_1 => r1,
        dout_2 => r2,
        w => w
    );

    clk <= not clk after 5 ns;

    stim_proc: process
    begin  
        wait until rising_edge(clk);
        w <= '1';   
        rst <= '0';
        rs1 <= "00";
        rs2 <= "00";
        data <= "01001000";
        wait until rising_edge(clk);
        w <= '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

    end process;
end;