library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Rx is
  port (
    clk : in std_logic;
    rx_pin : in std_logic;
    data : out std_logic_vector(7 downto 0);
    busy : out std_logic);
end Rx;

architecture Behavioral of Rx is

  constant wtime : std_logic_vector(15 downto 0) := x"1ADB";

  signal buf : std_logic_vector(8 downto 0) := (others => '0');
  signal count : std_logic_vector(15 downto 0) := "0" & wtime(15 downto 1);
  signal state : integer range -1 to 9 := -1;

begin

  busy <= '1' when state /= -1 else '0';

  process(clk)
  begin
    if rising_edge(clk) then
      case state is
        when -1 =>
          if rx_pin = '0' then
            if count = 0 then
              count <= wtime;
              state <= 9;
            else
              count <= count - 1;
            end if;
          end if;
        when 0 =>
          if count = "0" & wtime(15 downto 1) then
            count <= "0" & wtime(15 downto 1);
            state <= -1;
            data <= buf(7 downto 0);    -- flush
          else
            count <= count - 1;
          end if;
        when others =>
          if count = 0 then
            buf <= rx_pin & buf(8 downto 1);
            count <= wtime;
            state <= state - 1;
          else
            count <= count - 1;
          end if;
      end case;
    end if;
  end process;

end Behavioral;