


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


package Utils is 
constant N : natural := 7000;
 type K_DATA is array (0 to 63) of std_logic_vector(31 downto 0);
 type H_DATA is array (0 to 7) of std_logic_vector(31 downto 0);
 type M_DATA is array (0 to 15) of std_logic_vector(31 downto 0);
 type BLOCKS is array ( 0 to 15 ) of std_logic_vector (511 downto 0);
function RightRotate (a : std_logic_vector(31 downto 0); n : natural)
                    return std_logic_vector;
function LeftRotate (a : std_logic_vector(31 downto 0); n : natural)
                    return std_logic_vector;
function RightShift (a : std_logic_vector(31 downto 0); n : natural)
                    return std_logic_vector;
                                      
function S0_W (x : std_logic_vector(31 downto 0))
                    return std_logic_vector;
    function S1_W (x : std_logic_vector(31 downto 0))
                    return std_logic_vector;
    function S1_C (x : std_logic_vector(31 downto 0))
                    return std_logic_vector;
    function S0_C (x : std_logic_vector(31 downto 0))
                    return std_logic_vector;
function ch (x : std_logic_vector(31 downto 0);
                    y : std_logic_vector(31 downto 0);
                    z : std_logic_vector(31 downto 0))
                    return std_logic_vector;
function maj (x : std_logic_vector(31 downto 0);
                    y : std_logic_vector(31 downto 0);
                    z : std_logic_vector(31 downto 0))
                    return std_logic_vector;
                                                                   
                    
end package;

package body Utils is 
    function RightRotate (a : std_logic_vector(31 downto 0); n : natural)
                    return std_logic_vector is 
        begin 
        return (std_logic_vector(shift_right(unsigned(a), n))) or std_logic_vector((shift_left(unsigned(a), (32-n))));
    end function;        
    
    function LeftRotate (a : std_logic_vector(31 downto 0); n : natural)
                    return std_logic_vector is 
       begin 
       return (std_logic_vector(shift_left(unsigned(a), n))) or std_logic_vector((shift_right(unsigned(a), (32-n))));
    end function;
    
    function RightShift (a : std_logic_vector(31 downto 0); n : natural)
                    return std_logic_vector is          
          begin
        return std_logic_vector(shift_right(unsigned(a), n));
    end function;
    
    function S0_W (x : std_logic_vector(31 downto 0))
                    return std_logic_vector is
          begin 
          return (RightRotate(x,7) xor Rightrotate(x,18) xor RightShift(x,3) );
          end function;
      function S1_W (x : std_logic_vector(31 downto 0))
                    return std_logic_vector is
          begin 
           return ( RightRotate(x,17) xor RightRotate(x,19) xor RightShift(x,10) );
          end function;   
                        
      function S1_C (x : std_logic_vector(31 downto 0))
                    return std_logic_vector is
                  begin
                  return (RightRotate(x,6) xor Rightrotate(x,11) xor RightRotate(x,25));
                end function;
     function S0_C (x : std_logic_vector(31 downto 0))
                    return std_logic_vector is
                  begin
                  return (RightRotate(x,2) xor Rightrotate(x,13) xor RightRotate(x,22));
                end function;
    
     function ch (x : std_logic_vector(31 downto 0);
                    y : std_logic_vector(31 downto 0);
                    z : std_logic_vector(31 downto 0))
                    return std_logic_vector is 
                 begin
        return (x and y) xor (not(x) and z);
        end function;   
        
        
    function maj (x : std_logic_vector(31 downto 0);
                    y : std_logic_vector(31 downto 0);
                    z : std_logic_vector(31 downto 0))
                    return std_logic_vector is 
                    
       begin
        return (x and y) xor (x and z) xor (y and z);
    end function;
                                                  
     
    
                    
                    
                                
                    
               
  end package body ;              








