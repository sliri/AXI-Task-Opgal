----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2020 09:52:04 AM
-- Design Name: 
-- Module Name: global_signals_translator - global_signals_translator_arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- This entity genrated the RESET, RESETN and CLK signals for the entire design.
-- The RESET & RESETN signals are "asynchronous rest - synchrnous-out-of-reset" signals.
-- For more infomation see chapter A3.1 in AMBA AXI and ACE Protocol Specification.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.types_pack;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity global_signals_translator is
    Port ( ACLK         : in STD_LOGIC;  -- Global clock In
           ARESETN      : in STD_LOGIC;  -- Global axi RESETN (asynchronous reset, active low, '0'==> enters reset)
           CLK          : out STD_LOGIC; -- Globla clock (same as ACLK)
           RESET        : out STD_LOGIC; -- Synchronus RESET (active high, '1'==> enters reset)
           RESETN       : out STD_LOGIC);-- Synchronus RESETN (active low, '0'==> enters reset)
end global_signals_translator;

architecture global_signals_translator_arch of global_signals_translator is
    ------------------------------------------------------------------------------------------------------
    ---Sginals Declerations
    ------------------------------------------------------------------------------------------------------
    signal resetn_sig           : STD_LOGIC; 
    signal resetn_ff_sig        : STD_LOGIC; 
      

    ------------------------------------------------------------------------------------------------------
    ---Components Declerations
    ------------------------------------------------------------------------------------------------------

begin
    ------------------------------------------------------------------------------------------------------
    ---Components Instantiation
    ------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------
    ---Concurrent statements---
    ------------------------------------------------------------------------------------------------------
    RESETN     <= resetn_sig;
    RESET      <= not(resetn_sig);
    CLK        <= ACLK;

    
    ------------------------------------------------------------------------------------------------------
    ---Sequential statements---
    ------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------
    --reset_proc: 
    -- This process creates an ARESETN signal from the active high RESET signal.
    -- The AXI protocol uses a single active LOW reset signal, ARESETn. The reset signal can be asserted
    -- asynchronously, but deassertion must be synchronous with a rising edge of ACLK.
    -------------------------------------------------------------------------------------------------------
    reset_proc:process (ACLK,ARESETN)
    begin
        if (ARESETN = '0') then
            resetn_sig    <= '0'; 
            resetn_ff_sig <= '0';
        elsif rising_edge(ACLK) then
            resetn_ff_sig <= ARESETN; 
            resetn_sig    <= resetn_ff_sig;                    
        end if;  
    end process reset_proc;

  
end global_signals_translator_arch;
