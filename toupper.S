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
    movaps xmm3, xmm5           
    movaps xmm4, xmm7

    movaps xmm0, xmmword ptr [rdi]
    movaps xmm1, xmm0   

    pxor xmm6, xmm6
    pcmpeqb xmm6, xmm0
    pmovmskb eax, xmm6                              // Put MSBs into eax for testing
    test eax, eax
    jnz toupper_asm

    pcmpgtb xmm1, xmmword ptr [rip + begin_lower]   // Get x >= a mask in xmm0
    pcmpgtb xmm3, xmm0                              // Get z >= x mask in xmm3

    pand xmm1, xmm3                                 // Combine masks to find toupper() character

    pand xmm4, xmm1                                 // Create subtraction mask
    psubb xmm0, xmm4                                // Subtract 32

    movdqu [rdi], xmm0                              // Move back to rdi
    
    add rdi, 16
    jmp simd_loop

toupper_asm:
    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Skip1
    sub byte ptr [rdi], 0x20
.Skip1:
    inc rdi

    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Skip2
    sub byte ptr [rdi], 0x20
.Skip2:
    inc rdi

    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Skip3
    sub byte ptr [rdi], 0x20
.Skip3:
    inc rdi

    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Skip4
    sub byte ptr [rdi], 0x20
.Skip4:
    inc rdi

    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Skip5
    sub byte ptr [rdi], 0x20
.Skip5:
    inc rdi

    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Skip6
    sub byte ptr [rdi], 0x20
.Skip6:
    inc rdi

    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Skip7
    sub byte ptr [rdi], 0x20
.Skip7:
    inc rdi

    mov al, [rdi]
    test al, al
    je .Lend
    sub al, 'a'
    cmp al, 25
    ja .Skip8
    sub byte ptr [rdi], 0x20
.Skip8:
    inc rdi

    jmp toupper_asm

.Lend:
    ret            