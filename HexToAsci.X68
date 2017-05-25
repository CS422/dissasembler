*----------------------------------------------------------------------------
*
*               Hex to Ascii Converter
*
*----------------------------------------------------------------------------

;D0 holds the address we are operating on
    
;D1 and D2 hold the counter and terminal values for the loop, respectively

;D3 holds the nibble of that address we are changing to ascii

;D4 holds the intermediate result -- we move the final result into D0 when we're done computing

htoasetup
            MOVEM.L D1-D7/A0-A6, -(SP)  MOVE OUT ALL THE REGISTERS
            MOVEM.L D0,-(SP)
            JSR clearregisters
            MOVEM.L (SP)+,D0
            MOVE.B  #0,D1               MOVE OUR INIT VALUE INTO D1
            MOVE.B  #4,D2               MOVE TERMINAL VALUE INTO D2

htoa
            CLR.L   D3              CLEAR THE REGISTER IN WHICH WE HOLD A PROCESSED HEX CHAR TO BE SHIFTED
            MOVE.B  D0,D3           MOVE A BYTE OF THE ADDRESS INTO D3
            LSL.B   #4,D3           SHIFT OUT THE HIGH ORDER WORD
            LSR.B   #4,D3
            CMP.B D1,D2             COMPARE COUNTER AND TERMINAL VALUES
            BEQ htoafinished            IF THEY'RE EQUAL BRANCH TO BE DONE
            
htoanumber      
            CMPI.B  #$9,D3          COMPARE TO 9
            BGT htoaletter              IF IT'S LARGER THAN 9 IT'S A LETTER
            ADDI.B  #$30,D3         OTHERWISE ADD 30 TO GET THE ASCII NUMBER
            BRA htoamovebyte 

htoaletter      
            ADDI.B  #$37,D3             ADD 37 TO GET THE LETTER IN ASCII
            BRA htoamovebyte
            
htoamovebyte
            LSL.L   #3,D1       MULTIPLY THE COUNTER VALUE BY 8
            LSL.L   D1,D3       SHIFT THE STRING BY 8 * COUNTERVALUE
            LSR.L   #3,D1       SHIFT THE COUNTER VALUE BACK
            
            ADD.L   D3,D4       ADD THE RESULT TO D4, WHERE THE FINAL STRING WILL BE
            LSR.L   #4,D0       SHIFT THE FIRST 4 BITS OUT OF THE STRING STORED IN D0
            ADDQ    #1,D1       INCREMENT THE COUNTER
            BRA htoa      RESTART THE LOOP   

htoafinished
            MOVE.L     D4,D0                MOVE THE FINISHED ADDRESS INTO D0, WHERE WE PROMISED IT WOULD BE                 
            MOVEM.L    (SP)+, D1-D7/A0-A6   MOVE THE REGISTERS BACK OFF THE STACK
            RTS                             RETURN TO THE CALLING ADDRESS  


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
