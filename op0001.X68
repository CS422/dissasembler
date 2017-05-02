*-----------------------------------------------------------
* Title      : OPCODE for 0001 MOVE.B
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
*------------------
* Original Machine Code stored in D6(DO not Touch)
* D0 - Desinated register for 3 bit decoding
* D2 -  Desinated Temp register for storing edited machine code (changed this)
*




op0001
            MOVE.B  D6, D2 MOVE the original machine code to D2 to play with
            LSL.B   #1,D2   Shift the bits left by 1, IE 100 LSL.B -> 1000, we get the byte, then shift back LSR.B #1 -> 0100 (OMG EDWARD IS GOD)
            MOVE.B  D2,D0   MOVE OUT SHIFTED BTYE TO PLAY WITH TO D0 
            LSR.B   #1,D0   SHIFT TO GET THE 3 BITS VALUE
            
            JSR     (A6,D3)



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
            
            
            MOVE.B  #3,D5           ;counter for output
            
            
            BRA     printCode
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
