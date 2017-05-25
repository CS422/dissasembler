;D0 holds the address we are operating on

;D1 and D2 hold the counter and terminal values, respectively

;D3 holds the translated hex char before it is shifted (to be added to D5)

;D4 holds the assembled string

;Result is stored in D0 once the whole address has been processed

atohsetup       
            MOVEM.L D1-D7/A0-A6, -(SP)  MOVE OUT ALL THE REGISTERS
            MOVE.B  #0,D1               MOVE OUR INIT VALUE INTO D1
            MOVE.B  #4,D2               MOVE TERMINAL VALUE INTO D2
            
atoh
            CLR.L   D3              CLEAR THE REGISTER IN WHICH WE HOLD A PROCESSED HEX CHAR TO BE SHIFTED
            CMP.B D1,D2             COMPARE COUNTER AND TERMINAL VALUES
            BEQ atohfinished            IF THEY'RE EQUAL BRANCH TO BE DONE
            
atohnumber      
            CMPI.B  #$30,D0         COMPARE THE FIRST BYTE OF THE STRING TO 30
            BLT invalidasciichar    IF IT'S LESS THAN 30 PRINT AN ERROR
            CMPI.B  #$39,D0         COMPARE TO 39
            BGT atohletter              IF IT'S LARGER THAN 39 IT'S OUTSIDE OF THE ASCII NUMBERS
            SUBI.B  #$30,D0         OTHERWISE SUBTRACT 30 TO GET THE HEX NUMBER
            BRA atohmovebyte
            
atohletter            
            CMPI.B  #$41,D0             COMPARE THE FIRST BYTE OF THE STRING TO 41
            BLT invalidasciichar        IF IT'S LESS THAN 41 THEN IT'S LESS THAN ASCII 'A'
            CMPI.B  #$46,D0             COMPARE UPPER RANGE, 46 IS F IN ASCII
            BGT invalidasciichar        IF IT'S LARGER THAN 46 PRINT AN ERROR
            SUBI.B  #$37,D0             SUBTRACT 37 TO GET THE LETTER IN HEX
            BRA atohmovebyte
            
atohmovebyte
            MOVE.B  D0,D3       COPY THE FIRST BYTE OF THE STRING, WHICH WE JUST CHANGED TO HEX
            LSL.L   #2,D1       MULTIPLY THE COUNTER VALUE BY 4
            LSL.L   D1,D3       SHIFT THE STRING BY 4 * COUNTERVALUE
            LSR.L   #2,D1       SHIFT THE COUNTER VALUE BACK
            
            ADD.L   D3,D4       ADD THE RESULT TO D4, WHERE THE FINAL STRING WILL BE
            LSR.L #8,D0         SHIFT THE FIRST BYTE OUT OF THE STRING STORED IN D0
            ADDQ    #1,D1       INCREMENT THE COUNTER
            BRA atoh      RESTART THE LOOP   

atohfinished
            MOVE.W     D4,D0                MOVE THE FINISHED ADDRESS INTO D0, WHERE WE PROMISED IT WOULD BE                 
            MOVEM.L     (SP)+, D1-D7/A0-A6  MOVE THE REGISTERS BACK OFF THE STACK
            RTS                             RETURN TO THE CALLING ADDRESS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
Contact GitHub 
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
