library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.Util.all;

entity CPU_tb is
end CPU_tb;

architecture Behavioral of CPU_tb is

  component CPU is
    port (
      clk : in std_logic;
      ram : in ram_t;
      tx_go : out std_logic;
      tx_busy : in std_logic;
      tx_data : out std_logic_vector(7 downto 0));
  end component;

  signal myram : ram_t := (
    x"00000000",
    x"01000001",
    x"02100000",
    x"03210000",
    x"0430000A",
    x"11420000",
    x"22300003",
    x"31300000",
    --x"00000000",
    --x"00000000",
    --x"00000000",
    --x"00000000",
    x"B0C00000",
    x"C0000008", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000"
    );

  signal clk_gen : std_logic := '0';

  signal tx_go, tx_busy : std_logic;
  signal tx_data : std_logic_vector(7 downto 0);

begin

  myCPU : CPU port map (
    clk => clk_gen,
    ram => myram,
    tx_go => tx_go,
    tx_busy => tx_busy,
    tx_data => tx_data);

  -- clock generator
  process
  begin
    clk_gen <= '0';
    wait for 5 ns;
    clk_gen <= '1';
    wait for 5 ns;
  end process;

end Behavioral;
