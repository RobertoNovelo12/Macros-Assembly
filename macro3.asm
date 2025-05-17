; Variables en RAM para suma 16 bits
PSECT udata_bank0
num1:          DS 1       ; Primer número 8 bits
num2:          DS 1       ; Segundo número 8 bits
resultado_low:  DS 1       ; Resultado byte bajo
resultado_high: DS 1       ; Resultado byte alto
temp:          DS 1       ; Variable temporal
contador:      DS 1       ; Variable contador para delay simple

; Macro para suma 16 bits
SUMA16 MACRO NUM1, NUM2, RESULT_LOW, RESULT_HIGH
    MOVF NUM1, W
    ADDWF NUM2, W
    MOVWF RESULT_LOW

    BTFSC STATUS, 0      ; Si acarreo está limpio
    CLRF RESULT_HIGH
    BTFSS STATUS, 0      ; Si acarreo está seteado
    MOVLW 1
    MOVWF RESULT_HIGH
ENDM

; Macro para retardo simple
DELAY MACRO
    MOVLW 0xFF
    MOVWF contador
delay_loop:
    NOP
    DECFSZ contador, F
    GOTO delay_loop
ENDM