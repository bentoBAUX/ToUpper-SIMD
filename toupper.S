.intel_syntax noprefix
.global toupper_simd

.section .rodata
.align 16
    end_upper:      .byte 0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b
    begin_lower:    .byte 0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60
    diff:           .byte 0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
.section .text

toupper_simd:
    movdqa xmm5, [rip + end_upper]      // Store end_upper
    movdqa xmm7, [rip + diff]           // Store diff
    mov rcx, rdi
    neg rcx
    and rcx, 15
    jz simd_loop
    
sort_unaligned:
    mov al,[rdi]
    cmp al,0                        
    je .Lend
    sub al,'a'                      
    cmp al,25                       
    ja  unaligned_cont              
    sub byte ptr [rdi],0x20         
unaligned_cont:
    inc rdi
    dec rcx
    jnz sort_unaligned  

simd_loop:
    movaps xmm0, [rdi]
    
    pxor xmm6, xmm6
    pcmpeqb xmm6, xmm0
    pmovmskb eax, xmm6
    test eax, eax
    jnz toupper_asm

    movaps xmm3, xmm5
    movaps xmm4, xmm7
    movaps xmm1, xmm0

    pcmpgtb xmm1, [rip + begin_lower]
    pcmpgtb xmm3, xmm0
    pand xmm1, xmm3
    pand xmm4, xmm1
    psubb xmm0, xmm4
    movdqa [rdi], xmm0

    movaps xmm0, [rdi + 16]
    
    pxor xmm6, xmm6
    pcmpeqb xmm6, xmm0
    pmovmskb eax, xmm6
    test eax, eax
    jnz toupper_asm

    movaps xmm3, xmm5
    movaps xmm4, xmm7
    movaps xmm1, xmm0

    pcmpgtb xmm1, [rip + begin_lower]
    pcmpgtb xmm3, xmm0
    pand xmm1, xmm3
    pand xmm4, xmm1
    psubb xmm0, xmm4
    movdqa [rdi + 16], xmm0

    movaps xmm0, [rdi + 32]
    
    pxor xmm6, xmm6
    pcmpeqb xmm6, xmm0
    pmovmskb eax, xmm6
    test eax, eax
    jnz toupper_asm

    movaps xmm3, xmm5
    movaps xmm4, xmm7
    movaps xmm1, xmm0

    pcmpgtb xmm1, [rip + begin_lower]
    pcmpgtb xmm3, xmm0
    pand xmm1, xmm3
    pand xmm4, xmm1
    psubb xmm0, xmm4
    movdqa [rdi + 32], xmm0

    movaps xmm0, [rdi + 48]
    
    pxor xmm6, xmm6
    pcmpeqb xmm6, xmm0
    pmovmskb eax, xmm6
    test eax, eax
    jnz toupper_asm

    movaps xmm3, xmm5
    movaps xmm4, xmm7
    movaps xmm1, xmm0

    pcmpgtb xmm1, [rip + begin_lower]
    pcmpgtb xmm3, xmm0
    pand xmm1, xmm3
    pand xmm4, xmm1
    psubb xmm0, xmm4
    movdqa [rdi + 48], xmm0

    add rdi, 64
    jmp simd_loop

toupper_asm:
    // Process 1st character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process1
    sub byte ptr [rdi], 0x20
.Process1:
    inc rdi
    // Process 2nd character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process2
    sub byte ptr [rdi], 0x20
.Process2:
    inc rdi

    // Process 3rd character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process3
    sub byte ptr [rdi], 0x20
.Process3:
    inc rdi

    // Process 4th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process4
    sub byte ptr [rdi], 0x20
.Process4:
    inc rdi

    // Process 5th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process5
    sub byte ptr [rdi], 0x20
.Process5:
    inc rdi

    // Process 6th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process6
    sub byte ptr [rdi], 0x20
.Process6:
    inc rdi

    // Process 7th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process7
    sub byte ptr [rdi], 0x20
.Process7:
    inc rdi

    // Process 8th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process8
    sub byte ptr [rdi], 0x20
.Process8:
    inc rdi

    // Process 9th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process9
    sub byte ptr [rdi], 0x20
.Process9:
    inc rdi

    // Process 10th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process10
    sub byte ptr [rdi], 0x20
.Process10:
    inc rdi

    // Process 11th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process11
    sub byte ptr [rdi], 0x20
.Process11:
    inc rdi

    // Process 12th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process12
    sub byte ptr [rdi], 0x20
.Process12:
    inc rdi

    // Process 13th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process13
    sub byte ptr [rdi], 0x20
.Process13:
    inc rdi

    // Process 14th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process14
    sub byte ptr [rdi], 0x20
.Process14:
    inc rdi

    // Process 15th character
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Process15
    sub byte ptr [rdi], 0x20
.Process15:
    inc rdi

    // Repeat unrolled loop
    jmp toupper_asm
.Lend:
    ret            