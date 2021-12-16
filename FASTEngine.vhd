-------------------------------------------------------------------------------
--
-- Title       : FASTEngineMD
-- Design      : FASTEngineMD
-- Author      : Caio
-- Company     : USP
--
-------------------------------------------------------------------------------
--
-- File        : D:\projetos\HDLMDFAST\HFT\FASTMDEngine\compile\FASTEngine.vhd
-- Generated   : Wed Mar  3 14:53:53 2021
-- From        : D:\projetos\HDLMDFAST\HFT\FASTMDEngine\src\FASTEngine.asf
-- By          : FSM2VHDL ver. 5.0.7.2
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

use work.fast_engine_types.all;


entity FASTEngine is 

	generic(
		ABSENT_32 : STD_LOGIC_VECTOR (31 downto 0) := (OTHERS => '1');
		ABSENT_64 : STD_LOGIC_VECTOR (63 downto 0) := (OTHERS => '1');
		ABSENT_32i : STD_LOGIC_VECTOR (31 downto 0) := (X"80000000");
		ABSENT_64i : STD_LOGIC_VECTOR (63 downto 0) := (X"8000000000000000");
		ABSENT_STR : byte_type (0 to 49) := (OTHERS => X"00");
		
		UNDEFINED : STD_LOGIC_VECTOR (1 downto 0) := ("00");
		ASSIGNED : STD_LOGIC_VECTOR (1 downto 0) := ("01");
		EMPTY : STD_LOGIC_VECTOR (1 downto 0) := ("10");

		SecurityID_intended : STD_LOGIC_VECTOR (63 downto 0) := std_logic_vector(to_unsigned(3809639, 64))
	);

	port (
		clk: in STD_LOGIC;
		reset: in STD_LOGIC;
		enable: in STD_LOGIC;

		FASTByte_in: in STD_LOGIC_VECTOR (7 downto 0);
		read_in: in STD_LOGIC;

		startOfMachine_out: out STD_LOGIC;
		reading_out: out STD_LOGIC;

		type_out : out STD_LOGIC;
		updateAction_out : out STD_LOGIC_VECTOR(6 downto 0);
		position_out : out STD_LOGIC_VECTOR(3 downto 0);
		size_out : out STD_LOGIC_VECTOR(63 downto 0);
		exp_out : out STD_LOGIC_VECTOR(31 downto 0);
		man_out : out STD_LOGIC_VECTOR(63 downto 0);

		ready_out : out STD_LOGIC
	);
end FASTEngine;

architecture FASTEngine_arch of FASTEngine is

-- diagram signals declarations

-- readMessage signals declarations
signal sl_enableReadMsg: STD_LOGIC := '1';

signal byteCounter: INTEGER;
signal fieldLength: INTEGER;
signal endField: STD_LOGIC;

signal header: byte_type(0 TO 9);
signal MsgLength: byte_type(0 TO 1);
signal MsgLength_int: INTEGER;
signal PMap: BIT_VECTOR (0 to 31);
signal TemplateID: STD_LOGIC_VECTOR (15 downto 0);
signal MsgSeqNum: byte_type(0 TO 3);

-- MDIncRefresh_145 signals declarations
signal sl_enable145: STD_LOGIC := '1';

signal MD145Available: STD_LOGIC;
signal decode_145: STD_LOGIC;
signal reading_145: STD_LOGIC;

signal FASTByte_145: STD_LOGIC_VECTOR (7 downto 0);
signal fieldLength_145: INTEGER;
signal endField_145: STD_LOGIC;

signal PMap_145: BIT_VECTOR (0 to 31);
signal exp_sig: STD_LOGIC_VECTOR (31 downto 0);
signal thereIsMant: STD_LOGIC;
signal NoMDEntries_counter : INTEGER := 0;

signal MsgSeqNum_145: STD_LOGIC_VECTOR (31 downto 0);
signal NoMDEntries_145: STD_LOGIC_VECTOR (31 downto 0);
signal MDEntriesSequencePMap_145: BIT_VECTOR (0 to 31);
signal MDUpdateAction_145: STD_LOGIC_VECTOR (31 downto 0);
signal MDEntryType_145: byte_type(0 TO 49);
signal SecurityID_145: STD_LOGIC_VECTOR (63 downto 0);
signal MDEntryPx_e_145: STD_LOGIC_VECTOR (31 downto 0);
signal MDEntryPx_m_145: STD_LOGIC_VECTOR (63 downto 0);
signal MDEntrySize_145 : STD_LOGIC_VECTOR (63 downto 0);
signal MDEntryPositionNo_145 : STD_LOGIC_VECTOR (31 downto 0);

signal NoUnderlyings_145 : STD_LOGIC_VECTOR (31 downto 0);

-- orderBook signals declarations
signal sl_orderBook: STD_LOGIC := '1';
signal ofOrDepthBookAvailable: STD_LOGIC; -- out
signal handle: STD_LOGIC;				  -- in


-- SYMBOLIC ENCODED state machine: readMessage
type readMessage_type is (
    Start, wait1, readHeader, getPMap, getTemplateID, controlDecoder
);
-- attribute ENUM_ENCODING of readMessage_type: type is ... -- enum_encoding attribute is not supported for symbolic encoding

signal readMessage, NextState_readMessage: readMessage_type;


-- SYMBOLIC ENCODED state machine: MDIncRefresh_145
type MDIncRefresh_145_type is (
    getQuoteCondition, getRptSeq, getMDEntriesSequence_PMAP, getMDUpdateAction, getMDEntryType,
    getSecurityID, getMDEntryPx_e, Start, getMsgSeqNum, getSendingTime, getTradeDate, getNoMDEntries, getMDEntryPx_m,
	getMDEntryInterestRate_e, getMDEntryInterestRate_m, getNumberOfOrders, getPriceType, getMDEntryTime,
	getMDEntrySize, getMDEntryDate, getMDInsertDate, getMDInsertTime, getMDStreamID, getCurrency,
	getNetChgPrevDay_e, getNetChgPrevDay_m, getSellerDays, getTradeVolume, getTickDirection,
	getTradeCondition, getTradingSessionID, getOpenCloseSettlFlag, getOrderID, getTradeID,
	getMDEntryBuyer, getMDEntrySeller, getMDEntryPositionNo, getSettPriceType, getLastTradeDate,
	getPriceAdjustmentMethod, getPriceBandType, getPriceLimitType, getLowLimitPrice_e, getLowLimitPrice_m,
	getHighLimitPrice_e, getHighLimitPrice_m, getTradingReferencePrice_e, getTradingReferencePrice_m,
	getPriceBandMidpointPriceType, getAvgDailyTradedQty, getExpireDate, getEarlyTermination, getMaxTradeVol,
	getNoUnderlyings, getUnderlyingsSequence_PMap, getUnderlyingSecurityID, getUnderlyingPx_e, 
	getUnderlyingPx_m, getUnderlyingPxType, getIndexSeq, endMachine
);
-- attribute ENUM_ENCODING of MDIncRefresh_145_type: type is ... -- enum_encoding attribute is not supported for symbolic encoding

signal MDIncRefresh_145, NextState_MDIncRefresh_145: MDIncRefresh_145_type;


-- SYMBOLIC ENCODED state machine: orderBook
type orderBook_type is (
    Start, setBook, endMachine
);
-- attribute ENUM_ENCODING of orderBook_type: type is ... -- enum_encoding attribute is not supported for symbolic encoding

signal orderBook, NextState_orderBook: orderBook_type;

