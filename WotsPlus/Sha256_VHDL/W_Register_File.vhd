library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.Utils.all;


entity W_Register_File is
  Port (clk : in std_logic;
        MSG_PADDED :in std_logic_vector(0 to 511);
        W_Done : out std_logic;
        reset_cntW : in std_logic;
        controlcntW : in std_logic;
        
        --M_out : out M_DATA;
        --cnt_out :out unsigned (6 downto 0) ;
        W_OUT: out K_DATA   );
end W_Register_File;

architecture Behavioral of W_Register_File is
       signal W : K_DATA := ( 
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000"
    );
    
signal delay1, delay2 : std_logic := '0';
signal M : M_DATA;
signal  cntW : unsigned (6 downto 0) := "0010000";

begin 
msg_format: for i in 0 to 15 generate
    begin
       M(i) <= MSG_PADDED ((32*i) to (32 *(i+1)-1));
end generate;
process(clk)
    --variable cnt : unsigned (6 downto 0) := "0010000";
     
       begin 
       if(clk'event and clk = '1' ) then
          L1: for i in 0 to 15 Loop
            W(i) <= M(i);
            end loop;
            if (reset_cntW = '1' ) then 
                cntW <= "0010000";
            else            
                delay1 <= '1';  
                delay2 <= delay1;
                if (delay2 = '1' ) then
                    if (cntW = "1000000") then 
                        W_DONE <= '1';
                        cntW<="0010000";
                    else 
                    --if (controlcntW = '1') then
                        W_DONE<= '0';
                        W(to_integer(cntW)) <=  std_logic_vector(unsigned(W(to_integer(cntW)-16)) + unsigned(S0_W(W(to_integer(cntW)-15))) + unsigned(S1_W(W(to_integer(cntW)-2))) + unsigned(W(to_integer(cntW)-7) ));
                    cntW <= cntW + 1 ;
                    --end if ;
                end if ;  
          end if ;      
       end if ;
    end if ;
          end process;
           
        --M_out <= M;
        --cnt_out <= cnt;
        W_OUT <= W;
     
             
           
        
end Behavioral;