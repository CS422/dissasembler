*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $996

*------
*Test memory address between 996 and 9CF
*
*
*----
START:                  ; first instruction of program
    
* Put program code here
*----------------------------------------------------------
* Testing: MOVE.B
*----------------------------------------------------------
* Direct Addressing
*----------------------------------------------------------
*    MOVE.B  D0,D1       ; Testing Dn
*    MOVE.B  D0,D2       ; Testing Dn
**   MOVE.B  A0,D1       ; Testing An
*----------------------------------------------------------
* Indriect Addressing
*----------------------------------------------------------
*    MOVE.B  (A1),D7     ; Testing  (An)
*    MOVE.B  (A2),D7     ; Testing  (An)
*    MOVE.B  (A3),D7     ; Testing  (An)
*    MOVE.B  (A4),D7     ; Testing  (An)
*----------------------------------------------------------
* Indriect Addressing with Post Increment 
*----------------------------------------------------------
*    MOVE.B  (A7)+,D3     ; Testing  (An)+
*    MOVE.B  (A6)+,D5     ; Testing  (An)+
*----------------------------------------------------------
* Indriect Addressing with Pre Decrement
*----------------------------------------------------------
*    MOVE.B  -(A5),D4     ; Testing  -(An)
*    MOVE.B  -(A5),D4     ; Testing  -(An)
*----------------------------------------------------------
* Immediate Data
*----------------------------------------------------------
    *MOVE.B  #34,D4 
*     MOVE.B  #99,D5        
*----------------------------------------------------------
* Absolute Addressing - Word
*----------------------------------------------------------
    * MOVE.B  $4214,D5
*----------------------------------------------------------
* Absolute Addressing - Long
*----------------------------------------------------------
    * MOVE.B   $A000,D5
*----------------------------------------------------------
* end of MOVE.B
*----------------------------------------------------------
*-------------------------------------
*   ADD
*------------------------
*    ADDA.L  D5,A5
*    ADDA.W  D2,A7
**    
*    MOVE.B  #34,D5
*    MOVE.B  D6,D7           
*    ADDA.W  #34,A5
*    MOVE.B  #$22,D5
     ;ADD     #$5,D5 ;ADDQ
    
    ;MOVE.B   #$22,D5
;    ADD.B   D6,D5
*- BROken below, the buffer (A3) will not print the regnum 7, not sure why
;    ADD.W   A5,D6
; why does it print out wrong if i print multiple opcodes 
 
*    ADD.L   D7,D4
*    
;ISSUE (A3)/(A2) does not correctly print to the console if there are more than 1 OPCODE
*    ADD.W   D6,D2
*    ADD.L   D7,D1    
*    
*    ADD.W   D2,(A2)+



*    ADD.L   D5,(A4)+

;    SUB.B   D2,D6
*- immediate data prints 45 which is HEX equalivent of 69(decimal)
*-idea convert from decimal to hex to ascii
    MOVEQ   #69,D2
    














*-***********************************************************
    
    ;LEA     MESSAGE1,A1 *Loads message into address register A1
    ;MOVE.B  #14,D0      *Moves number 14 into data regiter D0
    ;TRAP    #15         *Displays Message
   
    ;LEA     inputbuffer,A1   ; Where to store input string
    ;MOVE.B  #2,D0       ; from keyboard to store into input buffer Read string
    ;TRAP    #15         ;execute the task


    ;LEA test_buffer,A1  ;LOAD THE LOCATION where THIS STRING WILL BE PUT INTO
    ; MOVE.B  #' ',(A1)+  ENTER space
    ;MOVE.B  #' ',(A1)+  ENTER space
    ;MOVE.B  #'D',(A1)+  load D
    ;MOVE.B  #'A',(A1)+  load A
    ;MOVE.B  #'N',(A1)+  Load N
    ;MOVE.B  #'N',(A1)+  Load N    
    ;MOVE.B  #'Y',(A1)+  Load Y
    ; MOVE.B  #' ',(A1)+  ENTER space
    ;  MOVE.B  #' ',(A1)+  ENTER space
    ;   MOVE.B  #' ',(A1)+  ENTER space
    
    ;LEA     MESSAGE2,A1 *Loads message into address register A1
    ;MOVE.B  #13,D0      *Moves number 14 into data regiter D0
    ;TRAP    #15         *Displays Message

    ;LEA     test_buffer,A1   ;NOT SINCE THE STRING IS STORED AT THE BUFFER WHICH IS A LOCATIOIN FOR THE STRING TO LIVE is LOADED
                            ; BACK INTO A1 for the trap task to execute what sin a1 String 
    ;MOVE.B  #13,D0      ; Display string with newline
    ;TRAP    #15

    ;MOVE.B   #9,D0
    ;TRAP   #15          ; halt simulator
   
;    ds.w    0       ; force even address
;buffer  ds.b    80  ; input string storage

*    LEA     MSG,A1
*    MOVE.B  #14, D0
*    TRAP    #15
    
    
*    MOVE.B  #2,D0
*    TRAP    #15
 
*    MOVEA.W $300,A2
*    MOVE.W  D1,D2   THE INPUT IS STORED INTO D1 WE MOVE IT TO D2
    
*    MOVE.W  D2,(A2)
    
    
    

    END    START        ; last line of source


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
