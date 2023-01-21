;------------------------------------------------- ------------------------------------
; @file:    P2-Display_7SEG
; @brief:   muestra los valores alfanuméricos(0-9 y A-F) en un display de 7 segmentos ánodo común
; @fecha:   14/01/2023
; @autora:  Salirrosas  Seminario  Shirley  Jasmin
; @Versión  y  programa: MPLAB  X  IDE  v6.00
;------------------------------------------------- ------------------------------------
    PROCESSOR 18F57Q84
    
#include "bitsconfig.inc"  ;/config statements should precede project file includes.
#include "retardos.inc"
#include <xc.inc>

PSECT resetVect,class=CODE, reloc=2
resetVect:
    goto Main
PSECT CODE
Main:
    CALL    Config_OSC
    CALL    Config_Port
    NOP
    
Condiciondeboton:
    BTFSC PORTA,3,0		;Salta si es cero
    GOTO  Numeros
    ;se va a Numeros
Consonantes:
    ;x000 1000
    Letra_A:
	CLRF	PORTD,0		;todos los puertos los pasa a 0
	BSF	PORTD,3,0	;se configura las salidas para que el display A
        CALL	Delay_1s	;hace un retardo -> 1segundo
	BTFSC	PORTA,3,0	;Salta si es cero
	GOTO	Numeros		;Va a la etiqueta numeros 
    ;x000 0011
    Letra_B:
	CLRF	PORTD,0		
	BSF	PORTD,0,0	;se configura las salidas para que el display B
	BSF	PORTD,1,0
	CALL	Delay_1s	
	BTFSC	PORTA,3,0	
	GOTO	Numeros		
	
    ;x100 0110
    Letra_C:
	CLRF	PORTD,0
	BSF	PORTD,1,0	;se configura las salidas para que el display C
	BSF	PORTD,2,0
	BSF	PORTD,6,0
	CALL	Delay_1s
	BTFSC	PORTA,3,0
	GOTO	Numeros
    ;x100 0000
    Letra_D:
	CLRF	PORTD,0
	BSF	PORTD,0,0	;se configura las salidas para que el display D
	BSF	PORTD,5,0
	CALL	Delay_1s
	BTFSC	PORTA,3,0
	GOTO	Numeros
    ;x000 0110
    Letra_E:
	CLRF	PORTD,0
	BSF	PORTD,1,0	;se configura las salidas para que el display E
	BSF	PORTD,2,0
	CALL	Delay_1s
	BTFSC	PORTA,3,0
	GOTO	Numeros
    ;x000 1110
    Letra_F:
	CLRF	PORTD,0
	BSF	PORTD,1,0	;se configura las salidas para que el display F
	BSF	PORTD,2,0
	BSF	PORTD,3,0
	CALL	Delay_1s
	BTFSC	PORTA,3,0
	GOTO	Numeros
        GOTO	Consonantes	    ;Se va a la etiqueta consonantes
	  
Numeros:
    
    ;x100 0000
    Numero0:
	CLRF	PORTD,0	    ;Mandar a 0 todo el puerto d
	BSF	PORTD,6,0   ;se configura las salidas del display 0
	CALL	Delay_1s	    ;Hacemos un retardo de 1seg
	BTFSS	PORTA,3,0   ;Salta si es 1--> sin presionar 
	GOTO	Consonantes	    ;Salta a la etiqueta consonantes
    ;x000 0110
    Numero1:
	SETF	PORTD,0	    
	BCF	PORTD,1,0   ;se configura las salidas del display 0
	BCF	PORTD,2,0
	CALL	Delay_1s	    
	BTFSS	PORTA,3,0   
	GOTO	Consonantes	    
	
    ;x010 0100
    Numero2:
	CLRF	PORTD,0
	BSF	PORTD,2,0
	BSF	PORTD,5,0
	CALL	Delay_1s
	BTFSS	PORTA,3,0
	GOTO	Consonantes
    ;x0110 0000
    Numero3:
	CLRF	PORTD,0
	BSF	PORTD,4,0
	BSF	PORTD,5,0
	CALL	Delay_1s
	BTFSS	PORTA,3,0
	GOTO	Consonantes
    ;x001 1001
    Numero4:
	CLRF	PORTD,0
	BSF	PORTD,0,0
	BSF	PORTD,3,0
	BSF	PORTD,4,0
	CALL	Delay_1s
	BTFSS	PORTA,3,0
	GOTO	Consonantes
    ;x000 10010
    Numero5:
	CLRF	PORTD,0
	BSF	PORTD,1,0
	BSF	PORTD,4,0
	CALL	Delay_1s
	BTFSS	PORTA,3,0
	GOTO	Consonantes
    ;x000 0010
    Numero6:
	CLRF	PORTD,0
	BSF	PORTD,1,0
	CALL	Delay_1s
	BTFSS	PORTA,3,0
	GOTO	Consonantes
    ;x000 0111
    Numero7:
	SETF	PORTD,0
	BCF	PORTD,0,0
	BCF	PORTD,1,0
	BCF	PORTD,2,0
	CALL	Delay_1s
	BTFSS	PORTA,3,0
	GOTO	Consonantes
    ;x000 0000
    Numero8:
	CLRF	PORTD,0
	CALL	Delay_1s
	BTFSS	PORTA,3,0
	GOTO	Consonantes
    ;x001 1000
    Numero9:
	CLRF	PORTD,0
	BSF	PORTD,3,0
	BSF	PORTD,4,0
	CALL	Delay_1s
	BTFSS	PORTA,3,0
	GOTO	Consonantes	    ;Salta a la etiqueta Consonantes
	GOTO	Numeros	    ;Salta a la etiqueta Numeros
	  
Config_OSC:
    ;configuración del Oscilador interno a una frecuencia de 4Mhz
    BANKSEL OSCCON1
    MOVLW 0x60	;seleccionamos el bloque del oscilador interno con un div:1
    MOVWF OSCCON1
    MOVLW 0X02	;seleccionamos a una frecuencia de 4Mhz
    MOVWF OSCFRQ
    RETURN
 
Config_Port:	;PORT-LAT-ANSEL-TRIS LED:RF3,  BUTTON:RA3
    ;Config Button
    BANKSEL LATA
    CLRF    LATA,1	;PORTA<7,0> = 0
    CLRF    ANSELA,1	;PORTA DIGITAL
    BSF	    TRISA,3,1	;RA3 COMO ENTRADA
    BSF	    WPUA,3,1	;ACTIVAMOS LA RESISTENCIA PULLUP DEL PIN RA3
    ;Config Port D
    BANKSEL PORTD
    SETF    PORTD,1	;PORTE<7,0> = 1
    CLRF    ANSELD,1	;PORTE DIGITAL
    CLRF    TRISD,1	;PORTE COMO SALIDA
    RETURN

END resetVect