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
* -----------------------ASR
            CMP.B   #$04,D3     ; ASR.B Dn
            BEQ     asrB_RN   
            CMP.B   #$00,D3     ; ASR.B Immidiate
            BEQ     asrB_IN      

  
            CMP.B   #$0C,D3     ; ASR.W Dn
            BEQ     asrW_RN          
            CMP.B   #$08,D3     ; ASR.W Immidiate
            BEQ     asrW_IN          


            CMP.B   #$14,D3     ; ASR.L Dn
            BEQ     asrL_RN            
            CMP.B   #$10,D3     ; ASR.L Immidiate
            BEQ     asrL_IN
            
            
*--------------------------LSL
            CMP.B   #$25,D3     ; LSL.B Dn
            BEQ     lslB_RN      

            CMP.B   #$21,D3     ; LSL.B Immidiate
            BEQ     lslB_IN      


            CMP.B   #$2D,D3     ; LSL.W Dn
            BEQ     lslW_RN          
            CMP.B   #$29,D3     ; LSL.W Immidiate
            BEQ     lslW_IN          


            CMP.B   #$35,D3     ; LSL.L Dn
            BEQ     lslL_RN            

            CMP.B   #$31,D3     ; LSL.L Immidiate
            BEQ     lslL_IN
            
*-------------------------LSR

            CMP.B   #$01,D3 LSR.B Immidiate
            BEQ     lsrB_IN
            CMP.B   #$05,D3 LSR.B   Dn
            BEQ     lsrB_RN 
            
            CMP.B   #$09,D3 LSR.W   Immidiate
            BEQ     lsrW_IN
            CMP.B   #$0D,D3 LSR.W   DN
            BEQ     lsrW_RN
            
            CMP.B   #$11,D3 LSR.L   Immidiate
            BEQ     lsrL_IN 
            
            CMP.B   #$15,D3 LSR.L   Dn
            BEQ     lsrL_RN
            
*--------------------------ROR
            CMP.B   #$07,D3     ; ROR.B Dn            
            BEQ     rorB_RN  
            CMP.B   #$03,D3     ; ROR.B Immidiate
            BEQ     rorB_IN      
    
            CMP.B   #$0B,D3     ; ROR.W Immidiate
            BEQ     rorW_IN            
            
            CMP.B   #$0F,D3     ; ROR.W Dn
            BEQ     rorW_RN  
        
        
            CMP.B   #$17,D3     ; ROR.L Dn
            BEQ     rorL_RN            

  
            CMP.B   #$13,D3     ; ROR.L Immidiate
            BEQ     rorL_IN
            
*----------------------------ROL
            CMP.B   #$27,D3     ; ROL.B Dn
            BEQ     rolB_RN      
            CMP.B   #$23,D3     ; ROL.B Immidiate
            BEQ     rolB_IN      


            CMP.B   #$2F,D3     ; ROL.W Dn
            BEQ     rolW_RN          
            CMP.B   #$2B,D3     ; ROL.W Immidiate
            BEQ     rolW_IN        

            CMP.B   #$37,D3     ; ROL.L Dn
            BEQ     rolL_RN            
            CMP.B   #$33,D3     ; ROL.L Immidiate
            BEQ     rolL_IN
                  

    

    
rorB_RN
    *-ROR.B D1,D2 dataregister ea
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

    MOVE.B  #'D',(A2)+ 
    JSR get_bit_9_11
    LEA numTable,A6     load numtable
    MULU    #8,D3   prepare for the jump
    JSR     (A6,D3) get the register number
    
    MOVE.B  #',',(A2)+
    
    MOVE.B  #'D',(A2)+
    JSR     get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)     get the register number
    
    BRA printCode
    
    
rorB_IN
    *-ROR.B #,D2 immediate addressing
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
    MOVE.B  #'#',(A2)+  ;print #
    
    JSR get_bit_9_11
    CMP.B   #0,D3  *-check if value is 8
    BNE shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete
    
rorW_IN
    *-immeidiate data from ROR.W
        *-ROR.W #,D2 immediate addressing
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'W',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+  ;print #
    
    JSR get_bit_9_11    get the bits for the immidate data
    CMP.B   #0,D3       check if its zero, meaning a move of 8
    BNE     shift_Not_8     not 8(zero) move to get the value and print reg number
    MOVE.B  #'8',(A2)+
    BRA     shift_complete
    

rorW_RN
    *-Register data from ROR.W
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'W',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+  ;print 
    
    MOVE.B  #'D',(A2)+
    JSR get_bit_9_11
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    
    JSR     get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    BRA printCode
    
rorL_RN
    *-ROR.L #,D#
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+  ;print 
    
    MOVE.B  #'D',(A2)+
    JSR get_bit_9_11
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    
    JSR     get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    BRA printCode
    
rorL_IN
    *-Immediate addressing for ROR.L    #,D2
    

    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+  ;print #
    
    JSR get_bit_9_11    get the bits for the immidate data
    CMP.B   #0,D3       check if its zero, meaning a move of 8
    BNE     shift_Not_8     not 8(zero) move to get the value and print reg number
    MOVE.B  #'8',(A2)+
    BRA     shift_complete
    
*--------------------------ROL.B
    
rolB_RN
    *-ROL.B D1,D2 dataregister ea
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'B',(A2)+  ;print B
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+

    MOVE.B  #'D',(A2)+ 
    JSR get_bit_9_11
    LEA numTable,A6     load numtable
    MULU    #8,D3   prepare for the jump
    JSR     (A6,D3) get the register number
    
    MOVE.B  #',',(A2)+
    
    MOVE.B  #'D',(A2)+
    JSR     get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)     get the register number
    
    BRA printCode
    
    
