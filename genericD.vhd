-- load packages
library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.STD_LOGIC_unsigned.all;
use ieee.std_logic.arith.all; 

-- /** Define the I/Os **\
ENTITY genericD IS
GENERIC (n1: positive:= 3; -- generic parameter to modify ai
         n2: positive:= 2; -- genric parameter to modify x bits
         n3: positive:= 3; -- generic parameter to modify control bits
         n4: positive:= 16); -- generic parameter to modify output/reg1/datafinal bits
PORT (clk, res : IN STD_LOGIC; -- set clock and reset as single bit logic input
      ai       : IN STD_LOGIC_VECTOR(n1-1 downto 0); -- set the input bit vector range to n1bits 
      x        : IN STD_LOGIC_VECTOR(n2-1 downto 0); -- set the input bit vector range to n2bits 
      fx       : OUT STD_LOGIC_VECTOR(n4-1 downto 0)); -- set the output but vector range to n4bits 
END genericD;
-- /** Describe behavioral domain of the entity **\
ARCHITECTURE bhv OF genericD IS
SIGNAL reg1     : STD_LOGIC_VECTOR(n4-1 downto 0):=(others => '0'); -- internal signal register 
SIGNAL control  : STD_LOGIC_VECTOR(n3 downto 0):= (n3-3=>'1', others => '0'); -- internal signal register to control the output  
SIGNAL datafinal: STD_LOGIC_VECTOR(n4-1 downto 0):= (others => '0'); -- internal signal register were the results of the polynomial is written to 
BEGIN
 PROCESS -- sequential logic execution
 BEGIN
    WAIT UNTIL (clk'EVENT AND clk = '1') -- wait for the clock to go high => (+ve) '1'
            control <= control(0) & control(n3 downto 1); -- register is shifted to operate as a rind counter

            IF res = '1' THEN --when the input res is high
            reg1 <= (others => '0'); --  reset all bits of the register
            control <= (n1-3=>'1', others => '0'); -- preload value
            datafinal <= (others => '0'); -- reset all bits of the register

            ELSIF (res = '0') THEN -- when res input is low
            reg1 <= x * (ai + reg1(n3-3 downto 0)); -- override reg1

            IF (control(1)='1') THEN -- when bit 1 of the register is high
            datafinal <= reg1 + ai; -- write the valid final result
            ELSE datafinal <= (others => '0'); -- (normal behavoir) output is 0
            END IF;
            END IF;
 END PROCESS ;
            fx <= datafinal; -- write content of datafinal to fx 
END bhv;
