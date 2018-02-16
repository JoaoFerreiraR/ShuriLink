LIBRARY ieee;
USE ieee.std_logic_1164.all; 
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ScoreCounter IS 
	PORT
	(
		Reset : in std_logic;
		score :  IN  STD_LOGIC;
		conta :  OUT  STD_LOGIC_Vector(15 downto 0)
	);
END ScoreCounter;

ARCHITECTURE behavior OF ScoreCounter IS 


Signal	temp_conta :  STD_LOGIC_Vector(15 downto 0) := "0000000000000000";
Begin
PROCESS(score, Reset, temp_conta)
BEGIN
if(Reset = '1') then --fazendo reset contador vai a 0
	temp_conta <= "0000000000000000";
elsif (RISING_EDGE(score)) THEN -- chegando ao limite volta a 0
	if (temp_conta = "1111111111111111") then
		temp_conta <= "0000000000000000";
	else
		temp_conta <= temp_conta + "0000000000000001"; --vai sempre incrementando 1
	end if;
END IF;
	conta <= temp_conta; 
END PROCESS;

END behavior;