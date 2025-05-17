; Variables necesarias para retardos
PSECT udata_bank0
delay_count1:  DS 1
delay_count2:  DS 1
delay_count3:  DS 1

; MACRO: DELAY_MS
DELAY_MS MACRO MS
    LOCAL delay_loop_outer
    LOCAL delay_loop_middle
    LOCAL delay_loop_inner

    MOVLW   MS
    MOVWF   delay_count3

delay_loop_outer:
    MOVLW   250
    MOVWF   delay_count2

delay_loop_middle:
    MOVLW   1
    MOVWF   delay_count1

delay_loop_inner:
    NOP
    NOP
    DECFSZ  delay_count1, F
    GOTO    delay_loop_inner

    DECFSZ  delay_count2, F
    GOTO    delay_loop_middle

    DECFSZ  delay_count3, F
    GOTO    delay_loop_outer
ENDM

; MACRO: DELAY_US
DELAY_US MACRO US
    LOCAL us_loop
    LOCAL us_end

    MOVLW   (US / 5)
    BTFSC   STATUS, 2
    GOTO    us_end
    MOVWF   delay_count1

us_loop:
    NOP
    NOP
    DECFSZ  delay_count1, F
    GOTO    us_loop

us_end:
ENDM