*-----------------------------------------------------------
* Title      : OPCODE for 0001 MOVE.B
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
*------------------
* Original Machine Code stored in D6(DO not Touch)
* D0 - Desinated register for 3 bit decoding
* D1 - register value for jumping to numTable with
* D2 - mode value for jumping to modTable with
*----------------------
* Order of Decoding
* 1. Decode 3bits for Destination Register => Store value at D0
* current at (A2) : ex)MOVE.B 
* 2. Decode 3bits for Destination Mode 
* => Jump to Mode Table => Store chars in order at (A2)
* current at (A2) : ex)MOVE.B (A
* => during the storing process, get D0 value and store char at (A2)
* current at (A2) : ex)MOVE.B (A0),
* 3. Decode 3bits for Source Register => Store value at D0
* current at (A2) : ex)MOVE.B (A0),
* 4. Decode 3bits for Source Mode 
* => Jump to Mode Table => Store chars in order at (A2)
* current at (A2) : ex)MOVE.B (A0),D
* => during the storing process, get D0 value and store char at (A2)
* current at (A2) : ex)MOVE.B (A0),D7




op0001
*------------------------------------------------------------
* OPCC **** **** **** ****
* 4 MSB determines the opcode and size 
* this case MOVE.B
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
           
            MOVE.L  D6,D1       MOVE the original machine code to D1 to play with
            LSL.W   #4,D1       BIT* **** **** 0000
            LSR.W   #8,D1       0000 0000 BIT* ****
            LSR.W   #5,D1       0000 0000 0000 0BIT     
            MULU    #8,D1       value adjusted for jumping
            LEA     regNumTable ,A7 Load the table into A7
            JSR     (A7,D1)     Jump to subroutine of value at D1    
*------------------------------------------------------------         
            MOVE.B  #',',(A2)+  comma between operands
*------------------------------------------------------------
* MachineCode: 0001 **** **** **BI T***
* Only next last 3 bits which is stored at D0 => Source Address mode
            CLR     D2
            CLR     D1
            MOVE.W  D6,D2       MOVE the original machine code to D2 to play with
            LSL.W   #2,D2       **** **** BIT* ***0
            LSR.W   #5,D2       **** **** 0000 0BIT
            MULU    #8,D2       value adjusted for jumping
            LEA     modeTable,A6 Load the table into A6
            JSR     (A6,D2)     Jump to subroutine of value at D0
*------------------------------------------------------------
* MachineCode: 0001 **** **** **** *BIT
* Only last 3 bits which is stored at D0 => Source Register
            
            MOVE.W  D6, D1      MOVE the original machine code to D1 to play with
            LSL.B   #1,D1       **** **** **** BIT0
            LSR.B   #1,D1       **** **** **** 0BIT      
            MULU    #8,D1       value adjusted for jumping
            LEA     regNumTable ,A7 Load the table into A7
            JSR     (A7,D1)     Jump to subroutine of value at D1

*------------------------------------------------------------
* end of decoding
*------------------------------------------------------------

* printing          
            BRA     printCode














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
