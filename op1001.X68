op1001

*-SUB, SUBA
    
        ; we need to determine what its size is (B,W,L) putting the data in D6
    JSR   WordOrLong ; WordOrLong decodes the OPMODE field and stores the output into D3 where
    ; we use to decode and branch
    *-now D3 contains the OPMODE FIELD telling us wether this is
    *-a LONG or a WORD
    
    *-now we need to decipher if its any of the subs
    CMP.B   #hex_0,D3 is this SUB.B
    BEQ sub_B   ;<EA> -> Dn
**    
**    CMP.B   #hex_1,D3   is it SUB.W
**    BEQ sub_W ;<EA> ->Dn
**    
**    CMP.B   #hex_2,D3   is it SUB.L
**    BEQ sub_L ;<EA> ->Dn
**    
**    CMP.B   #hex_3,D3
**    BEQ suba_W
**    
**    CMP.B   #hex_4,D3
**    BEQ sub_B_EA Dn -> EA
**    
**    CMP.B   #hex_5,D3
**    BEQ sub_W_EA Dn ->EA
**    
**    
**    CMP.B   #hex_6,D3
**    BEQ sub_L_EA Dn - >EA
**    
**    CMP.B   #hex_7,D3
**    BEQ suba_L


sub_B
    ;EA ->Dn
    
        *-store the size of the operation for immediate decoding use here/below
    *-D7 equals storage of size of operation
    *- #3 is byte , #2 is word #1 is long
    ;MOVE.B  #3,D7
    

    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'S',(A2)+
    MOVE.B  #'U',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'B',(A2)+
    *-always allow 4 spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+

    MOVE.B  #' ',(A2)+
    
        *-deCDOE EA (Dn,Dn
        * MachineCode: 0001 **** **** **BI T***
* Only next last 3 bits which is stored at D0 => Source subress mode
    *-insert immediate subressing here
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
            CMP.B   #32,D1         ; #imm => #XX 3 spaces
            ;BEQ.W   immediateData   ;branch to immediateData
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
            BRA printcode  
    
    
     
sub_W   ;sub.B EA->Dn
    
    *-store the size of the operation for immediate decoding use here/below
    *-D7 equals storage of size of operation
    *- #3 is byte , #2 is word #1 is long
    ;MOVE.B  #3,D7
    

    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'A',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    *-always allow 4 spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    
    *-deCDOE EA (Dn,Dn
        * MachineCode: 0001 **** **** **BI T***
* Only next last 3 bits which is stored at D0 => Source subress mode
    *-insert immediate subressing here
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
            CMP.B   #32,D1         ; #imm => #XX 3 spaces
            ;BEQ.W   immediateData   ;branch to immediateData
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
            BRA printcode  
   
sub_L   ;sub.B EA->Dn
    
    *-store the size of the operation for immediate decoding use here/below
    *-D7 equals storage of size of operation
    *- #3 is byte , #2 is word #1 is long
    ;MOVE.B  #3,D7
    

    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'A',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'L',(A2)+
    *-always allow 4 spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    
    *-deCDOE EA (Dn,Dn
        * MachineCode: 0001 **** **** **BI T***
* Only next last 3 bits which is stored at D0 => Source subress mode
    *-insert immediate subressing here
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
            CMP.B   #32,D1         ; #imm => #XX 3 spaces
            ;BEQ.W   immediateData   ;branch to immediateData
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
            BRA printcode  
    
suba_W  ;subA.W
    *-maybe error checking
    *-we know its subA.W so print it to our buffer
    *-ex subA.W D2,D7
    
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'S',(A2)+
    MOVE.B  #'U',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #'A',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    *-always allow 4 spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    
    * MachineCode: 0001 **** **** **BI T***
* Only next last 3 bits which is stored at D0 => Source subress mode
    *-insert immediate subressing here
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
            CMP.B   #32,D1         ; #imm => #XX 3 spaces
            ;BEQ.W   immediateData   ;branch to immediateData
    
        MOVE.B  #',',(A2)+
        MOVE.B  #'A',(A2)+
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
*------------------------------------------------------------       
        
    
*    *-IDEA; so after we do this we need to get the
*    *-EA decoding which resides between the 3_5 bit location
*    *-call a function that will decode this, which is the SOURCE
*    JSR EA_prep_3_5
*    
*    *-print the coma
*    MOVE.B  #',',(A2)+
*    MOVE.B  #'A',(A2)+ ; subress register is static
*    
*    JSR get_bit_9_11    now get the bits from 9 to 11 these are the destimation bits
*    
*    *-since D3 contains the register number 
*    LEA numTable,A6
*    MULU    #8,D3
*    JSR     (A6,D3)
        BRA printCode
        
        
        

suba_L  ;subA.L
    *-maybe error checking
    *-we know its subA.L so print it to our buffer
    *-ex subA.L D2,D7
    
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
        MOVE.B  #'S',(A2)+
        MOVE.B  #'U',(A2)+
        MOVE.B  #'B',(A2)+
        MOVE.B  #'A',(A2)+
        MOVE.B  #'.',(A2)+
        MOVE.B  #'L',(A2)+
    *-always allow 4 spaces
        MOVE.B  #' ',(A2)+
        MOVE.B  #' ',(A2)+
        MOVE.B  #' ',(A2)+      
    
    * MachineCode: 0001 **** **** **BI T***
* Only next last 3 bits which is stored at D0 => Source subress mode
    *-insert immediate subressing here
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
            CMP.B   #32,D1         ; #imm => #XX 3 spaces
            ;BEQ.W   immediateData   ;branch to immediateData
    
            MOVE.B  #',',(A2)+
            MOVE.B  #'A',(A2)+
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
*------------------------------------------------------------       
        
    
*    *-IDEA; so after we do this we need to get the
*    *-EA decoding which resides between the 3_5 bit location
*    *-call a function that will decode this, which is the SOURCE
*    JSR EA_prep_3_5
*    
*    *-print the coma
*    MOVE.B  #',',(A2)+
*    MOVE.B  #'A',(A2)+ ; subress register is static
*    
*    JSR get_bit_9_11    now get the bits from 9 to 11 these are the destimation bits
*    
*    *-since D3 contains the register number 
*    LEA numTable,A6
*    MULU    #8,D3
*    JSR     (A6,D3)
        BRA printCode


    
sub_B_EA   ;sub.B Dn -> EA
    
    *-store the size of the operation for immediate decoding use here/below
    *-D7 equals storage of size of operation
    *- #3 is byte , #2 is word #1 is long
    ;MOVE.B  #3,D7
    

    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'S',(A2)+
    MOVE.B  #'U',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'B',(A2)+
    *-always allow 4 spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    
    *-deCDOE EA (Dn,Dn
        * MachineCode: 0001 **** **** **BI T***
* Only next last 3 bits which is stored at D0 => Source subress mode
    *-insert immediate subressing here
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
            CMP.B   #32,D1         ; #imm => #XX 3 spaces
            ;BEQ.W   immediateData   ;branch to immediateData
            MOVE.B  #',',(A2)+
 ;           MOVE.B  #'D',(A2)+
            
* MachineCode: 0001 **** ***B IT** ****
* Only next last 3 bits which is stored at D0 => Destination subress mode
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
            BRA printcode  
            
            

   
sub_W_EA   ;sub.B Dn -> EA
    
    *-store the size of the operation for immediate decoding use here/below
    *-D7 equals storage of size of operation
    *- #3 is byte , #2 is word #1 is long
    ;MOVE.B  #3,D7
    MOVE.B  #1,D7
    

    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'S',(A2)+
    MOVE.B  #'U',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    *-always allow 4 spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    
    
    
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
            LEA     NumTable ,A7 Load the table into A7
            JSR     (A7,D1)     Jump to subroutine of value at D1   
            
            
            MOVE.B  #',',(A2)+
            *-INSERT IMMEDIATE DATA HERE
    *-deCDOE EA (Dn,Dn
        * MachineCode: 0001 **** **** **BI T***
 *Only next last 3 bits which is stored at D0 => Source subress mode
    *-insert immediate subressing here
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
            CMP.B   #32,D1         ; #imm => #XX 3 spaces
            ;BEQ.W   immediateData   ;branch to immediateData


            BRA printcode  
            
*            
*  
sub_L_EA   ;sub.L Dn -> EA
*    
*    *-store the size of the operation for immediate decoding use here/below
*    *-D7 equals storage of size of operation
*    *- #3 is byte , #2 is word #1 is long
*    ;MOVE.B  #3,D7
*    MOVE.B  #1,D7
*    
*
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'S',(A2)+
    MOVE.B  #'U',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'L',(A2)+
    *-always allow 4 spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    
    
    
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
            LEA     NumTable ,A7 Load the table into A7
            JSR     (A7,D1)     Jump to subroutine of value at D1   
            
            
            MOVE.B  #',',(A2)+
            *-INSERT IMMEDIATE DATA HERE
    *-deCDOE EA (Dn,Dn
        * MachineCode: 0001 **** **** **BI T***
 *Only next last 3 bits which is stored at D0 => Source subress mode
    *-insert immediate subressing here
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
            
            *-ERROR HERE NOT SURE WHY AFTER sub.L D2,(A2)+ it goines into this lower loop D1 = 20 no matchs
*            CMP.B   #32,D1         ; #imm => #XX 3 spaces
*            ;BEQ.W   immediateData   ;branch to immediateData


            BRA printcode  
*            
*            
*
*





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