-- Declarations of pre-registered internal signals
signal next_byteCounter: INTEGER;
signal next_FASTByte: STD_LOGIC_VECTOR (7 downto 0);
signal next_FASTByte_145: STD_LOGIC_VECTOR (7 downto 0);
signal next_fieldLength: INTEGER;
signal next_fieldLength_145: INTEGER;
signal next_handle: STD_LOGIC;
signal next_MD145Available: STD_LOGIC;
signal next_mem_counter: INTEGER := 0;
signal next_msg_length_145: INTEGER;
signal next_MsgLength: byte_type(0 TO 1);
signal next_MsgLength_int: INTEGER;
signal next_ofOrDepthBookAvailable: STD_LOGIC;
signal next_PMap: BIT_VECTOR (0 to 31);
signal next_PMap_145: BIT_VECTOR (0 to 31);
signal next_TemplateID: STD_LOGIC_VECTOR (15 downto 0);

begin

-- FSM coverage pragmas
-- Aldec enum Machine_MDIncRefresh_145 CURRENT=MDIncRefresh_145
-- Aldec enum Machine_MDIncRefresh_145 NEXT=NextState_MDIncRefresh_145
-- Aldec enum Machine_MDIncRefresh_145 INITIAL_STATE=Start
-- Aldec enum Machine_MDIncRefresh_145 STATES=MDEntries_getMDEntriesSequence_PMAP,MDEntries_getMDEntryPx_e,MDEntries_getMDEntryPx_m,MDEntries_getMDEntryType,MDEntries_getMDUpdateAction,MDEntries_getQuoteCondition,MDEntries_getRptSeq,MDEntries_getSecurityID,getMsgSeqNum,getNoMDEntries,getSendingTime,getTradeDate
-- Aldec enum Machine_MDIncRefresh_145 TRANS=MDEntries_getMDEntriesSequence_PMAP->MDEntries_getMDEntriesSequence_PMAP,MDEntries_getMDEntriesSequence_PMAP->MDEntries_getMDUpdateAction,MDEntries_getMDEntryPx_e->MDEntries_getMDEntryPx_e,MDEntries_getMDEntryPx_e->MDEntries_getMDEntryPx_m,MDEntries_getMDEntryPx_m->MDEntries_getMDEntryPx_m,MDEntries_getMDEntryType->MDEntries_getMDEntryType,MDEntries_getMDEntryType->MDEntries_getSecurityID,MDEntries_getMDUpdateAction->MDEntries_getMDEntryType,MDEntries_getMDUpdateAction->MDEntries_getMDUpdateAction,MDEntries_getQuoteCondition->MDEntries_getMDEntryPx_e,MDEntries_getQuoteCondition->MDEntries_getQuoteCondition,MDEntries_getRptSeq->MDEntries_getQuoteCondition,MDEntries_getRptSeq->MDEntries_getRptSeq,MDEntries_getSecurityID->MDEntries_getRptSeq,MDEntries_getSecurityID->MDEntries_getSecurityID,Start->getMsgSeqNum,getMsgSeqNum->getMsgSeqNum,getMsgSeqNum->getSendingTime,getNoMDEntries->MDEntries_getMDEntriesSequence_PMAP,getNoMDEntries->getNoMDEntries
-- Aldec enum Machine_MDIncRefresh_145 TRANS=getSendingTime->getSendingTime,getSendingTime->getTradeDate,getTradeDate->getNoMDEntries,getTradeDate->getTradeDate


-- FSM coverage pragmas
-- Aldec enum Machine_selectMessage CURRENT=selectMessage
-- Aldec enum Machine_selectMessage NEXT=NextState_selectMessage
-- Aldec enum Machine_selectMessage INITIAL_STATE=Start
-- Aldec enum Machine_selectMessage STATES=endMachine,getPMap,getTemplateID,readHeader,readMsg
-- Aldec enum Machine_selectMessage TRANS=Start->readHeader,getPMap->getPMap,getPMap->getTemplateID,getTemplateID->endMachine,getTemplateID->getTemplateID,readHeader->readMsg,readMsg->getPMap


----------------------------------------------------------------------
-- Machine: readMessage
----------------------------------------------------------------------
------------------------------------
-- Next State Logic (combinatorial)
------------------------------------
readMessage_NextState: process (byteCounter, endField, FASTByte_in, FASTByte_145, fieldLength, header, MD145Available, MsgLength, MsgLength_int, PMap, read_in, reading_145, TemplateID, readMessage)
-- machine variables declarations
variable field: byte_type(0 TO 149);
variable PMap_var: BIT_VECTOR (0 to 31);

begin
	NextState_readMessage <= readMessage;
	-- Set default values for outputs and signals
	startOfMachine_out <= '1';
	reading_out <= '0';
	endField <= '0';
	next_byteCounter <= byteCounter;
	decode_145 <= '0';
	next_fieldLength <= fieldLength;
	next_PMap <= PMap;
	next_TemplateID <= TemplateID;
	next_MsgLength <= MsgLength;
	next_MsgLength_int <= MsgLength_int;
	next_FASTByte_145 <= FASTByte_145;

	case readMessage is
		when Start =>
			startOfMachine_out <= '1';
			reading_out <= '0';
			endField <= '0';
			next_byteCounter <= 0;
			decode_145 <= '0';
			next_fieldLength <= 0;
			field := (OTHERS => X"00");
			next_PMap <= (OTHERS => '0');
			next_TemplateID <= (OTHERS => '0');
			if read_in = '1' then
				NextState_readMessage <= wait1;
			end if;


		when wait1 =>
			startOfMachine_out <= '0';
			reading_out <= '1';
			NextState_readMessage <= readHeader;


		when readHeader =>
			startOfMachine_out <= '0';
			reading_out <= '1';
			header(byteCounter) <= FASTByte_in;
			next_byteCounter <= byteCounter + 1;
			IF (byteCounter = 9) THEN					-- decode header
				MsgSeqNum <= header(0 to 3);
				--NoChunks := header (4 to 5);
				--CurrentChunk := header(6 to 7);
				next_MsgLength <= header(8 to 9);
				next_MsgLength_int <= to_integer(unsigned(header(8)(7 DOWNTO 0)) & unsigned(header(9)(7 DOWNTO 0))) + 10;
				endField <= '1';
			END IF;
			if endField = '0' then
				NextState_readMessage <= readHeader;
			else
				NextState_readMessage <= getPMap;
			end if;
			

		when getPMap =>
			startOfMachine_out <= '0';
			reading_out <= '1';
			field(fieldLength) := FASTByte_in;
			next_byteCounter <= byteCounter + 1;
			IF (FASTByte_in(7) = '0') THEN
				next_fieldLength <= fieldLength + 1;
			ELSIF (FASTByte_in(7) = '1') THEN					--if MSB = 1
				field(fieldLength)(7) := '0';
				PMap_var := (to_bitvector(field(0) & field(1) & field(2) & field(3))) SLL 1;
				next_PMap <= PMap_var;
				IF (PMap_var(1 - 1) = '0') THEN						-- TemplateID
					reading_out <= '0'; -- Block input
				ELSE
					reading_out <= '1';
				END IF;
				endField <= '1';
				next_fieldLength <= 0;
			END IF;
			if endField= '0' then
				NextState_readMessage <= getPMap;
			else
				NextState_readMessage <= getTemplateID;
			end if;


		when getTemplateID =>
			startOfMachine_out <= '0';
			IF (PMap (1 - 1) = '1') THEN
				reading_out <= '1';
				field(fieldLength) := FASTByte_in;
				next_byteCounter <= byteCounter + 1;
				IF (FASTByte_in(7) = '0') THEN
					next_fieldLength <= fieldLength + 1;
				ELSIF (FASTByte_in(7) = '1') THEN
					next_TemplateID <= "00" & field(0)(6 downto 0) & field(1)(6 downto 0);
					endField <= '1';
					next_fieldLength <= 0;
				END IF;
			ELSE
				reading_out <= '0';
				next_TemplateID <= (X"80" & X"00");
				endField <= '1';
				next_fieldLength <= 0;
			END IF;
			if endField = '0' then
				NextState_readMessage <= getTemplateID;
			else
				NextState_readMessage <= controlDecoder;
			end if;
		

		when controlDecoder =>
			startOfMachine_out <= '0';
			IF (byteCounter = MsgLength_int) THEN
				reading_out <= '0';
				endField <= '1';
				next_byteCounter <= 0;
			ELSE
				IF (to_integer(unsigned(TemplateID)) = 145) THEN
					IF (MD145Available = '1') THEN
						decode_145 <= '1';
						IF (reading_145 = '1') THEN
							reading_out <= '1';
							next_FASTByte_145 <= FASTByte_in;
							next_byteCounter <= byteCounter + 1; 
						ELSE
							reading_out <= '0';
						END IF;
					END IF;
				END IF;
			END IF;
			if endField = '0' then
				NextState_readMessage <= controlDecoder;
			else
				NextState_readMessage <= Start;
			end if;
