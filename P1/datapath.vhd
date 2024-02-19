library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Datapath for fibonacci sequence

entity datapath is
    generic(
      width : integer := 8
    );
    port(
      -- clk and rst
      clk: in std_logic;
      rst : in std_logic;
      
      -- i/o 
      n : in std_logic_vector(5 downto 0);
      result : out std_logic_vector(23 downto 0);
      -- control inputs
      x_sel : in std_logic;
      y_sel : in std_logic;
      i_sel : in std_logic;
      result_sel : in std_logic;


      n_en : in std_logic;
      result_en : in std_logic;
      x_en : in std_logic;
      y_en : in std_logic;
      i_en : in std_logic;
      n_eq_0 : out std_logic;

      -- status signals
      i_le_n : out std_logic
    );
end datapath;

-- The datapath is composed of registers, fibonacci logic and other components

-- The datapath starts with a register for the input n
-- if n_en is high, the input n is loaded into the register
-- afterwards, the register is connected to the fibonacci logic

architecture rtl of datapath is
    signal i_reg, x_reg, y_reg, n_reg : std_logic_vector(width-1 downto 0);
    signal i_mux, x_mux, y_mux, result_mux : std_logic_vector(width-1 downto 0);
    signal add1, add2 : std_logic_vector(width-1 downto 0);
  -- Build input register and logic 
    begin
  
  -- Connecting components to impl fibonacci logic using registers,mux, adders and comparators
        I_MUX : entity work.mux
            generic map(
            width => width
            )
            port map(
                input1 => add1,
                input2 => std_logic_vector(to_unsigned(2, width)),
                sel => i_sel,
                output => i_mux
            );
    
        X_MUX : entity work.mux
            generic map(
            width => width
            )
            port map(
                input1 => y_reg,
                input2 => std_logic_vector(to_unsigned(0, width)),
                sel => x_sel,
                output => x_mux
            );

        Y_MUX : entity work.mux
            generic map(
            width => width
            )
            port map(
                input1 => add2,
                input2 => std_logic_vector(to_unsigned(1, width)),
                sel => y_sel,
                output => y_mux
            );

        RESULT_MUX : entity work.mux
            generic map(
            width => width
            )
            port map(
                input1 => y_reg,
                input2 => std_logic_vector(to_unsigned(0, width)),
                sel => result_sel,
                output => output
            );

        -- REGISTERS

        I_REG : entity work.reg
            generic map(
            width => width
            )
            port map(
                clk => clk,
                reset => rst,
                d => i_mux,
                q => i_reg,
                en => i_en
            );

        X_REG : entity work.reg
            generic map(
            width => width
            )
            port map(
                clk => clk,
                reset => rst,
                d => x_mux,
                q => x_reg,
                en => x_en
            );

        Y_REG : entity work.reg
            generic map(
            width => width
            )
            port map(
                clk => clk,
                reset => rst,
                d => y_mux,
                q => y_reg,
                en => y_en
            );

        N_REG : entity work.reg
            generic map(
            width => 6
            )
            port map(
                clk => clk,
                reset => rst,
                d => n,
                q => n_reg,
                en => n_en
            );

        -- ADDERS

        ADD1 : entity work.adder
            generic map(
            width => width
            )
            port map(
                input1 => std_logic_vector(to_unsigned(1, width)),
                input2 => i_reg,
                output => add1
            );

        ADD2 : entity work.adder
            generic map(
            width => width
            )
            port map(
                input1 => x_reg,
                input2 => y_reg,
                output => add2
            );

        -- COMPARATOR
        N_COMP : entity work.comparator
            generic map(
            width => 6
            )
            port map(
                input1 => n_reg,
                input2 => std_logic_vector(to_unsigned(0, 6)),
                eq => n_eq_0
            );
        
        LE_COMP : entity work.comparator
            generic map(
            width => 6
            )
            port map(
                input1 => i_reg,
                input2 => n_reg,
                le => i_le_n
            );
end rtl;