----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2022 03:53:19 PM
-- Design Name: 
-- Module Name: Sha256 - Behavioral
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
use work.Utils.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sha256 is
Port(clk : in std_logic;
        rst : in std_logic;
        --data_ready : in std_logic;  --the edge of this signal triggers the capturing of input data and hashing it.
        --n_blocks : in natural; --number of padded message blocks / reads in padded msg blocks ; 
        --msg_block_in : in std_logic_vector(0 to 511); -- N ; 
        --Msg_blocks :in BLOCKS ;
        --mode_in : in std_logic;
        --finished : out std_logic;
        ap_return : out std_logic_vector(255 downto 0);
        --ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    p_read : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read1 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read2 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read3 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read4 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read5 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read6 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read7 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read8 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read9 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read10 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read11 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read12 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read13 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read14 : IN STD_LOGIC_VECTOR (511 downto 0);
    p_read15 : IN STD_LOGIC_VECTOR (511 downto 0));
end Sha256;

architecture Behavioral of Sha256 is
    type state is (RESET,IDLE,READ_MSG_BLOCK, W_REG_CALCULATOR, READ_TO_HASH, HASH, DONE );--, CLEAR );
    Signal prev_state, curr_state, next_state: state;    
    signal Msg_blocks : BLOCKS;
    
    
    -- W_REGISTER_FILE COMPONENT FOR COMPUTING W[] 
    component W_Register_File
      Port (clk : in std_logic;
        MSG_PADDED :in std_logic_vector(0 to 511);
        W_Done : out std_logic;
        controlcntW : in std_logic;
        reset_cntW : in std_logic;
        W_OUT: out K_DATA   );
        
       end component ;
       
    component HashLoop 
Port(   clk : in std_logic;
        controlcnt : in std_logic;
        reset_cnt : in std_logic;
        W_IN : in K_DATA; 
        HV_IN : in H_DATA;
        HV : out H_DATA ;
        Hash_Done : out std_logic);
end component; 

    signal W_TEMP : K_DATA; 
    signal data_ready : std_logic;
    signal hash_rdy : std_logic; 
    signal HV_IN , HV : H_DATA := (Others => (Others=> '0'));
    signal HV_INITIALVALUES : H_DATA := (X"6a09e667", X"bb67ae85", X"3c6ef372",
                                         X"a54ff53a", X"510e527f", X"9b05688c",
                                        X"1f83d9ab", X"5be0cd19");
                                       
    signal CNT_BLOCKS : natural := 0 ;
    signal controlcnt : std_logic ;
    signal reset_cntW : std_logic ;
    signal controlcntW : std_logic;
    signal reset_cnt : std_logic ; 
    signal msg_block_in : std_logic_vector(0 to 511);  
    signal n_blocks : natural := 2;
    
    constant Length : integer := 816;
    signal LenInt : std_logic_vector(63 downto 0) ; 
    signal Zeros : std_logic_vector (142 downto 0) := (others => '0');
    signal TempForPad : std_logic_vector(303 downto 0) ;
    
    

     
   signal p_read_temp,p_read_tempf :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal p_read1_temp,p_read1_tempf :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal  p_read2_temp,p_read2_tempf :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal p_read3_temp,p_read3_tempf :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal p_read4_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal p_read5_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal  p_read6_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal  p_read7_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal  p_read8_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal  p_read9_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal p_read10_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal   p_read11_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal p_read12_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal   p_read13_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal  p_read14_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal  p_read15_temp :  STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
   signal ap_return_temp, ap_returnfinal : STD_LOGIC_VECTOR (255 downto 0):= (others => '0');

    
   

begin

REVERSE_B : for i in 0 to 511 generate
    --p_read_temp((i+1)*8-1 downto (i*8)) <= p_read((i+2)*4 downto ((i+1)*4));
    p_read_temp(i)<=p_read(511-i);
    p_read1_temp(i)<=p_read1(511-i);
    p_read2_temp(i)<=p_read2(511-i);
    end generate;

REVERSE_FINAL : for i in 0 to 63 generate 
    p_read_tempf(i*8)<=p_read_temp((i*8)+7);
    p_read_tempf((i*8)+1)<=p_read_temp((i*8)+6);
    p_read_tempf((i*8)+2)<=p_read_temp((i*8)+5);
    p_read_tempf((i*8)+3)<=p_read_temp(i*8+4);
    p_read_tempf((i*8)+4)<=p_read_temp(i*8+3);
    p_read_tempf((i*8)+5)<=p_read_temp(i*8+2);
    p_read_tempf((i*8)+6)<=p_read_temp(i*8+1);
    p_read_tempf((i*8)+7)<=p_read_temp(i*8);
    
    
     
   p_read1_tempf(i*8)<=p_read1_temp((i*8)+7);
    p_read1_tempf((i*8)+1)<=p_read1_temp((i*8)+6);
    p_read1_tempf((i*8)+2)<=p_read1_temp((i*8)+5);
    p_read1_tempf((i*8)+3)<=p_read1_temp(i*8+4);
    p_read1_tempf((i*8)+4)<=p_read1_temp(i*8+3);
    p_read1_tempf((i*8)+5)<=p_read1_temp(i*8+2);
    p_read1_tempf((i*8)+6)<=p_read1_temp(i*8+1);
    p_read1_tempf((i*8)+7)<=p_read1_temp(i*8);
    
    
    
    end generate ;
    




LenInt <= std_logic_vector(to_unsigned(Length,64));
--p_read1&'1'&Zeros&LenInt;

