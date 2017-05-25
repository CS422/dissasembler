*-----------------------------------------------------------
* Title      : OPCODE for 0001 MOVE.B
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
*------------------
* Original Machine Code stored in D6(DO not Touch)
* D0 - Desinated register for jumping table
* D1 - register value 
* D2 - mode value 
*----------------------
* Order of Decoding
* 1. Decode 3bits for Source Mode => Store value at D2
* current at (A2) : ex)MOVE.B 
* 2. Decode 3bits for Destination Mode 
* => Jump to Mode Table => Store chars in order at (A2)
* current at (A2) : ex)MOVE.B (A
* => during the storing process, get D0 value and store char at (A2)
* current at (A2) : ex)MOVE.B (A0),
* 3. Decode 3bits for Source Register => Store value at D0
* current at (A2) : ex)MOVE.B (A0),
* 4. Decode 3bits for Source Mode 
* => Jump to Mode Table => Store chars in order at (A2)
* current at (A2) : ex)MOVE.B (A0),D
* => during the storing process, get D0 value and store char at (A2)
* current at (A2) : ex)MOVE.B (A0),D7




op0001
*------------------------------------------------------------
* OPCC **** **** **** ****
* 4 MSB determines the opcode and size 
* this case MOVE.B
            MOVE.L  #2,D7       ;data is not error
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #'M',(A2)+      ;print M
            MOVE.B  #'O',(A2)+      ;print O
            MOVE.B  #'V',(A2)+      ;print V
            MOVE.B  #'E',(A2)+      PRINT  E
            MOVE.B  #'.',(A2)+
            MOVE.B  #'B',(A2)+
*------------------------------------------------------------
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
            LEA     regNumTable ,A7 Load the table into A7
            JSR     (A7,D0)     Jump to subroutine of value at D1
*------------------------------------------------------------
* Check for #imm or Absolute addressing with D1: register value
            LEA     immAbTable, A7
            MULU    #8,D1
            JSR     (A7,D1)    
*            CMP.B   #4,D1         ; 100 => #imm => #XX 3 spaces
*            BEQ.B   immediateData   ;branch to immediateData
*            CMP.B   #0,D1         ; 000 => (xxx).W => #XXXX 5 spaces
*            BEQ.W   absoulteWord   ;branch to absoulteWord   
*            CMP.B   #1,D1         ; 001 => (xxx).L => #XXXXXXXX 9 spaces
*            BEQ.W   absoulteLong   ;branch to absoulteLong   


*------------------------------------------------------------
            MOVE.B  #',',(A2)+  comma between operands
*------------------------------------------------------------
* MachineCode: 0001 **** ***B IT** ****
* Only next last 3 bits which is stored at D0 => Destination Address mode
            CLR     D2
            CLR     D1
            MOVE.W  D6,D2       MOVE the original machine code to D2 to play with
            LSL.W   #7,D2       BIT* **** **** 0000
            LSR.W   #8,D2       0000 0000 BIT* ****
            LSR.W   #5,D2       0000 0000 0000 0BIT 
            MULU    #8,D2       value adjusted for jumping
            LEA     modeTable,A6 Load the table into A6
            JSR     (A6,D2)     Jump to subroutine of value at D2
*------------------------------------------------------------
* MachineCode: 0001 **** BIT* **** ****
* Decode 3 bits => Destination Register
* Stored at D1
           
            MOVE.W  D6,D1       MOVE the original machine code to D1 to play with
            LSL.W   #4,D1       BIT* **** **** 0000
            LSR.W   #8,D1       0000 0000 BIT* ****
            LSR.W   #5,D1       0000 0000 0000 0BIT     
            MULU    #8,D1       value adjusted for jumping
            LEA     regNumTable ,A7 Load the table into A7
            JSR     (A7,D1)     Jump to subroutine of value at D1    
*------------------------------------------------------------       
* end of decoding
*------------------------------------------------------------
* printing          
            BRA     printCode
* Subroutine immediateData 
* need to think about $ hex and % binary 
*------------------------------------------------------------
immediateData
            MOVE.B  #'#',(A2)+ 
            MOVE.W  (A5)+,D4    WE got the address for the operand
            MOVE.W  (A5),D4     Got the value of operand, immeditae data
            *4MSB   00X*
            CLR     D2
            MOVE.B  D4,D2       00X*
            LSR.B   #4,D2       000X
            MULU    #8,D2   
            LEA     numTable ,A7 Load the table into A7
            JSR     (A7,D2)     Jump to subroutine of value at D2
            *last 4bits 00*X
            CLR     D2
            MOVE.B  D4,D2       00*X
            LSL.B   #4,D2       00X*
            LSR.B   #4,D2       000X
            MULU    #8,D2   
           
            JSR     (A7,D2)     Jump to subroutine of value at D2

            RTS
            