--vhdl_cover_off
		when others =>
			null;
--vhdl_cover_on
	end case;
end process;

------------------------------------
-- Current State Logic (sequential)
------------------------------------
readMessage_CurrentState: process (clk)
begin
	if rising_edge(clk) then
		if reset='1' then
			readMessage <= Start;
		else
			if sl_enableReadMsg = '1' then
				readMessage <= NextState_readMessage;
			end if;
		end if;
	end if;
end process;

------------------------------------
-- Registered Outputs Logic
------------------------------------
readMessage_RegOutput: process (clk)
begin
	if rising_edge(clk) then
		if reset='1' then
			byteCounter <= 0;
			fieldLength <= 0;
			PMap <= (OTHERS => '0');
			TemplateID <= (OTHERS => '0');
		else
			if sl_enableReadMsg = '1' then
				byteCounter <= next_byteCounter;
				fieldLength <= next_fieldLength;
				PMap <= next_PMap;
				TemplateID <= next_TemplateID;
				MsgLength <= next_MsgLength;
				MsgLength_int <= next_MsgLength_int;
				FASTByte_145 <= next_FASTByte_145;
			end if;
		end if;
	end if;
end process;


----------------------------------------------------------------------
-- Machine: MDIncRefresh_145
----------------------------------------------------------------------
------------------------------------
-- Next State Logic (combinatorial)
------------------------------------
MDIncRefresh_145_NextState: process (byteCounter, decode_145, endField_145, FASTByte_145, fieldLength_145, handle, MD145Available, MDEntriesSequencePMap_145, ofOrDepthBookAvailable, PMap, PMap_145, MDIncRefresh_145, thereIsMant)
-- machine variables declarations
variable field: byte_type(0 TO 149);
variable fieldholder_str: byte_type(0 TO 49);
variable fieldholder_ui32: STD_LOGIC_VECTOR (31 downto 0);
variable fieldholder_ui64: STD_LOGIC_VECTOR (63 downto 0);

variable NoMDEntries_var: INTEGER;
variable MDEntriesSequencePMap_var: BIT_VECTOR (0 to 31);
variable prvs_MDUpdateAction: STD_LOGIC_VECTOR (31 downto 0);
variable prvs_MDEntryType: byte_type(0 TO 49);
variable prvs_MDEntryPx_e: INTEGER;
variable prvs_MDEntryPx_m: STD_LOGIC_VECTOR (63 downto 0);
variable prvs_MDEntrySize: STD_LOGIC_VECTOR (63 downto 0);
variable prvs_MDEntryPositionNo : STD_LOGIC_VECTOR (31 downto 0);
variable NoUnderLyings : INTEGER;
variable prvs_SecurityID: STD_LOGIC_VECTOR (63 downto 0);

variable status_MDUpdateAction : STD_LOGIC_VECTOR (1 downto 0) := UNDEFINED;
variable status_MDEntryType : STD_LOGIC_VECTOR (1 downto 0) := UNDEFINED;
variable status_SecurityID : STD_LOGIC_VECTOR (1 downto 0) := UNDEFINED;
variable status_MDEntryPx : STD_LOGIC_VECTOR (1 downto 0) := UNDEFINED;
variable status_MDEntrySize : STD_LOGIC_VECTOR (1 downto 0) := UNDEFINED;

variable delta_delta : STD_LOGIC_VECTOR (63 downto 0);
variable delta_base : STD_LOGIC_VECTOR (63 downto 0);


