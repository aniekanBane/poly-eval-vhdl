-- load packages
library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.STD_LOGIC_unsigned.all;
use ieee.std_logic.arith.all; 

-- /** Define the I/Os **\
ENTITY validOUT IS
PORT (clk, res : IN STD_LOGIC; -- set clock and reset as single bit logic input
      ai       : IN STD_LOGIC_VECTOR(2 downto 0); -- set the input bit vector range to 3bits (000 to 111) '0 - 7'
      x        : IN STD_LOGIC_VECTOR(1 downto 0); -- set the input bit vector range to 2bits (00 to 11) '0 - 3'
      fx       : OUT STD_LOGIC_VECTOR(8 downto 0)); -- set the output but vector range to 9bits (00000000)
END validOUT;
-- /** Describe behavioral domain of the entity **\
ARCHITECTURE bhv OF validOUT IS
SIGNAL reg1     : STD_LOGIC_VECTOR(8 downto 0):=(others => '0'); -- internal signal register with 11bit vector range (XX000000000)
SIGNAL control  : STD_LOGIC_VECTOR(3 downto 0):= ("0001"); -- internal signal register to control the output after 4 clock cycles with 4bit vector range 
SIGNAL datafinal: STD_LOGIC_VECTOR(8 downto 0):= (others => '0'); -- internal signal register were the results of the polynomial is written to with 9bit vector range (XXXXXXXXXX)
BEGIN
 PROCESS -- sequential logic execution
 BEGIN
    WAIT UNTIL (clk'EVENT AND clk = '1') -- wait for the clock to go high => (+ve) '1'
            control <= control(0) & control(3 downto 1); -- register is shifted to operate as a rind counter

            IF res = '1' THEN --when the input res is high
            reg1 <= (others => '0'); --  reset all bits of the register
            control <= "0001"; -- delay by 1clk
            datafinal <= (others => '0'); -- reset all bits of the register

            ELSIF (res = '0') THEN -- when res input is low
            reg1 <= x * (ai + reg1(6 downto 0)); -- reg1 is assigned the result

            IF (control(1)='1') THEN -- when bit 1 of the register is high
            datafinal <= reg1 + ai; -- write the valid final result
            ELSE datafinal <= (others => '0'); -- (normal behavoir) output is 0
            END IF;
            END IF;
 END PROCESS ;
            fx <= datafinal; -- write content of datashift to fx 
END bhv;
