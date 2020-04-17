----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2020 08:45:51 AM
-- Design Name: 
-- Module Name: data_rd_translator - data_rd_translator_ARCH
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- This entity perfoms a read from the FIFO.
-- It has two interfaces- as a master towards the FIFO and as an AXI slave towards an AXI master. 
-- 1. It decodes the AXI read channels (Read Data) signals,  and generates the FIFO RD interface signals.  
-- 2. It decodes the FIFO RD interface signals and generates AXI read channels (Read Data) signals. 
-- For more infomation see chpter A3.2 in AMBA AXI and ACE Protocol Specification.
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

entity data_rd_translator is
    Port (
         --GLOBAL SIGNALS
        ------------------
        CLK      : in STD_LOGIC; --Master clock 
        RESETN   : in STD_LOGIC; --Master reset, active low(reset when Low)

        --FIFO INTERFACE
        ------------------ 
        FIFO_RD_EN      : out   STD_LOGIC; --Dout bus consist the read data from the FIFO when RD_EN=1
        FIFO_DATA_OUT   : in    STD_LOGIC_VECTOR (31 downto 0); --Data from FIFO
        FIFO_EMPTY      : in    STD_LOGIC; 

        --AXI LITE INTERFACE
        ------------------ 
        --Read data channel
        RVALID          : out STD_LOGIC;   --Read valid. This signal indicates that the channel is signaling the required read data
        RREADY          : in STD_LOGIC;    --Read ready. This signal indicates that the master can accept the read data and response
        RDATA           : out STD_LOGIC_VECTOR ( 31 downto 0 ));  --Read data.       
end entity data_rd_translator;

