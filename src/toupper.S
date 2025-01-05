.intel_syntax noprefix
.global toupper_simd

.section .rodata
.align 16
    end_upper:      .byte 0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b,0x7b
    begin_lower:    .byte 0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60
    diff:           .byte 0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
.section .text

toupper_simd:
    movdqa xmm5, [rip + end_upper]                  // Store end_upper
    movdqa xmm7, [rip + diff]                       // Store diff
    mov rcx, rdi                
    neg rcx
    and rcx, 15                                     // Handle first n unaligned characters
    jz simd_loop
    
sort_unaligned:
    mov al, [rdi]
    cmp al, 'a'
    jl  unaligned_cont
    cmp al, 'z'
    jg  unaligned_cont
    and al, 0xDF
    mov byte ptr [rdi], al      
unaligned_cont:
    inc rdi
    dec rcx 
    jnz toupper_asm 
    cmp byte ptr [rdi], 0x00

simd_loop:

    movaps xmm0, xmmword ptr [rdi]                  // Move 16 characters into xmm0

    // Nullbyte check
    pxor xmm6, xmm6 
    pcmpeqb xmm6, xmm0                              // Compare the string to a string of 0s. If there is a nullbyte, xmm6 will contain a 0xFF
    pmovmskb eax, xmm6                              // Put the most significant bytes into eax for testing
    test eax, eax                                   // eax is 0 if there is no nullbyte
    jnz toupper_asm

    movaps xmm3, xmm5                               // Move end_upper into xmm3     
    movaps xmm1, xmm0                               // Copy of xmm0 

    pcmpgtb xmm1, xmmword ptr [rip + begin_lower]   // Get x >= a mask in xmm0
    pcmpgtb xmm3, xmm0                              // Get z >= x mask in xmm3

    pand xmm1, xmm3                                 // Combine masks to find toupper() character

    pand xmm1, xmm7                                 // Create subtraction mask
    psubb xmm0, xmm1                                // Subtract 32
    movdqa [rdi], xmm0                              // Move back to rdi
    
    add rdi, 16
    jmp simd_loop

.toupper_asm:
    mov al,[rdi]
    cmp al,0                    // Branch to return if char is '\0'
    je .end
    sub al,'a'                  // Make 'a' => 0, 'b' => 1, ..., 'z' => 25.
    cmp al,25                   // Branch to cont if al is unsigned > 25.
    ja .cont                    // "Jump above", unsigned equivalent to jg
    sub byte ptr [rdi],0x20     // Transform letter to upper case
.cont:
    inc rdi
    jmp .toupper_asm
.end:
    ret