begin
	NextState_MDIncRefresh_145 <= MDIncRefresh_145;
	-- Set default values for outputs and signals
	next_PMap_145 <= PMap_145;
	next_MD145Available <= MD145Available;
	next_handle <= handle;
	endField_145 <= '0';
	reading_145 <= '1';
	status_MDEntryType := UNDEFINED;

	case MDIncRefresh_145 is
		when Start =>
			next_PMap_145 <= PMap;
			field := (OTHERS => X"00");
			next_fieldLength_145 <= 0;
			next_MD145Available <= '1';
			next_handle <= '0';
			endField_145 <= '0';
			reading_145 <= '1';
			MDEntriesSequencePMap_145 <= (OTHERS => '0');
			NoMDEntries_counter <= 0;

			if decode_145 = '0' then
				NextState_MDIncRefresh_145 <= Start;
			else
				NextState_MDIncRefresh_145 <= getMsgSeqNum;
			end if;
			
			
		when getMsgSeqNum =>
			reading_145 <= '1';
			field(fieldLength_145) := FASTByte_145; 
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN 				--if MSB = 1
				fieldholder_ui32 := ("0000" & (field(0)(6 downto 0) & field(1)(6 downto 0) & field(2)(6 downto 0) & field(3)(6 downto 0)));
				fieldholder_ui32 := to_stdlogicvector(to_bitvector(fieldholder_ui32) SRL ((4 - (fieldLength_145 + 1)) * (8 - 1)));
				MsgSeqNum_145 <= fieldholder_ui32;
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMsgSeqNum;
			else
				NextState_MDIncRefresh_145 <= getSendingTime;
			end if;

		when getSendingTime =>
			field(fieldLength_145) := FASTByte_145; 
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN
				endField_145 <= '1';
				next_fieldLength_145 <= 0;

				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getSendingTime;
			else
				NextState_MDIncRefresh_145 <= getTradeDate;
			end if;
			

		when getTradeDate =>
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN 				--if MSB = 1
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN

				endField_145 <= '1';
				next_fieldLength_145 <= 0;

				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getTradeDate;
			else
				NextState_MDIncRefresh_145 <= getNoMDEntries;
			end if;
			

		when getNoMDEntries =>
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN
				fieldholder_ui32 := ("0000" & (field(0)(6 downto 0) & field(1)(6 downto 0) & field(2)(6 downto 0) & field(3)(6 downto 0)));
				fieldholder_ui32 := to_stdlogicvector(to_bitvector(fieldholder_ui32) SRL ((4 - (fieldLength_145 + 1)) * (8 - 1)));
					
				NoMDEntries_var := to_integer(unsigned(fieldholder_ui32));
				NoMDEntries_145 <= std_logic_vector(to_unsigned(to_integer(unsigned(fieldholder_ui32)), 32));
					
				endField_145 <= '1';
				next_fieldLength_145 <= 0;

				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getNoMDEntries;
			else
				NextState_MDIncRefresh_145 <= getMDEntriesSequence_PMAP; 
			end if;
		

		when getMDEntriesSequence_PMAP =>
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN
				
				fieldholder_ui32 := ((field(0)(6 downto 0) & field(1)(6 downto 0) & field(2)(6 downto 0) & field(3)(6 downto 0)) & "0000");
				MDEntriesSequencePMAP_145 <= to_bitvector(fieldholder_ui32);

				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntriesSequence_PMAP;
			else
				NextState_MDIncRefresh_145 <= getMDUpdateAction;
			end if;
			

		when getMDUpdateAction =>
			--      rules    --
			-- there is pmap
			-- PMap_order is 1
			-- field is MANDATORY
			-- operator is COPY
			-- initial value is 1
			-- It's copy and mandatory = not nullable.
			IF (MDEntriesSequencePmap_145(1 - 1) = '1') THEN
				-- if pmap is 1
				--reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN
					fieldholder_ui32 := ("0000" & (field(0)(6 downto 0) & field(1)(6 downto 0) & field(2)(6 downto 0) & field(3)(6 downto 0)));
					fieldholder_ui32 := to_stdlogicvector(to_bitvector(fieldholder_ui32) SRL ((4 - (fieldLength_145 + 1)) * (8 - 1)));
						
					MDUpdateAction_145 <= fieldholder_ui32;
					prvs_MDUpdateAction := fieldholder_ui32;
					
					status_MDUpdateAction := ASSIGNED;
					IF (field(0) = X"80") THEN 
						status_MDUpdateAction := EMPTY;
					END IF;

					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE
				reading_145 <= '0';
				IF (status_MDUpdateAction = ASSIGNED) THEN									--if assigned
					MDUpdateAction_145 <= prvs_MDUpdateAction;								--value <= previousValue
				ELSIF (status_MDUpdateAction = UNDEFINED) THEN								--if undefined
					MDUpdateAction_145 <= std_logic_vector(to_unsigned(1, 32)); 			--value <= initialValue
					prvs_MDUpdateAction := std_logic_vector(to_unsigned(1, 32));
				ELSIF (status_MDUpdateAction = EMPTY) THEN									--if empty
					MDUpdateAction_145 <= ABSENT_32; 										--value is absent
					prvs_MDUpdateAction := ABSENT_32;
				END IF;
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDUpdateAction;
			else
				NextState_MDIncRefresh_145 <= getMDEntryType;
			end if;
			
			
		when getMDEntryType => -- MD --
			--      rules		--
			-- there is pmap
			-- PMap_order is 2
			-- field is MANDATORY
			-- operator is COPY
			-- initial value is "0"
			IF (MDEntriesSequencePMap_145(2 - 1) = '1') THEN								--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN														--if MSB = 1
					field(0 to 149)(7) := (OTHERS => '0');
					fieldholder_str(0 to (fieldLength_145 + 1)) := field(0 to (fieldLength_145 + 1)); --(6 downto 0);
					fieldholder_str((fieldLength_145 + 1) to 49) := (OTHERS => X"00");

					fieldholder_str(fieldLength_145)(7) := '0';
					
					MDEntryType_145 <= fieldholder_str;
					prvs_MDEntryType := fieldholder_str; 							--conferir tamanho na literatura
					
					status_MDEntryType := ASSIGNED;								--field is being assigned
					IF (field(0) = X"80") THEN 									--if absent
						status_MDEntryType := EMPTY;								--it is empty
					END IF;
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE															--if pmap is 0
				reading_145 <= '0';																	
				IF (status_MDEntryType = ASSIGNED) THEN						--if assigned
					MDEntryType_145 <= prvs_MDEntryType;					--value <= previousValue
				ELSIF (status_MDEntryType = UNDEFINED) THEN					--if undefined
					MDEntryType_145 <= (X"30", OTHERS => X"00"); 			--value <= initialValue
					prvs_MDEntryType := (X"30", OTHERS => X"00");				
				ELSIF (status_MDEntryType = EMPTY) THEN						--if empty
					MDEntryType_145 <= ABSENT_STR; 							--value is absent
					prvs_MDEntryType := ABSENT_STR;
				END IF;			
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntryType;
			else
				NextState_MDIncRefresh_145 <= getSecurityID;
			end if;
			
			
		when getSecurityID => -- MD --
			--      rules		--
			-- there is pmap
			-- PMap_order is 3
			-- field is MANDATORY
			-- operator is COPY
			-- there is no initial value
			IF (MDEntriesSequencePMap_145(3 - 1) = '1') THEN					--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN
					fieldholder_ui64 := ("00000000" & (field(0)(6 downto 0) & field(1)(6 downto 0) & field(2)(6 downto 0) & field(3)(6 downto 0) & field(4)(6 downto 0) & field(5)(6 downto 0) & field(6)(6 downto 0) & field(7)(6 downto 0)));
					fieldholder_ui64 := to_stdlogicvector(to_bitvector(fieldholder_ui64) SRL ((8 - (fieldLength_145 + 1)) * (8 - 1)));
					
					SecurityID_145 <= fieldholder_ui64; --(field(0)(7 downto 0) & field(1)(7 downto 0) & field(2)(7 downto 0) & field(3)(7 downto 0) & field(4)(7 downto 0) & field(5)(7 downto 0) & field(6)(7 downto 0) & field(7)(7 downto 0)); --fieldholder_ui64;
					prvs_SecurityID := fieldholder_ui64;
					
					status_SecurityID := ASSIGNED;								--field is being assigned
					IF (field(0) = X"80") THEN 									--if absent
						status_SecurityID := EMPTY;								--it is empty
					END IF;
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;

					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;	
				END IF;
			ELSE																--if pmap is 0
				reading_145 <= '0';	
				IF (status_SecurityID = ASSIGNED) THEN			--if assigned
					SecurityID_145 <= prvs_SecurityID; 			--value <= previousValue
				ELSIF (status_SecurityID = UNDEFINED) THEN	--if undefined
					SecurityID_145 <= (OTHERS => '0'); 			--value <= initialValue
					prvs_SecurityID := (OTHERS => '0');
				ELSIF (status_SecurityID = EMPTY) THEN			--if empty
					SecurityID_145 <= ABSENT_64; 					--value is absent
					prvs_SecurityID := ABSENT_64;
				END IF;
				endField_145 <= '1';	
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getSecurityID;
			else
				NextState_MDIncRefresh_145 <= getRptSeq;
			end if;
			
		
		when getRptSeq =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 4
			-- field is MANDATORY
			-- operator is INCREMENT
			-- initial value is __
			-- It's increment and mandatory = not nullable.
			IF (MDEntriesSequencePMap_145(4 - 1) = '1') THEN		
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN

					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE
				reading_145 <= '0';																										--if pmap is 0
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getRptSeq;
			else
				NextState_MDIncRefresh_145 <= getQuoteCondition;
			end if;
			
	
		when getQuoteCondition =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 5
			-- field is OPTIONAL
			-- operator is NONE
			-- initial value is __
			IF (MDEntriesSequencePMap_145(5 - 1) = '1') THEN															--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;

					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;	
			ELSE
				reading_145 <= '0';	
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getQuoteCondition;
			else
				NextState_MDIncRefresh_145 <= getMDEntryPx_e;
			end if;
			
			
		when getMDEntryPx_e => -- MD --
			--      rules		--
			-- there is pmap
			-- PMap_order is 6
			-- whole field is OPTIONAL
			
			-- exp --
			-- operator is DEFAULT
			-- initial value is -2
			-- It's default and optional = nullable.
			IF (MDEntriesSequencePMap_145(6 - 1) = '1') THEN					--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN
					IF (field(0) = X"80") THEN 
						MDEntryPx_e_145 <= ABSENT_32i; 							--absent
						MDEntryPx_m_145 <= ABSENT_64;
						thereIsMant <= '0';
					ELSE
						fieldholder_ui32 := ("0000" & (field(0)(6 downto 0) & field(1)(6 downto 0) & field(2)(6 downto 0) & field(3)(6 downto 0)));
						fieldholder_ui32 := to_stdlogicvector(to_bitvector(fieldholder_ui32) SRL ((4 - (fieldLength_145 + 1)) * (8 - 1)));
						thereIsMant <= '1';
						IF (FASTByte_145(6) = '0') THEN				--if positive  (nullable) (fieldholder_ui32(31) = '0')
							MDEntryPx_e_145 <= std_logic_vector(to_signed(to_integer(signed(fieldholder_ui32) - 1), 32));
							prvs_MDEntryPx_e := to_integer(signed(fieldholder_ui32) - 1);
						ELSE
							MDEntryPx_e_145 <= std_logic_vector(to_signed(to_integer(signed(fieldholder_ui32)), 32));
							prvs_MDEntryPx_e := to_integer(signed(fieldholder_ui32));
						END IF;
					END IF;
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE	
				reading_145 <= '0';									
				MDEntryPx_e_145 <= X"000000" & '0' & std_logic_vector(to_signed(-2, 7)); 	--value <= initialValue
				prvs_MDEntryPx_e := -2; 												--std_logic_vector(to_unsigned(-2, 32));
				endField_145 <= '1';
				thereIsMant <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntryPx_e;
			elsif ((endField_145 = '1') AND (thereIsMant = '1')) then
				NextState_MDIncRefresh_145 <= getMDEntryPx_m;
			else
				NextState_MDIncRefresh_145 <= getMDEntryInterestRate_e;
			end if;
			
			
		when getMDEntryPx_m => -- MD --
			--      rules		--
			-- there is pmap
			-- PMap_order is 6
			-- whole field is OPTIONAL
			
			-- mant --
			-- operator is DELTA
			-- initial value is __
			-- It's delta and optional = nullable (?).
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN
				fieldholder_ui64 := ("00000000" & (field(0)(6 downto 0) & field(1)(6 downto 0) & field(2)(6 downto 0) & field(3)(6 downto 0) & field(4)(6 downto 0) & field(5)(6 downto 0) & field(6)(6 downto 0) & field(7)(6 downto 0)));
				fieldholder_ui64 := to_stdlogicvector(to_bitvector(fieldholder_ui64) SRL ((8 - (fieldLength_145 + 1)) * (8 - 1)));
				
				MDEntryPx_m_145 <= fieldholder_ui64;
				prvs_MDEntryPx_m := fieldholder_ui64;
				
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntryPx_m;
			else
				NextState_MDIncRefresh_145 <= getMDEntryInterestRate_e;
			end if;
			
			
		when getMDEntryInterestRate_e =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 7
			-- whole field is OPTIONAL
			
			-- exp --
			-- operator is DEFAULT
			-- initial value is -2
			-- It's default and optional = nullable.
			IF (MDEntriesSequencePMap_145(7 - 1) = '1') THEN			--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN
					IF (field(0) = X"80") THEN		
						thereIsMant <= '0';
					ELSE
						thereIsMant <= '1';
					END IF;

					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE		
				reading_145 <= '0';																			--if pmap is 0
				endField_145 <= '1';
				thereIsMant <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntryInterestRate_e;
			elsif ((endField_145 = '1') AND (thereIsMant = '1')) then
				NextState_MDIncRefresh_145 <= getMDEntryInterestRate_m;
			else
				NextState_MDIncRefresh_145 <= getNumberOfOrders;
			end if;
			
			
		when getMDEntryInterestRate_m =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 6
			-- whole field is OPTIONAL
			
			-- mant --
			-- operator is DELTA
			-- initial value is __
			-- It's delta and optional = nullable (?).
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN --if MSB = 1

				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntryInterestRate_m;
			else
				NextState_MDIncRefresh_145 <= getNumberOfOrders;
			end if;
			
			
		when getNumberOfOrders =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 8
			-- field is OPTIONAL
			-- operator is NONE
			-- initial value is __
			IF (MDEntriesSequencePMap_145(8 - 1) = '1') THEN			--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN						--if MSB = 1
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END If;
			ELSE
				reading_145 <= '0';
				endField_145 <= '1';	
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getNumberOfOrders;
			else
				NextState_MDIncRefresh_145 <= getPriceType;
			end if;
			
			
		when getPriceType =>
			--      rules		--
			-- there is none pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is none
			-- initial value is __
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN																				--if MSB = 1
				
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getPriceType;
			else
				NextState_MDIncRefresh_145 <= getMDEntryTime;
			end if;
			
			
		when getMDEntryTime =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 9
			-- field is MANDATORY
			-- operator is COPY
			-- initial value is __
			-- It's copy and mandatory = not nullable.
			IF (MDEntriesSequencePMap_145(9 - 1) = '1') THEN										--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= next_fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN																--if MSB = 1
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE													--if pmap is 0
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntryTime;
			else
				NextState_MDIncRefresh_145 <= getMDEntrySize;
			end if;
		
		
		when getMDEntrySize => -- MD --
			--      rules		--
			-- there is no pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is DELTA
			-- Initial value is __
			-- It's delta and optional = nullable.
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN											--if MSB = 1
				fieldholder_ui64 := ("00000000" & (field(0)(6 downto 0) & field(1)(6 downto 0) & field(2)(6 downto 0) & field(3)(6 downto 0) & field(4)(6 downto 0) & field(5)(6 downto 0) & field(6)(6 downto 0) & field(7)(6 downto 0)));
				fieldholder_ui64 := to_stdlogicvector(to_bitvector(fieldholder_ui64) SRL ((8 - (fieldLength_145 + 1)) * (8 - 1)));

				fieldholder_ui64 := std_logic_vector(to_signed(to_integer(signed(fieldholder_ui64)) - 1, 64));

				MDEntrySize_145 <=  fieldholder_ui64; 
				prvs_MDEntrySize := fieldholder_ui64; 
				
				delta_delta := fieldholder_ui64;
				IF (status_MDEntrySize = ASSIGNED) THEN										--if assigned
					delta_base := prvs_MDEntrySize;					
				ELSIF (status_MDEntrySize = UNDEFINED) THEN									--if undefined
					delta_base :=  std_logic_vector(to_signed(0, 64));						--the value of the field is the initial value
				ELSIF (status_MDEntrySize = EMPTY) THEN										--if empty
					MDEntrySize_145 <= ABSENT_64i;
					prvs_MDEntrySize := ABSENT_64i;
				END IF;
				MDEntrySize_145 <= std_logic_vector(signed(delta_base) + signed(delta_delta));
				prvs_MDEntrySize := std_logic_vector(signed(delta_base) + signed(delta_delta));
				
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntrySize;
			else
				NextState_MDIncRefresh_145 <= getMDEntryDate;
			end if;
			
			
		when getMDEntryDate =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 10
			-- field is OPTIONAL
			-- operator is COPY
			-- initial value is __
			-- It's copy and optional = nullable.
			IF (MDEntriesSequencePMap_145(10 - 1) = '1') THEN										--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN		--if MSB = 1
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE															--if pmap is 0
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntryDate;
			else
				NextState_MDIncRefresh_145 <= getMDInsertDate;
			end if;
			
			
		when getMDInsertDate =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 11
			-- field is OPTIONAL
			-- operator is COPY
			-- initial value is __
			-- It's copy and optional = nullable.
			IF (MDEntriesSequencePMap_145(11 - 1) = '1') THEN										--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN	
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN																--if MSB = 1
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
				
			ELSE
				reading_145 <= '0';			
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDInsertDate;
			else
				NextState_MDIncRefresh_145 <= getMDInsertTime;
			end if;
			
			
		when getMDInsertTime =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 12
			-- field is OPTIONAL
			-- operator is COPY
			-- initial value is __
			-- It's copy and optional = nullable.
			IF (MDEntriesSequencePMap_145(12 - 1) = '1') THEN										--if pmap is 1	
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN	
					next_fieldLength_145 <= next_fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN																--if MSB = 1
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE								--if pmap is 0
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDInsertTime;
			else
				NextState_MDIncRefresh_145 <= getMDStreamID;
			end if;
			
			
		when getMDStreamID =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 13
			-- field is OPTIONAL
			-- operator is none
			-- initial value is __
			IF (MDEntriesSequencePMap_145(13 - 1) = '1') THEN 				--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN										--if MSB = 1
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE	--if pmap is 0
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDStreamID;
			else
				NextState_MDIncRefresh_145 <= getCurrency;
			end if;
			
		
		when getCurrency =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 14
			-- field is MANDATORY
			-- operator is COPY
			-- initial value is "0"
			IF (MDEntriesSequencePMap_145(14 - 1) = '1') THEN 				--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN	--if MSB = 1
				
					endField_145 <= '1';
					next_fieldLength_145 <= 0;

					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE																--if pmap is 0
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getCurrency;
			else
				NextState_MDIncRefresh_145 <= getNetChgPrevDay_e;
			end if;
		
	
		when getNetChgPrevDay_e =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 15
			-- whole field is OPTIONAL
			
			-- exp --
			-- operator is DEFAULT
			-- initial value is __
			-- It's default and optional = nullable.
			IF (MDEntriesSequencePMap_145(15 - 1) = '1') THEN					-- if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;	
				ELSIF (FASTByte_145(7) = '1') THEN											-- if MSB = 1 (end of field)
					IF (field(0) = X"80") THEN									-- exp is absent
						thereIsMant <= '0';
					ELSE																-- if exp /= 0x80
						thereIsMant <= '1';
					END IF;

					endField_145 <= '1';
					next_fieldLength_145 <= 0;
	
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE																			--	if pmaps is 0 	
				reading_145 <= '0';																-- there is no initialValue
				endField_145 <= '1';
				thereIsMant <= '0';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getNetChgPrevDay_e;
			elsif ((endField_145 = '1') AND (thereIsMant = '1')) then
				NextState_MDIncRefresh_145 <= getNetChgPrevDay_m;
			else
				NextState_MDIncRefresh_145 <= getSellerDays;
			end if;
			
			
		when getNetChgPrevDay_m =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 15
			-- whole field is OPTIONAL
			
			-- mant --
			-- operator is DELTA
			-- initial value is __
			-- It's delta and optional = nullable (?).
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN						

				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getNetChgPrevDay_m;
			else
				NextState_MDIncRefresh_145 <= getSellerDays;
			end if;
			
			
		when getSellerDays =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 16
			-- field is OPTIONAL
			-- operator is NONE
			-- initial value is __
			-- It's noneOperator and optional = not nullable.
			IF (MDEntriesSequencePMap_145(16 - 1) = '1') THEN					--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN											--if MSB = 1
				
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE																			-- if pmap is 0
				reading_145 <= '0';															
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getSellerDays;
			else
				NextState_MDIncRefresh_145 <= getTradeVolume;
			end if;
			
			
		when getTradeVolume =>
			--      rules		--
			-- there is no pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is DELTA
			-- Initial value is __
			-- It's delta and optional = nullable (?).
			
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN									--if MSB = 1

				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getTradeVolume;
			else
				NextState_MDIncRefresh_145 <= getTickDirection;
			end if;
			
			
		when getTickDirection =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 17
			-- field is OPTIONAL
			-- operator is NONE
			-- Initial value is __
			IF (MDEntriesSequencePMap_145(17 - 1) = '1') THEN 				--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE	--if pmap is 0
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getTickDirection;
			else
				NextState_MDIncRefresh_145 <= getTradeCondition;
			end if;
			
			
		when getTradeCondition =>
			--      rules		--
			-- there is no pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is NONE
			-- Initial value is __
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN

				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getTradeCondition;
			else
				NextState_MDIncRefresh_145 <= getTradingSessionID;
			end if;
			
			
		when getTradingSessionID =>
			--      rules		--
			-- there is no  pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is NONE
			-- initial value is __
			-- It's noneOperator and optional = not nullable.
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN															--if MSB = 1
				
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getTradingSessionID;
			else
				NextState_MDIncRefresh_145 <= getOpenCloseSettlFlag;
			end if;
			
			
		when getOpenCloseSettlFlag =>
			--      rules		--
			-- there is no  pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is NONE
			-- initial value is __
			-- It's noneOperator and optional = not nullable.
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN																--if MSB = 1
				
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getOpenCloseSettlFlag;
			else
				NextState_MDIncRefresh_145 <= getOrderID;
			end if;
			
			
		when getOrderID => 
			--      rules		--
			-- there is pmap
			-- PMap_order is 18
			-- field is OPTIONAL
			-- operator is NONE
			-- Initial value is __
			IF (MDEntriesSequencePMap_145(18 - 1) = '1') THEN 				--if pmap is 1	
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE																	--if pmap is 0
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getOrderID;
			else
				NextState_MDIncRefresh_145 <= getTradeID;
			end if;
			
			
		when getTradeID =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 19
			-- field is OPTIONAL
			-- operator is NONE
			-- Initial value is __
			IF (MDEntriesSequencePMap_145(19 - 1) = '1') THEN 				--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE																	--if pmap is 0
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getTradeID;
			else
				NextState_MDIncRefresh_145 <= getMDEntryBuyer;
			end if;
			
			
		when getMDEntryBuyer =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 20
			-- field is OPTIONAL
			-- operator is NONE
			-- Initial value is __
			IF (MDEntriesSequencePMap_145(20 - 1) = '1') THEN 				--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE																	--if pmap is 0
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntryBuyer;
			else
				NextState_MDIncRefresh_145 <= getMDEntrySeller;
			end if;
			
			
		when getMDEntrySeller =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 21
			-- field is OPTIONAL
			-- operator is NONE
			-- Initial value is __
			IF (MDEntriesSequencePMap_145(21 - 1) = '1') THEN 				--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE																	--if pmap is 0
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntrySeller;
			else
				NextState_MDIncRefresh_145 <= getMDEntryPositionNo;
			end if;
			
			
		when getMDEntryPositionNo => -- MD --
			--      rules		--
			-- there is pmap
			-- PMap_order is 22
			-- field is OPTIONAL
			-- operator is NONE
			-- initial value is __
			-- It's noneOperator and optional = nullable.
			IF (MDEntriesSequencePMap_145(22 - 1) = '1') THEN					--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN																--if MSB = 1
					fieldholder_ui32 := ("0000" & (field(0)(6 downto 0) & field(1)(6 downto 0) & field(2)(6 downto 0) & field(3)(6 downto 0)));
					fieldholder_ui32 := to_stdlogicvector(to_bitvector(fieldholder_ui32) SRL ((4 - (fieldLength_145 + 1)) * (8 - 1)));
					
					MDEntryPositionNo_145 <= std_logic_vector(unsigned(fieldholder_ui32) - 1);
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE				-- if pmap is 0
				reading_145 <= '0';
				MDEntryPositionNo_145 <= ABSENT_32;											-- absent
				prvs_MDEntryPositionNo := ABSENT_32;										-- absent
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMDEntryPositionNo;
			else
				NextState_MDIncRefresh_145 <= getSettPriceType;
			end if;
	

		when getSettPriceType =>
			--      rules		--
			-- there is no  pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is NONE
			-- initial value is __
			-- It's noneOperator and optional = not nullable.
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN																--if MSB = 1
				
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getSettPriceType;
			else
				NextState_MDIncRefresh_145 <= getLastTradeDate;
			end if;
			
			
		when getLastTradeDate =>
			--      rules		--
			-- there is no  pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is NONE
			-- initial value is __
			-- It's noneOperator and optional = not nullable.
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN																--if MSB = 1
			
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getLastTradeDate;
			else
				NextState_MDIncRefresh_145 <= getPriceAdjustmentMethod;
			end if;
			
			
		when getPriceAdjustmentMethod =>
			--      rules		--
			-- there is no  pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is NONE
			-- initial value is __
			-- It's noneOperator and optional = not nullable.
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN																--if MSB = 1
				
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getPriceAdjustmentMethod;
			else
				NextState_MDIncRefresh_145 <= getPriceBandType;
			end if;
			
			
		when getPriceBandType =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 23
			-- field is OPTIONAL
			-- operator is NONE
			-- Initial value is __
			IF (MDEntriesSequencePMap_145(23 - 1) = '1') THEN 				--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN
					
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE																	--if pmap is 0
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getPriceBandType;
			else
				NextState_MDIncRefresh_145 <= getPriceLimitType;
			end if;
			
			
		when getPriceLimitType =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 24
			-- field is OPTIONAL
			-- operator is NONE
			-- initial value is __
			-- It's noneOperator and optional = not nullable.
			IF (MDEntriesSequencePMap_145(24 - 1) = '1') THEN							--if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN													--if MSB = 1
	
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE
				reading_145 <= '0';
				endField_145 <= '1';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getPriceLimitType;
			else
				NextState_MDIncRefresh_145 <= getLowLimitPrice_e;
			end if;
			
			
		when getLowLimitPrice_e =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 25
			-- whole field is OPTIONAL
			
			-- exp --
			-- operator is DEFAULT
			-- initial value is __
			-- It's default and optional = nullable.
			IF (MDEntriesSequencePMap_145(25 - 1) = '1') THEN					-- if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF  (FASTByte_145(7) = '1') THEN											-- if MSB = 1 (end of field)
					IF (field(0) = X"80") THEN									-- if exp is absent
						thereIsMant <= '0';
					ELSE										-- mant is in stream
						thereIsMant <= '1';
					END IF;
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE														-- there is no initialValue
				reading_145 <= '0';
				endField_145 <= '1';
				thereIsMant <= '0';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getLowLimitPrice_e;
			elsif ((endField_145 = '1') AND (thereIsMant = '1')) then
				NextState_MDIncRefresh_145 <= getLowLimitPrice_m;
			else
				NextState_MDIncRefresh_145 <= getHighLimitPrice_e;
			end if;
			
			
		when getLowLimitPrice_m =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 25
			-- whole field is OPTIONAL
			
			-- mant --
			-- operator is DELTA
			-- initial value is __
			-- It's delta and optional = nullable (?).
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN	--if MSB = 1
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getLowLimitPrice_m;
			else
				NextState_MDIncRefresh_145 <= getHighLimitPrice_e;
			end if;
			
			
		when getHighLimitPrice_e =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 26
			-- whole field is OPTIONAL
			
			-- exp --
			-- operator is DEFAULT
			-- initial value is __
			-- It's default and optional = nullable.
			IF (MDEntriesSequencePMap_145(26 - 1) = '1') THEN						-- if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;				
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;
				ELSIF (FASTByte_145(7) = '1') THEN												-- if MSB = 1 (end of field)
					IF (field(0) = X"80") THEN										-- if exp is absent
						thereIsMant <= '0';
					ELSE					
						thereIsMant <= '1';										-- mant is in stream
					END IF;
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE																									-- if pmap is 0
				reading_145 <= '0';																-- there is no initialValue
				endField_145 <= '1';
				thereIsMant <= '0';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getHighLimitPrice_e;
			elsif ((endField_145 = '1') AND (thereIsMant = '1')) then
				NextState_MDIncRefresh_145 <= getHighLimitPrice_m;
			else
				NextState_MDIncRefresh_145 <= getTradingReferencePrice_e;
			end if;
			
			
		when getHighLimitPrice_m =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 26
			-- whole field is OPTIONAL
			
			-- mant --
			-- operator is DELTA
			-- initial value is __
			-- It's delta and optional = nullable (?).
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN											--if MSB = 1
				
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getHighLimitPrice_m;
			else
				NextState_MDIncRefresh_145 <= getTradingReferencePrice_e;
			end if;
			
			
		when getTradingReferencePrice_e =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 27
			-- whole field is OPTIONAL
			
			-- exp --
			-- operator is DEFAULT
			-- initial value is __
			-- It's default and optional = nullable.
			IF (MDEntriesSequencePMap_145(27 - 1) = '1') THEN																															-- if pmap is 1
				reading_145 <= '1';
				field(fieldLength_145) := FASTByte_145;	
				IF (FASTByte_145(7) = '0') THEN
					next_fieldLength_145 <= fieldLength_145 + 1;		
				ELSIF (FASTByte_145(7) = '1') THEN																																					-- if MSB = 1 (end of field)
					IF (field(0) = X"80") THEN		
						thereIsMant <= '0';																																		-- mant is absent
					ELSE																																						-- if exp /= 0x80
						thereIsMant <= '1';																																		-- mant is in stream		
					END IF;
					endField_145 <= '1';
					next_fieldLength_145 <= 0;
					
					IF (endField_145 = '1') THEN
						field := (OTHERS => X"00");
					END IF;
				END IF;
			ELSE																			-- there is no initialValue
				reading_145 <= '0';
				endField_145 <= '1';
				thereIsMant <= '0';
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getTradingReferencePrice_e;
			elsif ((endField_145 = '1') AND (thereIsMant = '1')) then
				NextState_MDIncRefresh_145 <= getTradingReferencePrice_m;
			else
				NextState_MDIncRefresh_145 <= getPriceBandMidpointPriceType;
			end if;
			
			
		when getTradingReferencePrice_m =>
			--      rules		--
			-- there is pmap
			-- PMap_order is 27
			-- whole field is OPTIONAL
			
			-- mant --
			-- operator is DELTA
			-- initial value is __
			-- It's delta and optional = nullable (?).
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN											--if MSB = 1
			
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getTradingReferencePrice_m;
			else
				NextState_MDIncRefresh_145 <= getPriceBandMidpointPriceType;
			end if;
			
			
		when getPriceBandMidpointPriceType =>
			--      rules		--
			-- there is no  pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is NONE
			-- initial value is __
			-- It's noneOperator and optional = not nullable.
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN																--if MSB = 1
				
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getPriceBandMidpointPriceType;
			else
				NextState_MDIncRefresh_145 <= getAvgDailyTradedQty;
			end if;
			
			
		when getAvgDailyTradedQty =>
			--      rules		--
			-- there is no pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is none
			-- Initial value is __
			-- It's delta and optional = nullable (?).
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN								--if MSB = 1
			
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getAvgDailyTradedQty;
			else
				NextState_MDIncRefresh_145 <= getExpireDate;
			end if;
			
			
		when getExpireDate =>
			--      rules		--
			-- there is no pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is none
			-- Initial value is __
			-- It's delta and optional = nullable (?).
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN								--if MSB = 1
			
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getExpireDate;
			else
				NextState_MDIncRefresh_145 <= getEarlyTermination;
			end if;
			
			
		when getEarlyTermination =>
			--      rules		--
			-- there is no pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is none
			-- Initial value is __
			-- It's delta and optional = nullable (?).
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN								--if MSB = 1
	
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getEarlyTermination;
			else
				NextState_MDIncRefresh_145 <= getMaxTradeVol;
			end if;
			
			
		when getMaxTradeVol =>
			--      rules		--
			-- there is no pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is none
			-- Initial value is __
			-- It's delta and optional = nullable (?).
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN								--if MSB = 1
			
				endField_145 <= '1';
				next_fieldLength_145 <= 0;

				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getMaxTradeVol;
			else
				NextState_MDIncRefresh_145 <= getNoUnderlyings;
			end if;
			
			
		when getNoUnderlyings =>
			--      rules		--
			-- there is no  pmap
			-- PMap_order is __
			-- field is MANDATORY
			-- operator is NONE
			-- initial value is __
			-- It's noneOperator and MANDATORY = not nullable.
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN																--if MSB = 1
				fieldholder_ui32 := ("0000" & (field(0)(6 downto 0) & field(1)(6 downto 0) & field(2)(6 downto 0) & field(3)(6 downto 0)));
				fieldholder_ui32 := to_stdlogicvector(to_bitvector(fieldholder_ui32) SRL ((4 - fieldLength_145) * (8 - 1)));
				
				NoUnderLyings := to_integer(unsigned(fieldHolder_ui32));
				NoUnderLyings_145 <= fieldholder_ui32;
				
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
				
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getNoUnderlyings;
			--elsif (endField_145 = '1' AND NoUnderLyings > 0) then 
				--NextState_MDIncRefresh_145 <= getUnderlyingsSequence_PMap;
			else
				NextState_MDIncRefresh_145 <= getIndexSeq;
			end if;
			
			
		when getUnderlyingsSequence_PMap =>							-- begin of Underlyins Sequence
			
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getUnderlyingsSequence_PMap;
			else
				NextState_MDIncRefresh_145 <= getUnderlyingSecurityID;
			end if;
			
		
		when getUnderlyingSecurityID =>
			
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getUnderlyingSecurityID;
			else
				NextState_MDIncRefresh_145 <= getUnderlyingPx_e;
			end if;	
			
			
		when getUnderlyingPx_e =>
			
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getUnderlyingPx_e;
			elsif ((endField_145 = '1') AND (thereIsMant = '1')) then
				NextState_MDIncRefresh_145 <= getUnderlyingPx_m;
			else
				NextState_MDIncRefresh_145 <= getUnderlyingPxType;
			end if;
		
	
		when getUnderlyingPx_m =>
			
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getUnderlyingPx_m;
			else
				NextState_MDIncRefresh_145 <= getUnderlyingPxType;
			end if;
			
			
		when getUnderlyingPxType =>									-- end of Underlyins Sequence and enf of MDEntries sequence
			
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getUnderlyingPxType;
			else
				NextState_MDIncRefresh_145 <= getIndexSeq;
			end if;	
			
			
		when getIndexSeq =>
			--      rules		--
			-- there is no pmap
			-- PMap_order is __
			-- field is OPTIONAL
			-- operator is none
			-- Initial value is __
			-- It's delta and optional = nullable (?).
			field(fieldLength_145) := FASTByte_145;
			IF (FASTByte_145(7) = '0') THEN
				next_fieldLength_145 <= fieldLength_145 + 1;
			ELSIF (FASTByte_145(7) = '1') THEN								--if MSB = 1
			
				endField_145 <= '1';
				next_fieldLength_145 <= 0;
			
				IF (endField_145 = '1') THEN
					field := (OTHERS => X"00");
				END IF;

				NoMDEntries_counter <= NoMDEntries_counter + 1;
				IF (ofOrDepthBookAvailable = '1') THEN
					next_handle <= '1';
				END IF;
			END IF;
			if endField_145 = '0' then
				NextState_MDIncRefresh_145 <= getIndexSeq;
			elsif NoMDEntries_counter < NoMDEntries_var then
				NextState_MDIncRefresh_145 <= getMDEntriesSequence_PMAP;
			else
				NextState_MDIncRefresh_145 <= endMachine;
			end if;	
			
		
		when endMachine =>
				NextState_MDIncRefresh_145 <= Start;
			
			
