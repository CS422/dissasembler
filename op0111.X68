op0111
    *- MOVE Q
            CLR     D3          ;clear D3
            MOVE.B  D6,D3       ;copy data to D3
            ;MOVE.L  #2,D7       ;size of data is long
      

            MOVE.B  #' ',(A2)+  ;print some spaces
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #'M',(A2)+  ;print M
            MOVE.B  #'O',(A2)+  ;print O
            MOVE.B  #'V',(A2)+  ;print V
            MOVE.B  #'E',(A2)+  ;print E
            MOVE.B  #'Q',(A2)+  ;ptint Q
            MOVE.B  #' ',(A2)+  ;
            MOVE.B  #' ',(A2)+  ;print some spaces
            MOVE.B  #' ',(A2)+
            MOVE.B  #'#',(A2)+  ;print #
            MOVE.B  #'$',(A2)+  ;print 
            *-REMEMBER MOVEQ TAKES ONLY A BTYE OF DATA
            
            ;MOVE.B  #12,D5      ;counter for output
            LSR.B   #4,D3       *-get bit 4 to 7 and jump with it DATA
            MULU.W  #8,D3       ;gotta get ready to jump
            LEA     numTable,A6 ;load table
            JSR     (A6,D3)     ;branch to grab number

            CLR     D3          ;clear D3
            MOVE.B  D6,D3       ;copy data to D3
            LSL.B   #4,D3       ;get the biut 0 - 3 with it DATA to print BYTE SIZE
            LSR.B   #4,D3
            MULU.W  #8,D3       ;gotta get ready to jump
            LEA     numTable,A6 ;load table
            JSR     (A6,D3)     ;branch to grab number
            
            MOVE.B  #',',(A2)+  ;print ,
*            ADDI.B  #5,D5       ;counter for output
            MOVE.B  #'D',(A2)+  ;print D for data register and prepare to get Dn
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
            
            BRA     printCode

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
