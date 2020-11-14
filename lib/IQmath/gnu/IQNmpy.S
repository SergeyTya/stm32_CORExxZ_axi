//*****************************************************************************
//
// IQmpy.S - Fixed point multiply
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNmpy
//
//*****************************************************************************
//
// C Usage:    extern long _IQmpy(long M, long X);   // no round or sat
//
//-----------------------------------------------------------------------------
//
// On Entry:   r0     = M in IQ format
//             r1     = X in IQ format
//
// Regs Used:  r0, r1
//
// On Exit:    r0     = M * X in IQ format
//
// Q range:    30 to 1
//
//-----------------------------------------------------------------------------
//
// Algorithm:  The IQmpy operation generates a 64-bit result. The 64-bit
//             number must then be scaled back to a 32-bit value with the
//             same Q value as the original inputs. For example: if Q = 27,
//             then the multiplication of two I5Q27 numbers results in the
//             following 64-bit value:
//
//                          I5Q27 * I5Q27 = I10Q54
//
//             The value is then scaled back to an I5Q27 value as follows:
//
//                          I5Q27 = I10Q54 >> Q
//
//             For some of the operations, the value is either rounded or
//             saturated (or both) to its maximum value before scaling.
//
//##### INTERNAL BEGIN #####
//-----------------------------------------------------------------------------
// Benchmark:
//
// Cycles = ??
//
//##### INTERNAL END #####
//*****************************************************************************

    .syntax unified
    .thumb
    .text

//*****************************************************************************
//
// _IQ1mpy
//
//*****************************************************************************
    .section .text._IQ1mpy
    .globl _IQ1mpy
    .thumb_func
_IQ1mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #1

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 1)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ2mpy
//
//*****************************************************************************
    .section .text._IQ2mpy
    .globl _IQ2mpy
    .thumb_func
_IQ2mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #2

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 2)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ3mpy
//
//*****************************************************************************
    .section .text._IQ3mpy
    .globl _IQ3mpy
    .thumb_func
_IQ3mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #3

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 3)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ4mpy
//
//*****************************************************************************
    .section .text._IQ4mpy
    .globl _IQ4mpy
    .thumb_func
_IQ4mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #4

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 4)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ5mpy
//
//*****************************************************************************
    .section .text._IQ5mpy
    .globl _IQ5mpy
    .thumb_func
_IQ5mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #5

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 5)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ6mpy
//
//*****************************************************************************
    .section .text._IQ6mpy
    .globl _IQ6mpy
    .thumb_func
_IQ6mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #6

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 6)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ7mpy
//
//*****************************************************************************
    .section .text._IQ7mpy
    .globl _IQ7mpy
    .thumb_func
_IQ7mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #7

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 7)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ8mpy
//
//*****************************************************************************
    .section .text._IQ8mpy
    .globl _IQ8mpy
    .thumb_func
_IQ8mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #8

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 8)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ9mpy
//
//*****************************************************************************
    .section .text._IQ9mpy
    .globl _IQ9mpy
    .thumb_func
_IQ9mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #9

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 9)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ10mpy
//
//*****************************************************************************
    .section .text._IQ10mpy
    .globl _IQ10mpy
    .thumb_func
_IQ10mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #10

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 10)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ11mpy
//
//*****************************************************************************
    .section .text._IQ11mpy
    .globl _IQ11mpy
    .thumb_func
_IQ11mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #11

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 11)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ12mpy
//
//*****************************************************************************
    .section .text._IQ12mpy
    .globl _IQ12mpy
    .thumb_func
_IQ12mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #12

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 12)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ13mpy
//
//*****************************************************************************
    .section .text._IQ13mpy
    .globl _IQ13mpy
    .thumb_func
_IQ13mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #13

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 13)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ14mpy
//
//*****************************************************************************
    .section .text._IQ14mpy
    .globl _IQ14mpy
    .thumb_func
_IQ14mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #14

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 14)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ15mpy
//
//*****************************************************************************
    .section .text._IQ15mpy
    .globl _IQ15mpy
    .thumb_func
_IQ15mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #15

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 15)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ16mpy
//
//*****************************************************************************
    .section .text._IQ16mpy
    .globl _IQ16mpy
    .thumb_func
_IQ16mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #16

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 16)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ17mpy
//
//*****************************************************************************
    .section .text._IQ17mpy
    .globl _IQ17mpy
    .thumb_func
_IQ17mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #17

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 17)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ18mpy
//
//*****************************************************************************
    .section .text._IQ18mpy
    .globl _IQ18mpy
    .thumb_func
_IQ18mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #18

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 18)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ19mpy
//
//*****************************************************************************
    .section .text._IQ19mpy
    .globl _IQ19mpy
    .thumb_func
_IQ19mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #19

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 19)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ20mpy
//
//*****************************************************************************
    .section .text._IQ20mpy
    .globl _IQ20mpy
    .thumb_func
_IQ20mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #20

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 20)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ21mpy
//
//*****************************************************************************
    .section .text._IQ21mpy
    .globl _IQ21mpy
    .thumb_func
_IQ21mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #21

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 21)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ22mpy
//
//*****************************************************************************
    .section .text._IQ22mpy
    .globl _IQ22mpy
    .thumb_func
_IQ22mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #22

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 22)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ23mpy
//
//*****************************************************************************
    .section .text._IQ23mpy
    .globl _IQ23mpy
    .thumb_func
_IQ23mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #23

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 23)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ24mpy
//
//*****************************************************************************
    .section .text._IQ24mpy
    .globl _IQ24mpy
    .thumb_func
_IQ24mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #24

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 24)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ25mpy
//
//*****************************************************************************
    .section .text._IQ25mpy
    .globl _IQ25mpy
    .thumb_func
_IQ25mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #25

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 25)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ26mpy
//
//*****************************************************************************
    .section .text._IQ26mpy
    .globl _IQ26mpy
    .thumb_func
_IQ26mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #26

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 26)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ27mpy
//
//*****************************************************************************
    .section .text._IQ27mpy
    .globl _IQ27mpy
    .thumb_func
_IQ27mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #27

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 27)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ28mpy
//
//*****************************************************************************
    .section .text._IQ28mpy
    .globl _IQ28mpy
    .thumb_func
_IQ28mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #28

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 28)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ29mpy
//
//*****************************************************************************
    .section .text._IQ29mpy
    .globl _IQ29mpy
    .thumb_func
_IQ29mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #29

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 29)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ30mpy
//
//*****************************************************************************
    .section .text._IQ30mpy
    .globl _IQ30mpy
    .thumb_func
_IQ30mpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    //
    lsr     r0, r0, #30

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    //
    add     r0, r0, r1, lsl #(32 - 30)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

    .end
