*-----------------------------------------------------------
* Title      : OPCODE for 0001 MOVE.B
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
*------------------
* Original Machine Code stored in D6(DO not Touch)
* D0 - Desinated register for 3 bit decoding
* D1 - register value
* D2 - Desinated Temp register for storing edited machine code (changed this)
*




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
* MachineCode: 0001 **** BIT* **** ****
* Only first 3 bits after 4MSB  => Destination Register
* (which is stored at D0)
            CLR     D2
            CLR     D1
            CLR     D0
            MOVE.L  D6,D2       MOVE the original machine code to D2 to play with
            LSL.L   #4,D2       BIT* **** **** 0000
            LSR.L   #8,D2       0000 0000 BIT* ****
            LSR.L   #5,D2       0000 0000 0000 0BIT     
            MOVE.B  D2,D1       MOVE OUT SHIFTED BTYE TO PLAY WITH TO D0 
            MULU    #8,D1
            JSR     registerPrint
*------------------------------------------------------------
* MachineCode: 0001 **** ***B IT** ****
* Only next last 3 bits which is stored at D0 => Destination Address mode
            CLR     D2
            CLR     D1
            CLR     D0
            MOVE.W  D6,D2  MOVE the original machine code to D2 to play with
            LSL.L   #7,D2
            LSR.L   #8,D2
            LSR.L   #5,D2
            MOVE.B  D2,D0
            MULU    #8,D0
            LEA     modeTable,A6 Load the table into A6
            JSR     (A6,D0)     Jump to subroutine of value at D0
*------------------------------------------------------------
* MachineCode: 0001 **** **** **BI T***
* Only next last 3 bits which is stored at D0 => Source Address mode
            CLR     D2
            CLR     D1
            CLR     D0
            MOVE.W  D6,D2  MOVE the original machine code to D2 to play with
            LSL.W   #2,D2
            LSR.W   #5,D2
            MOVE.B  D2,D0
            MULU    #8,D0
            LEA     modeTable,A6 Load the table into A6
            JSR     (A6,D0)     Jump to subroutine of value at D0
*------------------------------------------------------------
* MachineCode: 0001 **** **** **** *BIT
* Only last 3 bits which is stored at D0 => Source Register
            CLR     D2
            CLR     D1
            CLR     D0
            MOVE.W  D6, D2  MOVE the original machine code to D2 to play with
            LSL.B   #1,D2   Shift the bits left by 1, IE 100 LSL.B -> 1000, we get the byte, then shift back LSR.B #1 -> 0100 (OMG EDWARD IS GOD)
            LSR.B   #1,D2
            MOVE.B  D2,D1   MOVE OUT SHIFTED BTYE TO PLAY WITH TO D0             
            MULU    #8,D1
             JSR     registerPrint
*            LEA     numTable,A6 Load the table into A6
*            JSR     (A6,D0)     Jump to subroutine of value at D0
*------------------------------------------------------------
* end of decoding
*------------------------------------------------------------

* printing          
            BRA     printCode












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
