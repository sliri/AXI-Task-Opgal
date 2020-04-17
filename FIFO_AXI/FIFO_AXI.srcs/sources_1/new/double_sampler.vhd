----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2020 08:45:51 AM
-- Design Name: 
-- Module Name: double_sampler 
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- This entity performs double sampling
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
use work.types_pack.all;
use work.consts_pack.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity double_sampler is
    Port (
         --GLOBAL SIGNALS
        ------------------
        CLK      : in STD_LOGIC; --Master clock 
        RESETN   : in STD_LOGIC; --Master reset, active low(reset when Low)

        --FIFO INTERFACE
        ------------------       
        FIFO_DATA_OUT     : in    STD_LOGIC_VECTOR (31 downto 0); 
        FIFO_EMPTY        : in    STD_LOGIC; 
        FIFO_DATA_OUT_F   : out   STD_LOGIC_VECTOR (31 downto 0); 
        FIFO_EMPTY_F      : out   STD_LOGIC; 

        --AXI LITE INTERFACE
        ------------------ 
        --Read data channel        
        RREADY          : in STD_LOGIC;   
        RREADY_F        : out STD_LOGIC);    
            
end entity double_sampler;

architecture double_sampler_arch of double_sampler is

     ------------------------------------------------------------------------------------------------------
    ---Sginals Declerations
    ------------------------------------------------------------------------------------------------------
    signal fifo_data_out_ff1    : STD_LOGIC_VECTOR (31 downto 0);    
    signal fifo_empty_ff1       : STD_LOGIC;   
    signal rready_ff1           : STD_LOGIC;
     
    
    
    

    

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
   
    
    ------------------------------------------------------------------------------------------------------
    ---Sequential statements---
    -----------------------------------------------------------------------------------------------------
    
   

    ------------------------------------------------------------------------------------------------------
    --The sampling process   
    -------------------------------------------------------------------------------------------------------
    double_sampler_proc:process (CLK,RESETN)
    begin
        if (RESETN = '0') then 
            fifo_data_out_ff1 <= (others=>'0');           
            fifo_empty_ff1    <= '1';          
            rready_ff1        <= '0';            
            FIFO_DATA_OUT_F   <= (others=>'0'); 
            FIFO_EMPTY_F      <= '1';  
            RREADY_F          <= '0'; 
        elsif rising_edge(CLK) then 
            fifo_data_out_ff1   <= FIFO_DATA_OUT;
            FIFO_DATA_OUT_F     <= fifo_data_out_ff1;
            fifo_empty_ff1      <= FIFO_EMPTY;
            FIFO_EMPTY_F        <= fifo_empty_ff1;
            rready_ff1          <= RREADY;
            RREADY_F            <= rready_ff1;
        end if;  
    end process double_sampler_proc;    
end architecture double_sampler_arch;
