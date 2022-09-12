library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity stage is
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
end stage;

architecture stage_proc of stage is
    component nregister is
        generic ( nbits: integer:=8);
        port (
          clock: in std_logic;
          rst: in std_logic;
          data_in: in std_logic_vector(1 to nbits);
          data_out: out std_logic_vector(1 to nbits);
          ld: in std_logic
        ) ;
    end component nregister;

    signal data_proc_out: std_logic_vector(1 to dout_size) := (others => '0');

    signal vld_proc_out: std_logic_vector(0 to 0) := (others => '0');
    signal vld_out: std_logic_vector(0 to 0) := (others => '0');

    function process_data(data_in: in std_logic_vector(1 to din_size))
        return std_logic_vector is
        variable data_out: std_logic_vector(1 to dout_size) := (others => '0');
    begin
        data_out := std_logic_vector(unsigned(data_in) + "01");
        return data_out;
    end function process_data;
    
begin
    data_reg: nregister
    generic map( nbits => dout_size)
    port map(
        clock => clk_i,
        rst => rst_i,
        data_in => data_proc_out,
        data_out => data_o,
        ld => not stall_i
    );

    vld_reg: nregister
    generic map( nbits => 1)
    port map(
        clock => clk_i,
        rst => rst_i,
        data_in => vld_proc_out,
        data_out => vld_out,
        ld => not stall_i
    );

    -- Process to handle valid signals
    -- Simplest case: valid output is valid 
    -- on the next clock when input is invalid
    vld: process(vld_i,vld_out)
    begin
        vld_proc_out(0) <= vld_i;
        vld_o <= vld_out(0);
    end process vld;

    -- Process for combinatorial data processing inside the stage
    -- Simplest case: just forward data
    data: process(data_i)
    begin
        data_proc_out <= process_data(data_i);
    end process data;

end stage_proc ; -- register_prcoess