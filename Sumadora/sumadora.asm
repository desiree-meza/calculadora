 ;---------------------------------------------------------------------
;Practica 6 "Sumdora"
;Hacer la suma de digitos
;La entrada de datos sera por un teclado matricial de 4x4
;Los digitos ah sumar y sus resultados se mostraran
;ya sea por pantalla LCD o display de 7 seg
;---------------------------------------------------------------------
#INCLUDE <p16f877A.inc>
 list p=16f877A            
 __config 3D31
;---------------------------------------------------------------------
;								CONFIGURACION
;---------------------------------------------------------------------
org	0x00

INICIO
 bsf	STATUS, RP0

 movlw	b'11110000'
 movwf	TRISB

 movlw	b'11110000'
 movwf	TRISD

 movlw	0x00
 movwf 	TRISC

 bcf	STATUS, RP0
;----------------------------------------------------------------------
;								INICIO
;----------------------------------------------------------------------
entrada
 call teclado
goto entrada
;----------------------------------------------------------------------
teclado
 bsf	PORTB,0;--------------------------ENERGISANDO ENTRADA RB0
	
	btfsc	PORTB,4
 	call	ON

	btfsc	PORTB,5
    call	UNO

 	btfsc	PORTB,6
	call 	CUATRO

 	btfsc	PORTB,7
 	call	SIETE

 bcf	PORTB,0;--------------------------COLUMNA 1
;===============================================================================
 bsf	PORTB,1;---------------------------ENERGISANDO ENTRADA RB1

	btfsc	PORTB,4
	call	CERO

	btfsc	PORTB,5
	call	DOS
	
	btfsc	PORTB,6 
	call	CINCO

	btfsc	PORTB,7
	call	OCHO

 bcf	PORTB,1;--------------------------COLUMNA 2
;==============================================================================
 bsf	PORTB,2;---------------------------ENERGISANDO ENTRADA RB2

	btfsc	PORTB,4
	call	IGUAL
	
	btfsc	PORTB,5
	call	TRES

 	btfsc	PORTB,6
	call	SEIS

	btfsc	PORTB,7
	call	NUEVE

 bcf	PORTB,2;--------------------------COLUMNA 3
;===============================================================================
 bsf	PORTB,3;----------------------------ENERGISANDO ENTRADA RB3

	btfsc	PORTB,4
	call	SUMA

 	btfsc	PORTB,5
	call	RESTA

 	btfsc	PORTB,6
	call	MULTI

	btfsc	PORTB,7
	call	DIVI

 bcf	PORTB,3;---------------------------COLUMNA 4
return
;-------------------------------------------------------------------------------
;								NUMEROS
;-------------------------------------------------------------------------------
CERO
 movlw 0x00
 movwf 0x35
 movlw 0x30
 call DISPLAY
return 

UNO
 movlw 0x01
 movwf 0x35
 movlw 0x31
 call DISPLAY
return

DOS
 movlw 0x02
 movwf 0x35
 movlw 0x32
 call DISPLAY
return

TRES
 movlw 0x03
 movwf 0x35
 movlw 0x33
 call DISPLAY
return

CUATRO
 movlw 0x04
 movwf 0x35
 movlw 0x34
 call DISPLAY
return

CINCO
 movlw 0x05
 movwf 0x35
 movlw 0x35
 call DISPLAY
return

SEIS
 movlw 0x06
 movwf 0x35
 movlw 0x36
 call DISPLAY
return

SIETE
 movlw 0x07
 movwf 0x35
 movlw 0x37
 call DISPLAY
return

OCHO
 movlw 0x08
 movwf 0x35
 movlw 0x38
 call DISPLAY
return

NUEVE
 movlw 0x09
 movwf 0x35
 movlw 0x39
 call DISPLAY
return
;-------------------------------------------------------------------------------
;									FIN DE NUMEROS
;-------------------------------------------------------------------------------
;										SIGNOS
;-------------------------------------------------------------------------------
;-----------------------------------------SUMA
SUMA
 movf 0x35,w
 movwf 0x36

 movlw 0x00
 movwf 0x37
	
 movlw 0x2B
 call DISPLAY
return
;---------------------------------------RESTA
RESTA
 movf 0x35,w
 movwf 0x36
	
 movlw 0x01
 movwf 0x37
	
 movlw 0x2D
 call DISPLAY
return
;---------------------------------------MULTIPLICAR
MULTI
 movf 0x35,w
 movwf 0x36
	
 movlw 0x02
 movwf 0x37
	
 movlw 0x2A
 call DISPLAY
return
;-----------------------------------------DIVICION
DIVI
 movf 0x35,w
 movwf 0x36
	
 movlw 0x03
 movwf 0x37
	
 movlw 0x2F
 call DISPLAY
return
;-----------------------------------------IGUAL
IGUAL
 movlw	0x3D
 call	DISPLAY
;--------------------------------------------------------------------------------
;										FIN DE LOS SIGNOS
;--------------------------------------------------------------------------------
;										 OPERACIONE SUMA			
;--------------------------------------------------------------------------------
;Programar los comparadores para las operaciones de calculo 
btfss	0x37,1
goto	COMPA1
goto	COMPA2

COMPA1: 
	btfss 0x37,0
	goto COMP1_0
	goto COMP1_1
COMPA2:
	btfss 0x37,0
	goto COMP1_2
	goto COMP1_2_1

;SUMA
COMP1_0: 
 movf	0x36,w
 addwf	0x35,w
 addlw	0x30
 call	DISPLAY
return

;-----------------------------------------FIN DE LA SUMA-------------------------

;										 OPERACIONE MULTIPLICACION			
;--------------------------------------------------------------------------------

;MULTI
COMP1_2:
 movlw 0x00
 LOOP2:
 addwf	0x36,w
 decf	0x35,f
 btfss STATUS,z
 goto LOOP2
 addlw	0x30
 call	DISPLAY
return

 

return
;-----------------------------------------FIN DE LA MULTIPLICACION-------------------------
;--------------------------------------------RESET-------------------------------
ON
 movlw	0x01
 call	LCD

 clrf	0x35
 clrf	0x36
 clrf	0x37
return
;--------------------------------------------FIN DEL RESET----------------------
;--------------------------------------------CONFIGUARACION DEL LCD
DISPLAY
	bsf	PORTD,0
	bcf	PORTD,1
	bsf	PORTD,2

	call	LCD

	movlw	0x38
 	call	LCD

	movlw	0x0E
	call	LCD

 	bsf	PORTD,0
	return

LCD	
	CALL 	BIT8_CDU;ESTIMA CEN,DEC,UNI
	movf	PORTC,W
	movwf	DEC
	movf	PORTC,W
	movwf	UNI
	
	
	bcf	PORTD,2
	call	DELAY
	
	bsf	PORTD,2
	call	DELAY
	
  	bcf	PORTD,0
	return

DELAY
	movlw	D'13'
	movwf	0x38
	movlw	D'251'
	movwf	0x39
	LOOP	decfsz	0x39
			goto	LOOP	
			decfsz	0x38
			goto	LOOP
	return
	return
return
;--------------------------------------------FIN DE LA CONFIGURACION DEL LCD

;=====================================================FIN DEL CODIGO
INCLUDE DCU.INC
end