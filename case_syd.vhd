-- load packages
library library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;
use ieee.std_logic_arith.all; 

-- /** Define the I/Os **\
ENTITY case_syd IS
PORT (clk, res : IN BIT; -- set clock and reset as single bit input
      ai, x    : IN INTEGER:=0; -- set ai and x as input integer wit intial values of zero
      fx       : OUT INTEGER:=0); -- set fx as integer output with initial value of zero
END case_syd;

-- /** Describe behavioral domain of the entity **\
ARCHITECTURE bhv OF case_syd IS
SIGNAL reg1 : INTEGER:=0; -- internal signal register with initial value of zero
BEGIN
 PROCESS -- sequential logic execution
 BEGIN
    WAIT UNTIL (clk'EVENT AND clk = '1') -- wait for the clock to go high => (+ve) '1'
            IF res = '1' THEN reg1 <= 0; -- when the input res is high reset the register
            ELSE reg1 <= x * (ai + reg1); -- (normal behavior) reg1 is assigned the result
            END IF;
 END PROCESS ;
            fx <= reg1 + ai; -- assign result
END bhv;
