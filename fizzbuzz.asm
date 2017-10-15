; Fizzbuzz!
; Iterate over 1 thru 20.
; If the counter is divisible by 3, print fizz.
; If the counter is divisible by 5, print buzz.
; If the counter is divisible by 3 and 5, print fizzbuzz.
; If the counter is not divisible by 3 nor 5, print the counter.
;
BITS 32

section .data
    counter dd 0x01
    fizz db "Fizz", 0x00
    buzz db "Buzz", 0x00
    fizzbuzz db "FizzBuzz", 0x00
    fmt_number_str db "%d", 0x0a, 0x00
    fmt_str db "%s", 0x0a, 0x00

section .text
    global _start
    extern printf

    _start:
    loop_head:
        xor edx, edx
        mov eax, [counter]
        mov ecx, 0x03       ; prepare the divisor
        div ecx             ; divide the dividend by the divisor (eax: 0x01; ecx: 0x03)
        cmp edx, 0x00       ; Check if the remainder is zero.
        je condition_fizz   ; if the remainder was zero, we found a fizz which potentially also has a fizzbuzz!
        xor ebx, ebx
        xor edx, edx
        mov eax, [counter]  ; prepare the dividend
        mov ecx, 0x05       ; prepare the divisor
        div ecx             ; divide the dividend by the divisor (eax / ecx; remainder is stored in edx)
        cmp edx, 0x00       ; Check if the remainder is zero.
        je condition_buzz   ; We found a buzz
        jmp condition_else  ; we haven't found either fizz, buzz or fizzbuzz. We print the current number.

    condition_fizz: ; if eax % 3 == 0 && eax % 5 != 0
        ; We land here when the current value of the counter is divisible by 3.
        ; But we also need to check if we found a fizzbuzz (divisible by 3 *and 5*).
        xor edx, edx        ; Clean out edx to get a non-dirty register in preparation of the division.
        mov eax, [counter]  ; prepare the dividend
        mov ecx, 0x05       ; prepare the divisor
        div ecx             ; divide the counter by 5, store the remainder in edx.
        cmp edx, 0x00       ; check if the remainder is zero.
        je condition_fizzbuzz  ; the current counter is divisible by 3 and 5, we found a fizzbuzz.
        ; When we don't take the jump (above) we only found a fizz, print it.
        push fizz
        push fmt_str
        call printf
        jmp loop_tail

    condition_buzz: ; if eax % 5 == 0 && eax % 3 != 0
        push buzz
        push fmt_str
        call printf
        jmp loop_tail

    condition_fizzbuzz: ; if eax % 5 == 0 && eax % 3 == 0
        push fizzbuzz
        push fmt_str
        call printf
        jmp loop_tail

    condition_else: ; if eax % 5 != 0 && eax % 3 != 0
        ; print the current counter
        push dword [counter]
        push fmt_number_str
        call printf
        jmp loop_tail

    loop_tail:
        mov eax, [counter]   ; Load the value of the counter into eax.
        inc eax              ; Increment the value of counter.
        mov [counter], eax   ; write back the incremented value into the counter var.
        cmp eax, 0x14        ; check if the counter equals 20.
        jle loop_head        ; Go back to the start and fizzbuzz it up, until the counter reaches 20.
        jmp quit

    quit:
        mov eax, 0x01
        mov ecx, 0x00
        int 0x80
