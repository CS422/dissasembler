*-----------------------------------------------------------
* Title      : (!!!!!!STABLE!!!!) Master branch
* Written by : Danny Ly & Edward Chang
* Date       : 4/27/2017
* Description: Our dissasembler for 68K
*-----------------------------------------------------------
*-CURRENT STATE ONLY CONVERTS THE STRING ADDRESS TO A HEX ADDRESS STORED INSIDE D6
    ORG    $1000
    
CR  EQU $0D
LF  EQU $0A
startLoc    EQU $7000


*--- Notes
*We'll keep A2 as our pointer to writing to the different buffers
* A4 will be our main pointer to current memory address and current data
* D3 will be dedicated register to manipulate our data in
*
*
*---------
START:                  
            ; first instruction of program
            ;LEA     stack,SP
            *-present the hello message
            LEA     welcome_message,A1  PRESENT THE WELCOME MESSAGE
            MOVE.B  #14,D0
            TRAP    #15
            
*           
**- FOR TEST RANGE FROM 996 - 9CF PUT CODES OR NOP ANYWHERE BETWEEN
*
** Put program code here
**-----
**This program starts by given a starting address and an ending address disassemble
**the binary code that is at that location.
**
**
**----
*
**-------
** Needs to check for odd addressing**
**
**
**-----
*                *---------------------I/O SECTION
*                * Grabs ascii from user and converts to hex stored into memory
*                * A4 is used as our pointer for the program, ending addresses can be stored
*                * statically in memory and retrieved when needed to compare
*                * this free's up a adress/data register to use
*                *-----------------------
*                
*                
*get_input_start_addr 
*                MOVE.L  #0,A3
*                CLR     D1
*                LEA     enter_start_AD,A1
*                MOVE.L  #14,D0
*                TRAP    #15
*                
*                
*
*      
*                LEA     userStartAddrInput,A1   load address to store the input from user
*                MOVE.L  #2,D0
*                TRAP    #15
*                JSR     parse_input             parse the starting address
*                
*                
*                MOVE.L  D6,A5                   MOVE OUR STARTING ADDRESS TO A6
*                
*                                                *----MIGHT NEED TO CHECK FOR ODD ADDRESSING ?
*                                                *----CHECK FOR ADDRESS OUT OF BOUNDS DOMAIN?
*
*
*get_input_end_addr
*                MOVE.L  #0,A3
*                CLR     D1
*                LEA     userEnd,A1
*                MOVE.L  #14,D0
*                TRAP    #15
*                
*
*
*                LEA     userEndAddrInput,A1
*                MOVE.B  userEnd,D1
*                MOVE.L  #2,D0
*                TRAP    #15
*                JSR     parse_end
*
*                
*                MOVE.L  D6,A6           MOVE OUT ENDING ADDRESS TO A7
*  
*             
*STORE_SRT_END:
*               
*                      ;store the starting and ending address into memory out of range
*            SUB.W   A5,D6           SUBTRACT THE STARTING ADDRESS FROM THE ENDING ADDRESS TO GET THE SIZE OF INSTRUCTIONS
*            MOVE.L  A5,$00FFFF00    STORE USER START ADDRESS SO WE CAN FREE UP REG
*            MOVE.L  A6,$00FFFF10    STORE USER END ADDRESS SO WE CAN FREE UP REG
*            MOVE.L  D6,$00FFFF20    STORE SIZE OF INSTRCTIONS
*            MOVE.L  A5,A4
            
            *----------FOR TESTING PURPOSES FOR RELEASE UNCOMMENT THE ABOVE----------------
            *       Testing Code Starts the address at 996 to 9CF about 30 entries
            *
            MOVE.L  #$996,D6    Starting address loads into D6
            MOVE.L  D6,A5       Move D6 into a5
            
            MOVE.L  #$9CF,D6
            MOVE.L  D6,A6
            
            
            MOVE.L  A5,$00FFFF00    STORE USER START ADDRESS SO WE CAN FREE UP REG
            MOVE.L  A6,$00FFFF10    STORE USER END ADDRESS SO WE CAN FREE UP REG
            MOVE.L  A5,A4           A4 is our starting.current pointer
            *
            *
            *-------------END OF TESING CODE-----------
        
            BRA get_next_instruction
                         
                         
   
