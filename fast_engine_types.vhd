-------------------------------------------------------------------------------
--
-- Title       : byte_type
-- Design      : FASTMDEngine
-- Author      : Caio
-- Company     : USP
--
-------------------------------------------------------------------------------
--
-- File        : D:\projetos\HDLMDFAST\HFT\FASTMDEngine\src\byte_type.vhd
-- Generated   : Mon Jan 11 10:26:10 2021
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {byte_type} architecture {byte_type}}	

------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

------------------------------------------------------------
PACKAGE fast_engine_types IS
		TYPE byte_type IS ARRAY (NATURAL RANGE <>) OF STD_lOGIC_VECTOR(7 DOWNTO 0);
		TYPE position_type_px IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(63 DOWNTO 0);
		--TYPE position_type_px IS ARRAY (NATURAL RANGE <>) OF real range (-1.7 ** 308) to (1.7 ** 308);
		--TYPE position_type_px IS ARRAY (NATURAL RANGE <>) OF float64;
		TYPE position_type_size IS ARRAY (NATURAL RANGE <>) OF STD_lOGIC_VECTOR(63 DOWNTO 0);

		TYPE position_type_px_exp IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
		TYPE position_type_px_man IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(63 DOWNTO 0);

end PACKAGE;
------------------------------------------------------------
