library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Datapath for fibonacci sequence

entity datapath is
    port(
      clk: in std_logic;
      rst : in std_logic;
      n : in std_logic_vector(5 downto 0);
      result : out std_logic_vector(23 downto 0);
      n_en : in std_logic;
      result_en : in std_logic;
      result_sel : in std_logic;
      x_en : in std_logic;
      x_sel : in std_logic;
      y_en : in std_logic;
      y_sel : in std_logic;
      i_en : in std_logic;
      i_sel : in std_logic;
      n_eq_0 : out std_logic;
      i_le_n : out std_logic
    );
end datapath;

-- The datapath is composed of registers, fibonacci logic and other components

-- The datapath starts with a register for the input n
-- if n_en is high, the input n is loaded into the register
-- afterwards, the register is connected to the fibonacci logic

architecture rtl of datapath is
  signal n_reg : std_logic_vector(5 downto 0);
  signal x_reg : std_logic_vector(23 downto 0);
  signal y_reg : std_logic_vector(23 downto 0);
  signal i_reg : std_logic_vector(5 downto 0);
  signal n_eq_0_reg : std_logic;
  signal i_le_n_reg : std_logic;
  
  -- Build input register and logic 
  n_reg : entity work.register
    generic map(
      width => 6
    )
    port map(
      clk => clk,
      rst => rst,
      d => n,
      en => n_en,
      q => n_reg
    );

  fibonacci : entity work.fib
    port map(
      clk => clk,
      rst => rst,
      n => n_reg,
      x => x_reg,
      y => y_reg,
      i => i_reg,
      n_eq_0 => n_eq_0_reg,
      i_le_n => i_le_n_reg
    );