*---move_addresses:
                                
                *-MOVE 2 INTO DATA REG
                
                ;JSR     LOOP
                *----LEA     good_code_buffer,a2 ;load the code buffer
                *-STORE THE OLD ADDRESS/STARTING/CURRENT INTO 
                
                *----MOVE.W  A4,A0
                
                *-STORE 2 AT DATA REG MAYBE FOR INCREMNTEATION
                *----MOVE.B  #2,D4
                
                *-MOVE OLD ADDRESS TO DATA REGISTER
                *-----MOVE.L  A0,D3   ;D3 IS USED TO PRINT OUT THE ADDRESS LINE, OR ANYTHING IN D3
                *------MOVE.L  D3,D7
                



                *------LEA     good_code_buffer,A2 load again
                *------JSR     print_d3
                
                
                ;JSR     get_opcode 

                *----MIGHT NEED TO CHECK FOR ODD ADDRESSING ?
                *----CHECK FOR ADDRESS OUT OF BOUNDS DOMAIN?
                ;SIMHALT


* ---------------------------------------------------------- 
* Decode ---------------------------------------------------
            LEA     startLoc,A4 ;loads statLoc's EA into A4
            BRA     get_next_instruction    ;put data in D3, incre. A4
     
mainLoop          
            *-----
            *-This is the various OP Codes to decode, and branch off too, we need to decode these ones
            *- listing of finished and un finished work
            *-          ***Machine Code saved in D6*****
            *-----

            LSR     #4,D3       SHIFT 4 BITS TO GET THE MSB OF THE WORD
            
            ;compare bits to instructions
            
            CMP.B   #bin0001,D3 ;MOVE.B
            *- Machine code saved in D6
            BEQ     op0001      ;branch to op0001
            ;CMP.B   #bin0011,D3 ;MOVE.W
            ;BEQ     op0011      ;branch to op0011
            ;CMP.B   #bin0010,D3 ;MOVE.L 
            ;BEQ     op0010      ;branch to op0010           
            CMP.B   #bin0111,D3 ;MOVEQ
            BEQ     op0111      ;branch to op0111                        
            CMP.B   #bin0100,D3     MOVEM.L, MOVEM.W, LEA, CLR, JSR,NOP(DONE), RTS(DONE)
            BEQ     op0100          branch to op0100                        
            CMP.B   #bin1101,D3 ;ADD, ADDA
            BEQ     op1101      ;branch to op1101            
            CMP.B   #bin1001,D3 ;SUB, SUBA
            BEQ     op1001      ;branch to op1001                        
            ;CMP.B   #bin0000,D3 ;ADDI, ANDI, EORI, BCHG, CMPI
            ;BEQ     op0000      ;branch to op0000                       
            ;CMP.B   #bin0101,D3 ;SUBQ
            ;BEQ     op0101      ;branch to op0101                         
            ;CMP.B   #bin0110,D3 ;Bcc
            ;BEQ     op0110      ;branch to op0110            
            ;CMP.B   #bin1000,D3 ;DIVU.W
            ;BEQ     op1000      ;branch to op1000                                      
            ;CMP.B   #bin1011,D3 ;CMP, CMPA, EOR
            ;BEQ     op1011      ;branch to op1011 
            ;CMP.B   #bin1100,D3 ;AND, MULS.W
            ;BEQ     op1100      ;branch to op1100                                    
            ;CMP.B   #bin1110,D3 ;ASR, LSL, ROL, ROR
            ;BEQ     op1110      ;branch to op1110            
            
            BRA     opERROR     ;invalid opcode display we havent implemented this code yet
            
            ;branch to display opError display
            
            ;print all the things...
 *******************************************************************************
