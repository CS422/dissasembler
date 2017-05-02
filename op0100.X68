*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
op0100      


 
            ;CMP.W   #$4EB9,D6   ;see if it's a JSR
            ;BEQ     jumpToRt            
            ;CMP.W   #$4E75,D6   ;see if it's a RTS
            ;BEQ     returnRt 
           
* determine if contents in D3 are a word or long ---------- 
            ;JSR     WorL        
* ---------------------------------------------------------
            ;CMP.B   #hex7,D3    ;see if it's a LEA
            ;BEQ     _lea        ;branch 
            
* determine if contents in D3 are either CLR or MOVEM ----- 
            ;JSR     clrORmm       
* ---------------------------------------------------------
            ;CMP.B   #hex8,D3    ;see if it's a CLR.B
            ;BEQ     _clrB       ;branch             
            ;CMP.B   #hex9,D3    ;see if it's a CLR.W
            ;BEQ     _clrW       ;branch   
            ;CMP.B   #hexA,D3    ;see if it's a CLR.L
            ;BEQ     _clrL       ;branch
  
            ;CMP.B   #hex2,D3    ;see if it's a MOVEM.W
            ;BEQ     _movemW     ;branch   
            ;CMP.B   #hex3,D3    ;see if it's a MOVEM.L
            ;BEQ     _movemL     ;branch              
                        
            ;BRA     opError     ;bad opcode branch to error
            
            
            CMP.W   #$4E71,D6
            BEQ     _NOP
            
            CMP.W   #$4E75,D6   ;see if it's a RTS
            BEQ     _RTS        branch to RTS
           

            
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
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
