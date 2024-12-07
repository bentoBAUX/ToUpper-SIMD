# ToUpper() in SIMD x86 Assembly

Working with SIMD requires a little bit of brain gymnastics. To ease your understanding on this implementation, I have prepared a schematic. The requirements for this is that you already understand how to perform conditional checks using `pcmp` (Packed Compare) commands in x86 Assembly.

## Usage & Example
```cmd
> gcc -o <name> src/simpleTest.c src/toupper.S
> ./<name>
  Before: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
  After: LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT, SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA.
```
## Schematic 
![Schematic](https://github.com/bentoBAUX/toupper_simd/blob/master/Schematic.png)
