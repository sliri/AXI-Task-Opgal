----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2020 10:26:04 PM
-- Design Name: 
-- Module Name: data_rd_translator_tb - data_rd_translator_tb_arch
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

entity data_rd_translator_tb is
--  Port ( );
end data_rd_translator_tb;

architecture data_rd_translator_tb_arch of data_rd_translator_tb is
   
   ------------------------------------------------------------------------------------------------------
   ---Sginals Declerations
   ------------------------------------------------------------------------------------------------------
    signal resetn_sig           : STD_LOGIC;
    signal reset_sig            : STD_LOGIC;
    signal clk_sig              : STD_LOGIC;
    signal aclk_sig             : STD_LOGIC;
    signal aresetn_sig          : STD_LOGIC;
    signal fifo_rd_en_sig       : STD_LOGIC; 
    signal fifo_data_out_sig    : STD_LOGIC_VECTOR (31 downto 0);
    signal fifo_data_out_f_sig  : STD_LOGIC_VECTOR (31 downto 0);  
    signal fifo_empty_sig       : STD_LOGIC; 
    signal fifo_empty_f_sig     : STD_LOGIC;
    signal rvalid_sig           : STD_LOGIC;   
    signal rready_sig           : STD_LOGIC;
    signal rready_f_sig         : STD_LOGIC;   
    signal rdata_sig            : STD_LOGIC_VECTOR ( 31 downto 0 );  --Read data.

   
   ------------------------------------------------------------------------------------------------------
   ---Components Declerations
   ------------------------------------------------------------------------------------------------------

    component global_signals_translator is
        Port ( ACLK         : in STD_LOGIC;  -- Global clock In
               ARESETN      : in STD_LOGIC;  -- Global axi RESETN (asynchronous reset, active low, '0'==> enters reset)
               CLK          : out STD_LOGIC; -- Globla clock (same as ACLK)
               RESET        : out STD_LOGIC; -- Synchronus RESET (active high, '1'==> enters reset)
               RESETN       : out STD_LOGIC);-- Synchronus RESETN (active low, '0'==> enters reset)
    end component global_signals_translator;


    component double_sampler is
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
    end component double_sampler;




    component data_rd_translator is
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
    end component data_rd_translator;

begin

    ------------------------------------------------------------------------------------------------------
     ---Components Instantiation
    ------------------------------------------------------------------------------------------------------
    global_signals_translator_inst :global_signals_translator port map(
        ACLK            =>  aclk_sig,
        ARESETN         =>  aresetn_sig,
        CLK             =>  clk_sig,
        RESET           =>  reset_sig,
        RESETN          =>  resetn_sig);

    double_sampler_inst: double_sampler port map(           
        CLK                 =>  clk_sig,
        RESETN              =>  resetn_sig,                    
        FIFO_DATA_OUT       =>  fifo_data_out_sig,  
        FIFO_EMPTY          =>  fifo_empty_sig,      
        FIFO_DATA_OUT_F     =>  fifo_data_out_f_sig, 
        FIFO_EMPTY_F        =>  fifo_empty_f_sig,    
        RREADY              =>  rready_sig,       
        RREADY_F            =>  rready_f_sig);                      
        
    
    data_rd_translator_inst :data_rd_translator port map(
        CLK             => clk_sig,
        RESETN          => resetn_sig,
        FIFO_RD_EN      => fifo_rd_en_sig, 
        FIFO_DATA_OUT   => fifo_data_out_f_sig,
        FIFO_EMPTY      => fifo_empty_f_sig,
        RVALID          => rvalid_sig,
        RREADY          => rready_f_sig,   
        RDATA           => rdata_sig); 

    
   
    ------------------------------------------------------------------------------------------------------
    ---Sequential statements---
    ------------------------------------------------------------------------------------------------------

    clock_process :process
    constant clock_period : time := 20 ns; 
    begin
        aclk_sig <= '0';
        wait for clock_period/2;
        aclk_sig <= '1';
        wait for clock_period/2;
    end process clock_process;


    resetn_process :process   
    begin
        aresetn_sig <= '0';
        wait for 100 ns;
        aresetn_sig <= '1';
        wait ;
    end process resetn_process;

    fifo_data_out_process :process   
    begin
        fifo_data_out_sig <= X"00000000";
        wait for 1 us;
        fifo_data_out_sig <= X"AAAAAAAA";
        wait for 1 us;
        fifo_data_out_sig <= X"55555555";
        wait for 1 us;
        fifo_data_out_sig <= X"FFFFFFFF";
        wait for 1 us;    
    end process fifo_data_out_process;


    fifo_empty_process :process   
    begin
        fifo_empty_sig <= '0';
        wait for 0.1 us;
        fifo_empty_sig <= '1';
        wait for 1 us;
        fifo_empty_sig <= '0';
        wait for 1.5 us;
        fifo_empty_sig <= '1';
        wait for 1 us;
        fifo_empty_sig <= '0';
        wait;
    end process fifo_empty_process;


    rready_sig_process :process   
    begin
        rready_sig <= '0';
        wait for 0.5 us;
        rready_sig <= '1';
        wait for 1 us;
        rready_sig <= '0';
        wait for 2 us;
        rready_sig <= '1';
        wait;
    end process rready_sig_process;

end data_rd_translator_tb_arch;
