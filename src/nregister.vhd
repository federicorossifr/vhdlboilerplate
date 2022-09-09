library ieee;
use ieee.std_logic_1164.all;

entity nregister is
  generic ( nbits: integer:=8);
  port (
    clock: in std_logic;
    rst: in std_logic;
    data_in: in std_ulogic_vector(1 to nbits);
    data_out: out std_ulogic_vector(1 to nbits);
    ld: in std_logic
  ) ;
end nregister;

architecture register_prcoess of nregister is
begin
    proc : process( rst,clock )
    begin
			if (clock='1' and clock'event) then
				if(rst = '1') then
            data_out <= (others => '0');
          else if(ld='1') then
					  data_out <= data_in;
          end if;
				end if;
			end if;
    end process ; -- proc
end register_prcoess ; -- register_prcoess