*
*******************************************************************************
addressCount 
            *-THIS LOCATION IS WHERE WE WILL PERIODICALLY CHECK THE RUNNING A4 REGISTERY WITH OUR STORED
            *-ENDING ADDRESS VALUE TO SEE IF WE HAVE REACHED THE END OF OUR ADDRESS RANGE
            *-A4 IS ALSO ACTS AS OUR 'I' VALUE OR OUR VALUE THAT KEEPS POINTING TO MEMORY LOCATIONS
            *-wE CAN USE THIS POINTER TO ACCESS DATA FURTHURE DOWN, THE END ADDRESS WE DO NOT NEED TO KEEP 
            *-TRACK OF CONSTANTLY SO WE CAN STORE INTO MEMORY AND RETRIEVE FROM MEMORY WHEN WE NEED IT
            
            LEA   $00FFFF10,A5  * RETRIEVE ENDING ADDRESS(THE LESASH /POINTER TO ENGIND ADDRESS
            MOVE.L  (A5),D1     * MOVE THE DATA STORED AT THE POINTER TO DATA REGISTER
            MOVE.L  A4,D5       * MOVE OPUR CURRENT POINTER 'I' FROM ADDRESS REGISTER TO DATA REGISTER
            CMP.L   D5,D1       * COMPARE THE ADDRESSES
            BLE     FINISH      * branch to end if ending address reached
            RTS                 * return IF WE HAVE NOT FINISHED
            
get_next_instruction:
                JSR addressCount    *-CHECKS IF WE REACHED OUT ENDING ADDRESS YET
                *-line count
                CLR D5             *-CLEAR THIS REGISTER/
                
                Lea good_code_buffer,A2 ;reset A2, LOADS THE BUFFER TO GET READY TO PRINT TO IT/WRITE TO IT
                MOVE.W  A4,A0   UPDATE OUR OLD ADDRESS STORED AT 10 WITH THE MOST CURRENT POINTER ADDRESS *INCRMENTED BY A WORD
                MOVE.L  #2,D7   *-CHECKER FOR ERROR
                MOVE.L  A0,D3   *-MOVE AROUND TEH DATA STORED AT CURRENT POINTER TO D3 REGISTER TO WORK WITH IT
                MOVE.L  D3,D6   
                LEA     good_code_buffer,A2
                                *-write the current data moved to data register d3
                JSR     write_data_in_D3_to_buffer
                
                MOVE.B  #' ',(A2)
                MOVE.B  #' ',(A2)
                MOVE.B  #' ',(A2)
                MOVE.B  #' ',(A2)
                
                CLR.L   D6
                CLR.L   D3
                
                MOVE.W  A4,A5    Load the instruction address into the designated address resgister A5 to decode operand if needed
                
                MOVE.W  (A4)+,D6 INCREMENT OUT STARTING/CURRENT POINTER BY A WORD, STORE THE CONTENTS OF WHAT ITS CURRENTLY POINTING AT
                                   *-WHICH WOULD BE THE OPCODE DATA, INTO D6

                MOVE.L  (A4),D4  If absolute addressing => this will be operand                 
                MOVE.W  D6,D3
                LSR.W   #8,D3
                
                BRA     mainLoop
                
write_data_in_D3_to_buffer:
            *------
            *   This is where we write to whatever is in data registrer D3 our dedicated D3 writer buffer writer
            *
            *
            *---------
                CMP.W   #2,D7 ERROR checking
                BNE     print_word branch off to write the first word of the line
                SWAP    D3
                SWAP    D6
                JSR     print_word
                SWAP    D6
                MOVE.L  D6,D3
                
 print_word:
                *-****
                * called 4 times to decode from hex to ascii the first word 
                *   using the below jump table
                *
                *-------
                LSR.W   #8,D3
                LSR.W   #4,D3
                MULU.W  #8,D3
                LEA     numTable,A6
                JSR     (A6,D3)
                
                MOVE.W  D6,D3   COPY DATA
                LSL.W   #4,D3
                LSR.W   #8,D3
                LSR.W   #4,D3
                MULU.W  #8,D3
                LEA     numTable,A6
                JSR     (A6,D3)
                
                MOVE.W  D6,D3
                
                LSL.W   #8,D3
                LSR.W   #8,D3
                LSR.W   #4,D3
                MULU.W  #8,D3
                LEA numTable,A6
                JSR     (A6,D3)
                
                
                MOVE.W  D6,D3
                LSL.W   #4,D3
                LSL.W   #8,D3
                LSR.W   #8,D3
                LSR.W   #4,D3
                MULU.W  #8,D3
                LEA     numTable,A6
                JSR     (A6,D3)
                ADDI.B  #4,D5
                RTS
* -----------------------------------------------------------            
* Jump Table immAbTable *************************************
*** matches the associated Addressing mode     
*************************************************************
immAbTable  JSR     IA000   ;Absoulute Word
            RTS             ;return, done printing
            JSR     IA001   ;Aboulute Long
            RTS             ;return, done printing
            JSR     IA010   ;blank
            RTS             ;return, done printing
            JSR     IA011   ;blank
            RTS             ;return, done printing  
            JSR     IA100   ;immediate Data
            RTS             ;return, done printing
* -----------------------------------------------------------            
IA010       RTS
IA011       RTS
* -----------------------------------------------------------            
* Subroutine IA000   ------------------------------------------
IA000                               ;absoulteWord   
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
* Subroutine IA001   ------------------------------------------
IA001                               ;absoulteLong
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
 
* -----------------------------------------------------------            
* Subroutine IA100   ------------------------------------------
IA100                               ;immediateData

            MOVE.B  #'#',(A2)+ 
            MOVE.B  #'$',(A2)+
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
* Jump Table modeTable ***************************************
*** matches the associated Addressing mode     
*************************************************************
modeTable   JSR     M0000   ;Dn, Data Register 
            RTS             ;return, done printing
            JSR     M0001   ;An, Address Register 
            RTS             ;return, done printing
            JSR     M0010   ;(An), Address
            RTS             ;return, done printing
            JSR     M0011   ;(An)+, Address with Postincrement
            RTS             ;return, done printing
            
            JSR     M0100   ;-(An), Address with Predecrement
            RTS             ;return, done printing
            JSR     M0101   ; blank - not assigned for this project
            RTS
            JSR     M0110   ; blank - not assigned for this project
            RTS
            JSR     M0111   ;(xxx).W, (xxx).L, #imm
            RTS             ;return, done printing           
* -----------------------------------------------------------            
* Subroutine M0000 ------------------------------------------
M0000                               ;Dn
            MOVE.B  #'D',(A2)+      ;display D
            MOVEA.L A2,A3           ;get address for n
            MOVE.B  #' ',(A2)+      ;blank
            RTS

* -----------------------------------------------------------            
* Subroutine M0001 ------------------------------------------
M0001                               ;An
            MOVE.B  #'A',(A2)+      ;display A
            MOVEA.L A2,A3           ;get address for n
            MOVE.B  #' ',(A2)+      ;blank
            RTS

* -----------------------------------------------------------            
* Subroutine M0010 ------------------------------------------
M0010                               ;(An) Address
            MOVE.B  #'(',(A2)+      ;display (
            MOVE.B  #'A',(A2)+      ;display A
            MOVEA.L A2,A3           ;get address for n
            MOVE.B  #' ',(A2)+      ;blank      
            MOVE.B  #')',(A2)+      ;display )
            RTS
 
* -----------------------------------------------------------            
* Subroutine M0011 ------------------------------------------
M0011                               ;(An)+ 
            MOVE.B  #'(',(A2)+      ;display (
            MOVE.B  #'A',(A2)+      ;display A
            MOVEA.L A2,A3           ;get address for n 
            MOVE.B  #' ',(A2)+      ;blank     
            MOVE.B  #')',(A2)+      ;display )
            MOVE.B  #'+',(A2)+      ;display +
            RTS

* -----------------------------------------------------------            
* Subroutine M0100 ------------------------------------------
M0100                               ;-(An)
            MOVE.B  #'-',(A2)+      ;display -
            MOVE.B  #'(',(A2)+      ;display (
            MOVE.B  #'A',(A2)+      ;display A
            MOVEA.L A2,A3           ;get address for n
            MOVE.B  #' ',(A2)+      ;blank      
            MOVE.B  #')',(A2)+      ;display )
            RTS

* -----------------------------------------------------------    
* Subroutine M0101 ------------------------------------------
M0101                               ;do nothing
            RTS
* -----------------------------------------------------------   
* Subroutine M0110 ------------------------------------------
M0110                               ;do nothing
            RTS
* -----------------------------------------------------------     
* Subroutine M0111 -------------------------Not finished-----
* Register is stored at D1
* ----case 1 : Register 100 => #imm => #XX 3 spaces
* ----case 2 : Register 000 => (XXX).W => 
* ----case 3 : Register 001 => (XXX).L
* 
* MOVE.W  (A4)+,D6 INCREMENT OUT STARTING/CURRENT POINTER BY A WORD, STORE THE CONTENTS OF WHAT ITS CURRENTLY POINTING AT

M0111                               ;(xxx).W, (xxx).L, #imm
                                    ; This will be taken care under opcode subroutine
            RTS

* -----------------------------------------------------------
* Subroutine immediateData 
;immediateData     
;            RTS
* -----------------------------------------------------------

* Subroutine registerPrint----------------------------------- 
registerPrint
            LEA     numTable,A7 Load the table into A7
            JSR     (A7,D1)     Jump to numTable with value at D1
            RTS

* -----------------------------------------------------------            
* Jump Table regNumTable ***************************************
*** prints the associated number of the register            *
*** Also prints hex values for data and addresses           *
*-----see below for decoding of what these sub-routines are
*************************************************************
regNumTable JSR     RN0000   ;register 0
            RTS             ;return, done printing
            JSR     RN0001   ;register 1
            RTS             ;return, done printing
            JSR     RN0010   ;register 2
            RTS             ;return, done printing
            JSR     RN0011   ;register 3
            RTS             ;return, done printing
            JSR     RN0100   ;register 4
            RTS             ;return, done printing
            JSR     RN0101   ;register 5
            RTS             ;return, done printing
            JSR     RN0110   ;register 6
            RTS             ;return, done printing
            JSR     RN0111   ;register 7
            RTS             ;return, done printing
* -----------------------------------------------------------            
* Subroutine RN0000 ------------------------------------------
RN0000
            MOVE.B  #'0',(A3)      ;display 0
            RTS

* -----------------------------------------------------------            
* Subroutine RN0001 ------------------------------------------
RN0001
            MOVE.B  #'1',(A3)      ;display 1
            RTS

* -----------------------------------------------------------            
* Subroutine RN0010 ------------------------------------------
RN0010
            MOVE.B  #'2',(A3)      ;display 2
            RTS
 
* -----------------------------------------------------------            
* Subroutine RN0011 ------------------------------------------
RN0011
            MOVE.B  #'3',(A3)      ;display 3
            RTS

* -----------------------------------------------------------            
* Subroutine RN0100 ------------------------------------------
RN0100
            MOVE.B  #'4',(A3)      ;display 4
            RTS

* -----------------------------------------------------------            
* Subroutine RN0101 ------------------------------------------
RN0101
            MOVE.B  #'5',(A3)      ;display 5
            RTS

* -----------------------------------------------------------            
* Subroutine RN0110 ------------------------------------------
RN0110
            MOVE.B  #'6',(A3)      ;display 6
            RTS
            
* -----------------------------------------------------------            
* Subroutine RN0111 ------------------------------------------
RN0111
            MOVE.B  #'7',(A3)      ;display 7
            RTS

* -----------------------------------------------------------            
* Jump Table numTable ***************************************
*** prints the associated number of the register            *
*** Also prints hex values for data and addresses           *
*-----see below for decoding of what these sub-routines are
*************************************************************
numTable    JSR     N0000   ;register 0
            RTS             ;return, done printing
            JSR     N0001   ;register 1
            RTS             ;return, done printing
            JSR     N0010   ;register 2
            RTS             ;return, done printing
            JSR     N0011   ;register 3
            RTS             ;return, done printing
            JSR     N0100   ;register 4
            RTS             ;return, done printing
            JSR     N0101   ;register 5
            RTS             ;return, done printing
            JSR     N0110   ;register 6
            RTS             ;return, done printing
            JSR     N0111   ;register 7
            RTS             ;return, done printing
            JSR     N1000   ;num 8
            RTS             ;return, done printing
            JSR     N1001   ;num 9
            RTS             ;return, done printing
            JSR     N1010   ;num A
            RTS             ;return, done printing
            JSR     N1011   ;num B
            RTS             ;return, done printing
            JSR     N1100   ;num C
            RTS             ;return, done printing
            JSR     N1101   ;num D
            RTS             ;return, done printing
            JSR     N1110   ;num E
            RTS             ;return, done printing
            JSR     N1111   ;num F
            RTS             ;return, done printing
* -----------------------------------------------------------            
* Subroutine N0000 ------------------------------------------
N0000
            MOVE.B  #'0',(A2)+      ;display 0
            RTS

* -----------------------------------------------------------            
* Subroutine N0001 ------------------------------------------
N0001
            MOVE.B  #'1',(A2)+      ;display 1
            RTS

* -----------------------------------------------------------            
* Subroutine N0010 ------------------------------------------
N0010
            MOVE.B  #'2',(A2)+      ;display 2
            RTS
 
* -----------------------------------------------------------            
* Subroutine N0011 ------------------------------------------
N0011
            MOVE.B  #'3',(A2)+      ;display 3
            RTS

* -----------------------------------------------------------            
* Subroutine N0100 ------------------------------------------
N0100
            MOVE.B  #'4',(A2)+      ;display 4
            RTS

* -----------------------------------------------------------            
* Subroutine N0101 ------------------------------------------
N0101
            MOVE.B  #'5',(A2)+      ;display 5
            RTS

* -----------------------------------------------------------            
* Subroutine N0110 ------------------------------------------
N0110
            MOVE.B  #'6',(A2)+      ;display 6
            RTS
            
* -----------------------------------------------------------            
* Subroutine N0111 ------------------------------------------
N0111
            MOVE.B  #'7',(A2)+      ;display 7
            RTS

* ----------------------------------------------------------- 
* Subroutine N1000 ------------------------------------------
N1000       
            MOVE.B  #'8',(A2)+      ;display 8
            RTS

* -----------------------------------------------------------            
* Subroutine N1001 ------------------------------------------
N1001   
            MOVE.B  #'9',(A2)+      ;display 9
            RTS

* -----------------------------------------------------------            
* Subroutine N1010 ------------------------------------------
N1010   
            MOVE.B  #'A',(A2)+      ;display A
            RTS

* -----------------------------------------------------------            
* Subroutine N1011 ------------------------------------------
N1011   
            MOVE.B  #'B',(A2)+      ;display B
            RTS

* -----------------------------------------------------------            
* Subroutine N1100 ------------------------------------------
N1100   
            MOVE.B  #'C',(A2)+      ;display C
            RTS

* -----------------------------------------------------------            
* Subroutine N1101 ------------------------------------------
N1101   
            MOVE.B  #'D',(A2)+      ;display D
            RTS

* -----------------------------------------------------------            
* Subroutine N1110 ------------------------------------------
N1110   
            MOVE.B  #'E',(A2)+      ;display E
            RTS

* -----------------------------------------------------------            
* Subroutine N1111 ------------------------------------------
N1111   
            MOVE.B  #'F',(A2)+      ;display F
            RTS   
*-------------------- HELPER FUCNTION LOCATION -----------
*- For Mode always D2
*-- For Register always D1
*-  Original Machine code In D6


*            HELPER LOCATION
*            HELPER LOCATION
*            HELPER LOCATION
*            HELPER LOCATION
*            HELPER LOCATION

get_0_3_bit
    

get_3_5bit
*------------------------------------------------------------
* MachineCode: 0001 **** **** **BI T***
* Only next last 3 bits which is stored at D0 => Source Address mode
            CLR     D2
            CLR     D1
            MOVE.B  D6,D2       MOVE the original machine code to D2 to play with
            LSL.B   #2,D2       **** **** BIT* **00
            LSR.B   #5,D2       **** **** 0000 0BIT
            RTS
            *------------------------------------------------------------


*-----------------------FUNCTION word or Long --------------
*----------Used to decipher if we are decoding a word or long
*-  This subroutine determines f the operations is a word or a long, 
*- we use the AND operator to clear out everything except for the 
*-3 bit which will be found in D3, we play with our data in D3
*-the word or LONG can be found in the OPCODE FIELD which is 
*-bits 8 _6

WordOrLong  
        *-find this OPMODE          
        CLR.L   D3
        MOVE.W  D6,D3 ;D6 holds the ORIGINAL CODE
        *-we will store this in D3
        *-using a shortcut the AND operator
        *-we need these bits
        *-[**** XXXX X[XXX] ****]
            *- starts repersenting bits we do not need
            *-shortcut we do not need to shift as much
            *-minor optimization
            *-AND F to keep 0 to throw away
        AND.W   #$0FF0,D3 means turn the zeros into zeros keep the F's
        LSR.W   #6,D3
        *- now weneed to get the last 3 bits
        *-shift to the right by 6 makes the last 3 bits in the 
        *-byte postion
        *-[**** **** XXXX X[XXX]]m we need to clear everything else
        AND.W   #$000F,D3 clear everything except the last byte we need
        LSL.W   #1,D3   shift the remaining bit out [X<-[XXX]]
        *-make sure everyhting is clearn except the last byte
        AND.W   #$000F,D3
        *-Shift back by 1 bit to the right
        LSR.W   #1,D3
        RTS 
        
            
            
            
            
            *---------------------------------------------------------------
            *--------------------------------------------------------
            *-OPCODE SUB ROUTINE INCLUDES ( all decodes are in different files - See files
            *-------------------------------------
            INCLUDE 'op0100.x68'    IN a different file, modulated design        
            INCLUDE 'op0001.x68'    MOVE.b Differetn file
            INCLUDE 'op1101.x68'    ADD,ADDA
            INCLUDE 'op1001.x68'    SUB,SUBA
            INCLUDE 'op0111.x68'    MOVEQ
        
            
           

            
opError                             
            MOVE.L  A0,D3
            MOVE.L  D3,D6
            LEA     bad_code_buffer,A2
            MOVE.L  #2,D7
            JSR     write_data_in_D3_to_buffer
            
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #'D',(A2)+      ;print D
            MOVE.B  #'A',(A2)+      ;print A
            MOVE.B  #'T',(A2)+      ;print T
            MOVE.B  #'A',(A2)+      ;print A
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            MOVE.B  #' ',(A2)+      ;print spaces
            
            
            MOVE.B  #'F',(A2)+      ;print spaces
            MOVE.B  #'F',(A2)+      ;print spaces
            MOVE.B  #'F',(A2)+      ;print spaces
            MOVE.B  #'F',(A2)+      ;print spaces
            
            
            ;MOVE.L  (A0),D3
            ;MOVE.L  D3,D6
            ;MOVE.L  #1,D7
            ;JSR     write_data_in_D3_to_buffer
            
            MOVE.B  #$00,(A2) * add NULL value to print string
            LEA     bad_code_buffer,A1
            MOVE.B  #13,D0
            TRAP    #15   
         
            BRA     get_next_instruction           
printCode   
            MOVE.B  #$00,(A2)   * add NULL value to print string
            MOVEP   (A2),D3
            LEA     good_code_buffer,A1 * load buffer for good code to print
            MOVEQ   #13,D0
            TRAP    #15         * display code
  
            BRA     get_next_instruction                     
* OP Codes -------------------------------------------------
bin0000     EQU     %0000   ;ADDI, ANDI, EORI, BCHG, CMPI
bin0001     EQU     %0001   ;MOVE.B
bin0010     EQU     %0010   ;MOVE.L
bin0011     EQU     %0011   ;MOVE.W
bin0100     EQU     %0100   ;MOVEM, MULS.L, DIVU.L, LEA, CLR, JSR, RTS
bin0101     EQU     %0101   ;SUBQ
bin0110     EQU     %0110   ;Bcc
bin0111     EQU     %0111   ;MOVEQ
bin1000     EQU     %1000   ;DIVU.W
bin1001     EQU     %1001   ;SUB, SUBA
bin1011     EQU     %1011   ;CMP, CMPA, EOR
bin1100     EQU     %1100   ;AND, MULS.W
bin1101     EQU     %1101   ;ADD, ADDA
bin1110     EQU     %1110   ;ASR, ASL, ROL, ROR

*Binary HEX values*---------------------------------------------------------------
hex_0   EQU     %0000 ;0 percent syntax means binary repersentation of this value
hex_1   EQU     %0001 ;1
hex_2   EQU     %0010 ;2    
hex_3   EQU     %0011 ;3
hex_4   EQU     %0100 ;4
hex_5   EQU     %0101 ;5
hex_6   EQU     %0110 ;6
hex_7   EQU     %0111 ;7
hex_8   EQU     %1000 ;8
hex_9   EQU     %1001 ;9
hex_A   EQU     %1010 ;A
hex_B   EQU     %1011 ;B
hex_C   EQU     %1100 ;C
hex_D   EQU     %1101 ;D
hex_E   EQU     %1110 ;E
hex_F   EQU     %1111 ;F      
            
;LOOP:
                *-compare the adress pointers current address with ending address to see if we need to continue
                *- load the address registrer (pointer/ this helps us look at data)
                *-load address register number into data register
                
                ;MOVE.L  a5,d2   ;move the value of a5 to d2(starting/current pointing number)
                ;lea     $00FFFF10,a6    ;load the ending address to d3(we do this so in the future d3 is not just storing something, we can free up d3 to use
                ;MOVE.L  (a6),d3         since we loaded the address of ou engine value into a address register 'basically keeping its pointer instance' we deref it for the value
                ;CMP.L   d2,d3       ;if the current poiinter is the same as 
                ;BEQ     FINISH      ;finish they are equal
                ;RTS

        
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
code0100         MOVE.L     #0,A3
                 CLR        D1
                 LEA        enter_start_AD,A1
                 MOVE.L     #14,D0
                 TRAP       #15
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

FINISH:
        *INCLUDE 'opcode_subroutine.x68'
            MOVE.L  A0,D3
            MOVE.L  D3,D6
            LEA     good_code_buffer,A2
 
            
            MOVE.B  #'F',(A2)+      ;print spaces
            MOVE.B  #'I',(A2)+      ;print spaces
            MOVE.B  #'I',(A2)+      ;print spaces
            MOVE.B  #'N',(A2)+      ;print spaces
            MOVE.B  #'I',(A2)+      ;print D
            MOVE.B  #'S',(A2)+      ;print A
            MOVE.B  #'H',(A2)+      ;print T
            MOVE.B  #'A',(A2)+      ;print A
            MOVE.B  #'A',(A2)+      ;print spaces
            MOVE.B  #'A',(A2)+      ;print spaces
            MOVE.B  #'H',(A2)+      ;print spaces
            MOVE.B  #'A',(A2)+      ;print spaces
            MOVE.B  #'R',(A2)+
            MOVE.L  (A0),D3
            MOVE.L  D3,D6
            MOVE.L  #1,D7

            
            MOVE.B  #$00,(A2) * add NULL value to print string
            LEA     good_code_buffer,A1
            MOVE.B  #13,D0
            TRAP    #15   
            SIMHALT

*-390 -> 406 WITH NOP AT 400


hexToAscii:
ones:
    MOVE.W  D2,D5
    MULU    #8,D5       value adjusted for jumping
    LEA     numTable ,A7 Load the table into A7
    JSR     (A7,D5)     Jump to subroutine of value at D1 
    *-adding res
    ;ADD     D2,D7
    

    RTS













*-Parses input - take input from user to create a memory address
*- entry is parsed to make sure it falls within a valid range
*-good inputs are converteed to hex
*-the entered addres get's stored in d3
*-
*-



parse_input     MOVEQ   #$0,D6  ZERO OUT THE REGISTERY
                MOVEQ   #$0,D5  ZERO OUT THE REGISTERY
                
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
welcome_message DC.B    'Hello and Welcome 68Kkrew"s 68K Disassembler(get the pun)',CR,LF,0


good_code_buffer    DS.B    88

bad_code_buffer     DS.B    30
no_entry    DC.B    'No Entry detected.',0
bad_entry   DC.B    'Bad Entry Dectected.',0
bad_char    DC.B    'Bad Char detected.',0
*-errors
;enter_start_AD  DC.B    'Enter a starting address between $0 and $00FFFE00: ',0
enter_start_AD  DC.B    'Enter a starting address: ',0
userStartAddrInput  DS.B    50  address used to store the data input from user
userEndAddrInput    DS.B    50  address used to stoer the data input from user

userEnd         DC.B    'Enter an address greater than the starting address: ',0

userEndInput    DS.B    50  addresse used to store the data input from user
error_inv_to_many_char  LEA no_entry,A1 load bad entry statment
                        MOVE.L  #1,D0
                        TRAP    #15
                        ;JMP     get_input

*-i dea i could load the string "           DATA            " without the cursor and find a way to load the address at the line

    END    START        ; last line of source





























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
