; Plik definicji dla systemu mikroprocesorowego DSM-51
; Data utworzenia pliku: Wtorek, 2 kwietnia 2000r.
; Autor: Tomasz Jaworski

;Urz¥dzenia zewn©trzne systemu DSM-51

CSIC		RamEqu	000h		; sterownik przerwaä
CSDA		RamEqu	008h		; przetwornik cyfrowo/analogowy
CSAD		RamEqu	010h		; przetwornik analogowo/cyfrowy
CSMX		RamEqu	018h		; multiplekser analogowy
CSKB0		RamEqu	021h		; klawiatura matrycowa, klawisze 0..7
CSKB1		RamEqu	022h		; klawiatura matrycowa, klawisze 8..
CS55A		RamEqu	028h		; ukˆad 8255 rejestr portu A
CS55B		RamEqu	029h		; ukˆad 8255 rejestr portu B
CS55C		RamEqu	02ah		; ukˆad 8255 rejestr portu C
CS55D		RamEqu	02bh		; ukˆad 8255 rejestr steruj¥cy
CSDS		RamEqu	030h		; wy˜wietlacz 7-segm, wyb¢r wska«nika
CSDB		RamEqu	038h		; wy˜wietlacz 7-segm, bufor danych
CSMOD		RamEqu	040h		; dekoder adres¢w (przeˆ¥czanie trybu)
LCDWC		RamEqu	080h		; wy˜wietlacz LCD, wpis rozkaz¢w
LCDWD		RamEqu	081h		; wy˜wietlacz LCD, wpis danych
LCDRC		RamEqu	082h		; wy˜wietlacz LCD, odczyt stanu
LCDRD		RamEqu	083h		; wy˜wietlacz LCD, odczyt danych
CSX		RamEqu	0c0h		; zewn©trzna magistrala systemowa

;Podprogramy standardowe w pami©ci EPROM systemu DSM-51

WRITE_TEXT	RomEqu	08100h	; wypisanie tekstu na LCD
WRITE_DATA	RomEqu	08102h	; wypisanie znaku na LCD
WRITE_HEX	RomEqu	08104h	; wypisanie liczby hex na LCD
WRITE_INSTR	RomEqu	08105h	; wysˆanie rozkazu do LCD	
LCD_INIT	RomEqu	08106h	; inicjalizacja LCD
LCD_OFF		RomEqu	0810ah	; wygaszenie LCD
LCD_CLR		RomEqu	0810ch	; ustawienie w stan pocz¥tkowy
DELAY_US	RomEqu	0810eh	; op¢«nienie (2*A+6)*12/11.059 us
DELAY_MS	RomEqu	08110h	; op¢«nienie A ms
DELAY_100MS	RomEqu	08112h	; op¢«nienie A * 100ms
WAIT_ENTER	RomEqu	08114h	; "PRESS ENTER." i czeka na ENTER
WAIT_ENTER_NW	RomEqu	08116h	; czekanie na klawisz ENTER
TEST_ENTER	RomEqu	08118h	; sprawdzenie klawisza ENTER
WAIT_ENT_ESC	RomEqu	0811ah	; czekanie na ENTER lub ESC
WAIT_KEY	RomEqu	0811ch	; czekanie na dowolny klawisz
GET_NUM		RomEqu	0811eh	; wczytanie liczby BCD (4 cyfry)
BCD_HEX		RomEqu	08120h	; zamiana BCD na HEX
HEX_BCD		RomEqu	08122h	; zamiana HEX na BCD
MUL_2_2		RomEqu	08124h	; mno¾enie liczb 2 bajtowych
MUL_3_1		RomEqu	08126h	; mno¾enie 3bajty * 1bajt
DIV_2_1		RomEqu	08128h	; dzielenie 2bajty / 1bajt
DIV_4_2		RomEqu	0812ah	; dzielenie 4bajty / 2bajty

; Koniec.
