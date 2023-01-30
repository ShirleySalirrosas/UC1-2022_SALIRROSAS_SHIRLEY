;_______________________________________________________________________________
; @AUTORA:  Salirrosas  Seminario  Shirley  Jasmin
; @FILE:    SEGUIR_SECUENCIA.S
; @BRIEF:   Codigo con el botón de placa y ejecute una secuencia
; @FECHA:   30/01/2023
; @VERSION Y PROGRAMA: MPLAB  X  IDE  v6.00
; @GRUPO:   05
;------------------------------------------------- -----------------------------
    
PROCESSOR 18F57Q84
#include "bitconfiguracion.inc"   // config statements should precede project 
				 ;file includes*/. ;nivel local / nivel proyecto
#include <xc.inc> 
    
PSECT udata_acs
contador1:   DS 1    ;reserva 1byte en memoria
contador2:   DS 1    ;reserva 1byte en memoria
offset:	     DS 1    ;reserva 1byte en memoria
counter:     DS 1    ;reserva 1byte en memoria
counter_1:   DS 1    ;reserva 1byte en memoria
recomenzar:   DS 1   ;reserva 1byte en memoria
    
PSECT ISRVectLowPriority,class=CODE,reloc=2
ISRVectLowPriority:
    BTFSS   PIR1,0,0	; ¿Se ha producido la INT0?
    GOTO    salida
    BCF	    PIR1,0,0	; limpiamos el flag de INT0
    GOTO    COMIENZO
salida:
    RETFIE
    
PSECT ISRVectHighPriority,class=CODE,reloc=2
ISRVectHighPriority:
    BTFSC   PIR10,0,0	; ¿Se ha producido la INT2?
    GOTO    retomar   
    BTFSC   PIR6,0,0	; ¿Se ha producido la INT1?
    GOTO    Detener
salida1:   
    RETFIE
                 
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main    
         
PSECT CODE   
Main:
    CALL    Config_Osc,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_Interrupciones,1
    GOTO    Toggle    

Toggle:
    BANKSEL LATF
    BTG	    LATF,3,1	;Led on    
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTG	    LATF,3,1	;Led off
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    GOTO    Toggle

COMIENZO:
    MOVLW   5
    MOVWF   counter_1,0	;carga el contador con el numero de repeticiones
    MOVLW   0
    MOVWF   recomenzar,0 ;cargar el valor para reiniciar los leds
    GOTO    reload
       
; Pasos para implementar Computed_GOTO 
;   1.Escribir el byte superior en PCLATU
;   2.Escribir el byte alto en PCLATH
;   3.Escribir el byte bajo en PCL
; NOTA:El offset debe ser multiplicado por "2" para el alineamiento en memoria.
    
Loop:  
    BANKSEL PCLATU
    MOVLW   low highword(TABLE)
    MOVWF   PCLATU,1
    MOVLW   high(TABLE)
    MOVWF   PCLATH,1
    RLNCF   offset,0,0
    CALL    TABLE
    MOVWF   LATC,0
    CALL    Delay_250ms
    DECFSZ  counter,1,0
    GOTO    Next_seq
    GOTO    verificar
    
Next_seq:
    INCF    offset,1,0
    BTFSS   recomenzar,1,0	;¿El bit uno de recomenzar es uno?
    GOTO    Loop
    GOTO    salida
    
reload:    
    MOVLW   10
    MOVWF   counter,0	;carga el contador con el numero de offset
    MOVLW   0
    MOVWF   offset,0	;definimos el valor del offset inicial
    GOTO    Loop
    
verificar:
    DECFSZ  counter_1,1,0   ;¿llego a 0 el contador de repeticiones?
    GOTO    reload
    GOTO    salida     
   
Detener:
    BCF	    PIR6,0,0	    ; limpiamos el flag de INT1
    SETF    recomenzar,0    ;valor de 1 --> recomenzar
    GOTO    salida1   
     
retomar:
    BCF	    PIR10,0,0	    ; limpiamos el flag de INT2
    SETF    recomenzar,0    ;valor de 1 --> recomenzar
    SETF    LATC,0
    GOTO    salida1     
 
Config_Osc:  
    BANKSEL OSCCON1
    MOVLW   0x60	;selecccionamos el bloque del oscilador interno 
			;con un div:1
    MOVWF   OSCCON1,1
    MOVLW   0x02	;seleccionamos una frecuencia de 4MHz
    MOVWF   OSCFRQ,1
    RETURN
    
