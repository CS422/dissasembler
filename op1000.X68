op1000
            ;do something effective            
            CLR     D3          ;clear D3
            MOVE.W  D6,D3       ;copy data to D3
            ;MOVE.L  #1,D7       ;size of data is word
            
            ;Print/store DIVU.W here
            MOVE.B  #'D',(A2)+  ;print D
            MOVE.B  #'I',(A2)+  ;print I
            MOVE.B  #'V',(A2)+  ;print V
            MOVE.B  #'U',(A2)+  ;print U
            MOVE.B  #'.',(A2)+  ;ptint .
            MOVE.B  #'W',(A2)+  ;print W
            MOVE.B  #' ',(A2)+  ;print some spaces
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #10,D5      ;counter for output
                        *-INSERT IMMEDIATE DATA HERE
    *-deCDOE EA (Dn,Dn
        * MachineCode: 0001 **** **** **BI T***
 *Only next last 3 bits which is stored at D0 => Source Address mode
    *-insert immediate addressing here
            CLR     D2
            CLR     D1
            MOVE.B  D6,D2       MOVE the original machine code to D2 to play with
            LSL.B   #2,D2       **** **** BIT* **00
            LSR.B   #5,D2       **** **** 0000 0BIT
            MULU    #8,D2       value adjusted for jumping
            LEA     modeTable,A6 Load the table into A6
            JSR     (A6,D2)     Jump to subroutine of value at D0   


 * MachineCode: 0001 **** **** **** *BIT
* Only last 3 bits which is stored at D0 => Source Register
            
            MOVE.B  D6, D1      MOVE the original machine code to D1 to play with
            LSL.B   #5,D1       **** **** BIT0 0000
            LSR.B   #5,D1       **** **** 0000 0BIT      
            MULU    #8,D1       value adjusted for jumping
            LEA     regNumTable ,A7 Load the table into A7
            JSR     (A7,D1)     Jump to subroutine of value at D1
            
            *-ERROR HERE NOT SURE WHY AFTER ADD.L D2,(A2)+ it goines into this lower loop D1 = 20 no matchs
*            CMP.B   #32,D1         ; #imm => #XX 3 spaces
*            BEQ.W   immediateData   ;branch to immediateData
            MOVE.B  #',',(A2)+
            MOVE.B  #'D',(A2)+
              *------------------------------------------------------------
* MachineCode: 0001 **** BIT* **** ****
* Decode 3 bits => Destination Register
* Stored at D1
            CLR     D1
            MOVE.W  D6,D1       MOVE the original machine code to D1 to play with
            LSL.W   #4,D1       BIT* **** **** 0000
            LSR.W   #8,D1       0000 0000 BIT* ****
            LSR.W   #5,D1       0000 0000 0000 0BIT     
            MULU    #8,D1       value adjusted for jumping
            LEA     numTable ,A7 Load the table into A7
            JSR     (A7,D1)     Jump to subroutine of value at D1  
            
            
            BRA printCode

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
