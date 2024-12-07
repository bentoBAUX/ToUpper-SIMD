#include <stdio.h>
#include <stdlib.h> // For malloc and free
#include <stdint.h> // For uintptr_t
extern void toupper_simd(char *str);
//extern void toupper_avx(char *str);

int main() {
    // Allocate memory dynamically, ensuring sufficient space for unalignment
    size_t buffer_size = 1000; // Adjust based on your string length
    void *original_memory = malloc(buffer_size + 16); // Extra space for alignment adjustments

    if (!original_memory) {
        perror("malloc failed");
        return 1;
    }

    // Align to a 16-byte boundary
    uintptr_t aligned_address = ((uintptr_t)original_memory + 15) & ~((uintptr_t)15);

    // Offset the pointer to make it unaligned
    char *unaligned_str = (char *)(aligned_address + 10); 
 
    char *original_str = "Hey buddy, a key reason you might not be seeing the loop progress beyond the first 16 characters";

    snprintf(unaligned_str, buffer_size, "%s", original_str); 
    
    printf("Unaligned address:\n");
    printf("  Before: %s\n", unaligned_str);
    toupper_simd(unaligned_str); 
    printf("  After: %s\n", unaligned_str);

    char str[] = "Hey buddy, a key reason you might not be seeing the loop progress beyond the first 16 characters";
    printf("Aligned address:\n");
    printf("  Before: %s\n", str);
    toupper_simd(str); // Pass the aligned
    printf("  After: %s\n", str);   

    // Test the AVX implementation
    char str_avx[] = "Hey buddy, a key reason you might not be seeing the loop progress beyond the first 16 characters";
    //printf("Aligned address (AVX):\n");
    //printf("  Before: %s\n", str_avx);
    //toupper_avx(str_avx); // Pass the aligned
    //printf("  After: %s\n", str_avx);


    // Free the original allocated memory (use the base pointer)
    free(original_memory);

    return 0;
}
