*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $9000
START:                  ; first instruction of program
    
* Put program code here
     NOP 

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
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
