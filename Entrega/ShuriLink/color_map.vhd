library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity color_map is

   Port ( shuriX : in std_logic_vector(9 downto 0);--posicao (coordenada X) do shuri  
          shuriY : in std_logic_vector(9 downto 0);--posicao (coordenada Y) do shuri
          DrawX : in std_logic_vector(9 downto 0); --desenha X
          DrawY : in std_logic_vector(9 downto 0); --desenha Y
          shuri_size : in std_logic_vector(9 downto 0);--tamanho shuri
          Red   : out std_logic_vector(9 downto 0);
          Green : out std_logic_vector(9 downto 0);
          Blue  : out std_logic_vector(9 downto 0);
			 dlink1_Left : in std_logic_vector(9 downto 0);-- 
			 dlink1_Top : in std_logic_vector(9 downto 0);			 
			 dlink_Width : in std_logic_vector(9 downto 0);--comprimento do dlink
			 
			 animacao : in std_logic_vector(1 downto 0);--animacao
			 score : in std_logic_vector(15 downto 0);--pontuacao
			 Estado_Start_Game : in std_logic;--estado jogo a correr
			 Estado_Quit_Game : in std_logic;--estado fim do jogo
			 Estado_Main_menu : in std_logic;--estado main menu
			 forca: in std_logic_vector(3 downto 0)
			 );
end color_map;

architecture Behavioral of color_map is

signal shuri_on : std_logic;--sinais
signal dlink1_on : std_logic;


constant Link_Left: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(50, 10);-- link onde aparace em x
constant Link_Top: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(330, 10); -- em y

constant forca_Left: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(15, 10);--
constant forca_Top: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(330, 10); --

constant Score_Right : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(600, 10);--score aparece a direita
constant Score_Top: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(20, 10); --e em cima
constant Font_Width : integer := 8; --tamanho letra 
constant Font_Mult_Factor : integer := 3; 
constant Font_Height : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(7, 10); --altura letra score
constant Font2_Height : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(16, 10); --altura letra game over

constant Message_Top : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(220, 10); --game over posicao
constant Message_Left : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(250, 10);

constant Message_Top_shuri : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(220, 10); --Flappy shuri posicao
constant Message_Left_shuri : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(200, 10);

constant Cap_Height : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(30, 10); --boca do dlink
constant Cap_Width : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(80, 10);

constant relva : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(360, 10); --boca do dlink

constant Altura_Barrinha : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(10, 10); --boca do dlink


-- 0 Transparent
-- 1 Red
-- 2 Green
-- 3 Yellow
-- 4 White
-- 5 blue
-- 9 preto

-----------------------------------------------------------------------------------------
--ALL SPRITES
-----------------------------------------------------------------------------------------
type T_LSPRITE is array (0 to 26, 0 to 127) of integer range 0 to 1;

