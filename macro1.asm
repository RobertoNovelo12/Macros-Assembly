PROCESSOR 16F877A
#include <xc.inc>
#include "macro2.asm"
#include "macro3.asm"

; Configuración de bits
CONFIG CP=OFF
CONFIG DEBUG=OFF
CONFIG WRT=OFF
CONFIG CPD=OFF
CONFIG WDTE=OFF
CONFIG LVP=OFF
CONFIG BOREN=ON
CONFIG PWRTE=ON
CONFIG FOSC=XT

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