#include <stdio.h>
extern void toupper_simd(char *str);

int main() {
    char str[] = "Hey buddy, a key reason you might not be seeing the loop progress beyond the first 16 characters";

    printf("Before: %s\n", str);
    toupper_simd(str); 
    printf("After: %s\n", str);   

    return 0;
}