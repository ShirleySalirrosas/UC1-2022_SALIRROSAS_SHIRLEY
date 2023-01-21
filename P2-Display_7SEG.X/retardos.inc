;-------------------------------------------------------------------------------------
; @file:		Implementacion de retardo.inc
; @brief:		Librería de retardo de 1 segundo
;			La frecuencia del oscilador es de 4 MHZ, entonces 1Tcy = 1us
; @date:		15/01/2023
; @author:		Salirrosas Seminario Shirley Jasmin
; @Version and program:	MPLAB X IDE v6.00
;-------------------------------------------------------------------------------------
    
PSECT udata_acs
    contador1: DS 1	    ;reserva 1 byte en acces ram
    contador2: DS 1	    ;reserva 1 byte en acces ram
    contador3: DS 1	    ;reserva 1 byte en acces ram 
PSECT code

Delay_1s:
    MOVLW 4
    MOVWF contador3,0
    Loop_250ms:			  ;2tcy
    MOVLW 250				  ;1tcy
    MOVWF contador2,0			  ;1tcy
    Loop_1s:			     
    MOVLW   249				  ;k Tcy
    MOVWF   contador1,0			  ;k tcy
    INT_LOOP9:			    
    Nop					  ;249k TCY
    DECFSZ  contador1,1,0		  ;251k TCY 
    Goto    INT_LOOP9			  ;496k TCY
    DECFSZ  contador2,1,0		  ;(k-1)+3tcy
    GOTO    Loop_1s			  ;(k-1)*2tcy
    DECFSZ  contador3,1,0
    GOTO Loop_250ms
    RETURN			           ;2 TCY
