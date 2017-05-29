op1110:
    ;ASR,LSL,ROL,ROR
    JSR get_shift_size
    
    *-compare for the sphift size
*    CMP.B   #$03,D3 ASR.W
*    BEQ     asr_W
    
*    CMP.B   #$1B,D3
*    BEQ     ror_W
*    
    
    JSR get_shift_normal
    
    *--------------------------------
* ----------------------------------------------------------  
*            CMP.B   #$04,D3     ;see if it's a ASR.B [to reg]
*            BEQ     asrB_R      
*            CMP.B   #$0C,D3     ;see if it's a ASR.W [to reg]
*            BEQ     _asrW_R          
*            CMP.B   #$14,D3     ;see if it's a ASR.L [to reg]
*            BEQ     _asrL_R            
*            CMP.B   #$00,D3     ;see if it's a ASR.B [to imm]
*            BEQ     _asrB_I      
*            CMP.B   #$08,D3     ;see if it's a ASR.W [to imm]
*            BEQ     _asrW_I          
*            CMP.B   #$10,D3     ;see if it's a ASR.L [to imm]
*            BEQ     _asrL_I
*
*            CMP.B   #$25,D3     ;see if it's a LSL.B [to reg]
*            BEQ     _lslB_R      
*            CMP.B   #$2D,D3     ;see if it's a LSL.W [to reg]
*            BEQ     _lslW_R          
*            CMP.B   #$35,D3     ;see if it's a LSL.L [to reg]
*            BEQ     _lslL_R            
*            CMP.B   #$21,D3     ;see if it's a LSL.B [to imm]
*            BEQ     _lslB_I      
*            CMP.B   #$29,D3     ;see if it's a LSL.W [to imm]
*            BEQ     _lslW_I          
*            CMP.B   #$31,D3     ;see if it's a LSL.L [to imm]
*            BEQ     _lslL_I
*
            CMP.B   #$07,D3     ;see if it's a ROR.B [to reg]
            BEQ     rorB_RN      
*            CMP.B   #$0F,D3     ;see if it's a ROR.W [to reg]
*            BEQ     _rorW_R          
*            CMP.B   #$17,D3     ;see if it's a ROR.L [to reg]
*            BEQ     _rorL_R            
            CMP.B   #$03,D3     ;see if it's a ROR.B [to imm]
            BEQ     rorB_IN      
*            CMP.B   #$0B,D3     ;see if it's a ROR.W [to imm]
*            BEQ     _rorW_I          
*            CMP.B   #$13,D3     ;see if it's a ROR.L [to imm]
*            BEQ     _rorL_I
*            
*            CMP.B   #$27,D3     ;see if it's a ROL.B [to reg]
*            BEQ     _rolB_R      
*            CMP.B   #$2F,D3     ;see if it's a ROL.W [to reg]
*            BEQ     _rolW_R          
*            CMP.B   #$37,D3     ;see if it's a ROL.L [to reg]
*            BEQ     _rolL_R            
*            CMP.B   #$23,D3     ;see if it's a ROL.B [to imm]
*            BEQ     _rolB_I      
*            CMP.B   #$2B,D3     ;see if it's a ROL.W [to imm]
*            BEQ     _rolW_I          
*            CMP.B   #$33,D3     ;see if it's a ROL.L [to imm]
*            BEQ     _rolL_I
                  

    

    
rorB_RN
    
rorB_IN
    *-ROR.B #,D2
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'B',(A2)+  ;print B
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+  ;print #
    
    JSR get_bit_9_11
    CMP.B   #0,D3  *-check if value is 8
    BNE rorB_N8
    MOVE.B  #'8',(A2)+
    BRA     ror_b_8
    
    
ror_b_8
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    JSR get_bit_0_2
    LEA numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    BRA     printCode
    
rorB_N8
    MULU.W  #8,D3
    LEA numTable,A6
    JSR     (A6,D3)
    
get_bit_0_2
    CLR     D3
    MOVE.B  D6,D3
    ;AND.W   #$0F,D3
    LSL.B   #5,D3
    LSR.B   #5,D3
    RTS
    
get_bit_9_11
    MOVE.W  D6,D3
    AND.W   #$0F00,D3
    LSR.W   #8,D3
    LSR.W   #1,D3
    RTS
    
get_shift_normal:
    *-get OPCODE
    CLR D3
    MOVE.W  D6,D3
    LSR.W   #3,D3 *-get bits 3 and 4 
    AND.W   #$00FF,D3
    LSL.B   #2,D3
    LSR.B   #2,D3
    RTS

get_shift_size:

    CLR.L   D3
    MOVE.W  D6,D3
    *-clear MSB and LSB
    AND.W   #$0FF0,D3
    LSR.W   #6,D3
    RTS         *-got the bit 6 and 7

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
