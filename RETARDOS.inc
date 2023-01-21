
;-------------------------------------------------------------------------------------
; @file:		Implementacion de retardos.inc
; @brief:		Librería de códigos de retardos para implementación.
;			La frecuencia del oscilador es de 4 MHZ, entonces 1Tcy = 1us
; @date:		08/01/2023
; @author:		Salirrosas Seminario Shirley Jasmin
; @Version and program:	MPLAB X IDE v6.00
;-------------------------------------------------------------------------------------
    
PSECT udata_acs
    contador1: DS 1	    ;reserva 1 byte en acces ram
    contador2: DS 1	    ;reserva 1 byte en acces ram
    
PSECT code
;(6+4k)us
    Delay_10us:				  ;2Tcy
	MOVLW 1				  ;1Tcy
	MOVWF contador1,0		  ;1Tcy
    Ext_loop1:		    
	 Nop				  ;k tcy
	 DECFSZ contador1,1,0		  ;(k-1) +3 Tcy
	 GOTO   Ext_loop1		  ;(k-1)*2 Tcy
	 RETURN				  ;2Tcy
;(3k+7)us
    Delay_25us:				  ;2Tcy
     MOVLW 6				  ;1Tcy
     MOVWF contador1,0			  ;1Tcy
     NOP				  ;1Tcy
     Ext_loop2:
	 DECFSZ contador1,1,0		  ;(k-1) +3 Tcy
	 GOTO   Ext_loop2		  ;(k-1)*2 Tcy
	 RETURN				  ;2Tcy
;(6+4k)us
    Delay_50us:				  ;2Tcy
     MOVLW 11				  ;1Tcy
     MOVWF contador1,0			  ;1Tcy
    Ext_loop3:
         Nop				  ;k tcy
	 DECFSZ contador1,1,0		  ;(k-1) +3 Tcy
	 GOTO   Ext_loop3		  ;(k-1)*2 Tcy
	 RETURN				  ;2Tcy
;(3k+7)us
    Delay_100us:			  ;2Tcy
     MOVLW 31				  ;1Tcy
     MOVWF contador1,0			  ;1Tcy
     NOP				  ;1Tcy
    Ext_loop4:
	 DECFSZ contador1,1,0		  ;(k-1) +3 Tcy
	 GOTO   Ext_loop4		  ;(k-1)*2 Tcy
	 RETURN				  ;2Tcy
;(8+4k)
    Delay_200us:			  ;2Tcy
     MOVLW 64				  ;1Tcy
     MOVWF contador1,0			  ;1Tcy
     NOP				  ;1Tcy
     NOP				  ;1Tcy
    Ext_loop5:
     DECFSZ contador1,1,0		  ;(k-1) +3 Tcy
     GOTO   Ext_loop5			  ;(k-1)*2 Tcy
     RETURN				  ;2Tcy
;(3k+7)us
    Delay_250us:			  ;2Tcy
     MOVLW 81				  ;1Tcy
     MOVWF contador1,0			  ;1Tcy
     NOP				  ;1Tcy
    Ext_loop6:
     DECFSZ contador1,1,0		  ;(k-1) +3 Tcy
     GOTO   Ext_loop6			  ;(k-1)*2 Tcy	  
     RETURN				  ;2Tcy
;(3k+8)us
    Delay_500us:			  ;2Tcy
     MOVLW 164				  ;1Tcy
     MOVWF contador1,0			  ;1Tcy
     NOP				  ;1Tcy
     NOP				  ;1Tcy
    Ext_loop7:
     DECFSZ contador1,1,0		  ;(k-1) +3 Tcy
     GOTO   Ext_loop7			  ;(k-1)*2Tcy	  
     RETURN				  ;2Tcy
;1 ms
    Delay_1ms:				  ;2Tcy
     MOVLW 1				  ;1Tcy
     MOVWF contador2,0			  ;1Tcy
    Loop_8:			    
     MOVLW   249			  ;k Tcy
     MOVWF   contador1,0	          ;k Tcy
    INT_LOOP:			    
     Nop			          ;249k Tcy
     DECFSZ  contador1,1,0	          ;251k Tcy 
     Goto    INT_LOOP		          ;494k Tcy
     DECFSZ  contador2,1,0	          ;(k-1)+3Tcy
     GOTO    Loop_8		          ;(k-1)*2Tcy
     RETURN				  ;2 Tcy
