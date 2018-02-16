library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity colisoes is
	Port (Clk : in std_logic;
			Reset: in std_logic;

			DLink_Left : in std_logic_vector(9 downto 0);--DLink limite esquerdo
			DLink_top : in std_logic_vector(9 downto 0);--DLink limite cima
			DLink_Width : in std_logic_vector(9 downto 0);--largura DLink

			Shuri_X : in std_logic_vector(9 downto 0);--posicao X do Shuri_
			Shuri_Y : in std_logic_vector(9 downto 0);--posicao Y do Shuri_
			Shuri_Width : in std_logic_vector(9 downto 0);--largura Shuri_
			Shuri_Height : in std_logic_vector(9 downto 0);--altura Shuri_

			colisao_c: out std_logic;
			colisao_l: out std_logic);
end colisoes;

architecture Behavioral of colisoes is
	constant top_bound : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(10, 10); --colisao no topo da janela
	constant bottom_bound : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(380, 10); --colisao no fundo da janela
begin
	check_colisao: process(Clk, Reset, DLink_Left, DLink_Top, Shuri_X, Shuri_Y, Shuri_Width, Shuri_Height, DLink_Width)
	begin

		if ((Shuri_X+CONV_STD_LOGIC_VECTOR(10, 10) > DLink_Left and Shuri_X+CONV_STD_LOGIC_VECTOR(10, 10) < DLink_Left + DLink_Width) and (Shuri_Y + Shuri_Height > DLink_Top )) then
			colisao_l <= '1';
		
		elsif(Shuri_Y + Shuri_Height > bottom_bound)  then
			colisao_c <= '1';
			
		else
			colisao_c <= '0';
			colisao_l <= '0';
		end if;
		
	end process;
end Behavioral;
