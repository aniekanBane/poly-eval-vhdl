-- load packages
library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;
use ieee.std_logic_arith.all; 

-- /** Define the I/Os **\
ENTITY vec_syd IS
PORT (clk, res : IN STD_LOGIC; -- set clock and reset as single bit logic input
      ai       : IN STD_LOGIC_VECTOR(2 downto 0); -- set the input bit vector range to 3bits (000 to 111) '0 - 7'
      x        : IN STD_LOGIC_VECTOR(1 downto 0); -- set the input bit vector range to 2bits (00 to 11) '0 - 3'
      fx       : OUT STD_LOGIC_VECTOR(8 downto 0)); -- set the output but vector range to 9bits (00000000)
END vec_syd;

-- /** Describe behavioral domain of the entity **\
ARCHITECTURE bhv OF vec_syd IS
SIGNAL reg1 : STD_LOGIC_VECTOR(8 downto 0); -- internal signal register with 9bit vector range (XXXXXXXXXX)
BEGIN
 PROCESS -- sequential logic execution
 BEGIN
    WAIT UNTIL (clk'EVENT AND clk = '1') -- wait for the clock to go high => (+ve) '1'
            IF res = '1' THEN reg1 <= (others => '0'); -- when the input res is high reset all bits of the register
            ELSE reg1 <= x * (ai + reg1(6 downto 0)); -- (normal behavior) reg1 is assigned the result
            END IF;
 END PROCESS ;
            fx <= reg1 + ai; -- assign result
END bhv;