;5 ms
    Delay_5ms:				  ;2Tcy
     MOVLW 5				  ;1Tcy
     MOVWF contador2,0			  ;1Tcy
    Loop_9:			     
     MOVLW   249			  ;k Tcy
     MOVWF   contador1,0	          ;k Tcy
    INT_LOOP1:			    
     Nop			          ;249k Tcy
     DECFSZ  contador1,1,0	          ;251k Tcy 
     Goto    INT_LOOP1		          ;494k Tcy
     DECFSZ  contador2,1,0		  ;(k-1)+3 Tcy
     GOTO    Loop_9			  ;(k-1)*2 Tcy
     RETURN			          ;2 Tcy
;10 ms
    Delay_10ms:				  ;2tcy
     MOVLW 10			          ;1Tcy
     MOVWF contador2,0		          ;1Tcy
    Loop_10:			     
     MOVLW   249		          ;k Tcy
     MOVWF   contador1,0	          ;k Tcy
    INT_Loop10:			    
     Nop			          ;249k Tcy
     DECFSZ  contador1,1,0	          ;251k Tcy 
     Goto    INT_Loop10		          ;494k Tcy
     DECFSZ  contador2,1,0		  ;(k-1)+3 Tcy
     GOTO    Loop_10			  ;(k-1)*2 Tcy
     RETURN			          ;2 Tcy
;25 ms
    Delay_25ms:				  ;2Tcy
     MOVLW 25			          ;1Tcy
     MOVWF contador2,0		          ;1Tcy
    Loop_11:			    
     MOVLW   249		          ;k Tcy
     MOVWF   contador1,0	          ;k Tcy
    INT_Loop11:			    
     Nop			          ;249k Tcy
     DECFSZ  contador1,1,0	          ;251k Tcy 
     Goto    INT_Loop11		          ;494k Tcy
     DECFSZ  contador2,1,0		  ;(k-1)+3 Tcy
     GOTO    Loop_11			  ;(k-1)*2 Tcy
     RETURN			          ;2 Tcy
;50 ms
    Delay_50ms:				  ;2Tcy
     MOVLW 50				  ;1Tcy
     MOVWF contador2,0		          ;1Tcy
    Loop_12:			    
     MOVLW   249		          ;k Tcy
     MOVWF   contador1,0	          ;k Tcy
    INT_Loop12:			    
     Nop			          ;249k Tcy
     DECFSZ  contador1,1,0	          ;251k Tcy
     Goto    INT_Loop12		          ;494k Tcy
     DECFSZ  contador2,1,0		  ;(k-1)+3 Tcy
     GOTO    Loop_12			  ;(k-1)*2 Tcy
     RETURN			          ;2 Tcy
;100 ms
    Delay_100ms:		          ;2Tcy
     MOVLW 100				  ;1Tcy
     MOVWF contador2,0			  ;1Tcy
    Loop_13:			     
     MOVLW   249		          ;1 Tcy
     MOVWF   contador1,0	          ;1 Tcy
    INT_Loop13:			    
     Nop			          ;249k Tcy
     DECFSZ  contador1,1,0	          ;251k Tcy
     Goto    INT_Loop13		          ;494k Tcy
     DECFSZ  contador2,1,0		  ;(k-1)+ Tcy
     GOTO    Loop_13			  ;(k-1)*2 Tcy
     RETURN			          ;2 Tcy
;200 ms
    Delay_200ms:               	          ;2Tcy
     MOVLW 250				  ;1Tcy
     MOVWF contador2,0		          ;1Tcy
    Loop_14:			     
     MOVLW   249		          ;k Tcy
     MOVWF   contador1,0	          ;k Tcy
    INT_Loop14:			    
     Nop			          ;249k Tcy
     DECFSZ  contador1,1,0	          ;251k Tcy 
     Goto    INT_Loop14		          ;494k Tcy
     DECFSZ  contador2,1,0		  ;(k-1)+3 Tcy
     GOTO    Loop_14			  ;(k-1)*2 Tcy
     RETURN			          ;2 Tcy
;250 ms
    Delay_250ms:		          ;2Tcy
     MOVLW 250			          ;1Tcy
     MOVWF contador2,0		          ;1Tcy
    Loop_15:			     
     MOVLW   249		          ;k Tcy
     MOVWF   contador1,0	          ;k Tcy
    INT_Loop15:			    
     Nop			          ;249k Tcy
     DECFSZ  contador1,1,0	          ;251k Tcy 
     Goto    INT_Loop15		          ;496k Tcy
     DECFSZ  contador2,1,0		  ;(k-1)+3 Tcy
     GOTO    Loop_15			  ;(k-1)*2 Tcy
     RETURN			          ;2Tcy
     


