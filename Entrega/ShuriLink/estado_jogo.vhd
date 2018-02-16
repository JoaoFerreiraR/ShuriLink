library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Pause -- pause the game
-- Quit -- Quit the game
-- Start -- Game is running
-- Main Menu -- Main Menu Screen
entity estado_jogo is
	Port (Frame_Clk : in std_logic;
			Pause_sig : in std_logic; --sinal pause
			Reset_Sig: in std_logic; --sinal reset
			Start_Sig : in std_logic; --sinal start
			Quit_Sig : in std_logic; --sinal quit
			collision: in std_logic; --colisao
			Pause_estado: out std_logic; --pause
			Quit_estado:	out std_logic; -- estado quit
			Start_estado: out std_logic; --estado start
			Main_Menu_estado: out std_logic); --estado menu
end estado_jogo;

architecture Behavioral of estado_jogo is
	-- inicia com:
	signal need_quit : std_logic := '0'; --aguarda pelo quit
	signal need_pause : std_logic := '0'; --aguarda pelo pause
	signal need_start : std_logic := '0'; --aguarda pelo start
	signal need_main_menu : std_logic := '0';  -- aguarda pelo menu
	signal is_pause : std_logic := '0'; --pausa desativado
	signal is_quit : std_logic := '0'; --quit desativado
	signal is_main_menu : std_logic := '1'; --menu ativado
	signal is_start : std_logic := '0'; -- start desativado
	signal one_time : std_logic := '0'; -- garante que so faz um ciclo
	
	
	begin
	update_goku: process(collision, Frame_Clk, Reset_sig, Start_sig, Quit_sig, pause_sig, is_pause, is_quit, is_main_menu, is_start, need_pause, need_quit, need_main_menu, need_start )
	begin
	if(Reset_sig='1') then
	-- ao pressionar reset o main menu fica ativo
		Main_Menu_estado <= '1';
		is_main_menu <= '1';
		need_main_menu <= '0';
		Pause_estado <= '0';
		is_pause <= '0';
		need_pause <= '0';
		Quit_estado <= '0';
		is_quit <= '0';
		need_quit <= '0';
		Start_estado <= '0';
		is_start <= '0';
		need_start <= '0';
		one_time <= '0';

	elsif(is_main_menu = '1' and start_sig = '1') then -- esta no main menu e aguarda o sinal de start
		need_main_menu <= '0';
		need_quit <= '0';
		need_start <= '1';
		need_pause <= '0';
		quit_estado <= '0';

	elsif(is_start = '1' and pause_sig = '1') then -- o start esta ativo e aguarda sinal de pausa
		need_main_menu <= '0';
		need_quit <= '0';
		need_start <= '0';
		need_pause <= '1';

	elsif(is_start = '1' and quit_sig = '1') then -- o start esta ativo e aguarda o sinal de quit
		need_main_menu <= '0';
		need_quit <= '1';
		need_start <= '0';
		need_pause <= '0';

	elsif (is_pause = '1' and pause_sig = '1') then -- esta em pausa e aguarda o sinal de start
		need_main_menu <= '0';
		need_quit <= '0';
		need_start <= '1';
		need_pause <= '0';

	elsif (is_pause = '1' and quit_sig = '1') then -- esta em pausa e aguarda o sinal de quit
		need_main_menu <= '0';
		need_quit <= '1';
		need_start <= '0';
		need_pause <= '0';

	elsif (is_quit = '1' and start_sig = '1') then -- quit ativo aguarda pelo sinal de start
		need_main_menu <= '1';
		need_quit <= '0';
		need_start <= '0';
		need_pause <= '0';


	elsif(rising_edge(Frame_Clk)) then
		if(need_main_menu = '1') then
			need_main_menu <= '0';
			one_time <= '0'; -- garante so um ciclo
			is_main_menu <= '1';
			is_Quit <= '0';
			is_pause <= '0';
			is_start <= '0';

		elsif(need_start = '1') then -- pressionado o start
			need_start <= '0';
			is_main_menu <= '0';
			is_Quit <= '0';
			is_pause <= '0';
			is_start <= '1';


		elsif((need_quit = '1' or collision = '1') and one_time = '0') then
			need_quit <= '0';
			one_time <= '1'; -- fez o ciclo
			is_main_menu <= '0';
			is_Quit <= '1';
			is_pause <= '0';
			is_start <= '0';

		elsif(need_pause = '1') then
			need_pause <= '0';
			is_main_menu <= '0';
			is_Quit <= '0';
			is_pause <= '1';
			is_start <= '0';


		end if;

		else

		end if;

		Pause_estado <= is_pause;
		Quit_estado <= is_Quit;
		Main_menu_estado <= is_main_menu;
		Start_estado <= is_start;

	end process;
end Behavioral;
