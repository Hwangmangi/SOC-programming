library ieee;
use ieee.std_logic_1164.all;

entity top is
generic
(
    simulation                                      :           std_logic := '0' -- '0' : real, '1' simulation
);
port(
    clk                                             :   in      std_logic;
    resetn                                          :   in      std_logic;

    SW_1                                            :   in      std_logic;  -- '0' : CIS_2M, '1' : OV5640

    camera_SCL                                      :   inout   std_logic;
    camera_SDA                                      :   inout   std_logic;

    camera_MCLK                                     :   out     std_logic;
    camera_RESETn                                   :   out     std_logic;
    camera_PWDN                                     :   out     std_logic;
    camera_PCLK                                     :   in      std_logic;
    camera_VSYNC                                    :   in      std_logic;
    camera_HSYNC                                    :   in      std_logic;
    camera_data                                     :   in      std_logic_vector(7 downto 0);

    TFTLCD_TCLK                                     :   out     std_logic;
    TFTLCD_Hsync                                    :   out     std_logic;
    TFTLCD_Vsync                                    :   out     std_logic;
    TFTLCD_DE_out                                   :   out     std_logic;
    TFTLCD_D                                        :   out     std_logic_vector(15 downto 0);
    TFTLCD_Tpower                                   :   out     std_logic
);
end entity;

architecture ar_top of top is

component clk_generator is
port(
    clk_in                                          :   in      std_logic;
    count                                           :   in      std_logic_vector(15 downto 0) := (others => '0');
    clk_out                                         :   out     std_logic
);
end component;

    signal  sig_clk_TFTLCD                          :           std_logic;
    signal  sig_clk_i2c                             :           std_logic;

component camera_i2c is
port(
    clk                                             :   in      std_logic;

    SW_1                                            :   in      std_logic;  -- '0' : CIS_2M, '1' : OV5640

    camera_RESETn                                   :   out     std_logic;
    camera_PWDN                                     :   out     std_logic;
    camera_SCL                                      :   inout   std_logic;
    camera_SDA                                      :   inout   std_logic
);
end component;

