--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:45:03 05/16/2012
-- Design Name:   
-- Module Name:   /opt/Xilinx/13.2/ISE_DS/pcie/pci454/leros_test.vhd
-- Project Name:  pci2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: leros_nexys2
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY leros_test IS
END leros_test;
 
ARCHITECTURE behavior OF leros_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT leros_nexys2
    PORT(
         clk : IN  std_logic;
         led : OUT  std_logic_vector(7 downto 0);
         rstx : OUT  std_logic;
			ser_txd : out std_logic;
			ser_rxd : in std_logic;
			icaddr : out std_logic_vector(26 downto 0);
			iclen : out std_logic_vector(5 downto 0);
			icreq : out std_logic;
			icrden : out std_logic;
			icdata : in std_logic_vector(31 downto 0);
			icempty : in std_logic
        );
    END COMPONENT;
    
	type IMEM_STATE_T is (WAIT_FOR_REQ,TRANSFER);
	signal state : IMEM_STATE_T := WAIT_FOR_REQ;

	-- the data ram
	constant nwords : integer := 2 ** 10;
	type ram_type is array(0 to nwords-1) of std_logic_vector(31 downto 0);
	signal dm : ram_type;
	

   --Inputs
   signal clk : std_logic := '0';
	signal ser_rxd : std_logic := '0';
	
	signal icaddr : std_logic_vector(26 downto 0);
	signal addr : std_logic_vector(24 downto 0);
	signal iclen : std_logic_vector(5 downto 0);
	signal count : std_logic_vector(5 downto 0);
	signal len : std_logic_vector(5 downto 0);
	signal icreq : std_logic;
	signal icrden : std_logic;
	signal icdata : std_logic_vector(31 downto 0);
	signal icempty : std_logic;

 	--Outputs
   signal led : std_logic_vector(7 downto 0);
   signal rstx : std_logic;
	signal ser_txd : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: leros_nexys2 PORT MAP (
          clk => clk,
          led => led,
          rstx => rstx,
			 ser_rxd => ser_rxd,
			 ser_txd => ser_txd,
			 icaddr => icaddr,
			 iclen => iclen,
			 icreq => icreq,
			 icrden => icrden,
			 icdata => icdata,
			 icempty => icempty
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	process(clk)
	begin
		if clk='1' and clk'Event and rstx = '0' then
			if state = WAIT_FOR_REQ then
				icempty <= '1' after 100 ps;
				if icreq = '1' then
					state <= TRANSFER after 100 ps;
					len <= iclen after 100 ps;
					addr <= icaddr(26 downto 2) after 100 ps;
					count <= "000000" after 100 ps;
				end if;
			else
				if count <= len then
						icdata <= dm(to_integer(unsigned(addr)+unsigned(count))) after 100 ps;
						icempty <= '0' after 100 ps;
					if icrden='1' then
						if count < len then
							icdata <= dm(to_integer(unsigned(addr)+unsigned(count)+1)) after 100 ps;
						else
							icempty <= '1' after 100 ps;
							state <= WAIT_FOR_REQ after 100 ps;
						end if;
						count <= std_logic_vector(unsigned(count) + 1) after 100 ps;
					end if;
				else
					icempty <= '1' after 100 ps;
					state <= WAIT_FOR_REQ after 100 ps;
				end if;
			end if;
		end if;
	end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
	--	rstx <= '1';
		
      wait for 100 ns;	

	--	rstx <= '0';
      wait for clk_period*10;


      -- insert stimulus here 

      wait;
   end process;

dm(0) <= X"00000000";
dm(1) <= X"30012100";
dm(2) <= X"00002108";
dm(3) <= X"00004000";
dm(4) <= X"20000000";
dm(5) <= X"70005001";
dm(6) <= X"50012002";
dm(7) <= X"20017001";
dm(8) <= X"09020000";
dm(9) <= X"214c3001";
dm(10) <= X"2d022901";
dm(11) <= X"30022f03";
dm(12) <= X"00002165";
dm(13) <= X"21654000";
dm(14) <= X"21653002";
dm(15) <= X"40000000";
dm(16) <= X"30022172";
dm(17) <= X"00002165";
dm(18) <= X"216f4000";
dm(19) <= X"21653002";
dm(20) <= X"40000000";
dm(21) <= X"30022173";
dm(22) <= X"00002165";
dm(23) <= X"210d4000";
dm(24) <= X"21653002";
dm(25) <= X"40000000";
dm(26) <= X"3002210a";
dm(27) <= X"00002165";
dm(28) <= X"00004000";
dm(29) <= X"0000216f";
dm(30) <= X"00004000";
dm(31) <= X"30022174";
dm(32) <= X"00002165";
dm(33) <= X"00004000";
dm(34) <= X"3002210a";
dm(35) <= X"2900218e";
dm(36) <= X"2f002d00";
dm(37) <= X"40000000";
dm(38) <= X"21750000";
dm(39) <= X"21653002";
dm(40) <= X"40000000";
dm(41) <= X"20030000";
dm(42) <= X"48003800";
dm(43) <= X"20010000";
dm(44) <= X"0d020000";
dm(45) <= X"50013001";
dm(46) <= X"00006001";
dm(47) <= X"50013002";
dm(48) <= X"00006000";
dm(49) <= X"40003000";
dm(50) <= X"3c000000";
dm(51) <= X"00002301";
dm(52) <= X"200249fd";
dm(53) <= X"20003801";
dm(54) <= X"40000000";
dm(55) <= X"00000000";
dm(56) <= X"50012000";
dm(57) <= X"20027000";
dm(58) <= X"70015001";
dm(59) <= X"00002001";
dm(60) <= X"30010902";
dm(61) <= X"30022173";
dm(62) <= X"00002165";
dm(63) <= X"00004000";
dm(64) <= X"00002001";
dm(65) <= X"30010d02";
dm(66) <= X"60015001";
dm(67) <= X"30020000";
dm(68) <= X"60005001";
dm(69) <= X"30000000";
dm(70) <= X"00004000";
dm(71) <= X"20000000";
dm(72) <= X"70005001";
dm(73) <= X"50012002";
dm(74) <= X"20047001";
dm(75) <= X"70025001";
dm(76) <= X"00002001";
dm(77) <= X"30010903";
dm(78) <= X"00002002";
dm(79) <= X"0d01491e";
dm(80) <= X"491b0000";
dm(81) <= X"218e3002";
dm(82) <= X"2d002900";
dm(83) <= X"00002f00";
dm(84) <= X"00004000";
dm(85) <= X"00002003";
dm(86) <= X"20023004";
dm(87) <= X"0d010000";
dm(88) <= X"218e3002";
dm(89) <= X"2d002900";
dm(90) <= X"00002f00";
dm(91) <= X"00004000";
dm(92) <= X"08042003";
dm(93) <= X"00003002";
dm(94) <= X"00002002";
dm(95) <= X"20013003";
dm(96) <= X"0d030000";
dm(97) <= X"50013001";
dm(98) <= X"00006002";
dm(99) <= X"50013004";
dm(100) <= X"00006001";
dm(101) <= X"50013002";
dm(102) <= X"00006000";
dm(103) <= X"40003000";
dm(104) <= X"00000000";
dm(105) <= X"00000000";
dm(106) <= X"00000000";
dm(107) <= X"00000000";
dm(108) <= X"00000000";
dm(109) <= X"00000000";
dm(110) <= X"00000000";
dm(111) <= X"00000000";








END;
