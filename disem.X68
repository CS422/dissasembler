*-----------------------------------------------------------
* Title      : 
* Written by : DANNY AND EDWARD
* Date       :
* Description:
*-----------------------------------------------------------
*-CURRENT STATE ONLY CONVERTS THE STRING ADDRESS TO A HEX ADDRESS STORED INSIDE D6
    ORG    $1000
CR  EQU $0D
LF  EQU $0A
START:                  ; first instruction of program
            ;LEA     stack,SP
            LEA     welcome_message,A1  PRESENT THE WELCOME MESSAGE
            MOVE.B  #14,D0
            TRAP    #15
            
           


* Put program code here
*-----
*This program starts by given a starting address and an ending address disassemble
*the binary code that is at that location.
*
*
*----


*run_program     
*                MOVE.L  #0,A3
*                CLR     D1
*                LEA     enter_start_AD,A1
*                MOVE.L  #14,D0
*                TRAP    #15
                
                
                *---------------------I/O SECTION
                
get_input_start_addr 
                MOVE.L  #0,A3
                CLR     D1
                LEA     enter_start_AD,A1
                MOVE.L  #14,D0
                TRAP    #15
                
                

      
                LEA     userStartAddrInput,A1   load address to store the input from user
                MOVE.L  #2,D0
                TRAP    #15
                JSR     parse_input         parse the starting address
                
                
                MOVE.L  D6,A5   MOVE OUR STARTING ADDRESS TO A6
                
                *----MIGHT NEED TO CHECK FOR ODD ADDRESSING ?
                *----CHECK FOR ADDRESS OUT OF BOUNDS DOMAIN?



get_input_end_addr
                MOVE.L  #0,A3
                CLR     D1
                LEA     userEnd,A1
                MOVE.L  #14,D0
                TRAP    #15
                


                LEA     userEndAddrInput,A1
                MOVE.B  userEnd,D1
                MOVE.L  #2,D0
                TRAP    #15
                JSR     parse_end

                
                MOVE.L  D6,A6   MOVE OUT ENDING ADDRESS TO A7
                JSR     get_opcode 

                *----MIGHT NEED TO CHECK FOR ODD ADDRESSING ?
                *----CHECK FOR ADDRESS OUT OF BOUNDS DOMAIN?
                ;SIMHALT

        *----------END OF I/O SECTION*---
        *----------Start of OPCODE SUBROUTINE
stack            EQU        $A000  
shift            EQU        12                   * Shift 12 bits 
                 ORG        $400
         
get_opcode       LEA        stack,SP        *Load the SP
                 LEA        jmp_table,A0    *Index into the table
                 CLR.L      D0              *Zero it       
                 MOVE.L     #$00009000,A1        *We'll play with it here
                 MOVE.W     (A1),D0
                 MOVE.B     #shift,D1       *Shift 12 bits to the right  
                 LSR.W      D1,D0           *Move the bits
                 MULU       #6,D0           *Form offset     
                 JSR        0(A0,D0)        *Jump indirect with index
                 
jmp_table        JMP        code0000        *Bit manipulation/MOVEP/Immediate
                 JMP        code0001        *MOVE.B
                 JMP        code0010        *MOVE.L
                 JMP        code0011        *MOVE.W
                 JMP        code0100        *Miscellaneous
                 JMP        code0101        *ADDQ/SUBQ/Scc/DBcc
                 JMP        code0110        *BSR,BRA,Bcc
                 JMP        code0111        *MOVEQ
                 JMP        code1000        *OR/DIV/SBCD
                 JMP        code1001        *SUB/SUBX
                 JMP        code1010        *Unassigned
                 JMP        code1011        *CMP/EOR
                 JMP        code1100        *AND/MUL/ABCD/EXG
                 JMP        code1101        *ADD/ADDA/ADDX
                 JMP        code1110        *Shift/Rotate
                 JMP        code1111        *Special/Reserved
                 
code0000         STOP       #$2700
code0001         STOP       #$2700
code0010         STOP       #$2700
code0011         STOP       #$2700
code0100         MOVE.L  #0,A3
                 CLR     D1
                 LEA     enter_start_AD,A1
                 MOVE.L  #14,D0
                 TRAP    #15
                 RTS
code0101         STOP       #$2700
code0110         STOP       #$2700
code0111         STOP       #$2700
code1000         STOP       #$2700
code1001         STOP       #$2700
code1010         STOP       #$2700
code1011         STOP       #$2700
code1100         STOP       #$2700
code1101         STOP       #$2700
code1110         STOP       #$2700
code1111         STOP       #$2700

        *INCLUDE 'opcode_subroutine.x68'
STORE_SRT_END:
            SUB.W   A5,D6   SUBTRACT THE STARTING ADDRESS FROM THE ENDING ADDRESS TO GET THE SIZE OF INSTRUCTIONS
            MOVE.L  A5,$00FFFF00    STORE USER START ADDRESS SO WE CAN FREE UP REG
            MOVE.L  A6,$00FFFF10    STORE USER END ADDRESS SO WE CAN FREE UP REG
            MOVE.L  D6,$00FFFF20    STORE SIZE OF INSTRCTIONS
            
            SIMHALT