Config_Port:
  ;Configuracion del led
    BANKSEL PORTF   
    CLRF    PORTF,1	;PORTF = 0
    CLRF    ANSELF,1	;ANSELF = 0 -- Digital
    BSF     LATF,3,1	;LATF = 0 -- Leds apagado
    BCF     TRISF,3,1	;TRISF = 1 --> salida

  ;Config User Button --> INT0(A3)
    BANKSEL PORTA
    CLRF    PORTA,1	;PORTA = 0
    BCF     ANSELA,3,1	;ANSELA = 0 -- Digital
    BSF	    TRISA,3,1	;TRISA = 1 --> entrada
    BSF	    WPUA,3,1	;Activo la reistencia Pull-Up
    
  ;Config Ext Button1
    BANKSEL PORTB
    CLRF    PORTB,1	;PORTB = 0
    BCF	    ANSELB,4,1	;ANSELB = 0 -- Digital
    BSF     TRISB,4,1	;TRISB = 1 --> entrada
    BSF	    WPUB,4,1	;Activo la reistencia Pull-Up
    
  ;Config Ext Button2
    BANKSEL PORTF
    CLRF    PORTF,1	;PORTF = 0	
    BCF	    ANSELF,2,1	;ANSELF = 0 -- Digital
    BSF	    TRISF,2,1	;TRISF = 1 --> entrada
    BSF	    WPUF,2,1	;Activo la reistencia Pull-Up
    
  ;Configuracion de PORTC
    BANKSEL PORTC   
    SETF    PORTC,1	;PORTC = 0
    SETF    LATC,1	;LATC = 0 -- Leds apagado
    CLRF    ANSELC,1	;ANSELC = 0 -- Digital
    CLRF    TRISC,1
    RETURN  
   
Config_PPS:
  ;INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	;INT0 --> RA3
  ;INT1
    BANKSEL INT1PPS
    MOVLW   0x0C
    MOVWF   INT1PPS,1	;INT1 --> RB4
  ;INT2
    BANKSEL INT2PPS
    MOVLW   0x2A
    MOVWF   INT2PPS,1	;INT2 --> RF2
    RETURN
    
; SECUENCIA PARA CONFIGURAR INTERRUPCION 
;   1.Definir prioridades
;   2.Configurar interrupcion
;   3.Limpiar el flag
;   4.Habilitar la interrupcion
;   5.Habilitar las interrupciones globales
    
Config_Interrupciones:
  ;CONFIGURACION DE PRIORIDADES
    BSF	INTCON0,5,0 ; INTCON0<IPEN> = 1 --Habilitar prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1    ; IPR1<INT0IP> = 0 -- INT0 de baja prioridad
    BSF	IPR6,0,1    ; IPR6<INT1IP> = 1 -- INT1 de alta prioridad
    BSF	IPR10,0,1   ; IPR10<INT2IP> = 1 -- INT2 de alta prioridad
    
  ;Config INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext
   
  ;Config INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT1IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT1IE> = 1 -- habilitamos la interrupcion ext1
    
  ;Config INT2
    BCF	INTCON0,2,0 ; INTCON0<INT2EDG> = 0 -- INT2 por flanco de bajada
    BCF	PIR10,0,0    ; PIR10<INT2IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE10<INT2IE> = 1 -- habilitamos la interrupcion ext1
    
  ;HABILITACION DE INTERRUPCIONES
    BSF INTCON0,7,0      ;INTCON0<GIE/GIEH>=1-habilitamos las interrupciones de 
			 ;forma global
    BSF INTCON0,6,0	 ;INTCON0<GIEL>=1-habilitamos las interrupciones de 
			 ;baja prioridad
    RETURN
        
TABLE:
    ADDWF   PCL,1,0
    RETLW   01111110B	; offset: 0
    RETLW   10111101B	; offset: 1
    RETLW   11011011B	; offset: 2
    RETLW   11100111B	; offset: 3
    RETLW   11111111B	; offset: 4
    RETLW   11100111B	; offset: 5
    RETLW   11011011B	; offset: 6
    RETLW   10111101B	; offset: 7
    RETLW   01111110B	; offset: 8
    RETLW   11111111B	; offset: 9 
        
    
; --------------- retardos ---------------
Delay_250ms:		    ;2Tcy --- CALL
    MOVLW   250		    ;1Tcy -- k1
    MOVWF   contador2,0	    ;1Tcy
; T = (6 + 4k)us	    1Tcy = 1us
Ext_Loop:		    ;2Tcy --- CALL
    MOVLW   249		    ;1Tcy -- k
    MOVWF   contador1,0	    ;1Tcy
Int_Loop:
    NOP			    ;k*Tcy
    DECFSZ  contador1,1,0   ;(k-1) + 3Tcy
    GOTO    Int_Loop	    ;(k-1)*2Tcy
    DECFSZ  contador2,1,0
    GOTO    Ext_Loop	    
    RETURN		    ;2Tcy
    
END resetVect