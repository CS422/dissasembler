*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
op0100      *MOVEM, JSR,LEA,RTS,NOP
* ---------------------------------------------------------
*   Check NOP - $4E71 constant value
* ---------------------------------------------------------      
            CMP.W   #$4E71,D6
            BEQ     _NOP
* ---------------------------------------------------------
*   Check RTS - $4E75 constant value
* ---------------------------------------------------------
            CMP.W   #$4E75,D6   ;see if it's a RTS
            BEQ     _RTS        branch to RTS
* ---------------------------------------------------------
*   Check LEA - 6to8 bit %111
* ---------------------------------------------------------
            CLR     D2
            MOVE.W  D6,D2       MOVE the original machine code to D2 to play with
            LSL.W   #7,D2       BIT* **** **** 0000
            LSR.W   #8,D2       0000 0000 BIT* ****
            LSR.W   #5,D2       0000 0000 0000 0BIT 
            CMP.B   #7,D2
            BEQ     _LEA        branch to LEA
* ---------------------------------------------------------
*   Check JSR  
* ---------------------------------------------------------
*   1. $4EB8 constant value => (XXX).W
            CMP.W   #$4EB8,D6   ;see if it's a JSR
            BEQ     _JSR  
*   2. $4EB9 constant value => (XXX).L
            CMP.W   #$4EB9,D6   ;see if it's a JSR
            BEQ     _JSR
*   3. $4EA0 ~ $4EA7        => (An)
            CMP.W   #$4EA7,D6   ;see if it's a JSR
            BLS     _JSR          
            
           
* determine if contents in D3 are a word or long ---------- 
            ;JSR     WorL        
* ---------------------------------------------------------
            ;CMP.B   #hex7,D3    ;see if it's a LEA
            ;BEQ     _lea        ;branch 
            
* determine if contents in D3 are either CLR or MOVEM ----- 
            ;JSR     clrORmm       
* ---------------------------------------------------------
            ;CMP.B   #hex2,D3    ;see if it's a MOVEM.W
            ;BEQ     _movemW     ;branch   
            ;CMP.B   #hex3,D3    ;see if it's a MOVEM.L
            ;BEQ     _movemL     ;branch              
                        
            ;BRA     opError     ;bad opcode branch to error
            
            
           
           

* ---------------------------------------------------------
* NOP subroutine
* ---------------------------------------------------------           
_NOP
            MOVE.L  #2,D7       ;data is not error
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #'N',(A2)+      ;print N
            MOVE.B  #'O',(A2)+      ;print O
            MOVE.B  #'P',(A2)+      ;print P
            MOVE.B  #3,D5           ;counter for output
            BRA     printCode
* ---------------------------------------------------------
* RTS subroutine
* ---------------------------------------------------------
_RTS    
            MOVE.L  #2,D7       ;data is not error
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #'R',(A2)+      ;print R
            MOVE.B  #'T',(A2)+      ;print T
            MOVE.B  #'S',(A2)+      ;print S
            MOVE.B  #3,D5           ;counter for output
            BRA     printCode
* ---------------------------------------------------------
* LEA subroutine
* ---------------------------------------------------------
_LEA    
            MOVE.L  #2,D7       ;data is not error
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #'L',(A2)+      ;print R
            MOVE.B  #'E',(A2)+      ;print T
            MOVE.B  #'A',(A2)+      ;print S
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #3,D5           ;counter for output
* ---------------------------------------------------------
            JSR     get_3to5_bit
            JSR     get_0to2_bit
* ---------------------------------------------------------            
* Check D2: mode value for immediate or Absolute addressing
            CMP.B   #7,D2
            BEQ     immAbLEA
* ---------------------------------------------------------
desDecodeLEA
            MOVE.B  #',',(A2)+  comma between operands
* ---------------------------------------------------------
            LEA     modeTable,A6
            MOVE.B  #1,D0
            MULU    #8,D0       value adjusted for jumping
            LEA     modeTable,A6 Load the table into A6
            JSR     (A6,D0)     Jump to subroutine of value at D0
       
            JSR     get_9to11_bit
* ---------------------------------------------------------
            BRA     printCode
* ---------------------------------------------------------
* JSR subroutine
* ---------------------------------------------------------
_JSR
            MOVE.L  #2,D7       ;data is not error
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #'J',(A2)+      ;print J
            MOVE.B  #'S',(A2)+      ;print S
            MOVE.B  #'R',(A2)+      ;print R
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #3,D5           ;counter for output
            JSR     get_3to5_bit
            JSR     get_0to2_bit
*------------------------------------------------------------
* Check D2: mode value for immediate or Absolute addressing
            CMP.B   #7,D2
            BEQ     immAbJSR
            BRA     printCode
*------------------------------------------------------------
immAbJSR
* Check for #imm or Absolute addressing with D1: register value
            LEA     immAbTable, A6
            MULU    #8,D1
            JSR     (A6,D1)
            BRA     printCode
immAbLEA
* Check for #imm or Absolute addressing with D1: register value
            LEA     immAbTable, A6
            MULU    #8,D1
            JSR     (A6,D1)
            BRA     desDecodeLEA
*------------------------------------------------------------
* end of file            
*------------------------------------------------------------
            

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
