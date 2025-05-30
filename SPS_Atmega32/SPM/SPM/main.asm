;
; SPM.asm
;
; Created: 5/6/2025 9:37:35 PM
; Author : ALISHERHAIDARI
;


; Replace with your application code
.include "m32def.inc"

; Constants
.equ DELAY_100MS = 31       ; Reduced delay for car entry (100ms approximation)
.equ DELAY_150MS = 47       ; Reduced delay for car leaving (150ms approximation)
.equ DELAY_1S = 156         ; 1 second delay when slot is empty (adjusted)

; Register definitions
.def temp = r16
.def loop_counter = r17
.def sensor_input = r18

; Initialization
.org 0x00
rjmp start

start:
    ; Set PORTD as input (IR sensors), PORTC as output (LEDs)
    ldi temp, 0x00
    out DDRD, temp
    ldi temp, 0x0F
    out DDRC, temp

main_loop:
    in sensor_input, PIND      ; Read sensor input (D0�D3)

    ; Check slot 1 (PIND0)
    sbrs sensor_input, 0       ; If bit 0 is set (car present)
    rjmp slot1_empty
    sbi PORTC, 0               ; Turn ON LED
    rcall delay_100ms_func     ; Very short delay for car entry
    rjmp check_slot2
slot1_empty:
    cbi PORTC, 0               ; Turn OFF LED
    rcall delay_150ms_func     ; Short delay for car leaving

check_slot2:
    sbrs sensor_input, 1       ; If bit 1 is set (car present)
    rjmp slot2_empty
    sbi PORTC, 1               ; Turn ON LED
    rcall delay_100ms_func
    rjmp check_slot3
slot2_empty:
    cbi PORTC, 1
    rcall delay_150ms_func

check_slot3:
    sbrs sensor_input, 2       ; If bit 2 is set (car present)
    rjmp slot3_empty
    sbi PORTC, 2               ; Turn ON LED
    rcall delay_100ms_func
    rjmp check_slot4
slot3_empty:
    cbi PORTC, 2
    rcall delay_150ms_func

check_slot4:
    sbrs sensor_input, 3       ; If bit 3 is set (car present)
    rjmp slot4_empty
    sbi PORTC, 3               ; Turn ON LED
    rcall delay_100ms_func
    rjmp loop_back
slot4_empty:
    cbi PORTC, 3
    rcall delay_150ms_func

loop_back:
    rjmp main_loop

; 100ms delay routine for car entry
delay_100ms_func:
    ldi loop_counter, DELAY_100MS
delay_100ms_loop:
    rcall short_delay
    dec loop_counter
    brne delay_100ms_loop
    ret

; 150ms delay routine for car leaving
delay_150ms_func:
    ldi loop_counter, DELAY_150MS
delay_150ms_loop:
    rcall short_delay
    dec loop_counter
    brne delay_150ms_loop
    ret

; Short delay (~6.5ms per call with 1MHz clock, tune as needed)
short_delay:
    ldi temp, 255
delay_loop1:
    dec temp
    brne delay_loop1
    ret
