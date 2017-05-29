*-----------------------------------------------------------
* Title      : OPCODE for 0001 MOVE.B 
* Written by : Edward
* Date       : 2017-05-23
* Description:
* Original Machine Code stored in D6(DO not Touch)
* D0 - Desinated register for jumping table
* D1 - register value 
* D2 - mode value 
*----------------------
* Order of Decoding
* 1. Decode 3-5 bits for Source Mode => Store value at D2, A3 is at the blank
* current at (A2) : ex)MOVE.B (A )
* 2. Decode 0-2 bits for Source Register => Store value at D0
* current at (A2) : ex)MOVE.B (A0), 
* 3. Check for immAb with D2:modeValue and differ with D1:registerValue
* 4. Decode 6-8 bits for Destination Mode 
* => Jump to Mode Table => Store chars in order at (A2)
* current at (A2) : ex)MOVE.B (A0),D
* 5. Decode 6-8 bits for Destination Register 
* => Jump to Mode Table => Store chars in order at (A2)
* current at (A2) : ex)MOVE.B (A0),D1


op0001
            MOVE.L  #2,D7       ;data is not error
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #'M',(A2)+      ;print M
            MOVE.B  #'O',(A2)+      ;print O
            MOVE.B  #'V',(A2)+      ;print V
            MOVE.B  #'E',(A2)+      PRINT  E
            MOVE.B  #'.',(A2)+
            MOVE.B  #'B',(A2)+
            MOVE.B  #' ',(A2)+ 
            MOVE.B  #' ',(A2)+
            JSR     get_3to5_bit
            JSR     get_0to2_bit
*------------------------------------------------------------
* Check D2: mode value for immediate or Absolute addressing
            CMP.B   #7,D2
            BEQ     immAb0001
*------------------------------------------------------------
desDecode0001   
            MOVE.B  #',',(A2)+  comma between operands
*------------------------------------------------------------
            JSR     get_6to8_bit
*------------------------------------------------------------
            JSR     get_9to11_bit 
*------------------------------------------------------------       
* end of decoding
*------------------------------------------------------------
* printing          
            BRA     printCode
*------------------------------------------------------------
immAb0001
* Check for #imm or Absolute addressing with D1: register value
            LEA     immAbTable, A6
            MULU    #8,D1
            JSR     (A6,D1)
            CMP     #32,D1      if immediate data
            BEQ     moveIntPointerWord0001
            BNE     desDecode0001 
moveIntPointerWord0001 
            JSR     moveIntPointerWord 
            BRA     desDecode0001   
*------------------------------------------------------------
* end of file            
*------------------------------------------------------------




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
