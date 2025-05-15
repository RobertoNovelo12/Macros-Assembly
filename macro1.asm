PROCESSOR 16F877A     
    
#include <xc.inc>  

; Configuración de bits
CONFIG CP=OFF          ; Protección de código desactivada
CONFIG DEBUG=OFF       ; Depuración desactivada
CONFIG WRT=OFF         ; Protección de escritura desactivada
CONFIG CPD=OFF         ; Protección de datos desactivada
CONFIG WDTE=OFF        ; Watchdog timer desactivado
CONFIG LVP=OFF         ; Programación de bajo voltaje desactivada
CONFIG BOREN=ON        ; Brown-out reset activado
CONFIG PWRTE=ON        ; Power-up timer activado
CONFIG FOSC=XT         ; Oscilador XT

; Definición de macros de control de puertos
;**********************************************************************
; MACRO: SETUP_PORT
; Configura un puerto como entrada o salida
; Argumentos:
;   - PORT_REG: Registro del puerto (PORTA, PORTB, etc.)
;   - TRIS_REG: Registro TRIS correspondiente (TRISA, TRISB, etc.)
;   - DIR_VALUE: Valor de dirección (0 para salida, 1 para entrada)
;**********************************************************************
SETUP_PORT MACRO PORT_REG, TRIS_REG, DIR_VALUE
    BANKSEL TRIS_REG   ; Selecciona el banco donde está TRIS
    MOVLW   DIR_VALUE  ; Carga el valor de dirección
    MOVWF   TRIS_REG   ; Configura la dirección
    BANKSEL PORT_REG   ; Vuelve al banco donde está el puerto
    CLRF    PORT_REG   ; Limpia el puerto
    ENDM

;**********************************************************************
; MACRO: SET_PIN
; Establece un pin específico de un puerto
; Argumentos:
;   - PORT_REG: Registro del puerto (PORTA, PORTB, etc.)
;   - PIN_NUM: Número de pin (0-7)
;**********************************************************************
SET_PIN MACRO PORT_REG, PIN_NUM
    BANKSEL PORT_REG   ; Selecciona el banco donde está el puerto
    BSF     PORT_REG, PIN_NUM  ; Establece el pin
    ENDM

;**********************************************************************
; MACRO: CLEAR_PIN
; Limpia un pin específico de un puerto
; Argumentos:
;   - PORT_REG: Registro del puerto (PORTA, PORTB, etc.)
;   - PIN_NUM: Número de pin (0-7)
;**********************************************************************
CLEAR_PIN MACRO PORT_REG, PIN_NUM
    BANKSEL PORT_REG   ; Selecciona el banco donde está el puerto
    BCF     PORT_REG, PIN_NUM  ; Limpia el pin
    ENDM

; Variables
PSECT udata_bank0
counter:    DS 1       ; Variable para conteo

; Vector de reset
PSECT resetVec, class=CODE, delta=2
resetVec:
    GOTO    main       ; Salto a la rutina principal

; Programa principal
PSECT code, delta=2
main:
    ; Inicialización
    SETUP_PORT PORTB, TRISB, 0x00    ; Configura PORTB como salida
    
secuencia_leds:
    ; Secuencia de encendido/apagado de LEDs
    SET_PIN   PORTB, 0    ; Enciende LED en RB0
    CALL      delay       ; Llama a rutina de retardo
    CLEAR_PIN PORTB, 0    ; Apaga LED en RB0
    
    SET_PIN   PORTB, 1    ; Enciende LED en RB1
    CALL      delay       ; Llama a rutina de retardo
    CLEAR_PIN PORTB, 1    ; Apaga LED en RB1
    
    SET_PIN   PORTB, 2    ; Enciende LED en RB2
    CALL      delay       ; Llama a rutina de retardo
    CLEAR_PIN PORTB, 2    ; Apaga LED en RB2
    
    SET_PIN   PORTB, 3    ; Enciende LED en RB3
    CALL      delay       ; Llama a rutina de retardo
    CLEAR_PIN PORTB, 3    ; Apaga LED en RB3
    
    GOTO      secuencia_leds  ; Repite la secuencia indefinidamente

; Rutina de retardo simple
delay:
    MOVLW    0xFF         ; Carga valor máximo
    MOVWF    counter      ; Almacena en variable contador
delay_loop:
    NOP                   ; No operación (consume un ciclo)
    DECFSZ   counter, F   ; Decrementa contador, salta si es cero
    GOTO     delay_loop   ; Si no es cero, continúa el bucle
    RETURN                ; Retorna cuando el contador llega a cero

END resetVec              ; Fin del programa, indica vector de reset