* -----------------------------------------------------------
* Subroutine absoulteWord   XXXX
*------------------------------------------------------------
absoulteWord   
            MOVE.B  #'$',(A2)+ 
            LSR.L   #8,D4       XXXX **** => 00XX XX**
            LSR.L   #8,D4       00XX XX** => 0000 XXXX
            *4MSB   X***
            CLR     D1
            MOVE.W  D4,D1       X***
            LSR.W   #8,D1       00X*
            LSR.W   #4,D1       000X
            LEA     numTable ,A7 Load the table into A7
            MULU    #8,D1
            JSR     (A7,D1)     Jump to subroutine of value at D1 
            *next 4MSB  *X**
            CLR     D1
            MOVE.W  D4,D1       *X**
            LSL.W   #4,D1       X**0        
            LSR.W   #8,D1       00X*
            LSR.W   #4,D1       000X
            LEA     numTable ,A7 Load the table into A7
            MULU    #8,D1
            JSR     (A7,D1)     Jump to subroutine of value at D1
            *next 4MSB  **X*
            CLR     D1
            MOVE.B  D4,D1       00X*
            LSR.B   #4,D1       000X
            LEA     numTable ,A7 Load the table into A7
                        MULU    #8,D1
            JSR     (A7,D1)     Jump to subroutine of value at D1
            *last 4  bits   ***X
            CLR     D1
            MOVE.B  D4,D1       00*X
            LSL.B   #4,D1       00X0    
            LSR.B   #4,D1       000X
            LEA     numTable ,A7 Load the table into A7
                        MULU    #8,D1
            JSR     (A7,D1)     Jump to subroutine of value at D1
            RTS            
* -----------------------------------------------------------
* Subroutine absoulteLong   XXXX XXXX
*------------------------------------------------------------
absoulteLong   
            CLR     D1
            CLR     D2 
            MOVE.B  #'$',(A2)+ 
            MOVE.L  D4,D2       D2 will be used for later
*----------- first Word Value D4
            LSR.L   #8,D4       XXXX **** => 00XX XX**
            LSR.L   #8,D4       00XX XX** => 0000 XXXX
            *4MSB   X***
            CLR     D1
            MOVE.W  D4,D1       X***
            LSR.W   #8,D1       00X*
            LSR.W   #4,D1       000X
            LEA     numTable ,A7 Load the table into A7
            MULU    #8,D1
            JSR     (A7,D1)     Jump to subroutine of value at D1 
            *next 4MSB  *X**
            CLR     D1
            MOVE.W  D4,D1       *X**
            LSL.W   #4,D1       X**0        
            LSR.W   #8,D1       00X*
            LSR.W   #4,D1       000X
            LEA     numTable ,A7 Load the table into A7
            MULU    #8,D1
            JSR     (A7,D1)     Jump to subroutine of value at D1
            *next 4MSB  **X*
            CLR     D1
            MOVE.B  D4,D1       00X*
            LSR.B   #4,D1       000X
            LEA     numTable ,A7 Load the table into A7
                        MULU    #8,D1
            JSR     (A7,D1)     Jump to subroutine of value at D1
            *last 4  bits   ***X
            CLR     D1
            MOVE.B  D4,D1       00*X
            LSL.B   #4,D1       00X0    
            LSR.B   #4,D1       000X
            LEA     numTable ,A7 Load the table into A7
                        MULU    #8,D1
            JSR     (A7,D1)     Jump to subroutine of value at D1
*---------  Second Word Value D2    **** XXXX
            *4MSB   X***
            CLR     D1
            MOVE.W  D2,D1
            LSR.W   #8,D1            00X*
            LSR.W   #4,D1            000X
            MULU    #8,D1
            LEA     numTable ,A7 Load the table into A7
            JSR     (A7,D1)     Jump to subroutine of value at D1
            *next 4MSB  *X**
            CLR     D1
            MOVE.W  D2,D1
            LSL.W   #4,D1       X**0
            LSR.W   #8,D1       00X*
            LSR.B   #4,D1       000X
            MULU    #8,D1
            LEA     numTable ,A7 Load the table into A7
            JSR     (A7,D1)     Jump to subroutine of value at D1
            *next 4MSB  **X*
            CLR     D1
            MOVE.B  D2,D1       00X*
            LSR.B   #4,D1       000X
            MULU    #8,D1
            LEA     numTable ,A7 Load the table into A7
            JSR     (A7,D1)     Jump to subroutine of value at D1
            *next 4MSB  ***X
            CLR     D1
            MOVE.B  D2,D1       00*X
            LSL.B   #4,D1       00X0
            LSR.B   #4,D1       000X
            MULU    #8,D1
            LEA     numTable ,A7 Load the table into A7
            JSR     (A7,D1)     Jump to subroutine of value at D1
           

            RTS
*------------------------------------------------------------
* end of file            
*------------------------------------------------------------























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
