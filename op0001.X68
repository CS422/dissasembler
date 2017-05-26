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
*------------------------------------------------------------
* MachineCode: 0001 **** **** **BI T***
* Only next last 3 bits which is stored at D0 => Source Address mode
            CLR     D2
            CLR     D1
            MOVE.B  D6,D2       MOVE the original machine code to D2 to play with
            LSL.B   #2,D2       **** **** BIT* **00
            LSR.B   #5,D2       **** **** 0000 0BIT
            MOVE.B  D2,D0
            MULU    #8,D0       value adjusted for jumping
            LEA     modeTable,A6 Load the table into A6
            JSR     (A6,D0)     Jump to subroutine of value at D0
*------------------------------------------------------------
* MachineCode: 0001 **** **** **** *BIT
* Only last 3 bits which is stored at D0 => Source Register
            
            MOVE.B  D6, D1      MOVE the original machine code to D1 to play with
            LSL.B   #5,D1       **** **** BIT0 0000
            LSR.B   #5,D1       **** **** 0000 0BIT
            MOVE.B  D1,D0      
            MULU    #8,D0       value adjusted for jumping
            LEA     regNumTable ,A6 Load the table into A6
            JSR     (A6,D0)     Jump to subroutine of value at D1
*------------------------------------------------------------
* Check D2: mode value for immediate or Absolute addressing
            CMP.B   #7,D2
            BEQ     immAb0001
*------------------------------------------------------------
desDecode0001   
            MOVE.B  #',',(A2)+  comma between operands
*------------------------------------------------------------
* MachineCode: 0001 **** ***B IT** ****
* Only next last 3 bits which is stored at D0 => Destination Address mode
            CLR     D2
            CLR     D1
            MOVE.W  D6,D2       MOVE the original machine code to D2 to play with
            LSL.W   #7,D2       BIT* **** **** 0000
            LSR.W   #8,D2       0000 0000 BIT* ****
            LSR.W   #5,D2       0000 0000 0000 0BIT 
            MULU    #8,D2       value adjusted for jumping
            LEA     modeTable,A6 Load the table into A6
            JSR     (A6,D2)     Jump to subroutine of value at D2
*------------------------------------------------------------
* MachineCode: 0001 **** BIT* **** ****
* Decode 3 bits => Destination Register
* Stored at D1
           
            MOVE.W  D6,D1       MOVE the original machine code to D1 to play with
            LSL.W   #4,D1       BIT* **** **** 0000
            LSR.W   #8,D1       0000 0000 BIT* ****
            LSR.W   #5,D1       0000 0000 0000 0BIT     
            MULU    #8,D1       value adjusted for jumping
            LEA     regNumTable ,A6 Load the table into A6
            JSR     (A6,D1)     Jump to subroutine of value at D1    
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
