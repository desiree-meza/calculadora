;--------------------
;practica #
;--------------------
 #include <p16f877.inc>
 list p=16f877
 __config 3D31
 op		EQU	0x20 
	val1		EQU	0x21
	val2		EQU	0x22	
	digito	EQU	0x23	
	suma	EQU	0x24
	temporal	EQU	0x25
	resultado	EQU	0x26
	operacion	EQU	0x27
	menosuno	EQU	0x28

 org 0x00
 CONFIGURACION
 ;limpia de puertos
 ; PORTB teclado
 clrf	 PORTC 
 clrf	op
 clrf	val1
 clrf	val2
 clrf	digito
 clrf	suma	
 clrf	temporal
 clrf  operacion
 clrf	resultado

 ;cambio de bancos
  ;cambio al banco 1
 bcf STATUS,RP1
 bsf STATUS,RP0
  
  ;activamos los puertos
 movlw	b'11110000'
 movwf	TRISB
 movlw	b'00000000'
 movwf	TRISC
 movwf	TRISD
 clrw

  ;cambio al banco 0
 bcf STATUS,RP1
 bcf STATUS,RP0
  
;------------------------------
;-----inicio-----
;------------------------------
 movlw	b'00111111' ;cero
 movwf	PORTD ;damos como valor inicial 0

 
CICLO
 ;revisando actividad de las filas/renglones
ACTIVIDADRENGLONA
 bsf	PORTB,0
 bcf 	PORTB,1
 bcf	PORTB,2
 bcf	PORTB,3
 btfsc 	PORTB,4 ;columna 1
 goto	SIETE
 btfsc 	PORTB,5 ;columna 2
 goto	OCHO
 btfsc	PORTB,6 ;colmna 3
 goto	NUEVE
 btfsc	PORTB,7 ;columna 4
 goto	DIV

;actividad renglon2
 bcf	PORTB,0
 bsf 	PORTB,1
 bcf	PORTB,2
 bcf	PORTB,3
 btfsc 	PORTB,4
 goto	CUATRO
 btfsc 	PORTB,5
 goto	CINCO
 btfsc	PORTB,6
 goto	SEIS
 btfsc	PORTB,7
 goto	POR

;activiada renglon3
 bcf	PORTB,0
 bcf 	PORTB,1
 bsf	PORTB,2
 bcf	PORTB,3
 btfsc 	PORTB,4
 goto	UNO
 btfsc 	PORTB,5
 goto	DOS
 btfsc	PORTB,6
 goto	TRES
 btfsc	PORTB,7
 goto	MENOS

;actividad ultimo renglon
 bcf	PORTB,0
 bcf 	PORTB,1
 bcf	PORTB,2
 bsf	PORTB,3
 btfsc 	PORTB,4
 goto	CLR
 btfsc 	PORTB,5
 goto	CERO
 btfsc	PORTB,6
 goto	IGUAL
 btfsc	PORTB,7
 goto	MAS
 goto 	CICLO
;numeros-----------------------------------------

UNO
		btfsc	PORTB,4
		goto $-1
		movlw	b'00000110'
		movwf	PORTD
		movlw	b'00000001'
	goto CICLO

	
DOS
		btfsc	PORTB,5
		goto $-1
		movlw	b'01011011' ;
		movwf	PORTD
		movlw	b'00000010'
	goto CICLO

TRES
		btfsc	PORTB,6
		goto $-1
		movlw	b'01001111'
		movwf	PORTD
		movlw	b'00000011'
	goto CICLO	
	
CUATRO
		btfsc	PORTB,4
		goto $-1
		movlw	b'01100110'
		movwf	PORTD
  movlw	b'00000100'
	goto CICLO
CINCO
		btfsc	PORTB,5
		goto $-1
		movlw	b'01101101'
		movwf	PORTD
		movlw	b'00000101'
	goto CICLO
SEIS
		btfsc	PORTB,6
		goto $-1
		movlw	b'01111101'
		movwf	PORTD
		movlw	b'00000110'
	goto CICLO
SIETE
	btfsc	PORTB,4
		goto $-1
		movlw	b'01000111'
		movwf	PORTD
		movlw	b'00000111'
		goto	CICLO
OCHO
		btfsc	PORTB,5
		goto $-1
		movlw	b'01111111'
		movwf	PORTD
		movlw	b'00001000'
	goto CICLO
NUEVE
		btfsc	PORTB,6
		goto $-1
		movlw	b'01101111'
		movwf	PORTD
		movlw	b'00001001'
	goto CICLO
CERO
		btfsc	PORTB,5
		movlw	b'00111111'
		movwf	PORTD
	goto	CICLO

DIV
		btfsc	PORTB,7
		goto $-1
		movlw	b'01110010'
		movwf	PORTC
	goto CICLO
POR	
		btfsc	PORTB,7
		goto $-1
		movlw	d'1'
		movwf	operacion
		movlw	b'01110110'
		movwf	PORTC
		addwf	val1,1
	goto CICLO
MENOS
		btfsc	PORTB,7
		goto $-1
		movlw	b'01000000'
		movwf	PORTC
	goto CICLO
MAS
		btfsc	PORTB,7
		goto $-1
		addwf	val1,1
		movlw	d'0'
		movwf	operacion
 		movlw  	b'01000110'
 		movwf  	PORTC
	goto CICLO

IGUAL
		btfsc	PORTB,6
		goto $-1
    		clrf PORTC
call NUMEROS
		movwf	val2
		movwf	resultado
		btfss		operacion,0
		goto 		SUMA1
		goto		MULTI
	goto 		CICLO

MULTI
		clrw
		clrf		menosuno
		movlw	d'1'
		movwf	menosuno
		clrw
		movf		val2,w
		call        NUMEROS
		addwf	resultado,1	; W + resultado = resultado
		clrw
		movlw	d'1'			; W = 1
		subwf	val1,1		; Val1 - 1 = ... -> 0
		clrw
		movf		val1,w		; Val1 = W
		addwf	menosuno,0
		subwf	menosuno,0
		btfss		STATUS,Z
		goto		MULTI
		clrw
		movf		resultado,w

		goto		MOSTRAR

SUMA1
		addwf	val1,0
		goto		MOSTRAR

CLR
	clrf	PORTC
	clrf	PORTD
	clrf	val1
	clrf	val2
	clrf	suma
	clrf	temporal	
	clrf	resultado
	clrf	digito
	clrf	operacion
	clrw	
	goto CICLO

MOSTRAR_UNO
 	movf		suma,w
	call		NUMEROS
	movwf	PORTD	
	goto		CICLO

MOSTRAR
	movwf	suma
	movlw	d'10'
	subwf	suma,w
	movwf	resultado
	btfss		STATUS,C
 	goto		MOSTRAR_UNO
	btfsc		STATUS,Z
	goto		OPDIEZ
	
	movlw		b'00000110'
  	movwf		PORTC
	movf			resultado,0
	call			NUMEROS
	movwf		PORTD
	goto			CICLO

OPDIEZ
	movlw		b'00000110'
	movwf		PORTC
	movlw		b'00111111'
 	movwf		PORTD
	goto			CICLO


NUMEROS
 addwf	PCL	,f
 retlw	b'00111111' ;0 
 retlw	b'00000110' ;1
 retlw	b'01011011' ;2
 retlw 	b'01001111' ;3
 retlw	b'01100110' ;4
 retlw	b'01101101' ;5
 retlw	b'01111101' ;6
 retlw	b'00000111' ;7
 retlw	b'01111111' ;8
 retlw	b'01101111' ;9 --> 01001
 retlw	b'00111111' ;0
 return

end