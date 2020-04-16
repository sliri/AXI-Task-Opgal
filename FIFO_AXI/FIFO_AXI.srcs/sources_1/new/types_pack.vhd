----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2020 01:05:22 PM
-- Design Name: 
-- Module Name: types_pack - Behavioral
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
use work.consts_pack.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


package types_pack is
    type axi_handshake_fsm_st_type is (st_fifo_empty,st_fifo_fetch,st_valid_not_ready,st_valid_ready);
    subtype fetch_cntr_type is INTEGER range 0 to C_MAX_FETCH_CNTR;    
end package types_pack;

package body types_pack is 

end types_pack; 