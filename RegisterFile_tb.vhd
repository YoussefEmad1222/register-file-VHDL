library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile_tb is
end RegisterFile_tb;

architecture RegisterFile_tb_behaviour of RegisterFile_tb is
    component RegisterFile is
        port (
            ReadReg1, ReadReg2, WriteReg : in std_logic_vector(4 downto 0);
            WriteData : in std_logic_vector(31 downto 0);
            clk, RegWrite : in std_logic;
            ReadData1, ReadData2 : out std_logic_vector(31 downto 0)
        );
    end component;

    signal ReadReg1, ReadReg2, WriteReg : std_logic_vector(4 downto 0);
    signal WriteData, ReadData1, ReadData2 : std_logic_vector(31 downto 0);
    signal clk, RegWrite : std_logic;
    constant clk_period : time := 100 ps;

begin

    UUT: RegisterFile
    port map (
        ReadReg1 => ReadReg1,
        ReadReg2 => ReadReg2,
        WriteReg => WriteReg,
        WriteData => WriteData,
        clk => clk,
        RegWrite => RegWrite,
        ReadData1 => ReadData1,
        ReadData2 => ReadData2
    );
     -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
---------- Test 1: (Two Cycles)
---------- Write to registers 3 and 2, then read from them -------
        -- wating for rising edge
	wait for clk_period/2;
	WriteReg <= "00011"; -- Register 3
        WriteData <= x"10101010";
        RegWrite <= '1';

	-- wating for falling edge
        wait for clk_period/2;
        ReadReg1 <= "00011"; -- Register 3
        ReadReg2 <= "00010"; -- Register 2
	RegWrite <= '0';
        
	-- wating for rising edge
	wait for clk_period/2;
        WriteReg <= "00010"; -- Register 2
        WriteData <= x"111A111F";
	RegWrite <= '1';
	
	-- wating for falling edge
        wait for clk_period/2;
        ReadReg1 <= "00011"; -- Register 3
        ReadReg2 <= "00010"; -- Register 2
	RegWrite <= '0';
----------------------------------------------------------------------------
	
	
---------- Test 2: (Two Cycles)
---------- Try to modify register 3 when RegWrite = '0' -------
---------- and write value x"FFFFFFFF" to register 5, and read them -------
        -- wating for rising edge
	wait for clk_period/2;
	WriteReg <= "00011"; -- Register 3
        WriteData <= x"1F1F1F1F";
        

	-- wating for falling edge
        wait for clk_period/2;
        ReadReg1 <= "00011"; -- Register 3
        ReadReg2 <= "01010"; -- Register 10
        
	-- wating for rising edge
	wait for clk_period/2;
        WriteReg <= "01010"; -- Register 10
        WriteData <= x"FFFABBBF";
	RegWrite <= '1';
	
	-- wating for falling edge
        wait for clk_period/2;
        ReadReg1 <= "00011"; -- Register 3
        ReadReg2 <= "01010"; -- Register 10
	RegWrite <= '0';
----------------------------------------------------------------------------

---------- Test 3: (One Cycles)
---------- Read register 5 in ReadData1, set WriteData = x"00000000" and  -------
---------- Read register 2 in ReadData2 -------
        -- wating for rising edge
	wait for clk_period/2;
	WriteData <= x"00000000";
	
	-- wating for falling edge
        wait for clk_period/2;
        ReadReg1 <= "01010"; -- Register 10
        ReadReg2 <= "00010"; -- Register 2
----------------------------------------------------------------------------

---------- Test 4: (One Cycles)
---------- Write to register 31 and  -------
---------- Read register 31 in ReadData1 and register 3 in ReadData2 -------       
	-- wating for rising edge
	wait for clk_period/2;
        WriteReg <= "11111"; -- Register 31
        WriteData <= x"FFFFAAAA";
	RegWrite <= '1';
	
	-- wating for falling edge
        wait for clk_period/2;
        ReadReg1 <= "11111"; -- Register 31
        ReadReg2 <= "00011"; -- Register 3
	RegWrite <= '0';
----------------------------------------------------------------------------

---------- Test 5: (One Cycles)
---------- Modify Data in register 3 from x"10101010" to x"FAFAFAFA"  -------
---------- Read register 31 in ReadData1 and register 3 in ReadData2 -------       
	-- wating for rising edge
	wait for clk_period/2;
        WriteReg <= "00011"; -- Register 3
        WriteData <= x"FAFAFAFA";
	RegWrite <= '1';
	
	-- wating for falling edge
        wait for clk_period/2;
        ReadReg1 <= "11111"; -- Register 31
        ReadReg2 <= "00011"; -- Register 3
	RegWrite <= '0';
----------------------------------------------------------------------------
	
        wait ;
     end process;

end RegisterFile_tb_behaviour;
