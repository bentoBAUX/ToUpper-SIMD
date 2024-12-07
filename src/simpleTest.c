#include <stdio.h>
extern void toupper_simd(char *str);

int main() {
    char str[] = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ";

    printf("Before: %s\n", str);
    toupper_simd(str); 
    printf("After: %s\n", str);   

    return 0;
}