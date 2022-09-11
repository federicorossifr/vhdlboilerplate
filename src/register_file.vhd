library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.types.all;

entity register_file is
  generic ( rbits: integer:= 8; 
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
end register_file;

architecture reg_arch of register_file is
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

    signal sel_v: std_logic_vector(nregs - 1 downto 0):= (others => '0');
    signal dout_v: regfile_out(nregs - 1 downto 0)(1 to rbits);
begin
    gen_regs: for ii in 0 to nregs-1 generate
        reg: nregister 
        generic  map ( nbits => rbits)
        port map (
            clock => clk,
            rst => rst,
            data_in => din,
            ld => sel_v(ii),
            data_out => dout_v(ii)
        );
    end generate gen_regs;

    sel: process(w,idx_1,idx_2)
    begin
        if (w = '1') then
            sel_v <= (others => '0');
            sel_v(to_integer(unsigned(idx_1))) <= '1';
        else 
            sel_v <= (others => '0');                
        end if;

        dout_1 <= dout_v(to_integer(unsigned(idx_1)));
        dout_2 <= dout_v(to_integer(unsigned(idx_2)));

    end process sel;

end reg_arch ; -- arch