architecture data_rd_translator_arch of data_rd_translator is

     ------------------------------------------------------------------------------------------------------
    ---Sginals Declerations
    ------------------------------------------------------------------------------------------------------
    signal rd_handshake_st      : axi_handshake_fsm_st_type; --The FSM state
    signal rd_handshake_pulse   : STD_LOGIC;   -- a 1 clcok pulse signal used mainly for debug.High only when trasaction of data takes plase. 
    signal fetch_cntr           : fetch_cntr_type; -- a counter signal
    signal fetch_cntr_rst_pulse : STD_LOGIC;       -- a 1 clock pulse signal, resets the fetch_cntr.
    signal fetch_end_pulse      : STD_LOGIC;        --a 1 clock pulse signal, signals he FSM that the data fetch from the FIFO is finished.
    
    

    

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
    -- The read_fifo_axi_fsm_proc implements the FIFO reaad via the AXI interface.
    -- Since FIFO logic prevents additional writes to a full FIFO and also prevents reads from an empty FIFO,
    -- The  FIFO_EMPTY is used as a "Ready" signal from the FIFO side.
    -- See chapter A3.2.1 in AMBA AXI and ACE Protocol Specification.
    -- For RESET prodedure see chapter A3.1.
    -- This is a single process, synchronous FSM .   
    -------------------------------------------------------------------------------------------------------
    read_address_fsm_proc:process (CLK,RESETN)
    begin
        if (RESETN = '0') then                                        
            -----STATE-----------
            rd_handshake_st     <= st_fifo_empty;
            rd_handshake_pulse  <= '0';
            fetch_cntr_rst_pulse <= '0';            
            -----OUTPUT-----------           
            FIFO_RD_EN          <= '0';            
            RVALID              <= '0';
            RDATA               <= (others => '0');                         
            ---------------------            
        elsif rising_edge(CLK) then
            case rd_handshake_st is
                when st_fifo_empty =>
                    if FIFO_EMPTY = '0' then  
                        -----STATE-----------
                        rd_handshake_st     <= st_fifo_fetch;
                        rd_handshake_pulse  <= '0';
                        fetch_cntr_rst_pulse <= '1';
                        -----OUTPUT-----------
                        FIFO_RD_EN          <= '1';           
                        RVALID              <= '0';
                        RDATA               <= (others => '0');                           
                    end if;
                when st_fifo_fetch =>                            
                    if fetch_end_pulse = '1' then
                        if RREADY = '0' then                  
                            -----STATE-----------
                            rd_handshake_st     <= st_valid_not_ready;
                            rd_handshake_pulse  <= '0';
                            fetch_cntr_rst_pulse <= '0';                              
                            -----OUTPUT-----------
                            FIFO_RD_EN          <= '0';            
                            RVALID              <= '1';
                            RDATA               <=  FIFO_DATA_OUT;
                        elsif  RREADY = '1' then
                            -----STATE-----------
                            rd_handshake_st     <= st_valid_ready;
                            rd_handshake_pulse  <= '1'; 
                            fetch_cntr_rst_pulse <= '0';                             
                            -----OUTPUT-----------
                            FIFO_RD_EN          <= '0';            
                            RVALID              <= '1';
                            RDATA               <= FIFO_DATA_OUT;
                        end if;
                    else
                        -----STATE-----------
                        rd_handshake_st     <= st_fifo_fetch;
                        rd_handshake_pulse  <= '0'; 
                        fetch_cntr_rst_pulse <= '0';                             
                        -----OUTPUT-----------
                        FIFO_RD_EN          <= '0';            
                        RVALID              <= '0';
                        RDATA               <= (others => '0');  
                    end if;                        
                when st_valid_not_ready =>
                    if RREADY = '1' then
                        -----STATE-----------
                        rd_handshake_st     <= st_valid_ready;
                        rd_handshake_pulse  <= '1';
                        fetch_cntr_rst_pulse <= '0';
                        -----OUTPUT-----------
                        FIFO_RD_EN          <= '0';            
                        RVALID              <= '1';
                        RDATA               <= FIFO_DATA_OUT;
                    end if;
                when st_valid_ready =>
                    if FIFO_EMPTY = '0' then
                        -----STATE-----------
                        rd_handshake_st     <= st_fifo_fetch;
                        rd_handshake_pulse  <= '0';
                        fetch_cntr_rst_pulse <= '1';
                        -----OUTPUT-----------
                        FIFO_RD_EN          <= '1';            
                        RVALID              <= '0';
                        RDATA               <= FIFO_DATA_OUT;
                    else
                        -----STATE-----------
                        rd_handshake_st     <= st_fifo_empty;
                        rd_handshake_pulse  <= '0';
                        fetch_cntr_rst_pulse <= '0';
                        -----OUTPUT-----------
                        FIFO_RD_EN          <= '0';            
                        RVALID              <= '0';
                        RDATA               <= FIFO_DATA_OUT;
                    end if;                  
            end case;           
           
        end if;  
    end process read_address_fsm_proc;


    ------------------------------------------------------------------------------------------------------
    -- The fetch_cntr_proc process is a simple counter. It counts from 0 to C_MAX_FETCH_CNTR.
    -- The purpose of this counter is to count C_MAX_FETCH_CNTR clocks untill the FSM finishes the
    -- st_fifo_fetch state.It is needed since It takes several clocks 
    -- from the moment the FIFO_RD_EN pulse was set to high untill
    -- The FIFO data is avilable  and valid at the RDATA port.
    -- The counter is reset to 0 via the fetch_cntr_rst_pulse 1-clcock-pulse signal.  
    -- The communication between the counter process and the FSM is via 1-clock pulses,         
    -------------------------------------------------------------------------------------------------------
    fetch_cntr_proc:process (CLK,RESETN)   
    begin        
        if (RESETN = '0') then
            fetch_cntr <= C_MAX_FETCH_CNTR;
        elsif rising_edge(CLK) then  
            if fetch_cntr = C_MAX_FETCH_CNTR then
                if fetch_cntr_rst_pulse = '1' then
                    fetch_cntr <= 0;
                end if;
            else
                fetch_cntr <= fetch_cntr+1;
            end if;
        end if;
    end process fetch_cntr_proc;

     ------------------------------------------------------------------------------------------------------
    -- The fetch_end_pulse_gen_proc  generates a 1-clock-pulse signal to the FSM one clock before
    -- The fetch_cntr reaches C_MAX_FETCH_CNTR. This pulse signals the FSM to leave the st_fifo_fetch state
    -- yo the next state.           
    -------------------------------------------------------------------------------------------------------
    fetch_end_pulse_gen_proc:process (CLK,RESETN)    
    begin        
        if (RESETN = '0') then
            fetch_end_pulse <= '0';
        elsif rising_edge(CLK) then  
            if fetch_cntr = C_MAX_FETCH_CNTR-1 then
                fetch_end_pulse <= '1';
            else
                fetch_end_pulse <= '0';
            end if;
        end if;
    end process fetch_end_pulse_gen_proc;
    



end data_rd_translator_arch;