constant letters_array : T_LSPRITE :=
				(  ( 0, 0, 0, 0, 0, 0, 0, 0,   -- 0, 
					  0, 0, 0, 0, 0, 0, 0, 0,   -- 1,
					  0, 0, 0, 1, 0, 0, 0, 0,   -- 2    *
					  0, 0, 1, 1, 1, 0, 0, 0,   -- 3   ***
					  0, 1, 1, 0, 1, 1, 0, 0,   -- 4  ** **
					  1, 1,0, 0, 0,  1, 1, 0,   -- 5 **   **
					  1, 1,0, 0, 0,  1, 1, 0,   -- 6 **   **
					  1, 1, 1, 1, 1, 1, 1, 0,   -- 7 *******
					  1, 1, 0, 0, 0, 1, 1, 0,   -- 8 **   **
					  1, 1, 0, 0, 0, 1, 1, 0,   -- 9 **   **
					  1, 1, 0, 0, 0, 1, 1, 0,   -- a **   **
					  1, 1, 0, 0, 0, 1, 1, 0,   -- b **   **
					  0, 0, 0, 0, 0, 0, 0, 0,   -- c
					  0, 0, 0, 0, 0, 0, 0, 0,   -- d
					  0, 0, 0, 0, 0, 0, 0, 0,   -- e
					  0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x42
					( 0, 0, 0, 0, 0, 0, 0, 0,   -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0,   --  1,
					 1, 1, 1, 1, 1, 1,0, 0,   -- 2 ******
					 0,  1, 1,0, 0,  1, 1,0,   -- 3  **  **
					 0,  1, 1,0, 0,  1, 1,0,   -- 4  **  **
					 0,  1, 1,0, 0,  1, 1,0,   -- 5  **  **
					 0,  1, 1, 1, 1, 1,0, 0,   -- 6  *****
					 0,  1, 1,0, 0,  1, 1,0,   -- 7  **  **
					 0,  1, 1,0, 0,  1, 1,0,   -- 8  **  **
					 0,  1, 1,0, 0,  1, 1,0,   -- 9  **  **
					 0,  1, 1,0, 0,  1, 1,0,   -- a  **  **
					  1, 1, 1, 1, 1, 1,0, 0,   -- b ******
					 0, 0, 0, 0, 0, 0, 0, 0,   -- c
					 0, 0, 0, 0, 0, 0, 0, 0,  -- d
					 0, 0, 0, 0, 0, 0, 0, 0,   -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x43
					( 0, 0, 0, 0, 0, 0, 0, 0,   -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0,   --  1,
					 0, 0,  1, 1, 1, 1,0, 0,   -- 2   ****
					 0,  1, 1,0, 0,  1, 1,0,   -- 3  **  **
					  1, 1,0, 0, 0, 0,  1,0,   -- 4 **    *
					  1, 1,0, 0, 0, 0, 0, 0,   -- 5 **
					  1, 1,0, 0, 0, 0, 0, 0,   -- 6 **
					  1, 1,0, 0, 0, 0, 0, 0,   -- 7 **
					  1, 1,0, 0, 0, 0, 0, 0,   -- 8 **
					  1, 1,0, 0, 0, 0,  1,0,   -- 9 **    *
					 0,  1, 1,0, 0,  1, 1,0,   -- a  **  **
					 0, 0,  1, 1, 1, 1,0, 0,   -- b   ****
					 0, 0, 0, 0, 0, 0, 0, 0,   -- c
					 0, 0, 0, 0, 0, 0, 0, 0,   -- d
					 0, 0, 0, 0, 0, 0, 0, 0,   -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x44
					( 0, 0, 0, 0, 0, 0, 0, 0,   -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0,   --  1,
					  1, 1, 1, 1, 1,0, 0, 0,   -- 2 *****
					 0,  1, 1,0,  1, 1,0, 0,   -- 3  ** **
					 0,  1, 1,0, 0,  1, 1,0,   -- 4  **  **
					 0,  1, 1,0, 0,  1, 1,0,   -- 5  **  **
					 0,  1, 1,0, 0,  1, 1,0,   -- 6  **  **
					 0,  1, 1,0, 0,  1, 1,0,   -- 7  **  **
					 0,  1, 1,0, 0,  1, 1,0,   -- 8  **  **
					 0,  1, 1,0, 0,  1, 1,0,   -- 9  **  **
					 0,  1, 1,0,  1, 1,0, 0,   -- a  ** **
					  1, 1, 1, 1, 1,0, 0, 0,   -- b *****
					 0, 0, 0, 0, 0, 0, 0, 0,   -- c
					 0, 0, 0, 0, 0, 0, 0, 0,   -- d
					 0, 0, 0, 0, 0, 0, 0, 0,   -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x45
					( 0, 0, 0, 0, 0, 0, 0, 0,   -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0,   --  1,
					  1, 1, 1, 1, 1, 1, 1,0,   -- 2 *******
					 0,  1, 1,0, 0,  1, 1,0,   -- 3  **  **
					 0,  1, 1,0, 0, 0,  1,0,   -- 4  **   *
					 0,  1, 1,0,  1,0, 0, 0,   -- 5  ** *
					 0,  1, 1, 1, 1,0, 0, 0,   -- 6  ****
					 0,  1, 1,0,  1,0, 0, 0,   -- 7  ** *
					 0,  1, 1,0, 0, 0, 0, 0,   -- 8  **
					 0,  1, 1,0, 0, 0,  1,0,   -- 9  **   *
					 0,  1, 1,0, 0,  1, 1,0,   -- a  **  **
					  1, 1, 1, 1, 1, 1, 1,0,   -- b *******
					 0, 0, 0, 0, 0, 0, 0, 0,   -- c
					 0, 0, 0, 0, 0, 0, 0, 0,   -- d
					 0, 0, 0, 0, 0, 0, 0, 0,   -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x46
					( 0, 0, 0, 0, 0, 0, 0, 0,   -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0,   --  1,
					  1, 1, 1, 1, 1, 1, 1,0,   -- 2 *******
					 0,  1, 1,0, 0,  1, 1,0,   -- 3  **  **
					 0,  1, 1,0, 0, 0,  1,0,   -- 4  **   *
					 0,  1, 1,0,  1,0, 0, 0,   -- 5  ** *
					 0,  1, 1, 1, 1,0, 0, 0,   -- 6  ****
					 0,  1, 1,0,  1,0, 0, 0,   -- 7  ** *
					 0,  1, 1,0, 0, 0, 0, 0,   -- 8  **
					 0,  1, 1,0, 0, 0, 0, 0,   -- 9  **
					 0,  1, 1,0, 0, 0, 0, 0,   -- a  **
					  1, 1, 1, 1,0, 0, 0, 0,   -- b ****
					 0, 0, 0, 0, 0, 0, 0, 0,   -- c
					 0, 0, 0, 0, 0, 0, 0, 0,   -- d
					 0, 0, 0, 0, 0, 0, 0, 0,   -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x47
					( 0, 0, 0, 0, 0, 0, 0, 0,   -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0,   --  1,
					 0, 0,  1, 1, 1, 1, 0, 0,   -- 2   ****
					 0,  1, 1,0, 0,  1, 1,0,   -- 3  **  **
					 1,  1, 0, 0, 0, 0,  1,0,   -- 4 **    *
					 1, 1,0, 0, 0, 0, 0, 0,   -- 5 **
					 1, 1,0, 0, 0, 0, 0, 0,   -- 6 **
					 1, 1,0,  1, 1, 1, 1,0,   -- 7 ** ****
					 1, 1,0, 0, 0,  1, 1,0, -- 8 **   **
					 1, 1,0, 0, 0,  1, 1,0, -- 9 **   **
					 0,  1, 1,0, 0,  1, 1,0, -- a  **  **
					 0, 0,  1, 1, 1,0,  1,0, -- b   *** *
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x48
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1,0, 0, 0,  1, 1,0, -- 2 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 3 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 4 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 5 **   **
					  1, 1, 1, 1, 1, 1, 1,0, -- 6 *******
					  1, 1,0, 0, 0,  1, 1,0, -- 7 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 8 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 9 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- a **   **
					  1, 1,0, 0, 0,  1, 1,0, -- b **   **
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x49
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					 0, 0,  1, 1, 1, 1,0, 0, -- 2   ****
					 0, 0, 0,  1, 1,0, 0, 0, -- 3    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 4    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 5    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 6    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 7    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 8    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 9    **
					 0, 0, 0,  1, 1,0, 0, 0, -- a    **
					 0, 0,  1, 1, 1, 1,0, 0, -- b   ****
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0), -- f
					-- code x4a
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					 0, 0, 0,  1, 1, 1, 1,0, -- 2    ****
					 0, 0, 0, 0,  1, 1,0, 0, -- 3     **
					 0, 0, 0, 0,  1, 1,0, 0, -- 4     **
					 0, 0, 0, 0,  1, 1,0, 0, -- 5     **
					 0, 0, 0, 0,  1, 1,0, 0, -- 6     **
					 0, 0, 0, 0,  1, 1,0, 0, -- 7     **
					  1, 1,0, 0,  1, 1,0, 0, -- 8 **  **
					  1, 1,0, 0,  1, 1,0, 0, -- 9 **  **
					  1, 1,0, 0,  1, 1,0, 0, -- a **  **
					 0,  1, 1, 1, 1,0, 0, 0, -- b  ****
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x4b
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1, 1,0, 0,  1, 1,0, -- 2 ***  **
					 0,  1, 1,0, 0,  1, 1,0, -- 3  **  **
					 0,  1, 1,0, 0,  1, 1,0, -- 4  **  **
					 0,  1, 1,0,  1, 1,0, 0, -- 5  ** **
					 0,  1, 1, 1, 1,0, 0, 0, -- 6  ****
					 0,  1, 1, 1, 1,0, 0, 0, -- 7  ****
					 0,  1, 1,0,  1, 1,0, 0, -- 8  ** **
					 0,  1, 1,0, 0,  1, 1,0, -- 9  **  **
					 0,  1, 1,0, 0,  1, 1,0, -- a  **  **
					  1, 1, 1,0, 0,  1, 1,0, -- b ***  **
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x4c
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1, 1, 1,0, 0, 0, 0, -- 2 ****
					 0,  1, 1,0, 0, 0, 0, 0, -- 3  **
					 0,  1, 1,0, 0, 0, 0, 0, -- 4  **
					 0,  1, 1,0, 0, 0, 0, 0, -- 5  **
					 0,  1, 1,0, 0, 0, 0, 0, -- 6  **
					 0,  1, 1,0, 0, 0, 0, 0, -- 7  **
					 0,  1, 1,0, 0, 0, 0, 0, -- 8  **
					 0,  1, 1,0, 0, 0,  1,0, -- 9  **   *
					 0,  1, 1,0, 0,  1, 1,0, -- a  **  **
					  1, 1, 1, 1, 1, 1, 1,0, -- b *******
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x4d
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1,0, 0, 0, 0,  1, 1,  -- 2 **    **
					  1, 1, 1,0, 0,  1, 1, 1,  -- 3 ***  ***
					  1, 1, 1, 1, 1, 1, 1, 1,  -- 4 ********
					  1, 1, 1, 1, 1, 1, 1, 1,  -- 5 ********
					  1, 1,0,  1, 1,0,  1, 1,  -- 6 ** ** **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 7 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 8 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 9 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- a **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- b **    **
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x4e
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1,0, 0, 0,  1, 1,0, -- 2 **   **
					  1, 1, 1,0, 0,  1, 1,0, -- 3 ***  **
					  1, 1, 1, 1,0,  1, 1,0, -- 4 **** **
					  1, 1, 1, 1, 1, 1, 1,0, -- 5 *******
					  1, 1,0,  1, 1, 1, 1,0, -- 6 ** ****
					  1, 1,0, 0,  1, 1, 1,0, -- 7 **  ***
					  1, 1,0, 0, 0,  1, 1,0, -- 8 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 9 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- a **   **
					  1, 1,0, 0, 0,  1, 1,0, -- b **   **
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x4f
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					 0,  1, 1, 1, 1, 1,0, 0, -- 2  *****
					  1, 1,0, 0, 0,  1, 1,0, -- 3 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 4 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 5 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 6 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 7 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 8 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 9 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- a **   **
					 0,  1, 1, 1, 1, 1,0, 0, -- b  *****
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x50, 
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1, 1, 1, 1, 1,0, 0, -- 2 ******
					 0,  1, 1,0, 0,  1, 1,0, -- 3  **  **
					 0,  1, 1,0, 0,  1, 1,0, -- 4  **  **
					 0,  1, 1,0, 0,  1, 1,0, -- 5  **  **
					 0,  1, 1, 1, 1, 1,0, 0, -- 6  *****
					 0,  1, 1,0, 0, 0, 0, 0, -- 7  **
					 0,  1, 1,0, 0, 0, 0, 0, -- 8  **
					 0,  1, 1,0, 0, 0, 0, 0, -- 9  **
					 0,  1, 1,0, 0, 0, 0, 0, -- a  **
					  1, 1, 1, 1,0, 0, 0, 0, -- b ****
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x5 1,0, 
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					 0,  1, 1, 1, 1, 1,0, 0, -- 2  *****
					  1, 1,0, 0, 0,  1, 1,0, -- 3 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 4 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 5 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 6 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 7 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 8 **   **
					  1, 1,0,  1,0,  1, 1,0, -- 9 ** * **
					  1, 1,0,  1, 1, 1, 1,0, -- a ** ****
					 0,  1, 1, 1, 1, 1,0, 0, -- b  *****
					 0, 0, 0, 0,  1, 1,0, 0, -- c     **
					 0, 0, 0, 0,  1, 1, 1,0, -- d     ***
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0), -- f
					-- code x52
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1, 1, 1, 1, 1,0, 0, -- 2 ******
					 0,  1, 1,0, 0,  1, 1,0, -- 3  **  **
					 0,  1, 1,0, 0,  1, 1,0, -- 4  **  **
					 0,  1, 1,0, 0,  1, 1,0, -- 5  **  **
					 0,  1, 1, 1, 1, 1,0, 0, -- 6  *****
					 0,  1, 1,0,  1, 1,0, 0, -- 7  ** **
					 0,  1, 1,0, 0,  1, 1,0, -- 8  **  **
					 0,  1, 1,0, 0,  1, 1,0, -- 9  **  **
					 0,  1, 1,0, 0,  1, 1,0, -- a  **  **
					  1, 1, 1,0, 0,  1, 1,0, -- b ***  **
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x53
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					 0,  1, 1, 1, 1, 1,0, 0, -- 2  *****
					  1, 1,0, 0, 0,  1, 1,0, -- 3 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 4 **   **
					 0,  1, 1,0, 0, 0, 0, 0, -- 5  **
					 0, 0,  1, 1, 1,0, 0, 0, -- 6   ***
					 0, 0, 0, 0,  1, 1,0, 0, -- 7     **
					 0, 0, 0, 0, 0,  1, 1,0, -- 8      **
					  1, 1,0, 0, 0,  1, 1,0, -- 9 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- a **   **
					 0,  1, 1, 1, 1, 1,0, 0, -- b  *****
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x54
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1, 1, 1, 1, 1, 1, 1,  -- 2 ********
					  1, 1,0,  1, 1,0,  1, 1,  -- 3 ** ** **
					  1,0, 0,  1, 1,0, 0,  1,  -- 4 *  **  *
					 0, 0, 0,  1, 1,0, 0, 0, -- 5    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 6    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 7    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 8    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 9    **
					 0, 0, 0,  1, 1,0, 0, 0, -- a    **
					 0, 0,  1, 1, 1, 1,0, 0, -- b   ****
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0), -- f
					-- code x55
					 (0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1,0, 0, 0,  1, 1,0, -- 2 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 3 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 4 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 5 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 6 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 7 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 8 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- 9 **   **
					  1, 1,0, 0, 0,  1, 1,0, -- a **   **
					 0,  1, 1, 1, 1, 1,0, 0, -- b  *****
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x56
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1,0, 0, 0, 0,  1, 1,  -- 2 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 3 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 4 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 5 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 6 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 7 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 8 **    **
					 0,  1, 1,0, 0,  1, 1,0, -- 9  **  **
					 0, 0,  1, 1, 1, 1,0, 0, -- a   ****
					 0, 0, 0,  1, 1,0, 0, 0, -- b    **
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x57
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1,0, 0, 0, 0,  1, 1,  -- 2 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 3 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 4 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 5 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 6 **    **
					  1, 1,0,  1, 1,0,  1, 1,  -- 7 ** ** **
					  1, 1,0,  1, 1,0,  1, 1,  -- 8 ** ** **
					  1, 1, 1, 1, 1, 1, 1, 1,  -- 9 ********
					 0,  1, 1,0, 0,  1, 1,0, -- a  **  **
					 0,  1, 1,0, 0,  1, 1,0, -- b  **  **
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f

					-- code x58
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1,0, 0, 0, 0,  1, 1,  -- 2 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 3 **    **
					 0,  1, 1,0, 0,  1, 1,0, -- 4  **  **
					 0, 0,  1, 1, 1, 1,0, 0, -- 5   ****
					 0, 0, 0,  1, 1,0, 0, 0, -- 6    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 7    **
					 0, 0,  1, 1, 1, 1,0, 0, -- 8   ****
					 0,  1, 1,0, 0,  1, 1,0, -- 9  **  **
					  1, 1,0, 0, 0, 0,  1, 1,  -- a **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- b **    **
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x59
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1,0, 0, 0, 0,  1, 1,  -- 2 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 3 **    **
					  1, 1,0, 0, 0, 0,  1, 1,  -- 4 **    **
					 0,  1, 1,0, 0,  1, 1,0, -- 5  **  **
					 0, 0,  1, 1, 1, 1,0, 0, -- 6   ****
					 0, 0, 0,  1, 1,0, 0, 0, -- 7    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 8    **
					 0, 0, 0,  1, 1,0, 0, 0, -- 9    **
					 0, 0, 0,  1, 1,0, 0, 0, -- a    **
					 0, 0,  1, 1, 1, 1,0, 0, -- b   ****
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ), -- f
					-- code x5a
					( 0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  1,
					  1, 1, 1, 1, 1, 1, 1, 1,  -- 2 ********
					  1, 1,0, 0, 0, 0,  1, 1,  -- 3 **    **
					  1,0, 0, 0, 0,  1, 1,0, -- 4 *    **
					 0, 0, 0, 0,  1, 1,0, 0, -- 5     **
					 0, 0, 0,  1, 1,0, 0, 0, -- 6    **
					 0, 0,  1, 1,0, 0, 0, 0, -- 7   **
					 0,  1, 1,0, 0, 0, 0, 0, -- 8  **
					  1, 1,0, 0, 0, 0, 0,  1,  -- 9 **     *
					  1, 1,0, 0, 0, 0,  1, 1,  -- a **    **
					  1, 1, 1, 1, 1, 1, 1, 1,  -- b ********
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ),
					 -- tra�o
					(0, 0, 0, 0, 0, 0, 0, 0, -- 0, 
					 0, 0, 0, 0, 0, 0, 0, 0, --  0,
					 0, 0,0, 0, 0, 0,  0, 0,  -- 2 
					 0, 0,0, 0, 0, 0,  0, 0,  -- 3 
					 0, 0,0, 0, 0, 0,  0, 0,  -- 4
					 0, 0,0, 0, 0, 0,  0, 0,  -- 4
					 0, 0,  0, 0, 0, 0,0, 0, -- 6  
					 0,  1, 1,1, 1,  1, 1,0, -- 5  
					 0,  1, 1,1, 1,  1, 1,0, -- 5  
					 0, 0, 0,  0, 0,0, 0, 0, -- 9   
					 0, 0, 0,  0, 0,0, 0, 0, -- a   
					 0, 0,  0, 0, 0, 0,0, 0, -- b   
					 0, 0, 0, 0, 0, 0, 0, 0, -- c
					 0, 0, 0, 0, 0, 0, 0, 0, -- d
					 0, 0, 0, 0, 0, 0, 0, 0, -- e
					 0, 0, 0, 0, 0, 0, 0, 0  ) -- f
					 ); -- f
					-- code x5b)

--Desenho link
type T_BSPRITE is array(0 to 99) of integer range 0 to 9;

constant flap_sprite : T_BSPRITE :=--Saltar (cabelo amarelo)
			    (0,0,0,0,0,1,1,1,1,0,
				 0,0,0,0,9,9,9,1,1,1,
				 0,0,0,9,9,9,9,9,1,1,
				 9,0,9,6,1,6,9,6,1,1,
				 0,9,0,6,6,6,6,6,0,1,
				 0,9,0,6,6,6,1,1,0,0,
				 0,6,6,9,1,1,1,1,0,0,
				 0,0,0,0,1,1,6,6,0,0,
				 0,0,0,0,1,1,6,6,0,0,
				 0,0,0,0,0,9,9,9,0,0);


constant shuri_sprite : T_BSPRITE :=--normal (cabelo preto)
				(0,2,2,2,2,0,0,0,0,0,
				 2,2,2,3,3,3,3,0,0,0,
				 2,2,3,3,3,3,3,0,0,0,
				 2,2,6,3,6,2,6,8,0,8,
				 2,0,6,6,6,6,6,0,8,0,
				 0,0,2,2,6,6,6,0,8,0,
				 0,0,2,2,2,2,2,6,6,0,
				 0,0,6,6,2,2,0,0,0,0,
				 0,0,6,6,2,2,0,0,0,0,
				 0,0,3,3,3,0,0,0,0,0);
				 
constant shuriken_A : T_BSPRITE :=
				(0,0,0,0,9,0,0,0,0,0,
				 0,0,0,0,9,9,0,0,0,0,
				 0,0,0,0,9,9,0,0,0,0,
				 0,0,0,9,9,9,9,0,0,0,
				 0,9,9,9,0,0,9,9,9,9,
				 9,9,9,9,0,0,9,9,9,0,
				 0,0,0,9,9,9,9,0,0,0,
				 0,0,0,0,9,9,0,0,0,0,
				 0,0,0,0,9,9,0,0,0,0,
				 0,0,0,0,0,9,0,0,0,0);
				 
constant shuriken_B : T_BSPRITE :=
				(9,9,0,0,0,0,0,0,9,9,
				 9,9,9,0,0,0,0,9,9,9,
				 0,9,9,9,9,9,9,9,9,0,
				 0,0,9,9,0,0,9,9,0,0,
				 0,0,9,0,0,0,0,9,0,0,
				 0,0,9,0,0,0,0,9,0,0,
				 0,0,9,9,0,0,9,9,0,0,
				 0,9,9,9,9,9,9,9,9,0,
				 9,9,9,0,0,0,0,9,9,9,
				 9,9,0,0,0,0,0,0,9,9);		
				 		
constant forca_estrutura : T_BSPRITE :=
				(0,0,0,4,4,4,0,0,0,0,
				 0,0,0,4,0,4,0,0,0,0,
				 0,0,0,4,0,4,0,0,0,0,
				 0,0,0,4,0,4,0,0,0,0,
				 0,0,0,4,0,4,0,0,0,0,
				 0,0,0,4,0,4,0,0,0,0,
				 0,0,0,4,0,4,0,0,0,0,
				 0,0,0,4,0,4,0,0,0,0,
				 0,0,0,4,0,4,0,0,0,0,
				 0,0,0,4,4,4,0,0,0,0);	

type T_FARRAY is array(0 to 9, 0 to 63) of integer range 0 to 1;--numeros de 1 a 9
constant font_array : T_FARRAY := 
			  (( 0, 4, 4, 4, 4, 4, 4, 0,	-- 0
				 0, 4, 4, 4, 4, 4, 4, 0,
				 0, 4, 4, 0, 0, 4, 4, 0,
				 0, 4, 4, 0, 0, 4, 4, 0,
				 0, 4, 4, 0, 0, 4, 4, 0,
				 0, 4, 4, 0, 0, 4, 4, 0,
				 0, 4, 4, 4, 4, 4, 4, 0,
				 0, 4, 4, 4, 4, 4, 4, 0),
				 
				(0, 0, 0, 4, 4, 0, 0, 0,  -- 1
				 0, 0, 4, 4, 4, 0, 0, 0,
				 0, 4, 0, 4, 4, 0, 0, 0,
				 0, 0, 0, 4, 4, 0, 0, 0,
				 0, 0, 0, 4, 4, 0, 0, 0,
				 0, 0, 0, 4, 4, 0, 0, 0,
				 0, 4, 4, 4, 4, 4, 4, 0,
				 0, 4, 4, 4, 4, 4, 4, 0),
				 
				(0, 0, 0, 4, 4, 4, 0, 0,	-- 2
				 0, 0, 4, 4, 0, 4, 4, 0,
				 0, 4, 4, 0, 4, 4, 0, 0,
				 0, 0, 0, 4, 4, 0, 0, 0,
				 0, 0, 4, 4, 0, 0, 0, 0,
				 0, 4, 4, 0, 0, 0, 0, 0,
				 0, 4, 4, 4, 4, 4, 0, 0,
				 0, 0, 4, 4, 4, 4, 0, 0),
				 
				(0, 4, 4, 4, 4, 4, 0, 0,  -- 3
				 0, 4, 4, 4, 4, 4, 0, 0,
				 0, 0, 0, 0, 4, 4, 0, 0,
				 0, 0, 4, 4, 4, 4, 0, 0,
				 0, 0, 4, 4, 4, 4, 0, 0,
				 0, 0, 0, 0, 4, 4, 0, 0,
				 0, 4, 4, 4, 4, 4, 0, 0,
				 0, 4, 4, 4, 4, 4, 0, 0),
				 
				(0, 0, 0, 0, 4, 4, 4, 0, 	-- 4
			     0, 0, 0, 4, 4, 4, 4, 0, 
			     0, 0, 4, 4, 0, 4, 4, 0, 
			     0, 4, 4, 0, 0, 4, 4, 0, 
			     0, 4, 4, 4, 4, 4, 4, 0,
			     0, 0, 4, 4, 4, 4, 4, 0,
			     0, 0, 0, 0, 0, 4, 4, 0,
			     0, 0, 0, 0, 0, 4, 4, 0),
				 
				(0, 0, 4, 4, 4, 4, 0, 0,  -- 5
				 0, 0, 4, 4, 4, 4, 0, 0,
				 0, 0, 4, 0, 0, 0, 0, 0,
				 0, 0, 4, 4, 4, 4, 0, 0,
				 0, 0, 4, 4, 4, 4, 0, 0,
				 0, 0, 0, 0, 4, 4, 0, 0,
				 0, 0, 4, 4, 4, 4, 0, 0,
				 0, 0, 4, 4, 4, 0, 0, 0),
				 
			    (0, 0, 0, 0, 4, 4, 0, 0,  -- 6
			     0, 0, 0, 4, 4, 0, 0, 0,
			     0, 0, 4, 4, 0, 0, 0, 0,
			     0, 0, 4, 4, 0, 0, 0, 0,
			     0, 0, 4, 4, 4, 4, 0, 0,
			     0, 0, 4, 4, 0, 4, 4, 0,
			     0, 0, 4, 4, 0, 4, 4, 0,
			     0, 0, 0, 4, 4, 4, 0, 0),
				 
				(0, 0, 4, 4, 4, 4, 4, 0,	-- 7
				 0, 0, 0, 0, 0, 0, 4, 0,
				 0, 0, 0, 0, 0, 4, 0, 0,
				 0, 0, 0, 0, 4, 0, 0, 0,
				 0, 0, 0, 4, 0, 0, 0, 0,
				 0, 0, 4, 0, 0, 0, 0, 0,
				 0, 0, 4, 0, 0, 0, 0, 0,
				 0, 0, 4, 0, 0, 0, 0, 0),
				 
				(0, 0, 0, 4, 4, 0, 0, 0,  -- 8
				 0, 0, 4, 4, 4, 4, 0, 0,
				 0, 0, 4, 0, 0, 4, 0, 0,
				 0, 0, 0, 4, 4, 0, 0, 0,
				 0, 0, 0, 4, 4, 0, 0, 0,
				 0, 0, 4, 0, 0, 4, 0, 0,
				 0, 0, 4, 4, 4, 4, 0, 0,
				 0, 0, 0, 4, 4, 0, 0, 0),
				 
			    (0, 0, 0, 4, 4, 4, 4, 0,	-- 9
			     0, 0, 0, 4, 4, 4, 4, 0,
			     0, 0, 4, 4, 0, 4, 4, 0,
			     0, 0, 4, 4, 0, 4, 4, 0,
			     0, 0, 0, 4, 4, 4, 4, 0,
			     0, 0, 0, 4, 4, 4, 4, 0,
			     0, 0, 0, 0, 0, 4, 4, 0,
			     0, 0, 0, 0, 0, 4, 4, 0)
				);
				
begin
  --limites do shuri
  shuri_on_proc : process (shuriX, shuriY, DrawX, DrawY, shuri_size)
  begin
    if (DrawX >= shuriX and DrawX <= shuriX + shuri_size and DrawY >= shuriY and DrawY <= shuriY + shuri_size) then
      shuri_on <= '1'; --desenha o shuri
    else
      shuri_on <= '0';
    end if;
  end process shuri_on_proc;
  
  --limites dos dlinks
   Pipe_on_proc : process (dlink1_Left, dlink1_Top, DrawX, DrawY, dlink_Width)
  begin
    --dlink1
    if (DrawX >= dlink1_Left and DrawX <= dlink1_Left + dlink_Width and DrawY <= dlink1_Top + dlink_width and DrawY >= dlink1_top) then
		dlink1_on <= '1';--desenha dlink1
	 else
        dlink1_on <= '0';
    end if;
    
	 
  end process Pipe_on_proc;
  
  
--foram usadas layers para dividir os objectos no ecra

 do_map : process ( Estado_Start_Game, Estado_Quit_Game, Estado_Main_menu,shuri_on, dlink1_on, dlink1_Left,  
					dlink1_Top, shuriX, shuriY, DrawX, DrawY, animacao, score, dlink_Width)
     
     variable xpixel, ypixel : integer range 0 to 30;
	 variable digit : integer range 0 to 26; --score
	 variable color: integer range 0 to 9; --cor
  begin
  color := 0; 
  
 ---------------------------------------------------------------------------------------------  
-- Layer inferior -- cor de fundo
	if ( DrawY >= relva ) then
	color := 2; -- cor de fundo verde

-- desenhar o ceu azul	
	else
	color := 5;
	end if;
	
-- Desenhar o link no inicio
	if(DrawX >= Link_Left and DrawX < Link_Left + shuri_size and DrawY >= Link_Top and 
	   DrawY <= Link_Top + shuri_size) then 
			if((DrawX - Link_Left) <27) then
				xpixel := (CONV_INTEGER((DrawX - Link_Left)) / 3); -- 
			else 
				xpixel := 9;
			end if;
		if((DrawY - Link_Top) < 27) then
				ypixel := (CONV_INTEGER((DrawY-Link_Top)) /3 ); -- 
			else 
				ypixel := 9;
		end if;
			if (shuri_sprite(xpixel + 10 * ypixel) /= 0) then
				color := shuri_sprite(xpixel + 10 * ypixel); -- not flapping sprite
			else
				color := color; -- transparente
			
			end if;
	end if;	
	
	
 ---------------------------------------------------------------------------------------------		
-- 2a Layer -- dlinks -------------------------------------------------------------------------

		if(dlink1_on = '1') then--atribuicoes dlink1
				
					if((DrawX - dlink1_left) <27) then
						xpixel := (CONV_INTEGER((DrawX - dlink1_left)) / 3); -- 1 cor por 5 x-pixels
					else 
						xpixel := 9;
					end if;
					if((DrawY - dlink1_top) < 27) then
						ypixel := (CONV_INTEGER((DrawY-dlink1_top)) /3 ); -- 1 cor por 5 y-pixels
						else 
						ypixel := 9;
					end if;
					if(animacao = "00") then
						if (flap_sprite(xpixel + 10 * ypixel) /= 0) then
							color := flap_sprite(xpixel + 10 * ypixel); -- not flapping sprite
						else
							color := color; -- transparente
						end if;
					else
						if (flap_sprite(xpixel + 10 * ypixel) /= 0) then -- flapping sprite
							color :=flap_sprite(xpixel + 10 * ypixel);
						else
							color := color; -- transparente
					end if;
				end if;
		end if;
		

 ----------------------------------------------------------------------------------------------------------------------------------------------
-- 3a layer -- Score --------------------------------------------------------------------------------------------------------------------------
			if(DrawX >= Score_Right and DrawX <= Score_Right + Font_Width and DrawY >= Score_Top and DrawY <= Score_Top + Font_Height) then
			digit := (CONV_INTEGER(score) / 100) mod 10;--para o digito das centenas "0--"
			xpixel := CONV_INTEGER(signed(DrawX - Score_Right));
			ypixel := CONV_INTEGER(signed(DrawY - Score_Top));
			if (Font_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := Font_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width);--nao transparente
			else
				color := color; --transparente
			end if;
	 end if;
			
	 if(DrawX >= Score_Right + Font_Width and DrawX <= Score_Right + 2 * Font_Width and DrawY >= Score_Top and DrawY <= Score_Top + Font_Height) then
			digit := (CONV_INTEGER(score) / 10) mod 10;--digito das dezenas "-0-"
			xpixel := CONV_INTEGER(signed(DrawX - Score_Right - Font_Width));
			ypixel := CONV_INTEGER(signed(DrawY - Score_Top));
			if (Font_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := Font_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width);--nao transparente
			else
				color := color;--transparente
			end if;
	 end if;
			
		if(DrawX >= Score_Right + 2 * Font_Width and DrawX <= Score_Right + 3 * Font_Width and DrawY >= Score_Top and DrawY <= Score_Top + Font_Height) then
			digit := CONV_INTEGER(score) mod 10;--digito das unidades "--0"
			xpixel := CONV_INTEGER(signed(DrawX - Score_Right - Font_Width));
			ypixel := CONV_INTEGER(signed(DrawY - Score_Top)-1);--
			if (Font_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := Font_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width);--nao transparente
			else
				color := color;--transparente
			end if;
		end if;
		
----------------------------------------------------------------------------------------------------------
    


if(Estado_Start_Game = '1' or Estado_Quit_Game = '1') then
--layer de cima -- shuriken ----------------------------------------------------------------------------------  

----------------------------------------------------------------
if (shuri_on = '1') then -- o pixel actual esta onde o shuri esta
	 		
		if((DrawX - shuriX) <27) then
			xpixel := (CONV_INTEGER((DrawX - shuriX)) / 3); -- 1 cor por 5 x-pixels
		else 
			xpixel := 9;
		end if;
		if((DrawY - shuriY) < 27) then
			ypixel := (CONV_INTEGER((DrawY-shuriY)) /3 ); -- 1 cor por 5 y-pixels
			else 
			ypixel := 9;
		end if;
		if(animacao = "00") then
			if (shuriken_A(xpixel + 10 * ypixel) /= 0) then
				color := shuriken_A(xpixel + 10 * ypixel); -- not flapping sprite
			else
				color := color; -- transparente
			end if;
		else
			if (shuriken_A(xpixel + 10 * ypixel) /= 0) then -- flapping sprite
				color :=shuriken_A(xpixel + 10 * ypixel);
			else
				color := color; -- transparente
		end if;
	end if;
end if;

-----------------------------------------------
-- se come�ou o jogo tem o tube da forca atras

	if((DrawX >= CONV_STD_LOGIC_VECTOR(15, 10) and DrawX <= CONV_STD_LOGIC_VECTOR(18, 10) and 
	DrawY >= CONV_STD_LOGIC_VECTOR(280, 10) and DrawY <= CONV_STD_LOGIC_VECTOR(360, 10)) or --barra esquerda
	(DrawX >= CONV_STD_LOGIC_VECTOR(15, 10) and DrawX <= CONV_STD_LOGIC_VECTOR(40, 10) and 
	DrawY >= CONV_STD_LOGIC_VECTOR(280, 10) and DrawY <= CONV_STD_LOGIC_VECTOR(283, 10)) or -- barra de cima
	(DrawX >= CONV_STD_LOGIC_VECTOR(15, 10) and DrawX <= CONV_STD_LOGIC_VECTOR(40, 10) and 
	DrawY >= CONV_STD_LOGIC_VECTOR(357, 10) and DrawY <= CONV_STD_LOGIC_VECTOR(360, 10)) or --barra de baixo
	(DrawX >= CONV_STD_LOGIC_VECTOR(37, 10) and DrawX <= CONV_STD_LOGIC_VECTOR(40, 10) and 
	DrawY >= CONV_STD_LOGIC_VECTOR(280, 10) and DrawY <= CONV_STD_LOGIC_VECTOR(360, 10))) then 
		color:= 4;
	end if;	



	if(DrawX > CONV_STD_LOGIC_VECTOR(18, 10) and DrawX < CONV_STD_LOGIC_VECTOR(37, 10) and 
	DrawY >= CONV_STD_LOGIC_VECTOR(357 - (7 * CONV_INTEGER(forca)), 10)  and DrawY <= CONV_STD_LOGIC_VECTOR(357, 10)) then
		color:= 1; 
	end if;




end if;
-- Estado Main menu-----------------------------------------------------------------------------------------------------------


	
	

if(Estado_Main_menu = '1') then -- ecra de Main Menu
	
	if(DrawX >= Message_Left_shuri and DrawX < Message_Left_shuri + Font_Width*Font_Mult_Factor and DrawY >= Message_top_shuri and 
	   DrawY <= Message_top_shuri + 16*Font_Mult_Factor) then -- font2_height * 5
			digit := 18; -- letra S
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left_shuri))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top_shuri))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
	 
	 
	 	elsif(DrawX >= Message_Left_shuri + Font_width*Font_Mult_Factor and DrawX < Message_Left_shuri + Font_Width*2*Font_Mult_Factor and 
			  DrawY >= Message_top_shuri and DrawY <= Message_top_shuri + 16*Font_Mult_Factor) then -- font2_height *5
				digit := 7; -- letra H
				xpixel := (CONV_INTEGER(signed(DrawX - Message_Left_shuri - Font_width*Font_Mult_Factor))/Font_Mult_Factor);
				ypixel := (CONV_INTEGER(signed(DrawY - Message_top_shuri))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
		
			
		elsif(DrawX >= Message_Left_shuri + Font_width * 2 *Font_Mult_Factor and DrawX < Message_Left_shuri + Font_Width*3*Font_Mult_Factor and 
		      DrawY >= Message_top_shuri and DrawY <= Message_top_shuri + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 20; -- letra u
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left_shuri - 2*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top_shuri))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
		
		
		elsif(DrawX >= Message_Left_shuri + Font_width * 3 *Font_Mult_Factor and DrawX < Message_Left_shuri + Font_Width*4*Font_Mult_Factor and 
		      DrawY >= Message_top_shuri and DrawY <= Message_top_shuri + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 17; -- letra R
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left_shuri - 3*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top_shuri))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
		
		
		elsif(DrawX >= Message_Left_shuri + Font_width * 4 *Font_Mult_Factor and DrawX < Message_Left_shuri + Font_Width*5*Font_Mult_Factor and  
		      DrawY >= Message_top_shuri and DrawY <= Message_top_shuri + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 8; --letra I
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left_shuri - 4*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top_shuri))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
		
		
		elsif(DrawX >= Message_Left_shuri + Font_width * 5*Font_Mult_Factor and DrawX < Message_Left_shuri + Font_Width*6*Font_Mult_Factor and 
		      DrawY >= Message_top_shuri and DrawY <= Message_top_shuri + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 26; -- -
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left_shuri - 5*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top_shuri))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
		
		
		elsif(DrawX >= Message_Left_shuri + Font_width * 6*Font_Mult_Factor and DrawX < Message_Left_shuri + Font_Width*7*Font_Mult_Factor and 
		      DrawY >= Message_top_shuri and DrawY <= Message_top_shuri + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 11; --letra L
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left_shuri - 6*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top_shuri))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
		
		
		elsif(DrawX >= Message_Left_shuri + Font_width * 7*Font_Mult_Factor and DrawX < Message_Left_shuri + Font_Width*8*Font_Mult_Factor and 
		      DrawY >= Message_top_shuri and DrawY <= Message_top_shuri + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 8; --letra I
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left_shuri - 7*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top_shuri))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4 ;
			else
				color := color;
			end if;
			
		elsif(DrawX >= Message_Left_shuri + Font_width * 8*Font_Mult_Factor and DrawX < Message_Left_shuri + Font_Width*9*Font_Mult_Factor and 
		      DrawY >= Message_top_shuri and DrawY <= Message_top_shuri + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 13; --letra N
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left_shuri - 8*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top_shuri))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4 ;
			else
				color := color;
			end if;
			
		elsif(DrawX >= Message_Left_shuri + Font_width * 9*Font_Mult_Factor and DrawX < Message_Left_shuri + Font_Width*10*Font_Mult_Factor and 
		      DrawY >= Message_top_shuri and DrawY <= Message_top_shuri + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 10; --letra K
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left_shuri - 9*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top_shuri))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4 ;
			else
				color := color;
			end if;
			
		end if;
	
	end if;
	
	 if(Estado_Quit_Game = '1') then -- ecra de Game Over
	
	if(DrawX >= Message_Left and DrawX < Message_Left + Font_Width*Font_Mult_Factor and DrawY >= Message_top and 
	   DrawY <= Message_top + 16*Font_Mult_Factor) then -- font2_height * 5
			digit := 6; -- letra G
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
	 
	 
	 	elsif(DrawX >= Message_Left + Font_width*Font_Mult_Factor and DrawX < Message_Left + Font_Width*2*Font_Mult_Factor and 
			  DrawY >= Message_top and DrawY <= Message_top + 16*Font_Mult_Factor) then -- font2_height *5
				digit := 0; -- letra A
				xpixel := (CONV_INTEGER(signed(DrawX - Message_Left - Font_width*Font_Mult_Factor))/Font_Mult_Factor);
				ypixel := (CONV_INTEGER(signed(DrawY - Message_top))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then --letra A digit=0
				color := 4;
			else
				color := color;
			end if;
		
			
		elsif(DrawX >= Message_Left + Font_width * 2 *Font_Mult_Factor and DrawX < Message_Left + Font_Width*3*Font_Mult_Factor and 
		      DrawY >= Message_top and DrawY <= Message_top + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 12; -- letra M
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left - 2*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
		
		
		elsif(DrawX >= Message_Left + Font_width * 3 *Font_Mult_Factor and DrawX < Message_Left + Font_Width*4*Font_Mult_Factor and 
		      DrawY >= Message_top and DrawY <= Message_top + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 4; -- letra E
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left - 3*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
		
		
		elsif(DrawX >= Message_Left + Font_width * 5 *Font_Mult_Factor and DrawX < Message_Left + Font_Width*6*Font_Mult_Factor and  
		      DrawY >= Message_top and DrawY <= Message_top + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 14; --letra O
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left - 5*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
		
		
		elsif(DrawX >= Message_Left + Font_width * 6*Font_Mult_Factor and DrawX < Message_Left + Font_Width*7*Font_Mult_Factor and 
		      DrawY >= Message_top and DrawY <= Message_top + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 21; -- letra V
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left - 6*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
		
		
		elsif(DrawX >= Message_Left + Font_width * 7*Font_Mult_Factor and DrawX < Message_Left + Font_Width*8*Font_Mult_Factor and 
		      DrawY >= Message_top and DrawY <= Message_top + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 4; --letra E
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left - 7*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4;
			else
				color := color;
			end if;
		
		
		elsif(DrawX >= Message_Left + Font_width * 8*Font_Mult_Factor and DrawX < Message_Left + Font_Width*9*Font_Mult_Factor and 
		      DrawY >= Message_top and DrawY <= Message_top + 16*Font_Mult_Factor) then -- font2_height *5
			digit := 17; --letra R
			xpixel := (CONV_INTEGER(signed(DrawX - Message_Left - 8*Font_width*Font_Mult_Factor))/Font_Mult_Factor);
			ypixel := (CONV_INTEGER(signed(DrawY - Message_top))/Font_Mult_Factor);
			if (letters_array(CONV_INTEGER(digit), xpixel + ypixel * Font_Width) /= 0) then
				color := 4 ;
			else
				color := color;
			end if;
		end if;
	
	end if;
				
-- MAIN MENU FIM ------------------------------------------------------------------------------------------------------------


-- "GAME OVER" --------------------------------------------------------------------------------------------------------------

				
-- END GAME OVER -------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
	
 -- 0 Transparent
-- 1 Red
-- 2 Green
-- 3 Yellow
-- 4 White
-- 5 Blue
-- 6 Orange
-- 7 Grey Lighter
-- 8 Grey Darker
-- 9 Black

		case color is
				when 0 =>
						for I in 0 to 9 loop
							Red(I) <= '1'; -- Transparent
							Green(I) <= '1';
							Blue(I) <= '1';
						end loop;
							 
					
				when 1 => 	 
						for I in 0 to 9 loop
							Red(I) <= '1'; -- red
							Green(I) <= '0';
							Blue(I) <= '0';
						end loop;
							 
				when 2 =>   
						for I in 0 to 9 loop
							Red(I) <= '0'; -- green
							Green(I) <= '1';
							Blue(I) <= '0';
						end loop;
							 
				when 3 => 	 
						for I in 0 to 9 loop
							Red(I) <= '1'; -- amarelo
							Green(I) <= '1';
							Blue(I) <= '0';
						end loop;
				when 4 =>                       -- White
						for I in 0 to 9 loop
							Red(I) <= '1'; -- Transparent
							Green(I) <= '1';
							Blue(I) <= '1';
						end loop;
				when 5 =>      					-- skyblue 
							Red   <= b"0000000000";
							 Green <= b"1011111111";
							 Blue  <= b"1111111111";
							
				when 6 =>      					-- cor selec cor pele
							 Red   <= b"1111111111";
							 Green <= b"1100011110";
							 Blue  <= b"1010111000";			 

				when 8 =>  						-- cor selec castanho
							 Red   <= b"0110010001";
							 Green <= b"0011100100";
							 Blue  <= b"0001001100";		
							 	 			 							
				
				when others =>  -- black
							for I in 0 to 9 loop
							Red(I) <= '0'; -- Transparent
							Green(I) <= '0';
							Blue(I) <= '0';
						end loop;
							 
			end case;

end process do_map;
end Behavioral;