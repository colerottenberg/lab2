library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Building a Testbench for my datapath fibonnaci calculator

entity tb_fibonacci is
end tb_fibonacci;

architecture tb of tb_fibonacci is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal n : std_logic_vector(5 downto 0) := "000000";
    signal result : std_logic_vector(23 downto 0);