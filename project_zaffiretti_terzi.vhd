library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    Port ( 
        i_clk     : in std_logic;
        i_start   : in std_logic;
        i_rst     : in std_logic;
        i_data    : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done    : out std_logic;
        o_en      : out std_logic;
        o_we      : out std_logic;
        o_data    : out std_logic_vector(7 downto 0)
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
    
    type state_type is (WAIT_START, FETCH_WZ, GET_WZ, WAIT_RAM,  FETCH_ADDR, GET_ADDR, CHECK_WZ, ADDR_BUILD, WRITE_OUT, DONE);
    
    signal state_reg, state_next : state_type;
	
	signal o_done_next, o_en_next, o_we_next : std_logic := '0';
	signal o_data_next : std_logic_vector(7 downto 0) := "00000000";
	signal o_address_next : std_logic_vector(15 downto 0) := "0000000000000000";
	signal wz_selector, wz_selector_next : std_logic_vector(15 downto 0) := "0000000000000000";
	
    signal w_zone_0, w_zone_1, w_zone_2, w_zone_3, w_zone_4, w_zone_5, w_zone_6, w_zone_7 : std_logic_vector(7 downto 0) := "00000000";
	signal w_zone_0_next, w_zone_1_next, w_zone_2_next, w_zone_3_next, w_zone_4_next, w_zone_5_next, w_zone_6_next, w_zone_7_next : std_logic_vector(7 downto 0) := "00000000";
	signal address_toCheck, address_toCheck_next : std_logic_vector(7 downto 0) := "00000000";
	signal address_diff, address_diff_next : signed(7 downto 0) := "00000000";
	signal counter, counter_next : std_logic_vector(2 downto 0) := "000";
    
begin
    process (i_clk, i_rst) 
    begin
        if (i_rst = '1') then
            w_zone_0 <= "00000000";
            w_zone_1 <= "00000000";
            w_zone_2 <= "00000000";
            w_zone_3 <= "00000000";
            w_zone_4 <= "00000000";
            w_zone_5 <= "00000000";
            w_zone_6 <= "00000000";
            w_zone_7 <= "00000000";
	        wz_selector <= "0000000000000000";
            address_toCheck <= "00000000";
            address_diff <= "00000000";
            counter <= "000";
			state_reg <= WAIT_START;
        elsif (i_clk'event and i_clk='1') then
            o_done <= o_done_next;
            o_en <= o_en_next;
            o_we <= o_we_next;
            o_data <= o_data_next;
            o_address <= o_address_next;
            state_reg <= state_next;
            wz_selector <= wz_selector_next;
            w_zone_0 <= w_zone_0_next;
            w_zone_1 <= w_zone_1_next;
            w_zone_2 <= w_zone_2_next;
            w_zone_3 <= w_zone_3_next;
            w_zone_4 <= w_zone_4_next;
            w_zone_5 <= w_zone_5_next;
            w_zone_6 <= w_zone_6_next;
            w_zone_7 <= w_zone_7_next;
            address_toCheck <= address_toCheck_next;
            address_diff <= address_diff_next;
            counter <= counter_next;
        end if;
    end process;

    process(i_start, i_data, state_reg, state_next, wz_selector, wz_selector_next, w_zone_0, w_zone_1, w_zone_2, w_zone_3, w_zone_4, w_zone_5, w_zone_6, w_zone_7, 
            address_toCheck, address_diff, address_diff_next, counter, wz_selector_next, w_zone_0_next, w_zone_1_next, w_zone_2_next, w_zone_3_next, 
            w_zone_4_next, w_zone_5_next, w_zone_6_next, w_zone_7_next, address_toCheck_next, counter_next)
    begin
        o_done_next <= '0';
        o_en_next <= '0';
        o_we_next <= '0';
        o_data_next <= "00000000";
        o_address_next <= "0000000000000000";
        wz_selector_next <= wz_selector;
        w_zone_0_next <= w_zone_0;
        w_zone_1_next <= w_zone_1;
        w_zone_2_next <= w_zone_2;
        w_zone_3_next <= w_zone_3;
        w_zone_4_next <= w_zone_4;
        w_zone_5_next <= w_zone_5;
        w_zone_6_next <= w_zone_6;
        w_zone_7_next <= w_zone_7;
        address_toCheck_next <= address_toCheck;
        counter_next <= counter;
        address_diff_next <= address_diff;
		state_next <= state_reg;
		
        case state_reg is
            when WAIT_START =>
                if (i_start = '1' and wz_selector = "0000000000000000") then
                    counter_next <= "000";
                    state_next <= FETCH_WZ;
                elsif (i_start = '1' and wz_selector = "0000000000001000") then
                    counter_next <= "000";
                    state_next <= FETCH_ADDR;
                else
                    state_next <= WAIT_START;
                end if;
            when FETCH_WZ =>
                o_en_next <= '1';
				o_we_next <= '0';
                o_address_next <= wz_selector;
                state_next <= WAIT_RAM;
            when GET_WZ =>
                case wz_selector is
                    when "0000000000000000" =>
                        w_zone_0_next <= i_data;
                        wz_selector_next <= "0000000000000001";
                        state_next <= FETCH_WZ;
                    when "0000000000000001" =>
                        w_zone_1_next <= i_data;
                        wz_selector_next <= "0000000000000010";
                        state_next <= FETCH_WZ;
                    when "0000000000000010" =>
                        w_zone_2_next <= i_data;
                        wz_selector_next <= "0000000000000011";
                        state_next <= FETCH_WZ;
                    when "0000000000000011" =>
                        w_zone_3_next <= i_data;
                        wz_selector_next <= "0000000000000100";
                        state_next <= FETCH_WZ;
                    when "0000000000000100" =>
                        w_zone_4_next <= i_data;
                        wz_selector_next <= "0000000000000101";
                        state_next <= FETCH_WZ;
                    when "0000000000000101" =>
                        w_zone_5_next <= i_data;
                        wz_selector_next <= "0000000000000110";
                        state_next <= FETCH_WZ;
                    when "0000000000000110" =>
                        w_zone_6_next <= i_data;
                        wz_selector_next <= "0000000000000111";
                        state_next <= FETCH_WZ;
                    when "0000000000000111" =>
                        w_zone_7_next <= i_data;
                        wz_selector_next <= "0000000000001000";
                        state_next <= FETCH_ADDR;
                    when others => null;
                    end case;
            when FETCH_ADDR =>
                o_en_next <= '1';
                o_we_next <= '0';
                o_address_next <= wz_selector;
                state_next <= WAIT_RAM;
            when WAIT_RAM =>
                if (wz_selector = "0000000000001000") then
                    state_next <= GET_ADDR;
                else
                    state_next <= GET_WZ;
                end if;
            when GET_ADDR =>
                    address_toCheck_next <= i_data;
                    state_next <= CHECK_WZ;
            when CHECK_WZ =>
                case counter is 
                    when "000" =>
                        address_diff_next <= signed(address_toCheck) - signed(w_zone_0);
                        if (address_diff_next < 0 or address_diff_next > 3) then
                            counter_next <= "001";
                            state_next <= CHECK_WZ;                    
                        else 
                            state_next <= ADDR_BUILD;
                        end if;
                    when "001" =>
                        address_diff_next <= signed(address_toCheck) - signed(w_zone_1);
                        if (address_diff_next < 0 or address_diff_next > 3) then
                            counter_next <= "010";
                            state_next <= CHECK_WZ;
                        else 
                            state_next <= ADDR_BUILD;
                        end if;
                    when "010" =>
                        address_diff_next <= signed(address_toCheck) - signed(w_zone_2);
                        if (address_diff_next < 0 or address_diff_next > 3) then
                            counter_next <= "011";
                            state_next <= CHECK_WZ;
                        else 
                            state_next <= ADDR_BUILD;
                        end if;
                    when "011" =>
                        address_diff_next <= signed(address_toCheck) - signed(w_zone_3);
                        if (address_diff_next < 0 or address_diff_next > 3) then
                            counter_next <= "100";
                            state_next <= CHECK_WZ;
                        else 
                            state_next <= ADDR_BUILD;
                        end if;
                    when "100" =>
                        address_diff_next <= signed(address_toCheck) - signed(w_zone_4);
                        if (address_diff_next < 0 or address_diff_next > 3) then
                            counter_next <= "101";
                            state_next <= CHECK_WZ;
                        else 
                            state_next <= ADDR_BUILD;
                        end if;
                    when "101" =>
                        address_diff_next <= signed(address_toCheck) - signed(w_zone_5);
                        if (address_diff_next < 0 or address_diff_next > 3) then
                            counter_next <= "110";
                            state_next <= CHECK_WZ;
                        else 
                            state_next <= ADDR_BUILD;
                        end if;
                    when "110" =>
                        address_diff_next <= signed(address_toCheck) - signed(w_zone_6);
                        if (address_diff_next < 0 or address_diff_next > 3) then
                            counter_next <= "111";
                            state_next <= CHECK_WZ;
                        else 
                            state_next <= ADDR_BUILD;
                        end if;
                    when "111" =>
                        address_diff_next <= signed(address_toCheck) - signed(w_zone_7);
                        if (address_diff_next < 0 or address_diff_next > 3) then
                            state_next <= WRITE_OUT;
                        else 
                            state_next <= ADDR_BUILD;
                        end if;
                    when others => null;
                end case; 
            when ADDR_BUILD =>
                case address_diff is
                    when "00000000" =>
                        address_ToCheck_next <= '1' & counter(2 downto 0) & "0001";
                    when "00000001" =>
                        address_ToCheck_next <= '1' & counter(2 downto 0) & "0010";
                    when "00000010" =>
                        address_ToCheck_next <= '1' & counter(2 downto 0) & "0100";
                    when "00000011" =>
                        address_ToCheck_next <= '1' & counter(2 downto 0) & "1000";
                    when others => null;
                end case;
		        state_next <= WRITE_OUT;
            when WRITE_OUT =>
                o_en_next <= '1';
                o_we_next <= '1';
                o_address_next <= "0000000000001001"; 
                o_data_next <=  address_ToCheck;
                o_done_next <= '1';
                state_next <= DONE;
            when DONE =>
                if (i_start = '0') then
                    address_ToCheck_next <= "00000000";
                    state_next <= WAIT_START;
                end if;
            when others => null;
        end case;
    end process;          
end Behavioral;