msg_block_in <= Msg_blocks(CNT_BLOCKS);
Msg_blocks(0)<= p_read_tempf;
TempforPad <= p_read1_tempf(511 downto 208) ; 
Msg_blocks(1)<= TempforPad &'1'& Zeros & LenInt;
--Msg_blocks(1)<=p_read1_temp; 
--Msg_blocks(2)<= p_read2;
--Msg_blocks(3)<= p_read3;
--Msg_blocks(4)<= p_read4;
--Msg_blocks(5)<= p_read5;
--Msg_blocks(6)<= p_read6;
--Msg_blocks(7)<= p_read7;
--Msg_blocks(8)<= p_read8;
--Msg_blocks(9)<= p_read9;
--Msg_blocks(10)<= p_read10;
--Msg_blocks(11)<= p_read11;
--Msg_blocks(12)<= p_read12;
--Msg_blocks(13)<= p_read13;
--Msg_blocks(14)<= p_read14;
--Msg_blocks(15)<= p_read15;



W_COMP : W_Register_File port map (clk => clk, MSG_PADDED => msg_block_in, W_Done=> data_ready, W_OUT=>W_TEMP, reset_cntW  => reset_cntW , controlcntW => controlcntW);

HASH_COMP : HashLoop port map (clk => clk , W_IN=> W_TEMP, controlcnt => controlcnt ,HV_IN => HV_IN, reset_cnt => reset_cnt, HV=>HV, Hash_Done=>hash_rdy);

process(clk, rst)
    begin
        if(rst='1') then
            curr_state <= RESET;
        elsif(clk'event and clk='1') then  
         case curr_state is 
            when RESET =>
                controlcnt <= '0';
                controlcntW <= '0'; 
                reset_cnt <= '1' ;
                reset_cntW <= '1';
                if(rst='1') then 
                    curr_state <= RESET;
                else
                    curr_state <= IDLE;
                end if ;  
           when IDLE =>
                ap_done <= '0' ;
                ap_ready <= '0';
                ap_idle <= '1'; 
                CNT_BLOCKS <= 0 ;
                HV_IN <= HV_INITIALVALUES;
                --ap_return_temp <= (others => '0');
                if (ap_start = '1') then 
                curr_state <= READ_MSG_BLOCK;
                end if;
           when READ_MSG_BLOCK =>
                ap_idle <= '0'; 
                if( CNT_BLOCKS = 0 ) then 
                    HV_IN <= HV_INITIALVALUES;
                else 
                    HV_IN <= HV ;
                 end if ;
                reset_cnt <= '1' ;
                reset_cntW <= '1' ; 
                controlcnt <= '0';
                controlcntW <= '0' ;
                 curr_state <= W_REG_CALCULATOR;
            when W_REG_CALCULATOR => 
                    controlcntW <= '1' ;
                    reset_cnt <= '0' ;
                    reset_cntW <= '0';
                    controlcnt <= '0';
                    curr_state <= READ_TO_HASH;
           when READ_TO_HASH =>
                    reset_cnt <= '0' ;
                    reset_cntW <= '0';
                    controlcnt <= '0';
                    controlcntW <= '0';
                if (data_ready = '1' ) then 
                     curr_state <= HASH;
                end if ; 
           when HASH => 
                    reset_cnt <= '0' ;
                    controlcntW <= '0' ;
                    reset_cntW <= '0';
                    controlcnt <= '1';
                   if ( CNT_BLOCKS = n_blocks - 1 AND hash_rdy = '1' ) then 
                    curr_state <= DONE ;
                   elsif ( hash_rdy = '1') then
                    CNT_BLOCKS <= CNT_BLOCKS +1;
                    curr_state <= READ_MSG_BLOCK ; 
                   end if ; 
           when DONE =>           
                ap_done <= '1' ;
                ap_ready <= '1';
                ap_return_temp <= HV(0) & HV(1) & HV(2) & HV(3) & HV(4) & HV(5) & HV(6) & HV(7);
                --ap_return <= HV(7)&HV(6)&HV(5)&HV(4)&HV(3)&HV(2)&HV(1)&HV(0);
                curr_state<= IDLE;
           --when CLEAR => -- reset all components for next SHA call (not next SHA block -> this is IDLE) 
                --HV_IN <= HV_INITIALVALUES;
                --curr_state <= IDLE;
                
                
         end case ;
         end if;
     end process ;
     
   REVERSE_OUT : for i in 0 to 255 generate
    --p_read_temp((i+1)*8-1 downto (i*8)) <= p_read((i+2)*4 downto ((i+1)*4));
    ap_returnfinal(i)<=ap_return_temp(255-i);
    ap_returnfinal(i)<=ap_return_temp(255-i);
    ap_returnfinal(i)<=ap_return_temp(255-i);
    end generate;

REVERSE_OUTFINAL : for i in 0 to 31 generate 
    ap_return(i*8)<=ap_returnfinal((i*8)+7);
    ap_return((i*8)+1)<=ap_returnfinal((i*8)+6);
    ap_return((i*8)+2)<=ap_returnfinal((i*8)+5);
    ap_return((i*8)+3)<=ap_returnfinal(i*8+4);
    ap_return((i*8)+4)<=ap_returnfinal(i*8+3);
    ap_return((i*8)+5)<=ap_returnfinal(i*8+2);
    ap_return((i*8)+6)<=ap_returnfinal(i*8+1);
    ap_return((i*8)+7)<=ap_returnfinal(i*8);
    end generate;
    
    
end Behavioral;
