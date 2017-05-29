op1100  ;AND MULS.W

    JSR WordOrLong  ;result is what the OPMODE FIELD IS STored in D3
    
    CMP.B   #hex_0,D3    ; AND.B
    BEQ     and_B       ;branch             
    CMP.B   #hex1,D3    ; AND.W
    BEQ     and_W       ;branch    
    CMP.B   #hex2,D3    ; AND.L
    BEQ     and_L       ;branch             
    CMP.B   #hex4,D3    ; AND.B [to EA]
    BEQ     and_B_EA    ;branch             
    CMP.B   #hex5,D3    ; AND.W [to EA]
    BEQ     and_W_EA    ;branch    
    CMP.B   #hex6,D3    ; AND.L [to EA]
    BEQ     and_L_EA    ;branch 
            
    CMP.B   #hex7,D3    ; CMPA.W
    BEQ     _mulsW      ;branch  



and_B
    *-AND.B

    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'A',(A2)+
    MOVE.B  #'N',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
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
        MOVE.B  #'D',(A2)+
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
            
            BRA printCode
    
    
    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