*-Parses input - take input from user to create a memory address
*- entry is parsed to make sure it falls within a valid range
*-good inputs are converteed to hex
*-the entered addres get's stored in d3
*-
*-
parse_input     MOVEQ   #$0,D6  IM SURE WE CAN USE CLR, CLEAR THE DATA REGISTER
                MOVEQ   #$0,D5
                
                *-CHECK TO SEE INPUT DATA
                CMP.B   D5,D1   D5 IS 0
                BEQ     error_no_input no input was found
                CMPI    #$8,D1  CHECK IF THE USER ENTERED TOO MANY CHARACTERS 8+
                BGT     error_bad_entry
                ;BGT     error_inv_to_many_char
                BRA     parse_each

parse_end        MOVEQ   #$0,D6  CLEARS THE D6 REGISTEY
                MOVEQ   #$0,D5  CLEARS D5
                CMP.B   D5,D1   CHECKS TO SEE IF A VALUE WAS ENTERED
                BEQ     error_no_input
                CMPI    #$8,D1  CHECKS IF THE USER ENTERED TOO MANY CHARACTERS 8+
                BGT     error_bad_entry
                ;BGT     error_to_many_char
                BRA     parse_each        

*parse each analyzes each ind character entered
*in ASCII table lower case 'f' is tyhe highest character code (102)

parse_each      MOVE.B  (A1)+,D2    GET THE NEXT CHARACTER FOR PARSING
                CMP.B   D5,D2       CHECK IF THE NEXT VALUE IS NULL, IF SO WE HAVE EITHER ERROR OR REACHED END OF INPUT
                BEQ     parse_complete  end of user input
                CMP.B   #102,D2     NEED TO CHECK WETHER THE INPUT IS OUT OF ASCII RANGE 'f' is 102
                BGT     hex_compare
                
                *-
                *Comapare the decimal number values betyween 0 -9 first
                *
                *-
dec_compare     CMP.B   #47,D2      if its lower than 47 that means its invalid character
                                    *-for decimal values between [47, 57] are valid
                BLE     error_char 
                CMP.B   #58, D2     IF THE VALUE IS NOT LESS THAN 47 AND NOT GREATER THAN 58 WE CAN CONVERT DECIMAL TO HEX
                BLT     dec_convert
                *-
                *there are no number values, lets check alpha characters
                *->IF the value is not less than 65 which is 'A' and the value is NO more than
                *->71 'G' then we should go and convert to hex range A-F
                *-UPPER case
                *-      
hex_compare     CMP.B   #65,D2      CHECK TO SEE IF THE VALUE OF THE CHAR IS LESS THAN 65(A)
                BLT     error_char  the VALUE IS LESS THAN 65 WHICH IS SYMBOLS AND INVALID
                CMP.B   #71,D2      CHECK TO SEE IF THE VALUE OF THE CHAR IS LESS THAN 71(G)
                BLT     upper_ascii VALUE FELL IN RANGE A-F                 
low_hex_compare CMP.B   #97,D2      CHECK TO SEE IF VALUE IS LESS THAN 97 'a'
                BLT     error_char  VALUE IS SOME SYMBOL *- 97 - 103
                CMP.B   #103,D2     CHECK IF ITS WITHIN RANGE, LESS THAN 103
                BLT     lower_ascii
                
         
dec_convert     SUBI.B  #48,D2      CONVERT TO HEX FROM ASCII BY SUBTRACTING 48 FROM CURRENT DECIMAL VALUE
                *-BECAUSE 0 - 9 THE HEX VALUES WILL BE A SINGLE CHAR WE SHIFT LEFT
                ASL.L   #4,D6
                ADD.B   D2,D6       MOVE NEW BYTE INTO THE RETURN REGISTER
                BRA     parse_each  continue to parse the next character, SHOULD BE IN RANGE FOR LOWER
                                    *- 97 - 103
                
                            
*- ASCII conversions UPPER case to hex value by substracting 55

upper_ascii     SUBI.B  #55,D2  SUBTRACT 55 TO GET THE HEX VALUE OF THE CORRESPONDING CHARACTER
                ASL.L   #4,D6   MOVE THE SANITIZED VALUE INTO D6 REGISTER
                ADD.B   D2,D6   MOVE THE NEW BYTE INTO RETURN REGISTER
                BRA     parse_each  parse next item
*-ASCI lower case to hex value by subtracting 87
lower_ascii     SUBI.B  #87,D2
                ASL.L   #4,D6
                ADD.B   D2,D6
                BRA     parse_each

parse_complete  MOVEQ   #1,D4  FINISH PARSING USER INPUT
                RTS             JUMP FROM SUBROUTINE                
error_no_input  LEA no_entry,A1 load bad entry statment
                MOVE.L  #1,D0
                TRAP    #15
                ;JMP     get_input
error_char      LEA bad_char,A1
                trap #15
                ;JMP get_input0
error_bad_entry LEA bad_entry,A1
                TRAP #15
                ;JMP  get_input


    SIMHALT             ; halt simulator

* Put variables and constants here
welcome_message DC.B    'Hello and Welcome 68Kkrew"s 68K Disassembler(get the pun)',CR,LF


no_entry    DC.B    'No Entry detected.',0
bad_entry   DC.B    'Bad Entry Dectected.',0
bad_char    DC.B    'Bad Char detected.',0
*-errors
enter_start_AD  DC.B    'Enter a starting address between $0 and $00FFFE00: ',0
userStartAddrInput  DS.B    50  address used to store the data input from user
userEndAddrInput    DS.B    50  address used to stoer the data input from user

userEnd         DC.B    'Enter an address greater than the starting address: ',0

userEndInput    DS.B    50  addresse used to store the data input from user
error_inv_to_many_char  LEA no_entry,A1 load bad entry statment
                        MOVE.L  #1,D0
                        TRAP    #15
                        ;JMP     get_input



    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
