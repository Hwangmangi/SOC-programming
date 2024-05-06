library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_generator is
port(
    clk_in                      :   in      std_logic;
    count                       :   in      std_logic_vector(15 downto 0) := (others => '0');
    clk_out                     :   out     std_logic
);
end entity;

architecture ar_clk_generator of clk_generator is

    signal  sig_count           :           std_logic_vector(15 downto 0) := (others => '0');
    signal  sig_clk_out         :           std_logic := '0';

begin

process(clk_in)
begin
    if(clk_in'event and clk_in = '1')then
        if(sig_count = count)then
            sig_count <= (others => '0');
        else
            sig_count <= sig_count + 1;
        end if;
    end if;
end process;

process(clk_in)
begin
    if(clk_in'event and clk_in = '1')then
        if(sig_count = count)then
            sig_clk_out <= not(sig_clk_out);
        end if;
    end if;
end process;

clk_out <= sig_clk_out;

end architecture;