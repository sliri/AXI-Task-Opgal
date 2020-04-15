----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2020 10:20:50 PM
-- Design Name: 
-- Module Name: top_tb - top_tb_arch
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_tb is
end top_tb;

architecture top_tb_arch of top_tb is

    component top is
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
    end component top;

begin



end top_tb_arch;