component camera_to_RAM is
generic
(
    simulation                                      :           std_logic := simulation
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
end component;

    signal  sig_RAM_write_enable                    :           std_logic_vector(0 downto 0);
    signal  sig_RAM_write_address                   :           std_logic_vector(16 downto 0);
    signal  sig_RAM_write_data                      :           std_logic_vector(15 downto 0);

component RAM_camera is
port(
    clka                                            :   in      std_logic;
    wea                                             :   in      std_logic_vector(0 downto 0);
    addra                                           :   in      std_logic_vector(16 downto 0);
    dina                                            :   in      std_logic_vector(15 downto 0);
    clkb                                            :   in      std_logic;
    addrb                                           :   in      std_logic_vector(16 downto 0);
    doutb                                           :   out     std_logic_vector(15 downto 0)
);
end component;

    signal  sig_ram_doutb                           :           std_logic_vector(15 downto 0);

component RAM_to_TFTLCD is
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
end component;

    signal  sig_RAM_read_address                    :           std_logic_vector(16 downto 0);

    signal  sig_TFTLCD_Hsync                        :           std_logic;
    signal  sig_TFTLCD_Vsync                        :           std_logic;
    signal  sig_TFTLCD_R                            :           std_logic_vector(7 downto 3);
    signal  sig_TFTLCD_G                            :           std_logic_vector(7 downto 2);
    signal  sig_TFTLCD_B                            :           std_logic_vector(7 downto 3);

--component chipscope_icon IS
--  port (
--    CONTROL0                                        :	inout	std_logic_vector(35 downto 0)
--);
--end component;
--
--	signal	sig_CONTROL0                            :			std_logic_vector(35 downto 0) := (others => 'Z');
--
--component chipscope_ila IS
--  port (
--    CONTROL                                         :	inout	std_logic_vector(35 downto 0);
--    CLK                                             :	in		std_logic;
--    TRIG0                                           :	in		std_logic_vector(255 downto 0)
--);
--end component;
--
--	signal	sig_TRIG                                :			std_logic_vector(255 downto 0);
--
--component counter is
--port(
--    reset                                           :   in      std_logic;
--    reset_active                                    :   in      std_logic;
--    clk                                             :   in      std_logic;
--    enable_active                                   :   in      std_logic;
--    enable                                          :   in      std_logic;
--    counter                                         :   out     std_logic_vector(31 downto 0)
--);
--end component;
--
--    signal  sig_v_counter                           :   std_logic_vector(31 downto 0);
--    signal  sig_h_counter                           :   std_logic_vector(31 downto 0);
--
--    signal  sig_TFTLCD_v_counter                    :   std_logic_vector(31 downto 0);
--    signal  sig_TFTLCD_h_counter                    :   std_logic_vector(31 downto 0);
--
--component ila_0 IS
--port(
--    clk                                             :   in      std_logic;
--    probe0                                          :   in      std_logic_vector(255 downto 0)
--);
--end component;
--
--component vio_0 IS
--port(
--    clk                                             :   in      std_logic;
--    probe_out0                                      :   out     std_logic_vector(7 downto 0)
--);
--end component;

begin

component_clk_generator_TFTLCD : clk_generator
port map(
    clk_in                                          =>  clk,
    count                                           =>  x"0001",
    clk_out                                         =>  sig_clk_TFTLCD
);

component_clk_generator_i2c : clk_generator
port map(
    clk_in                                          =>  clk,
    count                                           =>  x"0064",
    clk_out                                         =>  sig_clk_i2c
);

component_camera_i2c : camera_i2c
port map(
    clk                                             =>  sig_clk_i2c,

    SW_1                                            =>  SW_1,

    camera_RESETn                                   =>  camera_RESETn,
    camera_PWDN                                     =>  camera_PWDN,
    camera_SCL                                      =>  camera_SCL,
    camera_SDA                                      =>  camera_SDA
);

component_camera_to_RAM : camera_to_RAM
port map(
    clk                                             =>  camera_PCLK,

    SW_1                                            =>  SW_1,

    CVSYNC                                          =>  camera_VSYNC,
    CHSYNC                                          =>  camera_HSYNC,
    CY                                              =>  camera_data,

    RAM_write_enable                                =>  sig_RAM_write_enable,
    RAM_write_address                               =>  sig_RAM_write_address,
    RAM_write_data                                  =>  sig_RAM_write_data
);

component_RAM_camera : RAM_camera
port map(
    clka                                            =>  camera_PCLK,
    wea                                             =>  sig_RAM_write_enable,
    addra                                           =>  sig_RAM_write_address,
    dina                                            =>  sig_RAM_write_data,
    clkb                                            =>  sig_clk_TFTLCD,
    addrb                                           =>  sig_RAM_read_address,
    doutb                                           =>  sig_ram_doutb
);

component_RAM_to_TFTLCD : RAM_to_TFTLCD
port map(
    clk                                             =>  sig_clk_TFTLCD,

    RAM_read_address                                =>  sig_RAM_read_address,
    RAM_read_data                                   =>  sig_ram_doutb,

    TFTLCD_Hsync                                    =>  sig_TFTLCD_Hsync,
    TFTLCD_Vsync                                    =>  sig_TFTLCD_Vsync,
    TFTLCD_R                                        =>  sig_TFTLCD_R,
    TFTLCD_G                                        =>  sig_TFTLCD_G,
    TFTLCD_B                                        =>  sig_TFTLCD_B
);

camera_MCLK     <=  clk;

TFTLCD_TCLK     <=  sig_clk_TFTLCD;
TFTLCD_DE_out   <=  '1';
TFTLCD_Tpower   <=  '1';

TFTLCD_Hsync    <=  sig_TFTLCD_Hsync;
TFTLCD_Vsync    <=  sig_TFTLCD_Vsync;
TFTLCD_D        <=  sig_TFTLCD_R(7 downto 3) & sig_TFTLCD_G(7 downto 2) & sig_TFTLCD_B(7 downto 3);

--component_chipscope_icon : chipscope_icon
--port map(
--    CONTROL0                                        => sig_CONTROL0
--);
--
----/////////////////////////////////////////////////////////////////////
--
--component_chipscope_ila : chipscope_ila
--port map(
--    CONTROL                                         =>	sig_CONTROL0,
--    CLK                                             =>	camera_PCLK,
--    TRIG0                                           =>	sig_TRIG
--);
--
----component_chipscope_ila : chipscope_ila
----port map(
----    CONTROL                                         =>	sig_CONTROL0,
----    CLK                                             =>	sig_clk_TFTLCD,
----    TRIG0                                           =>	sig_TRIG
----);
--
----/////////////////////////////////////////////////////////////////////
--
--component_counter_v : counter
--port map(
--    reset                                           =>  camera_VSYNC,
--    reset_active                                    =>  '1',
--    clk                                             =>  camera_HSYNC,
--    enable_active                                   =>  '1',
--    enable                                          =>  '1',
--    counter                                         =>  sig_v_counter
--);
--
--component_counter_h : counter
--port map(
--    reset                                           =>  '1',
--    reset_active                                    =>  '0',
--    clk                                             =>  camera_PCLK,
--    enable_active                                   =>  '1',
--    enable                                          =>  camera_HSYNC,
--    counter                                         =>  sig_h_counter
--);
--
----/////////////////////////////////////////////////////////////////////
--
--component_counter_TFTLCD_v : counter
--port map(
--    reset                                           =>  sig_TFTLCD_Vsync,
--    reset_active                                    =>  '0',
--    clk                                             =>  sig_TFTLCD_Hsync,
--    enable_active                                   =>  '1',
--    enable                                          =>  '1',
--    counter                                         =>  sig_TFTLCD_v_counter
--);
--
--component_counter_TFTLCD_h : counter
--port map(
--    reset                                           =>  '1',
--    reset_active                                    =>  '0',
--    clk                                             =>  sig_clk_TFTLCD,
--    enable_active                                   =>  '1',
--    enable                                          =>  sig_TFTLCD_Hsync,
--    counter                                         =>  sig_TFTLCD_h_counter
--);
--
--sig_TRIG(0)                 <=	camera_HSYNC;
--sig_TRIG(32 downto 1)       <=	sig_h_counter(31 downto 0);
--sig_TRIG(33)                <=	camera_VSYNC;
--sig_TRIG(65 downto 34)      <=	sig_v_counter(31 downto 0);
--sig_TRIG(73 downto 66)      <=	camera_data(7 downto 0);
--
--sig_TRIG(74)                <=	sig_RAM_write_enable(0);
--sig_TRIG(91 downto 75)      <=	sig_RAM_write_address(16 downto 0);
--sig_TRIG(107 downto 92)     <=	sig_RAM_write_data(15 downto 0);
--
--sig_TRIG(124 downto 108)    <=	sig_RAM_read_address(16 downto 0);
--sig_TRIG(140 downto 125)    <=	sig_ram_doutb(15 downto 0);
--sig_TRIG(141)               <=	sig_TFTLCD_Hsync;
--sig_TRIG(142)               <=	sig_TFTLCD_Vsync;
--sig_TRIG(147 downto 143)	<=	sig_TFTLCD_R(7 downto 3);
--sig_TRIG(153 downto 148)	<=	sig_TFTLCD_G(7 downto 2);
--sig_TRIG(158 downto 154)	<=	sig_TFTLCD_B(7 downto 3);
--sig_TRIG(190 downto 159)	<=	sig_TFTLCD_v_counter(31 downto 0);
--sig_TRIG(222 downto 191)	<=	sig_TFTLCD_h_counter(31 downto 0);
--
--sig_TRIG(223)               <=  camera_SCL;
--sig_TRIG(224)               <=  camera_SDA;
--
--sig_TRIG(255 downto 225)	<=  (others => '0');

end architecture;