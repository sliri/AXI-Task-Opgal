----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2020 04:07:47 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
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

entity top is
    Port (
        -----------------
        --AXI GLOBAL
        ------------------ 
        ACLK            : in STD_LOGIC;
        ARESETN         : in STD_LOGIC;
        -----------------
        --FIFO INTERFACE
        ------------------ 
        FIFO_CLK        : out STD_LOGIC;
        FIFO_RST        : out STD_LOGIC;
        FIFO_WR_EN      : in STD_LOGIC;
        FIFO_DATA_IN    : out STD_LOGIC_VECTOR (31 downto 0);
        FIFO_RD_EN      : out STD_LOGIC;
        FIFO_DATA_OUT   : in STD_LOGIC_VECTOR (31 downto 0);
        FIFO_EMPTY      : in STD_LOGIC;
        FIFO_FULL       : in STD_LOGIC;        
        ---------------------
        --AXI LITE INTERFACE
        ---------------------       
        --Write address channel
        AXI_AWVALID     : in STD_LOGIC;
        AXI_AWREADY     : out STD_LOGIC;
        AXI_AWADDR      : in STD_LOGIC_VECTOR ( 31 downto 0 );
        AXI_AWPROT      : in STD_LOGIC_VECTOR ( 2 downto 0 );
        --Write data channel
        WVALID          : in STD_LOGIC;
        WREADY          : out STD_LOGIC;
        WDATA           : in STD_LOGIC_VECTOR ( 31 downto 0 );
        WSTRB           : in STD_LOGIC_VECTOR ( 3 downto 0 );
        --Write response channel
        BVALID          : out STD_LOGIC;
        BREADY          : in STD_LOGIC;
        BRESP           : out STD_LOGIC_VECTOR ( 1 downto 0 );
        --Read address channel
        ARVALID         : in STD_LOGIC;
        ARREADY         : out STD_LOGIC;
        ARADDR          : in STD_LOGIC_VECTOR ( 31 downto 0 );
        ARPROT          : in STD_LOGIC_VECTOR ( 2 downto 0 );
        --Read data channel
        RVALID          : out STD_LOGIC;
        RREADY          : in STD_LOGIC;
        RDATA           : out STD_LOGIC_VECTOR ( 31 downto 0 );
        RRESP           : out STD_LOGIC_VECTOR ( 1 downto 0 )
    );
end top;

architecture arch_top of top is
   
   ------------------------------------------------------------------------------------------------------
   ---Sginals Declerations
   ------------------------------------------------------------------------------------------------------
   signal resetn_sig     : STD_LOGIC;
   signal reset_sig      : STD_LOGIC;
   signal clk_sig        : STD_LOGIC;
   
   ------------------------------------------------------------------------------------------------------
   ---Components Declerations
   ------------------------------------------------------------------------------------------------------
   component global_signals_translator 
    Port ( ACLK         : in STD_LOGIC;
           ARESETN      : in STD_LOGIC;
           CLK          : out STD_LOGIC;
           RESET        : out STD_LOGIC;
           RESETN       : out STD_LOGIC);
    end component global_signals_translator;

    component data_rd_translator 
        Port (
             --GLOBAL SIGNALS
            ------------------
            CLK      : in STD_LOGIC; --Master clock 
            RESETN   : in STD_LOGIC; --Master reset, active low(reset when Low)
    
            --FIFO INTERFACE
            ------------------ 
            FIFO_RD_EN      : out   STD_LOGIC; --Dout bus consist the read data from the FIFO when RD_EN=?1?
            FIFO_DATA_OUT   : in    STD_LOGIC_VECTOR (31 downto 0); --Data from FIFO
            FIFO_EMPTY      : in    STD_LOGIC; 
    
            --AXI LITE INTERFACE
            ------------------ 
            --Read data channel
            RVALID          : out STD_LOGIC;   --Read valid. This signal indicates that the channel is signaling the required read data
            RREADY          : in STD_LOGIC;    --Read ready. This signal indicates that the master can accept the read data and response
            RDATA           : out STD_LOGIC_VECTOR ( 31 downto 0 ));  --Read data.
            --RRESP           : out STD_LOGIC_VECTOR ( 1 downto 0 ));  --Read response. This signal indicates the status of the read transfer.
    end component data_rd_translator;
    

begin

    ------------------------------------------------------------------------------------------------------
     ---Components Instantiation
    ------------------------------------------------------------------------------------------------------
    global_signals_translator_inst :global_signals_translator port map(
        ACLK            =>  ACLK,
        ARESETN         =>  ARESETN,
        CLK             =>  clk_sig,
        RESET           =>  reset_sig,
        RESETN          =>  resetn_sig);
    
    data_rd_translator_inst :data_rd_translator port map(
        CLK             => clk_sig,
        RESETN          => resetn_sig,
        FIFO_RD_EN      => FIFO_RD_EN, 
        FIFO_DATA_OUT   => FIFO_DATA_OUT,
        FIFO_EMPTY      => FIFO_EMPTY,
        RVALID          => RVALID,
        RREADY          => RREADY,   
        RDATA           => RDATA); 
    
    ------------------------------------------------------------------------------------------------------
    ---Concurrent statements---
    ------------------------------------------------------------------------------------------------------
    FIFO_CLK    <= clk_sig;
    FIFO_RST    <= reset_sig;
 
   
   
    


end arch_top;