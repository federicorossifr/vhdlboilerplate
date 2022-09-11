library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;



package types is
    type regfile_out is array (natural range<>) of std_logic_vector;
end package ;