--vhdl_cover_off
		when others =>
			null;
--vhdl_cover_on
	end case;
end process;

----------------------------------
-- Current State Logic (sequential)
----------------------------------
MDIncRefresh_145_CurrentState: process (clk)
begin
	if rising_edge(clk) then
		if reset='1' then
			MDIncRefresh_145 <= Start;
		else
			if sl_enable145 = '1' then
				MDIncRefresh_145 <= NextState_MDIncRefresh_145;
			end if;
		end if;
	end if;
end process;

----------------------------------
-- Registered Outputs Logic
----------------------------------
MDIncRefresh_145_RegOutput: process (clk)
begin
	if rising_edge(clk) then
		if reset = '1' then
			PMap_145 <= PMap;
			fieldLength_145 <= 0;
			MD145Available <= '1';
			handle <= '0';
		else
			if sl_enable145 = '1' then
				PMap_145 <= next_PMap_145;
				fieldLength_145 <= next_fieldLength_145;
				MD145Available <= next_MD145Available;
				handle <= next_handle;
			end if;
		end if;
	end if;
end process;


----------------------------------------------------------------------
-- Machine: orderBook
----------------------------------------------------------------------
------------------------------------
-- Next State Logic (combinatorial)
------------------------------------
orderBook_NextState: process (handle, MDEntryPx_e_145, MDEntryPx_m_145, ofOrDepthBookAvailable, orderBook, SecurityID_145, MDEntryPositionNo_145, MDEntryType_145, MDUpdateAction_145)
-- machine variable declarations

