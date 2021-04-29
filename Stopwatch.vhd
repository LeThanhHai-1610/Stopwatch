--Microcomputer Lab Homework 1
--Group 4 has 3 members:
--Lê Thanh Hải      1851027
--Nguyễn Hoàng Tuấn 1851018
--Đặng Vũ Kim Ký    1812744

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
entity Stopwatch is
port
(

	------------ CLOCK ------------
	CLOCK2_50       	:in    	std_logic;
	CLOCK3_50       	:in    	std_logic;
	CLOCK4_50       	:in    	std_logic;
	CLOCK_50        	:in    	std_logic;

	------------ KEY ------------
	KEY             	:in    	std_logic_vector(3 downto 0);

	------------ SW ------------
	SW              	:in    	std_logic_vector(9 downto 0);

	------------ LED ------------
	LEDR            	:out   	std_logic_vector(9 downto 0);

	------------ Seg7 ------------
	HEX0            	:out   	std_logic_vector(6 downto 0);
	HEX1            	:out   	std_logic_vector(6 downto 0);
	HEX2            	:out   	std_logic_vector(6 downto 0);
	HEX3            	:out   	std_logic_vector(6 downto 0);
	HEX4            	:out   	std_logic_vector(6 downto 0);
	HEX5            	:out   	std_logic_vector(6 downto 0)
);

end entity;
architecture rtl of Stopwatch is
signal t: std_logic_vector(2 downto 0);
signal out1,out2,out3,out4,out5,out0: std_logic_vector(3 downto 0);
signal tmp: std_logic_vector(4 downto 0);
signal temp: std_logic := '0';
signal clk2: std_logic;
signal A: std_logic := '1';
signal B: std_logic := '1';
signal C: std_logic := '1';
--------------------------------------------------
component led IS
  PORT ( input : IN STD_LOGIC_VECTOR(3 downto 0);
        output : OUT STD_LOGIC_VECTOR(6 downto 0));
END component;
----------------------------------------------------
component Clock_Divider is
port (clk,reset: in std_logic;
clock_out: out std_logic);
end component;
----------------------------------------------------
begin
process(KEY(1),KEY(2),KEY(3))
BEGIN
IF (KEY(1) = '0') THEN
    A <= '0'; B <= '1'; C <= '1';
ELSIF  (KEY(2) = '0') THEN
    A <= '1'; B <= '0'; C <= '1';
ELSIF  (KEY(3) = '0') THEN
    A <= '1'; B <= '1'; C <= '0';
END IF;
END PROCESS;
-----------------------
process(A,B,C,clk2)
begin
if    (A='0') then 
    out2<="0000";
	 out3<="0000";
	 out4<="0000";
	 out5<="0000";
	 out0<="0000";
	 out1<="0000";
elsif rising_edge (clk2) then
    if(C = '0') then
        if(out0="1001") then
            out0<="0000";
	         out1<=out1+0001;
	     else out0<=out0+0001;out1<=out1;
        end if;
        if ((out0="1001") and (out1="1001")) then
	         out0<="0000";
	         out1<="0000";
	         out2<=out2+0001;
	         if (out2="1001") then 
	             out2<="0000";
		          out3<=out3+0001;
		      else out3<=out3;
	         end if;
	         if ((out2="1001") and (out3="0101")) then
	             out2<="0000";
		          out3<="0000";
		          out4<= out4+0001;
	             if (out4="1001") then 
	                 out4<="0000";
		              out5<=out5+0001;
	             else out5<= out5;
	             end if;
	             if ((out4="1001") and (out5="0101")) then
	                 out2<="0000";
		              out3<="0000";
		              out4<="0000";
		              out5<="0000";
			           out0<="0000";
		              out1<="0000";
	             end if;
	         end if;
	      end if;
    end if;
end if;
end process;	 
S: Clock_Divider port map(CLOCK_50,NOT(B),clk2);
S1:led port map(out2,HEX2);
S2:led port map(out3,HEX3);
S3:led port map(out4,HEX4);
S4:led port map(out5,HEX5);
S5:led port map(out0,HEX0);
S6:led port map(out1,HEX1);
-- body --

end rtl;
---------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY led IS
  PORT ( input : IN STD_LOGIC_VECTOR(3 downto 0);
        output : OUT STD_LOGIC_VECTOR(6 downto 0));
END led;
ARCHITECTURE Behavioral OF led IS
BEGIN
  PROCESS(input)
  BEGIN
    CASE input IS           --  abcdefg
		WHEN "0000" => output <= "1000000"; 
		WHEN "0001" => output <= "1111001"; 
		WHEN "0010" => output <= "0100100"; 
		WHEN "0011" => output <= "0110000"; 
		WHEN "0100" => output <= "0011001"; 
		WHEN "0101" => output <= "0010010";
		WHEN "0110" => output <= "0000010";
		WHEN "0111" => output <= "1111000";
		WHEN "1000" => output <= "0000000";
		WHEN "1001" => output <= "0010000";
		WHEN OTHERS => output <= "1111111";-- ALL OFF
	  END CASE;
  END PROCESS;
END Behavioral;
------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
entity Clock_Divider is
port ( clk,reset: in std_logic;
clock_out: out std_logic);
end Clock_Divider;
architecture bhv of Clock_Divider is
signal count: integer:=1;
signal tmp1 : std_logic := '0';
begin
process(clk,reset)
begin
if(reset = '1') then
count <= 1;
tmp1 <= '0';
elsif(clk'event and clk='1') then
count <= count+1;if (count = 250000) then
tmp1 <= NOT tmp1;
count <= 1;
end if;
end if;
clock_out <= tmp1;
end process;
end bhv;