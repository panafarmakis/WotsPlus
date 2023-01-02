---------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2022 01:08:50 PM
-- Design Name: 
-- Module Name: HashLoop - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.Utils.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HashLoop is
Port(   clk : in std_logic;
        controlcnt : in std_logic;
        reset_cnt : in std_logic;
        W_IN : in K_DATA; 
        HV_IN : in H_DATA;
        HV : out H_DATA ;
        Hash_Done : out std_logic);
end HashLoop;

architecture Behavioral of HashLoop is

                                       
  signal HVTEMP : H_DATA ;                                   

    constant K : K_DATA := (
        
        X"428a2f98", X"71374491", X"b5c0fbcf", X"e9b5dba5",
        X"3956c25b", X"59f111f1", X"923f82a4", X"ab1c5ed5",
        X"d807aa98", X"12835b01", X"243185be", X"550c7dc3",
        X"72be5d74", X"80deb1fe", X"9bdc06a7", X"c19bf174",
        X"e49b69c1", X"efbe4786", X"0fc19dc6", X"240ca1cc",
        X"2de92c6f", X"4a7484aa", X"5cb0a9dc", X"76f988da",
        X"983e5152", X"a831c66d", X"b00327c8", X"bf597fc7",
        X"c6e00bf3", X"d5a79147", X"06ca6351", X"14292967",
        X"27b70a85", X"2e1b2138", X"4d2c6dfc", X"53380d13",
        X"650a7354", X"766a0abb", X"81c2c92e", X"92722c85",
        X"a2bfe8a1", X"a81a664b", X"c24b8b70", X"c76c51a3",
        X"d192e819", X"d6990624", X"f40e3585", X"106aa070",
        X"19a4c116", X"1e376c08", X"2748774c", X"34b0bcb5",
        X"391c0cb3", X"4ed8aa4a", X"5b9cca4f", X"682e6ff3",
        X"748f82ee", X"78a5636f", X"84c87814", X"8cc70208",
        X"90befffa", X"a4506ceb", X"bef9a3f7", X"c67178f2"
    );
        signal a : std_logic_vector (31 downto 0 ) := (others => '0');
        signal b : std_logic_vector (31 downto 0):= (others => '0');
        signal c : std_logic_vector (31 downto 0):= (others => '0');
        signal d: std_logic_vector (31 downto 0):= (others => '0');
        signal e : std_logic_vector (31 downto 0):= (others => '0');
        signal f: std_logic_vector (31 downto 0) := (others => '0');
        signal g: std_logic_vector (31 downto 0):= (others => '0');
        signal h : std_logic_vector(31 downto 0 ):= (others => '0');
        --signal Temp1 : std_logic_vector(31 downto 0 ):= (others => '0' );
        --signal Temp2 : std_logic_vector(31 downto 0 ) := (others => '0' );
        --signal W_IN : K_DATA;
        signal flag1, flag2 : std_logic := '0'; 
        signal cnt : unsigned (6 downto 0) := "0000000";
        signal done: std_logic := '0';
        
        
   

begin
            
          
            
process (clk) 
    variable Temp1 : std_logic_vector(31 downto 0 ):= (others => '0' );
    variable Temp2 : std_logic_vector(31 downto 0 ) := (others => '0' );

begin 
          
    if(clk'event and clk = '1' ) then
            if (reset_cnt = '1' ) then 
                cnt <= "0000000";
            else 
                if (cnt = "0000000") then 
                a <= HV_IN(0);
                b <= HV_IN(1);
                c <= HV_IN(2);
                d <= HV_IN(3);
                e <= HV_IN(4);
                f <= HV_IN(5);
                g <= HV_IN(6);
                h <= HV_IN(7);
                 
                end if ;
                if (cnt = "1000000") then  
                    HVTEMP(0) <= std_logic_vector(unsigned(a) + unsigned(HV_IN(0)));
                    HVTEMP(1) <= std_logic_vector(unsigned(b) + unsigned(HV_IN(1)));
                    HVTEMP(2) <= std_logic_vector(unsigned(c) + unsigned(HV_IN(2)));
                    HVTEMP(3) <= std_logic_vector(unsigned(d) + unsigned(HV_IN(3)));
                    HVTEMP(4) <= std_logic_vector(unsigned(e) + unsigned(HV_IN(4)));
                    HVTEMP(5) <= std_logic_vector(unsigned(f) + unsigned(HV_IN(5)));
                    HVTEMP(6) <= std_logic_vector(unsigned(g) + unsigned(HV_IN(6)));
                    HVTEMP(7) <= std_logic_vector(unsigned(h) + unsigned(HV_IN(7)));     
                    done <= '1' ;
                    if (done = '1') then 
                       Hash_done <= '1';
                       HV<=HVTEMP;
                    end if ;
                else 
                        Hash_done <= '0';
                        if (controlcnt = '1') then 
                            Temp1 := std_logic_vector(unsigned(h) + unsigned(S1_C(e)) + unsigned(ch(e, f, g)) +unsigned(K(TO_INTEGER(cnt)))+unsigned(W_IN(TO_INTEGER(cnt)))); 
                            Temp2 := std_logic_vector(unsigned(S0_C(a)) + unsigned(maj(a,b,c)) );
                            flag1 <= '1'; 
                            if (flag1 = '1' ) then 
                                h <= g;
                                g <= f;
                                f <= e;
                                e <= std_logic_vector(unsigned(d) + unsigned(Temp1));
                                d <= c;
                                c <= b; 
                                b <= a;
                                a <= std_logic_vector(unsigned(Temp1) + unsigned(Temp2));
                                cnt <= cnt + 1 ; 
                            end if ;   
                        end if ;
           
                end if ;   
           end if;
    end if ;  
    --end if ;

    

end process ;


end Behavioral;