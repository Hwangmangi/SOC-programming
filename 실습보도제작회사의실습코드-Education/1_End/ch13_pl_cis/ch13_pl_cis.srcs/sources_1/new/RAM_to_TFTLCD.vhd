library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity RAM_to_TFTLCD is
port(
    clk                                             :   in      std_logic;

    RAM_read_address                                :   out     std_logic_vector(16 downto 0);
    RAM_read_data                                   :   in      std_logic_vector(15 downto 0);

    TFTLCD_Hsync                                    :   out     std_logic;
    TFTLCD_Vsync                                    :   out     std_logic;
    TFTLCD_R                                        :   out     std_logic_vector(7 downto 3);
    TFTLCD_G                                        :   out     std_logic_vector(7 downto 2);
    TFTLCD_B                                        :   out     std_logic_vector(7 downto 3)
);
end entity;

architecture ar_RAM_to_TFTLCD of RAM_to_TFTLCD is

    signal  sig_h_count                             :            std_logic_vector(15 downto 0) := (others => '0');
    signal  sig_h_sync                              :            std_logic := '0';
    signal  sig_h_sync_delay_1                      :            std_logic := '0';
    signal  sig_h_sync_delay_2                      :            std_logic := '0';

    signal  sig_v_count                             :            std_logic_vector(15 downto 0) := (others => '0');
    signal  sig_v_sync                              :            std_logic := '0';
    signal  sig_v_sync_delay_1                      :            std_logic := '0';
    signal  sig_v_sync_delay_2                      :            std_logic := '0';

    signal  sig_RAM_read_address                    :            std_logic_vector(16 downto 0) := (others => '0');
    signal  sig_RAM_read_data                       :            std_logic_vector(15 downto 0) := (others => '0');

    signal  sig_TFTLCD_R                            :           std_logic_vector(7 downto 3) := (others => '0');
    signal  sig_TFTLCD_G                            :           std_logic_vector(7 downto 2) := (others => '0');
    signal  sig_TFTLCD_B                            :           std_logic_vector(7 downto 3) := (others => '0');

begin

process(clk)
begin
    if(clk'event and clk = '1')then
        if(sig_h_count < 40)then
            sig_h_sync  <=  '0';
            sig_h_count <=  sig_h_count + 1;
        elsif((sig_h_count >= 40) and (sig_h_count < 522))then
            sig_h_sync  <=  '1';
            sig_h_count <=  sig_h_count + 1;
        else
            sig_h_sync  <=  '0';
            sig_h_count <=  (others => '0');

            if(sig_v_count < 10)then
                sig_v_sync  <=  '0';
                sig_v_count <=  sig_v_count + 1;
            elsif((sig_v_count >= 10) and (sig_v_count < 284))then
                sig_v_sync  <=  '1';
                sig_v_count <=  sig_v_count + 1;
            else
                sig_v_sync  <=  '0';
                sig_v_count <=  (others => '0');
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(clk'event and clk = '1')then
        if(sig_v_sync = '0')then
            sig_RAM_read_address <= (others => '0');
        else
            if(sig_v_count >= 12 and sig_v_count < 284)then
                if((sig_h_count >= 42) and (sig_h_count < 522))then
                    sig_RAM_read_address <= sig_RAM_read_address + 1;
                end if;
            end if;
        end if;
    end if;
end process;

RAM_read_address <= sig_RAM_read_address;

process(clk)
begin
    if(clk'event and clk = '0')then
        sig_h_sync_delay_1 <= sig_h_sync;
        sig_h_sync_delay_2 <= sig_h_sync_delay_1;

        sig_v_sync_delay_1 <= sig_v_sync;
        sig_v_sync_delay_2 <= sig_v_sync_delay_1;
    end if;
end process;

TFTLCD_Hsync    <=  sig_h_sync_delay_2;
TFTLCD_Vsync    <=  sig_v_sync_delay_2;

process(clk)
begin
	if(clk'event and clk = '1')then
        if(sig_v_count = 12)then
            if(sig_h_count = 43)then
                sig_RAM_read_data <= (others => '1');
            elsif(sig_h_count = 522)then
                sig_RAM_read_data <= (others => '1');
            else
                sig_RAM_read_data <= RAM_read_data;
            end if;
        elsif(sig_v_count = 283)then
            if(sig_h_count = 43)then
                sig_RAM_read_data <= (others => '1');
            elsif(sig_h_count = 522)then
                sig_RAM_read_data <= (others => '1');
            else
                sig_RAM_read_data <= RAM_read_data;
            end if;
        else
            sig_RAM_read_data <= RAM_read_data;
        end if;
    end if;
end process;

process(clk)
begin
	if(clk'event and clk = '0')then
        sig_TFTLCD_R	<=	sig_RAM_read_data(4 downto 0);
        sig_TFTLCD_G	<=	sig_RAM_read_data(10 downto 5);
        sig_TFTLCD_B	<=	sig_RAM_read_data(15 downto 11);
	end if;
end process;

TFTLCD_R    <=  sig_TFTLCD_R;
TFTLCD_G    <=  sig_TFTLCD_G;
TFTLCD_B    <=  sig_TFTLCD_B;

end architecture;