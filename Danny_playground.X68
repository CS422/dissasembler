*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
*    MOVE.B #0, D1
*    MOVE.B  #1,D2
    *-using D7 for original value in HEX
    *-Using D5 to hold temp value, result
    *-D3 for shifting operations
    
    *-D7 is end result
    *-D6 is remainder where we do computatioins
    *-D5 is used as a cache
    
    MOVE.W  #0,D7
    MOVE.W  #9999,D6
    ;MOVE.L  D6,D7
    *-result = D7
    *-original Number D6
thousands:
    CMP     #1000,D6
    BLT     hundreds
    MOVE.L    D6,D5
    DIVU    #1000,D5
    SWAP    D5
    CLR     D6
    MOVE.W  D5,D6
    LSR.L   #8,D5
    LSR.L   #8,D5
    LSL.L   #8,D5
    LSL.L   #4,D5
    MULU    #8,D5       value adjusted for jumping
    LEA     numTable ,A7 Load the table into A7
    JSR     (A7,D5)     Jump to subroutine of value at D1 
    *-adding result, concatenate the result to A2
    ADD     D5,D7
    
hundreds:                                        
    CMP     #100,D6
    MOVE.L  D6,D5
    BLT     tens    if less than 100 then go to tens
    ;MOVE.W  D6,D7   MOVE to play with, D7 is result register
    

    DIVU    #100,D5 WE HAVE [REMAINDER][QUOTIENT]
    *-D7 Holds remainder
    *-move the remainder back into d6 to get remainder of coversion
    
    SWAP    D5  get the remainder
    CLR     D6
    MOVE.W  D5,D6 Move the remainder to D6
    LSR.L   #8,D5
    MULU    #8,D5       value adjusted for jumping
    LEA     numTable ,A7 Load the table into A7
    JSR     (A7,D5)     Jump to subroutine of value at D1 
    *-adding res
    ADD     D5,D7   ;add the end result to D7   
   
tens:
    MOVE.L  D6,D5                         
    CMP     #10,D6
    BLE     ones                               
    DIVU    #10,D6 splits the result in [Remainder][Quotient] each taking a word in size
                                        
    LSL     #4,D6   #add'0'
    ADD.W   D6,D7   Add the current quotient to the RESULTING register
    LSR.L     #8,D6   Shift out the Quotient
    LSL.L     #8,D6   Shift back the deleted Quotient
    SWAP    D6      D6 equald the remainder of the current computation
    MOVE.W  D6,D5
*    MOVE.W  D6,D5 Move entire result to D5 to split
*    ;Get the remainder from D6
*    MOVE.L  D6,D3 get the remainder move D6 long-word to d3 to shift
*                                        
*    LSR.L   #8,D3 Shift right 16 bits to get the remainder by itself
*    LSR.L   #8,D3
*    LSL.W   #4,D5
*
*    ADD     D3,D5 Add the remainder to the end of the quotient
    MULU    #8,D5       value adjusted for jumping
    LEA     numTable ,A7 Load the table into A7
    JSR     (A7,D5)     Jump to subroutine of value at D1 
    *-adding res
ones:
    MOVE.W  D6,D5
    MULU    #8,D5       value adjusted for jumping
    LEA     numTable ,A7 Load the table into A7
    JSR     (A7,D5)     Jump to subroutine of value at D1 
    *-adding res
    ADD     D6,D7
    
    

*                                                
*    MOVE.B  #34,D0
*    MOVE.w  #122,D1
    
    MOVEA.W #$1004,A1    ;MOVE the address $1004 into address register, right before our immediate addressing code
    MOVE.W  (A1)+,D2
    MOVE.W  (A1)+,D2    ;our immediate addressing code is here stored in D2
    
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
