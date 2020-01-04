;************************************************
;LEKCJA   7	- KLAWIATURA PRZEGL§DANA SEKWENCYJNIE
;PRZYKùAD 4	- ODCZYT KLAWIATURY
;************************************************
include dsm51.inc

SEG_ON bit	P1.6	;wà•czenie wyòwietlacza 7-segm.
LED	bit	P1.7
KEY	bit	P3.5	;odczyt klawiatury

;Pami©Ü wewn©trzna RAM
DISPLAY		EQU	30H
KEY_LAST	EQU	DISPLAY+6

	LJMP	START
	ORG	100H
START:

	CLR	A
	MOV	DISPLAY,A		;wpisz 0 do pami©ci
	MOV	DISPLAY+1,A		;danych wszystkich
	MOV	DISPLAY+2,A		;wska´nik¢w
	MOV	DISPLAY+3,A
	MOV	DISPLAY+4,A
	MOV	DISPLAY+5,A
	MOV	DISPLAY+6,A

LOOP_DISP:			;ustaw dane do wyòw.
				;na wska´niku 1
	MOV	R0,#DISPLAY	;adres pobierania kod¢w
	MOV	R2,#7		;licznik - liczba wska´.
	MOV	R3,#00000001B ;wyb¢r wska´nika
				  ;- kod 1 z 8

LOOP:
	SETB	SEG_ON		;wyà•cz poprzedni
				;wska´nik
	MOV	R1,#CSDS	;adres wyboru wska´nika
	MOV	A,R3		;nr wska´nika (1z8)
	MOVX	@R1,A		;wpisz wybrany wska´nik

	MOV	R1,#CSDB	;adres danych wska´nika
	MOV	A,@R0		;dane wska´nika
	CJNE	R3,#01000000B,SEG	;czy 7 wska´nik
	SJMP	LEDS		;tak-diody òwiec•ce
				;nie ma zamiany na kod
SEG:
	LCALL	GET_COD7	;zamiana cyfry na kod
LEDS:
	MOVX	@R1,A		;wpisanie kodu zapalanych
				;segment¢w do buforu
				;danych wska´nika
	CLR	SEG_ON		;wà•czenie wska´nika

	MOV	C,KEY		;wst©pny odczyt klawisza
	MOV	A,#1		;odczekanie 1ms-òwiecenie
	LCALL	DELAY_MS	;jednego wska´nika

	JC	KEY_ON		;kontrola jednoznacznoòci
	JB	KEY,KEY_END	;odczytu klawisza

KEY_OFF:
	MOV	A,R3		;klawisz zwolniony
	CPL	A
	ANL	KEY_LAST,A	;zeruj odpowiedni bit
	SJMP	KEY_END

KEY_ON:
	JNB	KEY,KEY_END
	MOV	A,R3		;klawisz naciòni©ty
	ANL	A,KEY_LAST
	JNZ	KEY_END		;klawisz byà naciòni©ty
				;bez reakcji

	MOV	A,R3		;klawisz byà zwolniony
	ORL	KEY_LAST,A	;ustaw odpowiedni bit
	INC	@R0		;zwi©ksz licznik
				;naciòni©Ü - liczb© na
				;odpowiednim wska´niku
KEY_END:
	MOV	A,R3
	RL	A		;numeru nast©pnego
	MOV	R3,A		;wska´nika (kod 1 z 8)
	INC	R0		;adres danych nast©pnego
				;wska´nika

	DJNZ	R2,LOOP		;kolejne òwiecenie
				;siedmiu wska´nik¢w
	SJMP	LOOP_DISP	;zacznij od wska´nika 1

;**************************************
;Podprogram zamienia cyfr© na kod 7-segmentowy
GET_COD7:
	ANL	A,#0FH		;tabela kod¢w 0..15
	INC	A		;pomi‰ rozkaz RET
	MOVC	A,@A+PC		;pobierz kod
	RET

COD_7SEG:
	DB	03FH		;kod znaku 0
	DB	006H		;kod znaku 1
	DB	05BH		;kod znaku 2
	DB	04FH		;kod znaku 3
	DB	066H		;kod znaku 4
	DB	06DH		;kod znaku 5
	DB	07DH		;kod znaku 6
	DB	007H		;kod znaku 7
	DB	07FH		;kod znaku 8
	DB	06FH		;kod znaku 9
	DB	077H		;kod znaku A
	DB	07CH		;kod znaku b
	DB	039H		;kod znaku C
	DB	05EH		;kod znaku d
	DB	079H		;kod znaku E
	DB	071H		;kod znaku F
