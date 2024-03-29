library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity reg is
    generic(
	 width : integer := 6
	 );
    port(
        clk: in std_logic;
        reset: in std_logic;
        d: in std_logic_vector(width-1 downto 0);
        q: out std_logic_vector(width-1 downto 0);
        en : in std_logic
    );
end entity;

architecture rtl of reg is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                q <= d;
            end if;
        end if;
    end process;
end rtl;