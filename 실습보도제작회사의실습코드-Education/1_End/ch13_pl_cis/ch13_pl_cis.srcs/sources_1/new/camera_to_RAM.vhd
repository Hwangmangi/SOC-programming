library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity camera_to_RAM is
generic
(
    simulation                                      :           std_logic := '0' -- '0' : real, '1' simulation
);
port(
    clk                                             :   in      std_logic;

    SW_1                                            :   in      std_logic;  -- '0' : CIS_2M, '1' : OV5640

    CVSYNC                                          :   in      std_logic;
    CHSYNC                                          :   in      std_logic;
    CY                                              :   in      std_logic_vector(7 downto 0);

    RAM_write_enable                                :   out     std_logic_vector(0 downto 0);
    RAM_write_address                               :   out     std_logic_vector(16 downto 0);
    RAM_write_data                                  :   out     std_logic_vector(15 downto 0)
);
end entity;

architecture ar_camera_to_RAM of camera_to_RAM is

    constant    sig_v_count_max_real                :           integer := 272;
    constant    sig_h_count_max_real                :           integer := 480;

    constant    sig_v_count_max_simulation          :           integer := 272;
    constant    sig_h_count_max_simulation          :           integer := 480;

    signal  sig_v_count_max                         :           integer := 0;
    signal  sig_h_count_max                         :           integer := 0;

    signal  sig_CVSYNC                              :           std_logic := '1';
    signal  sig_CHSYNC                              :           std_logic := '0';
    signal  sig_CY                                  :           std_logic_vector(7 downto 0) := (others => '0');

    signal  sig_CVSYNC_delay                        :           std_logic := '1';
    signal  sig_CHSYNC_delay                        :           std_logic := '0';
    signal  sig_CY_delay                            :           std_logic_vector(7 downto 0) := (others => '0');

    signal  sig_temp                                :           std_logic := '0';

    signal  sig_v_count                             :           std_logic_vector(15 downto 0) := (others => '0');
    signal  sig_h_count                             :           std_logic_vector(15 downto 0) := (others => '0');
    signal  sig_address_count                       :           std_logic_vector(16 downto 0) := (others => '0');

    signal  sig_enable                              :           std_logic := '0';

    signal  sig_RAM_write_enable                    :           std_logic_vector(0 downto 0) := (others => '0');
    signal  sig_RAM_write_address                   :           std_logic_vector(16 downto 0) := (others => '0');
    signal  sig_RAM_write_data                      :           std_logic_vector(15 downto 0) := (others => '0');

begin

sig_v_count_max <=  sig_v_count_max_real    when    simulation = '0' else   sig_v_count_max_simulation;
sig_h_count_max <=  sig_h_count_max_real    when    simulation = '0' else   sig_h_count_max_simulation;

process(clk)
begin
    if(clk'event and clk = '1')then
        sig_CVSYNC          <=  CVSYNC;
        sig_CHSYNC          <=  CHSYNC;
        sig_CY              <=  CY;

        sig_CVSYNC_delay    <=  sig_CVSYNC;
        sig_CHSYNC_delay    <=  sig_CHSYNC;
        sig_CY_delay        <=  sig_CY;
    end if;
end process;

process(clk)
begin
    if(clk'event and clk = '1')then
        if(sig_CVSYNC_delay = '0')then
            if(sig_CHSYNC_delay = '1')then
                sig_temp <= not(sig_temp);
            end if;
        else
            sig_temp <= '0';
        end if;
    end if;
end process;

process(clk)
begin
    if(clk'event and clk = '1')then
        if(sig_CVSYNC = '0')then
            if(sig_CHSYNC = '0' and sig_CHSYNC_delay = '1')then
                sig_v_count <= sig_v_count + 1;
            end if;
        else
            sig_v_count <= (others => '0');
        end if;
    end if;
end process;

process(clk)
begin
    if(clk'event and clk = '1')then
        if(sig_CVSYNC = '0')then
            if(sig_CHSYNC = '1')then
                if(sig_temp = '1')then
                    sig_h_count <= sig_h_count + 1;
                end if;
            else
                sig_h_count <= (others => '0');
            end if;
        else
            sig_h_count <= (others => '0');
        end if;
    end if;
end process;

process(clk)
begin
    if(clk'event and clk = '1')then
        if(sig_CVSYNC = '0')then
            if(sig_RAM_write_enable(0) = '1')then
                sig_address_count <= sig_address_count + 1;
            end if;
        else
            sig_address_count <= (others => '0');
        end if;
    end if;
end process;

process(clk)
begin
    if(clk'event and clk = '1')then
        if(sig_CVSYNC = '0')then
            if(sig_CHSYNC = '1')then
                if(sig_v_count < sig_v_count_max)then
                    if(sig_h_count < sig_h_count_max)then
                        sig_enable <= '1';
                    else
                        sig_enable <= '0';
                    end if;
                else
                    sig_enable <= '0';
                end if;
            end if;
        else
            sig_enable <= '0';
        end if;
    end if;
end process;

process(clk)
begin
    if(clk'event and clk = '1')then
        if(sig_enable = '1')then
            if(sig_temp = '0')then
                sig_RAM_write_enable    <=  (others => '0');
                sig_RAM_write_address   <=  (others => '0');
                sig_RAM_write_data(15 downto 8) <= sig_CY_delay;
            elsif(sig_temp = '1')then
                sig_RAM_write_enable(0) <=  '1';
                sig_RAM_write_address   <=  sig_address_count;
                sig_RAM_write_data(7 downto 0) <= sig_CY_delay;
            end if;
        else
            sig_RAM_write_enable    <=  (others => '0');
            sig_RAM_write_address   <=  (others => '0');
            sig_RAM_write_data      <=  (others => '0');
        end if;
    end if;
end process;

RAM_write_enable    <=  sig_RAM_write_enable;
RAM_write_address   <=  sig_RAM_write_address;
RAM_write_data(15 downto 11)    <=  sig_RAM_write_data(15 downto 11);
RAM_write_data(10 downto 5)     <=  sig_RAM_write_data(10 downto 5);
RAM_write_data(4 downto 0)      <=  sig_RAM_write_data(4 downto 0);

end architecture;