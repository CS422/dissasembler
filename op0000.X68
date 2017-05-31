

op0000  ;ADDI

    **----------------------------------------
    *decode what type of opcode/size it is
    *- using decode0000 there will only be a couple static options in D3 to compare
    *-D3:
    *-#$18 -> ANDI.B
    *-#$19 ->ANDI.W
    *-#$1A -> ANDI.L
    JSR decode0000
    
    CMP.B   #$18,D3     ;see if it's a ADDI.B
    BEQ     addi_B
*    
    CMP.B   #$19,D3     ;see if it's a ADDI.W
    BEQ     addi_W
    CMP.B   #$1A,D3     ;see if it's a ADDI.L
    BEQ     addi_L 
    
    CMP.B   #$10,D3 SUBI.B  #$66,(A2)+
    BEQ     subi_B_
    
    CMP.B   #$11,D3 SUBI.W  #$66,(A2)+
    BEQ     subi_W_
    
    CMP.B   #$12,D3 SUBI.L  #$66,(A2)+
    BEQ     subi_L_
    
    
    JSR finish


addi_B
    MOVE.B  D6, D3 [ 0000 0000 [USES] [USES] ] D6 ->d3
    *- GET the register Value [ 0000 0XXX ]
*    LSL.B   #5,D3
*    LSR.B   #5,D3       got it here
*    
    *-immediate data not allowed here

    *-Because we know this is ADDi.B we know that out data following this opcode
    *-is of size B, so we can now grab that data, look at it and print it out
    
    *temporary store out data in memory
    
    *-MOVE machine code into temp D2
    MOVE.W  D6,D2
    ;MOVEA.W D6,A5       ; BUGGG LOOK BELOW WHWERE DO WE STORE OUR ABS IMM DATA IN ????
    MOVE.W  (A4)+,D6 ;i forgot where we store our data in memory
    ;MOVE.W  D6,D3   Move the data back into D3 to play with
    
    *-MOVE the word/bytte data at D4 into D3
    ;MOVE.W  D4,D3
    
    *-PRINT
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'D',(A2)+  ;print D
    MOVE.B  #'D',(A2)+  ;print 
    MOVE.B  #'I',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print     
    MOVE.B  #'#',(A2)+  ;print 
    MOVE.B  #'$',(A2)+  ;print 

    
    JSR print_word
    MOVE.W  D2,D6
    MOVE.B  #',',(A2)+
    
    ;MOVE.W  A5,D6
    
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
            
    BRA printCode
    

addi_W

    MOVE.B  D6, D3 [ 0000 0000 [USES] [USES] ] D6 ->d3
    *- GET the register Value [ 0000 0XXX ]

    
    *-immediate data not allowed here

    *-Because we know this is ADDi.B we know that out data following this opcode
    *-is of size B, so we can now grab that data, look at it and print it out
    
    MOVE.W  D6,D2
    ;MOVEA.W D6,A5       ; BUGGG LOOK BELOW WHWERE DO WE STORE OUR ABS IMM DATA IN ????
    MOVE.W  (A4)+,D6 ;i forgot where we store our data in memory
    ;MOVE.W  D6,D3   Move the data back into D3 to play with
    
    
    *-PRINT
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'D',(A2)+  ;print D
    MOVE.B  #'D',(A2)+  ;print 
    MOVE.B  #'I',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'W',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #'#',(A2)+  ;print 
    MOVE.B  #'$',(A2)+  ;print 

    
    JSR print_word
    MOVE.W  D2,D6
    MOVE.B  #',',(A2)+
    
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
    BRA printCode

addi_L
    *- D4 holds our .L abs and immi data

    MOVE.B  D6, D3 [ 0000 0000 [USES] [USES] ] D6 ->d3
    *- GET the register Value [ 0000 0XXX ]
    LSL.B   #5,D3
    LSR.B   #5,D3       got it here
    
    *-immediate data not allowed here

    *-Because we know this is ADDi.B we know that out data following this opcode
    *-is of size B, so we can now grab that data, look at it and print it out
    
    *temporary store out data in memory
    ;MOVEA.W D6,A5       ; BUGGG LOOK BELOW WHWERE DO WE STORE OUR ABS IMM DATA IN ????
    ;MOVE.W  (A4)+,D6 ;i forgot where we store our data in memory
    MOVE.L  (A4)+,D3 ;throw away just need to increment pointer here
    ;MOVE.L  D5,D3   Move the data back into D3 to play with
*    MOVE.W  D6,D5
*    MOVE.L  D3,D6
    
    *-PRINT
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'D',(A2)+  ;print D
    MOVE.B  #'D',(A2)+  ;print 
    MOVE.B  #'I',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'L',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print     
    MOVE.B  #'#',(A2)+  ;print 
    MOVE.B  #'$',(A2)+  ;print 
    
    JSR print_long
    *-STORE LONG data inside D3
    MOVE.B  #',',(A2)+
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
    BRA printCode


subi_B_
    MOVE.W  D6,D2
    ;MOVEA.W D6,A5       ; BUGGG LOOK BELOW WHWERE DO WE STORE OUR ABS IMM DATA IN ????
    MOVE.W  (A4)+,D6 ;i forgot where we store our data in memory
    
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'S',(A2)+  ;print 
    MOVE.B  #'U',(A2)+  ;print 
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #'I',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #'#',(A2)+  ;print 
    MOVE.B  #'$',(A2)+  ;print 
    
    JSR print_word
    MOVE.W  D2,D6
    MOVE.B  #',',(A2)+
    
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
    BRA printCode
    

subi_W_
    MOVE.W  D6,D2
    ;MOVEA.W D6,A5       ; BUGGG LOOK BELOW WHWERE DO WE STORE OUR ABS IMM DATA IN ????
    MOVE.W  (A4)+,D6 ;i forgot where we store our data in memory
    
    
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'S',(A2)+  ;print 
    MOVE.B  #'U',(A2)+  ;print 
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #'I',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'W',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #'#',(A2)+  ;print 
    MOVE.B  #'$',(A2)+  ;print 
    
    JSR print_word
    MOVE.W  D2,D6
    MOVE.B  #',',(A2)+
    
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
    BRA printCode   
    
subi_L_

    MOVE.L  (A4)+,D3 ;throw away just need to increment pointer here
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'S',(A2)+  ;print 
    MOVE.B  #'U',(A2)+  ;print 
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #'I',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'L',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #'#',(A2)+  ;print 
    MOVE.B  #'$',(A2)+  ;print 
    
    JSR print_long
    *-STORE LONG data inside D3
    MOVE.B  #',',(A2)+
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
    BRA printCode


decode0000
    *-this will put the bits 6 - 10 however add zeros
    CLR.L   D3
    MOVE.W  D6,D3
    AND.W   #$0FF0,D3   shortcut of zeroing the edges without shiting around
                        ;[ 0000 1111 1111 0000]
                        ;[ ZERO KEEP KEEP ZERO ]
                        ;[ 
    LSR.W   #6,D3   [ 0000 1111 11XX XXXX ] -> [ 0000 0000 0011 1111 ]
    AND.W   #$00FF,D3   Cancel out any trailing bits 
    RTS