rolB_IN
    *-ROR.B #,D2 immediate addressing
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'B',(A2)+  ;print B
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+  ;print #
    
    JSR get_bit_9_11
    CMP.B   #0,D3  *-check if value is 8
    BNE shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete
    


*--------------------------ROL.W  
rolW_RN
    *-ROL.W D1,D2 dataregister ea
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'W',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+

    MOVE.B  #'D',(A2)+ 
    JSR get_bit_9_11
    LEA numTable,A6     load numtable
    MULU    #8,D3   prepare for the jump
    JSR     (A6,D3) get the register number
    
    MOVE.B  #',',(A2)+
    
    MOVE.B  #'D',(A2)+
    JSR     get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)     get the register number
    
    BRA printCode
    
    
rolW_IN
    *-ROR.W #,D2 immediate addressing
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'W',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+  ;print #
    
    JSR get_bit_9_11
    CMP.B   #0,D3  *-check if value is 8
    BNE shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete

*---------------------ROL.L
  
rolL_RN
    *-ROL.L D1,D2 dataregister ea
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+

    MOVE.B  #'D',(A2)+ 
    JSR get_bit_9_11
    LEA numTable,A6     load numtable
    MULU    #8,D3   prepare for the jump
    JSR     (A6,D3) get the register number
    
    MOVE.B  #',',(A2)+
    
    MOVE.B  #'D',(A2)+
    JSR     get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)     get the register number
    
    BRA printCode
    
    
rolL_IN
    *-ROR.B #,D2 immediate addressing
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+  ;print #
    
    JSR get_bit_9_11
    CMP.B   #0,D3  *-check if value is 8
    BNE shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete
    


*------------------------ ASR
asrB_RN
    *ASR.B #,Dn
    
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'D',(A2)+ 
    JSR     get_bit_9_11
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    JSR get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    BRA     printCode
    
    
asrB_IN
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+
    
    JSR     get_bit_9_11
    CMP.B   #0,D3
    BNE     shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete



*------------------------ASR.W
asrW_RN
    *ASR.B #,Dn
    
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'W',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'D',(A2)+ 
    JSR     get_bit_9_11
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    JSR get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    BRA     printCode
    
    
asrW_IN
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'W',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+
    
    JSR     get_bit_9_11
    CMP.B   #0,D3
    BNE     shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete



*-------------------------ASR.L

asrL_RN
    *ASR.B #,Dn
    
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'L',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'D',(A2)+ 
    JSR     get_bit_9_11
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    JSR get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    BRA     printCode
    
    
asrL_IN
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'L',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+
    
    JSR     get_bit_9_11
    CMP.B   #0,D3
    BNE     shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete
*-----------------------------LSL


lslB_RN
    *LSL.B #,Dn
    
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'D',(A2)+ 
    JSR     get_bit_9_11
   
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    JSR get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    BRA     printCode
    
    
lslB_IN
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+
    
    JSR     get_bit_9_11
    CMP.B   #0,D3
    BNE     shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete


*----------------------------LSL.W



lslW_RN
    *LSL.B #,Dn
    
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'W',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'D',(A2)+ 
    JSR     get_bit_9_11
   
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    JSR get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    BRA     printCode
    
    
lslW_IN
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'W',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+
    
    JSR     get_bit_9_11
    CMP.B   #0,D3
    BNE     shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete


*-----------------------------LSL.L



lslL_RN
    *LSL.B #,Dn
    
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'L',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'D',(A2)+ 
    JSR     get_bit_9_11
   
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    JSR get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    BRA     printCode
    
    
lslL_IN
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'L',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+
    
    JSR     get_bit_9_11
    CMP.B   #0,D3
    BNE     shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete




*--------------------------LSR.B
lsrB_RN
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'B',(A2)+  ;print B
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'D',(A2)+ 
    JSR     get_bit_9_11
   
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    JSR get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    BRA     printCode
    
    
lsrB_IN
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'B',(A2)+  ;print B
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+
    
    JSR     get_bit_9_11
    CMP.B   #0,D3
    BNE     shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete



*--------------------------LSR.W
lsrW_RN   
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'W',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'D',(A2)+ 
    JSR     get_bit_9_11
   
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    JSR get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    BRA     printCode
    
    
lsrW_IN
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'W',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+
    
    JSR     get_bit_9_11
    CMP.B   #0,D3
    BNE     shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete

*------------------------LSR.L

lsrL_RN
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'D',(A2)+ 
    JSR     get_bit_9_11
   
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    JSR get_bit_0_2
    
    LEA     numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    
    BRA     printCode
    
    
lsrL_IN
    
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'S',(A2)+  ;print S
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces 
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+
    
    JSR     get_bit_9_11
    CMP.B   #0,D3
    BNE     shift_Not_8
    MOVE.B  #'8',(A2)+
    BRA     shift_complete








    *------------------HELPER FUNCTIONS*********************
shift_complete
    MOVE.B  #',',(A2)+
    MOVE.B  #'D',(A2)+
    JSR get_bit_0_2
    LEA numTable,A6
    MULU    #8,D3
    JSR     (A6,D3)
    BRA     printCode
    
shift_Not_8
    MULU.W  #8,D3
    LEA numTable,A6
    JSR     (A6,D3)
    JSR     shift_complete
    
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
