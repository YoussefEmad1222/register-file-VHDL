LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

Entity RegisterFile is
	port(
		ReadReg1, ReadReg2, WriteReg : IN std_logic_vector(4 downto 0);
		WriteData : IN std_logic_vector(31 downto 0);
		clk, RegWrite : IN std_logic ;
		ReadData1 , ReadData2 : OUT std_logic_vector(31 downto 0)
	);
End RegisterFile;

Architecture RegisterFile_behaviour of RegisterFile is
	-- arrray size = 2^(#bits_to_select_registers) - 1
	type RegFile is array (0 to 31) of std_logic_vector(31 downto 0);
	signal Registers : RegFile;
Begin
	process(clk)
	Begin
		if rising_edge(clk) then
			if RegWrite = '1' then
				Registers(to_integer(unsigned(WriteReg))) <= WriteData;
			end if;
		end if;
		if falling_edge(clk) then
			ReadData1 <=  Registers(to_integer(unsigned(ReadReg1)));
			ReadData2 <=  Registers(to_integer(unsigned(ReadReg2)));
		end if;
	end process;

End RegisterFile_behaviour;