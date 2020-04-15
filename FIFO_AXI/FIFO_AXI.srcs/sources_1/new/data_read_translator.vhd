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
        --RRESP           : out STD_LOGIC_VECTOR ( 1 downto 0 ));  --Read response. This signal indicates the status of the read transfer.
end entity data_rd_translator;

architecture data_rd_translator_arch of data_rd_translator is

     ------------------------------------------------------------------------------------------------------
    ---Sginals Declerations
    ------------------------------------------------------------------------------------------------------
    signal rd_handshake_st      : fifo_rd_fsm_st_type;
    signal rd_handshake_pulse   : STD_LOGIC;  
    signal fifo_data_out_ff1    : STD_LOGIC_VECTOR (31 downto 0);
    signal fifo_data_out_ff2    : STD_LOGIC_VECTOR (31 downto 0);
    signal fifo_empty_ff11      : STD_LOGIC;
    signal fifo_empty_ff12      : STD_LOGIC;
    signal rready_ff1           : STD_LOGIC;
    signal rready_ff2           : STD_LOGIC;
    
    

    

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
    -- The double_sampler_proc dimply performs double sampling to all input signals.
    -- The sampled signals shall be used in all other processes. 
    -------------------------------------------------------------------------------------------------------
    -- double_sampler_proc:process (CLK,RESETN)
    -- begin
        -- if (RESETN = '0') then
            -- fifo_data_out_ff1       <= (others => '0');
            -- fifo_data_out_ff2       <= (others => '0');           
            -- fifo_empty_ff1          <= '0';
            -- fifo_empty_ff2          <= '0'; 
            -- rready_ff1              <= '0';
            -- rready_ff2              <= '0';
        -- elsif rising_edge(CLK) then 
            -- fifo_data_out_ff1       <= FIFO_DATA_OUT;
            -- fifo_data_out_ff2       <= fifo_data_out_ff1;             
            -- fifo_empty_ff1          <= FIFO_EMPTY;
            -- fifo_empty_ff2          <= fifo_empty_ff1;
            -- rready_ff1              <= RREADY;
            -- rready_ff2              <= rready_ff1; 
        -- end if;  
    -- end process double_sampler_proc;

    ------------------------------------------------------------------------------------------------------
    -- The read_fifo_axi_fsm_proc implements the FIFO reaad via the AXI interface.
    -- Since FIFO logic prevents additional writes to a full FIFO and also prevents reads from an empty FIFO,
    -- The  FIFO_EMPTY is used as a "Raady" signal from the FIFO side.
    -- See chapter A3.2.1 in AMBA AXI and ACE Protocol Specification.
    -- For RESET prodedure see chapter A3.1.
    -- This is a single process, synchronous FSM .   
    -------------------------------------------------------------------------------------------------------
    read_address_fsm_proc:process (CLK,RESETN)
    begin
        if (RESETN = '0') then                                        
            -----STATE-----------
            rd_handshake_st     <= st_not_valid;
            rd_handshake_pulse  <= '0';            
            -----OUTPUT-----------           
            FIFO_RD_EN          <= '0';            
            RVALID              <= '0';
            RDATA               <= (others => '0');                         
            ---------------------            
        elsif rising_edge(CLK) then
            case rd_handshake_st is
                when st_not_valid =>
                    if FIFO_EMPTY = '0' then
                        -----STATE-----------
                        rd_handshake_st     <= st_valid;
                        rd_handshake_pulse  <= '0';
                        -----OUTPUT-----------
                        FIFO_RD_EN          <= '0';            
                        RVALID              <= '1';
                        RDATA               <= (others => '0');                           
                    end if;
                when st_valid =>
                    if FIFO_EMPTY = '1' then
                        -----STATE-----------
                        rd_handshake_st     <= st_not_valid;
                        rd_handshake_pulse  <= '0';
                        -----OUTPUT-----------
                        FIFO_RD_EN          <= '0';            
                        RVALID              <= '0';
                        RDATA               <= (others => '0');
                    elsif  RREADY = '1' then
                        -----STATE-----------
                        rd_handshake_st     <= st_valid_ready;
                        rd_handshake_pulse  <= '0';
                        -----OUTPUT-----------
                        FIFO_RD_EN          <= '1';            
                        RVALID              <= '0';
                        RDATA               <= (others => '0');
                    end if;
                when st_valid_ready =>
                        if FIFO_EMPTY = '1' then
                            -----STATE-----------
                            rd_handshake_st     <= st_not_valid;
                            rd_handshake_pulse  <= '0';
                            -----OUTPUT-----------
                            FIFO_RD_EN          <= '0';            
                            RVALID              <= '0';
                            RDATA               <= (others => '0');
                        else
                            -----STATE-----------
                            rd_handshake_st     <= st_valid;
                            rd_handshake_pulse  <= '1';
                            -----OUTPUT-----------
                            FIFO_RD_EN          <= '0';            
                            RVALID              <= '1';
                            RDATA               <= FIFO_DATA_OUT;
                        end if;
            end case;
                 

                    
                    
                    
                    
                
                
                
                


            
            
            
            

           
           
        end if;  
    end process read_address_fsm_proc;



end data_rd_translator_arch;
