library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shuriken is
	Port (	Frame_Clk : in std_logic; 
			Reset: in std_logic;
			click : in std_logic; --salto
			game_over: in std_logic;
			Pause : in std_logic;
			
			forca  :in std_logic_vector(3 downto 0); -- força com que é atirado para cima 
			
			shuriken_x : out std_logic_vector(9 downto 0); --posicao x
			shuriken_y : out std_logic_vector(9 downto 0); --posicao y
			
			shuriken_width : out std_logic_vector(9 downto 0); --largura
			shuriken_height : out std_logic_vector(9 downto 0); --altura
			anim_frame : out std_logic_vector(1 downto 0); --animacao
			forca_out: out std_logic_vector(3 downto 0);
			selec_forca_out : out std_logic;
			colisao_l : in std_logic
			);
end shuriken;

architecture Behavioral of shuriken is
	signal shuri_y : std_logic_vector(9 downto 0); -- posicao y 
	signal shuri_vy : std_logic_vector(9 downto 0); --velocidade y
	signal shuri_vx : std_logic_vector(9 downto 0); --velocidade x
	signal shuri_x : std_logic_vector(9 downto 0); -- posicao x 
	signal forcar: std_logic_vector (3 downto 0);
	signal precisa_click : std_logic := '0';

	signal selec_forca : std_logic := '1'; -- primeira parte que permite escolher a força
	
	
	constant shuri_ay : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(1, 10); --animacao
	constant click_forca_x : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(-5, 10); --forca do click (subir)
	constant click_forca_y : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(-8, 10); --forca do click (subir)
	constant shuriken_X_inicial : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(70, 10); --posicao inicial 
	constant shuriken_Y_inicial : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(330, 10); --posicao inicial
	constant shuriken_VY_inicial : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10); --velocidade inicial
	constant shuriken_VX_inicial : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(5, 10); --velocidade inicial
	
	constant shuri_width : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(30, 10); --largura
	constant shuri_height : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(30, 10); --altura
begin
	update_shuriken: process(Frame_Clk, Reset, click, Pause, precisa_click, shuri_vy, shuri_y)
	begin
	if(Reset='1' or colisao_l = '1') then --quando pressionado reset
		shuri_y <= shuriken_Y_inicial; --posicao inicial
		shuri_vy <= shuriken_VY_inicial; --velocidade inicial	
		shuri_x <= shuriken_X_inicial;
		shuri_vx <= shuriken_VX_inicial;
		precisa_click <= '0';
		selec_forca <= '1';


	elsif( selec_forca = '1' and click ='1' and pause = '0')then
		
		shuri_y <= shuriken_Y_inicial; --posicao inicial
		shuri_vy <= shuriken_VY_inicial; --velocidade inicial	
		shuri_x <= shuriken_X_inicial;
		shuri_vx <= shuriken_VX_inicial;
				
		selec_forca<= '0';
		forcar <= forca;
		precisa_click <= '1';
	

		
		
	
		
	elsif(rising_edge(Frame_Clk)) then	
		if(Pause = '1' or game_over = '1' or selec_forca = '1' ) then --quando colide
			shuri_vy <= shuri_vy; --velocidade fica como esta
			shuri_y <= shuri_y; -- posicao fica como esta
			shuri_vx <= shuri_vx;
			shuri_x <= shuri_x;
			
			
		elsif(shuri_y > CONV_STD_LOGIC_VECTOR(460, 10)) then --quando toca no chao do ecra
			shuri_y <= CONV_STD_LOGIC_VECTOR(459, 10); --fica na posicao actual 
			shuri_vy <= CONV_STD_LOGIC_VECTOR(0, 10); -- velocidade fica a 0
			shuri_x <= shuri_x;
			shuri_vx <= CONV_STD_LOGIC_VECTOR(0, 10); -- velocidade fica a 0

		elsif(shuri_y < CONV_STD_LOGIC_VECTOR(20, 10)) then --quando toca em cima
			shuri_y <= CONV_STD_LOGIC_VECTOR(21, 10); -- fica na posição de baixo
			shuri_vy <= CONV_STD_LOGIC_VECTOR(0, 10); -- velocidade 0 (parado)
			

		elsif(precisa_click = '1') then
			shuri_vy <= shuri_vy + CONV_STD_LOGIC_VECTOR( CONV_INTEGER(click_forca_y)-(CONV_INTEGER(forcar)),10);
			shuri_y <= shuri_y + shuri_vy; -- posicao = posicao + incremento da velocidade (distancia de subida)
			shuri_x <= shuri_x + CONV_STD_LOGIC_VECTOR(CONV_INTEGER(forcar) - CONV_INTEGER(click_forca_x),10);
			precisa_click <= '0';
		else
			shuri_vy <= shuri_vy + shuri_ay; --desce
			shuri_y <= shuri_y + shuri_vy; 
			shuri_x <= shuri_x + CONV_STD_LOGIC_VECTOR(CONV_INTEGER(forcar) - CONV_INTEGER(click_forca_x),10);
			
		end if;	

	else 

	end if;
	
	shuriken_x <= shuri_x;
	shuriken_y <= shuri_y;
	shuriken_width <= shuri_width;
	shuriken_height <= shuri_height;
	forca_out <= forcar;
	selec_forca_out <= selec_forca; 
	end process;
	

	
end Behavioral;