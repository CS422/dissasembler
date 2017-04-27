*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $400
CR  EQU $0D
LF  EQU $0A
START:                  ; first instruction of program
    
* Put program code here
    
    LEA     MESSAGE1,A1 *Loads message into address register A1
    MOVE.B  #14,D0      *Moves number 14 into data regiter D0
    TRAP    #15         *Displays Message
   
    ;LEA     inputbuffer,A1   ; Where to store input string
    ;MOVE.B  #2,D0       ; from keyboard to store into input buffer Read string
    ;TRAP    #15         ;execute the task


    LEA test_buffer,A1  ;LOAD THE LOCATION where THIS STRING WILL BE PUT INTO
     MOVE.B  #' ',(A1)+  ENTER space
    MOVE.B  #' ',(A1)+  ENTER space
    MOVE.B  #'D',(A1)+  load D
    MOVE.B  #'A',(A1)+  load A
    MOVE.B  #'N',(A1)+  Load N
    MOVE.B  #'N',(A1)+  Load N    
    MOVE.B  #'Y',(A1)+  Load Y
     MOVE.B  #' ',(A1)+  ENTER space
      MOVE.B  #' ',(A1)+  ENTER space
       MOVE.B  #' ',(A1)+  ENTER space
    
    LEA     MESSAGE2,A1 *Loads message into address register A1
    MOVE.B  #13,D0      *Moves number 14 into data regiter D0
    TRAP    #15         *Displays Message

    LEA     test_buffer,A1   ;NOT SINCE THE STRING IS STORED AT THE BUFFER WHICH IS A LOCATIOIN FOR THE STRING TO LIVE is LOADED
                            ; BACK INTO A1 for the trap task to execute what sin a1 String 
    MOVE.B  #13,D0      ; Display string with newline
    TRAP    #15

    MOVE.B   #9,D0
    TRAP   #15          ; halt simulator
   
message1 dc.b 'enter your string: ',0
message2 dc.b 'string you have entered is: ',0
test_buffer ds.w    85    
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
    
    
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here
;MSG     DC.L    'ENTER A NUMBER: ',0
inputbuffer    ds.w    9999  input string storage

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
