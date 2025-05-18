PROCESSOR 16F877A
#include <xc.inc>
#include "macro2.asm"
#include "macro3.asm"

; CONFIG
  CONFIG FOSC = XT             ; Oscillator Selection bits (XT oscillator)
  CONFIG WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
  CONFIG PWRTE = ON            ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG BOREN = ON            ; Brown-out Reset Enable bit (BOR enabled)
  CONFIG LVP = OFF             ; Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3 is digital I/O, HV on MCLR must be used for programming)
  CONFIG CPD = OFF             ; Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
  CONFIG WRT = OFF             ; Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
  CONFIG CP = OFF              ; Flash Program Memory Code Protection bit (Code protection off)

; Definición de macros de control de puertos
SETUP_PORT MACRO PORT_REG, TRIS_REG, DIR_VALUE
    BANKSEL TRIS_REG
    MOVLW   DIR_VALUE
    MOVWF   TRIS_REG
    BANKSEL PORT_REG
    CLRF    PORT_REG
ENDM

SET_PIN MACRO PORT_REG, PIN_NUM
    BANKSEL PORT_REG
    BSF     PORT_REG, PIN_NUM
ENDM

CLEAR_PIN MACRO PORT_REG, PIN_NUM
    BANKSEL PORT_REG
    BCF     PORT_REG, PIN_NUM
ENDM

; Vector de reset (único en todo el proyecto)
PSECT resetVec, class=CODE, delta=2
resetVec:
    GOTO main

; Programa principal
PSECT code, delta=2
main:
    ; Inicialización
    SETUP_PORT PORTB, TRISB, 0x00    ; PORTB como salida

secuencia_leds:
    ; Enciende/apaga cada LED con retardo usando la macro
    SET_PIN PORTB, 0
    DELAY_MS 200
    CLEAR_PIN PORTB, 0

    SET_PIN PORTB, 1
    DELAY_MS 200
    CLEAR_PIN PORTB, 1

    SET_PIN PORTB, 2
    DELAY_MS 200
    CLEAR_PIN PORTB, 2

    SET_PIN PORTB, 3
    DELAY_MS 200
    CLEAR_PIN PORTB, 3

    MOVLW 25
    MOVWF num1
    MOVLW 10
    MOVWF num2

    SUMA16 num1, num2, resultado_low, resultado_high

    MOVF resultado_low, W
    MOVWF PORTB
    DELAY

    GOTO secuencia_leds

END resetVec