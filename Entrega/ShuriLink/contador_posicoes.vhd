LIBRARY ieee;
USE ieee.std_logic_1164.all; 
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY contador_posicoes IS 
	PORT
	(
		clk : in std_logic;
		contador :  OUT  STD_LOGIC_Vector(3 downto 0)
	);
END contador_posicoes;

ARCHITECTURE gerador OF contador_posicoes IS 


Signal	contador_temp :  STD_LOGIC_Vector(3 downto 0) := "0000";
Begin
PROCESS(contador_temp, clk)
BEGIN
if (RISING_EDGE(clk)) THEN --quando o contador for ao maximo volta a 0
	if (contador_temp = "1111") then
		contador_temp <= "0000";
	elsif(contador_temp ="1010") then
		contador_temp <= "1101";
	else
		contador_temp <= contador_temp + "0001"; --vai incrementando sempre 1
	end if;
	
end if;
	contador <= contador_temp;
END PROCESS;

END gerador;