library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity ALU is
  port (
    code : in std_logic_vector(1 downto 0);
    arg0 : in std_logic_vector(31 downto 0);
    arg1 : in std_logic_vector(31 downto 0);
    ival : in std_logic_vector(31 downto 0);
    retv : out std_logic_vector(31 downto 0));
end ALU;

architecture Behavioral of ALU is
begin

  -- combinational
  process(code, arg0, arg1, ival)
    variable total, shift : std_logic_vector(31 downto 0);
  begin
    case code is
      when "00" =>
        retv <= arg0 + arg1 + ival;
      when "01" =>
        retv <= arg0 - arg1;
      when "10" =>
        total := arg1 + ival;
        if total(31) = '0' then
          shift := total;
        else
          shift := (not total) + 1;
        end if;

        if shift >= 32 then
          retv <= (others => '0');
        else
          if total(31) = '0' then
            retv <= std_logic_vector(shift_left(unsigned(arg0), to_integer(unsigned(shift))));
          else
            retv <= std_logic_vector(shift_right(unsigned(arg0), to_integer(unsigned(shift))));
          end if;
        end if;
      when "11" =>
        if arg0 = 0 then
          retv <= arg0;
        else
          retv <= not arg0(31) & arg0(30 downto 0);
        end if;
      when others =>
        retv <= (others => 'Z');
    end case;
  end process;

end Behavioral;
