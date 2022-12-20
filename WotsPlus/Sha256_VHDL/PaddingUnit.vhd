----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2022 07:24:52 PM
-- Design Name: 
-- Module Name: PaddingUnit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Utils.all;


--MSG_PADDED<="01101000011001010110110001101100011011110010000001110111011011110111001001101100011001001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001011000";

entity PaddingUnit is

       generic (N: integer := 7);
       port( MSG: in std_logic_vector(N-1 downto 0);
             MSG_PADDED :out std_logic_vector(511 downto 0);
             PADD_DONE : out std_logic );

end PaddingUnit;
   
architecture Behavioral of PaddingUnit is


signal Temp : std_logic_vector(N downto 0);
signal LenInt : std_logic_vector(63 downto 0) ; 
signal Zeros : std_logic_vector (446-N downto 0) := (others => '0');


begin
    Temp <= MSG & '1';
    LenInt <= std_logic_vector(to_unsigned(N,64));
    MSG_PADDED <= Temp & Zeros & LenInt;
    PADD_DONE <= '1';
    
    
               
     
    
    
    
        
            
end Behavioral;