variable stdSize : STD_LOGIC_VECTOR(63 downto 0);
variable stdExp : STD_LOGIC_VECTOR(31 downto 0);
variable stdMan : STD_LOGIC_VECTOR(63 downto 0);

begin
	NextState_orderBook <= orderBook;
	-- Set default values for outputs and signals
	next_ofOrDepthBookAvailable <= ofOrDepthBookAvailable;
	ready_out <= '0';
	case orderBook is
		when Start =>
			next_ofOrDepthBookAvailable <= '1';
			if handle = '1' then
				NextState_orderBook <= setBook;
			end if;

		when setBook =>
			next_ofOrDepthBookAvailable <= '0';

			IF (MDEntryPx_e_145 /= X"80000000" AND MDEntryPx_m_145 /= ABSENT_64) THEN
				
				IF (MDEntryPx_e_145(6) = '1') THEN
				
					stdExp(6 downto 0) := MDEntryPx_e_145(6 downto 0);
					stdExp(31 downto 7) := (OTHERS => '1');
				
				ELSE
					stdExp := MDEntryPx_e_145;
				END IF;
				
				stdSize := MDEntrySize_145;
				stdMan := MDEntryPx_m_145;
				
			else
				stdSize := X"0000000000000000";
				stdExp := X"00000001";
				stdMan := X"BFF0000000000000";
			END IF;
			IF ((SecurityID_145 = SecurityID_intended) AND (signed(MDEntryPositionNo_145) < 11) AND (signed(MDEntryPositionNo_145) > 0)) THEN
				IF (MDUpdateAction_145 = std_logic_vector(to_unsigned(0, 32))) THEN									-- new
					IF (MDEntryType_145(0) = X"30" AND MDEntryType_145(1 to 49) = ABSENT_STR(1 to 49)) THEN			-- bid

						type_out <= '0';
						updateAction_out <= "0110000"; 											 -- 0 in binary MDUpdateAction_145(6 downto 0);
						position_out <= MDEntryPositionNo_145(3 downto 0);
						size_out <= stdSize;
						exp_out <= stdExp;
						man_out <= stdMan;
						ready_out <= '1';

					ELSIF (MDEntryType_145(0) = X"31" AND MDEntryType_145(1 to 49) = ABSENT_STR(1 to 49)) THEN		-- offer
						type_out <= '1';
						updateAction_out <= MDUpdateAction_145(6 downto 0);
						position_out <= MDEntryPositionNo_145(3 downto 0);
						size_out <= stdSize;
						exp_out <= stdExp;
						man_out <= stdMan;
						ready_out <= '1';
					END IF;
				END IF;
			END IF;
			NextState_orderBook <= endMachine;

		when endMachine =>
			NextState_orderBook <= Start;
--vhdl_cover_off
		when others =>
			null;
--vhdl_cover_on
	end case;
end process;

------------------------------------
-- Current State Logic (sequential)
------------------------------------
orderBook_CurrentState: process (clk)
begin
	if rising_edge(clk) then
		if reset = '1' then
			orderBook <= Start;
		else
			if sl_orderBook = '1' then
				orderBook <= NextState_orderBook;
			end if;
		end if;
	end if;
end process;

------------------------------------
-- Registered Outputs Logic
------------------------------------
orderBook_RegOutput: process (clk)
begin
	if rising_edge(clk) then
		if reset = '1' then
			ofOrDepthBookAvailable <= '1';
		else
			if sl_orderBook = '1' then
				ofOrDepthBookAvailable <= next_ofOrDepthBookAvailable;
			end if;
		end if;
	end if;
end process;

end FASTEngine_arch;