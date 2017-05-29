op0101


    JSR WordOrLong
    
    * ---------------------------------------------------------
            
     CMP.B   #hex_0,D3    ;see if it's a ADDQ.B
     BEQ     addQ_B       ;branch 
     CMP.B   #hex_1,D3    ;see if it's a ADDQ.W
     BEQ     addQ_W       ;branch
     CMP.B   #hex_2,D3    ;see if it's a ADDQ.L
     BEQ     addQ_L       ;branch
*    
     CMP.B  #hex_4,D3
     BEQ    subQ_B
     CMP.B  #hex_5,D3
     BEQ    subQ_W
     CMP.B  #hex_6,D3
     BEQ    subQ_L
     


addQ_B:
    *-get bit 9 to 11
    *-data field
        *-PRINT
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'A',(A2)+  ;print
    MOVE.B  #'D',(A2)+  ;print 
    MOVE.B  #'D',(A2)+  ;print 
    MOVE.B  #'Q',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print     
    MOVE.B  #'#',(A2)+  ;print 


*------------------------------------------------------------
* MachineCode: 0001 **** BIT* **** ****
* Decode 3 bits => Destination Register
* Stored at D1
    JSR get_bit_9_11_ADDQ

    MULU    #8,D1       value adjusted for jumping
    LEA     NumTable ,A6 Load the table into A6
    JSR     (A6,D1)     Jump to subroutine of value at D1
    
    MOVE.B  #',',(A2)+

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

        JSR printCode   


addQ_W:
    *-get bit 9 to 11
    *-data field
        *-PRINT
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'A',(A2)+  ;print
    MOVE.B  #'D',(A2)+  ;print 
    MOVE.B  #'D',(A2)+  ;print 
    MOVE.B  #'Q',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'W',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print     
    MOVE.B  #'#',(A2)+  ;print 


*------------------------------------------------------------
* MachineCode: 0001 **** BIT* **** ****
* Decode 3 bits => Destination Register
* Stored at D1
    JSR get_bit_9_11_ADDQ
    MULU    #8,D1       value adjusted for jumping
    LEA     NumTable ,A6 Load the table into A6
    JSR     (A6,D1)     Jump to subroutine of value at D1
    
    MOVE.B  #',',(A2)+

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

        JSR printCode   



addQ_L:
    *-get bit 9 to 11
    *-data field
        *-PRINT
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'A',(A2)+  ;print
    MOVE.B  #'D',(A2)+  ;print 
    MOVE.B  #'D',(A2)+  ;print 
    MOVE.B  #'Q',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'L',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print     
    MOVE.B  #'#',(A2)+  ;print 


*------------------------------------------------------------
* MachineCode: 0001 **** BIT* **** ****
* Decode 3 bits => Destination Register
* Stored at D1
    JSR get_bit_9_11_ADDQ

    MULU    #8,D1       value adjusted for jumping
    LEA     NumTable ,A6 Load the table into A6
    JSR     (A6,D1)     Jump to subroutine of value at D1
    
    MOVE.B  #',',(A2)+

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

        JSR printCode   

subQ_B:
    *-get bit 9 to 11
    *-data field
        *-PRINT
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'S',(A2)+  ;print
    MOVE.B  #'U',(A2)+  ;print 
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #'Q',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print     
    MOVE.B  #'#',(A2)+  ;print 


*------------------------------------------------------------
* MachineCode: 0001 **** BIT* **** ****
* Decode 3 bits => Destination Register
* Stored at D1
    JSR get_bit_9_11_ADDQ
    MULU    #8,D1       value adjusted for jumping
    LEA     NumTable ,A6 Load the table into A6
    JSR     (A6,D1)     Jump to subroutine of value at D1
    
    MOVE.B  #',',(A2)+

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

        JSR printCode   




subQ_W:
    *-get bit 9 to 11
    *-data field
        *-PRINT
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'S',(A2)+  ;print
    MOVE.B  #'U',(A2)+  ;print 
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #'Q',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'W',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print     
    MOVE.B  #'#',(A2)+  ;print 


*------------------------------------------------------------
* MachineCode: 0001 **** BIT* **** ****
* Decode 3 bits => Destination Register
* Stored at D1
    JSR get_bit_9_11_ADDQ
    MULU    #8,D1       value adjusted for jumping
    LEA     NumTable ,A6 Load the table into A6
    JSR     (A6,D1)     Jump to subroutine of value at D1
    
    MOVE.B  #',',(A2)+

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

        JSR printCode   



subQ_L:
    *-get bit 9 to 11
    *-data field
        *-PRINT
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print   
    MOVE.B  #'S',(A2)+  ;print
    MOVE.B  #'U',(A2)+  ;print 
    MOVE.B  #'B',(A2)+  ;print 
    MOVE.B  #'Q',(A2)+  ;print 
    MOVE.B  #'.',(A2)+  ;print 
    MOVE.B  #'L',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print 
    MOVE.B  #' ',(A2)+  ;print     
    MOVE.B  #'#',(A2)+  ;print 


*------------------------------------------------------------
* MachineCode: 0001 **** BIT* **** ****
* Decode 3 bits => Destination Register
* Stored at D1
    JSR get_bit_9_11_ADDQ
    MULU    #8,D1       value adjusted for jumping
    LEA     NumTable ,A6 Load the table into A6
    JSR     (A6,D1)     Jump to subroutine of value at D1
    
    MOVE.B  #',',(A2)+

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

        JSR printCode   



addd_8
        add.b   #8,D1
        RTS

get_bit_9_11_ADDQ:
            *-get bit 9 _11 which is immediate datae, and check if its zero
            *-if so add 8 ZERO repersents 8 in ADDQ
            MOVE.W  D6,D1       MOVE the original machine code to D1 to play with
            LSL.W   #4,D1       BIT* **** **** 0000
            LSR.W   #8,D1       0000 0000 BIT* ****
            LSR.W   #5,D1       0000 0000 0000 0BIT   
            CMP.B   #0,D1
            BEQ     addd_8  
            RTS

 
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
