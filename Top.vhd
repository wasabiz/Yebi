library IEEE;
use IEEE.std_logic_1164.all;

library UNISIM;
use UNISIM.VComponents.all;

use work.Util.all;

entity Top is
  port (
    MCLK1 : in std_logic;
    RS_TX : out std_logic;
    RS_RX : in std_logic);
end Top;

architecture Behavioral of Top is

  component CPU is
    port (
      clk : in std_logic;
      ram : in ram_t;
      tx_en : out std_logic;
      tx_data : out std_logic_vector(31 downto 0);
      rx_en : out std_logic;
      rx_data : in std_logic_vector(31 downto 0));
  end component;

  component IO is
    port (
      clk : in std_logic;
      tx_pin : out std_logic;
      rx_pin : in std_logic;
      tx_en : in std_logic;
      tx_data : in std_logic_vector(31 downto 0);
      rx_en : in std_logic;
      rx_data : out std_logic_vector(31 downto 0));
  end component;

  signal iclk, clk : std_logic := '0';

  signal tx_en : std_logic;
  signal tx_data : std_logic_vector(31 downto 0);
  signal rx_en : std_logic;
  signal rx_data : std_logic_vector(31 downto 0);

  signal myramfib : ram_t := (
    x"00000000",                        -- 0 nop
    x"0300000A",                        -- 1 mov $3, 10
    x"01000001",                        -- 2 mov $1, 1
    x"02000001",                        -- 3 mov $2, 1
                                        --  LOOP:
    x"C30F0006",                        -- 4 beq $3, $0, EXIT
    x"0330FFFF",                        -- 5 add $3, $3, -1
    x"04200000",                        -- 6 mov $4, $2
    x"02210000",                        -- 7 add $2, $2, $1
    x"01400000",                        -- 8 mov $1, $4
    x"C00FFFFB",                        -- 9 br LOOP
                                        --  EXIT:
    x"B0100000",                        -- A write $1
    x"C00FFFFF",                        -- B br EXIT
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

  signal myramloopback : ram_t := (
    x"00000000",
    x"0100FFFF",
    x"A2000000",
    x"C12FFFFF",
    x"B0200000",
    x"C00FFFFD",
    x"00000000",
    x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
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

begin

  ib: IBUFG port map (
    i => MCLK1,
    o => iclk);

  bg: BUFG port map (
    i => iclk,
    o => clk);

  myCPU : CPU port map (
    clk => clk,
    ram => myramloopback,
    tx_en => tx_en,
    tx_data => tx_data,
    rx_en => rx_en,
    rx_data => rx_data);

  myIO : IO port map (
    clk => clk,
    tx_pin => RS_TX,
    rx_pin => RS_RX,
    tx_en => tx_en,
    tx_data => tx_data,
    rx_en => rx_en,
    rx_data => rx_data);

end Behavioral;
