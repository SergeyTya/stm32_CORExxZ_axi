//*****************************************************************************
//
// IQrmpy.S - Fixed point multiply with rounding (no saturation)
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNrmpy
//
//*****************************************************************************
//
// C Usage:    extern long _IQNrmpy(long M, long X); // with rounding only
//
//-----------------------------------------------------------------------------
//
// On Entry:   r0     = A in IQ format
//             r1     = B in IQ format
//
// Regs Used:  r0, r1
//
// On Exit:    r0     = A*B stored as IQ
//
// Q range:    30 to 1
//
//-----------------------------------------------------------------------------
//
// Algorithm:  The integer portion of the IQ*I32 number is calculated
//             as follows:
//
//                result = (A*B >> q_value)+result[-1];
//
//-----------------------------------------------------------------------------
//
// Benchmark:
//
// Cycles = 5-9 cycles, not counting call
//
//*****************************************************************************

    .syntax unified
    .thumb
    .text

//*****************************************************************************
//
// _IQ1rmpy
//
//*****************************************************************************
    .section .text._IQ1rmpy
    .globl _IQ1rmpy
    .thumb_func
_IQ1rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #1

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 1)

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
// _IQ2rmpy
//
//*****************************************************************************
    .section .text._IQ2rmpy
    .globl _IQ2rmpy
    .thumb_func
_IQ2rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #2

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 2)

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
// _IQ3rmpy
//
//*****************************************************************************
    .section .text._IQ3rmpy
    .globl _IQ3rmpy
    .thumb_func
_IQ3rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #3

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 3)

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
// _IQ4rmpy
//
//*****************************************************************************
    .section .text._IQ4rmpy
    .globl _IQ4rmpy
    .thumb_func
_IQ4rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #4

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 4)

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
// _IQ5rmpy
//
//*****************************************************************************
    .section .text._IQ5rmpy
    .globl _IQ5rmpy
    .thumb_func
_IQ5rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #5

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 5)

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
// _IQ6rmpy
//
//*****************************************************************************
    .section .text._IQ6rmpy
    .globl _IQ6rmpy
    .thumb_func
_IQ6rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #6

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 6)

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
// _IQ7rmpy
//
//*****************************************************************************
    .section .text._IQ7rmpy
    .globl _IQ7rmpy
    .thumb_func
_IQ7rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #7

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 7)

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
// _IQ8rmpy
//
//*****************************************************************************
    .section .text._IQ8rmpy
    .globl _IQ8rmpy
    .thumb_func
_IQ8rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #8

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 8)

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
// _IQ9rmpy
//
//*****************************************************************************
    .section .text._IQ9rmpy
    .globl _IQ9rmpy
    .thumb_func
_IQ9rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #9

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 9)

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
// _IQ10rmpy
//
//*****************************************************************************
    .section .text._IQ10rmpy
    .globl _IQ10rmpy
    .thumb_func
_IQ10rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #10

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 10)

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
// _IQ11rmpy
//
//*****************************************************************************
    .section .text._IQ11rmpy
    .globl _IQ11rmpy
    .thumb_func
_IQ11rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #11

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 11)

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
// _IQ12rmpy
//
//*****************************************************************************
    .section .text._IQ12rmpy
    .globl _IQ12rmpy
    .thumb_func
_IQ12rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #12

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 12)

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
// _IQ13rmpy
//
//*****************************************************************************
    .section .text._IQ13rmpy
    .globl _IQ13rmpy
    .thumb_func
_IQ13rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #13

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 13)

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
// _IQ14rmpy
//
//*****************************************************************************
    .section .text._IQ14rmpy
    .globl _IQ14rmpy
    .thumb_func
_IQ14rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #14

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 14)

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
// _IQ15rmpy
//
//*****************************************************************************
    .section .text._IQ15rmpy
    .globl _IQ15rmpy
    .thumb_func
_IQ15rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #15

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 15)

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
// _IQ16rmpy
//
//*****************************************************************************
    .section .text._IQ16rmpy
    .globl _IQ16rmpy
    .thumb_func
_IQ16rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #16

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 16)

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
// _IQ17rmpy
//
//*****************************************************************************
    .section .text._IQ17rmpy
    .globl _IQ17rmpy
    .thumb_func
_IQ17rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #17

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 17)

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
// _IQ18rmpy
//
//*****************************************************************************
    .section .text._IQ18rmpy
    .globl _IQ18rmpy
    .thumb_func
_IQ18rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #18

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 18)

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
// _IQ19rmpy
//
//*****************************************************************************
    .section .text._IQ19rmpy
    .globl _IQ19rmpy
    .thumb_func
_IQ19rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #19

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 19)

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
// _IQ20rmpy
//
//*****************************************************************************
    .section .text._IQ20rmpy
    .globl _IQ20rmpy
    .thumb_func
_IQ20rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #20

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 20)

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
// _IQ21rmpy
//
//*****************************************************************************
    .section .text._IQ21rmpy
    .globl _IQ21rmpy
    .thumb_func
_IQ21rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #21

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 21)

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
// _IQ22rmpy
//
//*****************************************************************************
    .section .text._IQ22rmpy
    .globl _IQ22rmpy
    .thumb_func
_IQ22rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #22

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 22)

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
// _IQ23rmpy
//
//*****************************************************************************
    .section .text._IQ23rmpy
    .globl _IQ23rmpy
    .thumb_func
_IQ23rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #23

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 23)

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
// _IQ24rmpy
//
//*****************************************************************************
    .section .text._IQ24rmpy
    .globl _IQ24rmpy
    .thumb_func
_IQ24rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #24

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 24)

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
// _IQ25rmpy
//
//*****************************************************************************
    .section .text._IQ25rmpy
    .globl _IQ25rmpy
    .thumb_func
_IQ25rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #25

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 25)

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
// _IQ26rmpy
//
//*****************************************************************************
    .section .text._IQ26rmpy
    .globl _IQ26rmpy
    .thumb_func
_IQ26rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #26

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 26)

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
// _IQ27rmpy
//
//*****************************************************************************
    .section .text._IQ27rmpy
    .globl _IQ27rmpy
    .thumb_func
_IQ27rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #27

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 27)

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
// _IQ28rmpy
//
//*****************************************************************************
    .section .text._IQ28rmpy
    .globl _IQ28rmpy
    .thumb_func
_IQ28rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #28

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 28)

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
// _IQ29rmpy
//
//*****************************************************************************
    .section .text._IQ29rmpy
    .globl _IQ29rmpy
    .thumb_func
_IQ29rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #29

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 29)

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
// _IQ30rmpy
//
//*****************************************************************************
    .section .text._IQ30rmpy
    .globl _IQ30rmpy
    .thumb_func
_IQ30rmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Shift the lower 32 bits of the result down by Q
    // Also, update Carry flag to indicate whether or not to round
    //
    lsrs    r0, r0, #30

    //
    // Shift the upper 32 by ~Q
    // Add the upper and lower bits together
    // Add the carry flag in to round
    //
    adc     r0, r0, r1, lsl #(32 - 30)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

    .end
