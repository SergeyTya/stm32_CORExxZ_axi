//*****************************************************************************
//
// IQfrac.S - Return fractional portion of fixed point number.
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNfrac
//
//*****************************************************************************
//
// C Usage:    extern long _IQfrac(long A);   // no round or sat
//
//-----------------------------------------------------------------------------
//
// On Entry:   r0    = A in IQ format
//
// Regs Used:  r0
//
// On Exit:    r0    = fractional portion of A stored as IQ
//
// Q range:    30 to 1
//
//-----------------------------------------------------------------------------
//
// Algorithm:  The fractional portion of the IQ number is calculated
//             as follows:
//
//                frac = A - ((A >> q_value) << q_value);
//
//##### INTERNAL BEGIN #####
//-----------------------------------------------------------------------------
//
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
// _IQ1frac
//
//*****************************************************************************
    .section .text._IQ1frac
    .globl _IQ1frac
    .thumb_func
_IQ1frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #1

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #1

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
// _IQ2frac
//
//*****************************************************************************
    .section .text._IQ2frac
    .globl _IQ2frac
    .thumb_func
_IQ2frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #2

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #2

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
// _IQ3frac
//
//*****************************************************************************
    .section .text._IQ3frac
    .globl _IQ3frac
    .thumb_func
_IQ3frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #3

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #3

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
// _IQ4frac
//
//*****************************************************************************
    .section .text._IQ4frac
    .globl _IQ4frac
    .thumb_func
_IQ4frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #4

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #4

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
// _IQ5frac
//
//*****************************************************************************
    .section .text._IQ5frac
    .globl _IQ5frac
    .thumb_func
_IQ5frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #5

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #5

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
// _IQ6frac
//
//*****************************************************************************
    .section .text._IQ6frac
    .globl _IQ6frac
    .thumb_func
_IQ6frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #6

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #6

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
// _IQ7frac
//
//*****************************************************************************
    .section .text._IQ7frac
    .globl _IQ7frac
    .thumb_func
_IQ7frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #7

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #7

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
// _IQ8frac
//
//*****************************************************************************
    .section .text._IQ8frac
    .globl _IQ8frac
    .thumb_func
_IQ8frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #8

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #8

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
// _IQ9frac
//
//*****************************************************************************
    .section .text._IQ9frac
    .globl _IQ9frac
    .thumb_func
_IQ9frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #9

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #9

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
// _IQ10frac
//
//*****************************************************************************
    .section .text._IQ10frac
    .globl _IQ10frac
    .thumb_func
_IQ10frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #10

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #10

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
// _IQ11frac
//
//*****************************************************************************
    .section .text._IQ11frac
    .globl _IQ11frac
    .thumb_func
_IQ11frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #11

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #11

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
// _IQ12frac
//
//*****************************************************************************
    .section .text._IQ12frac
    .globl _IQ12frac
    .thumb_func
_IQ12frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #12

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #12

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
// _IQ13frac
//
//*****************************************************************************
    .section .text._IQ13frac
    .globl _IQ13frac
    .thumb_func
_IQ13frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #13

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #13

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
// _IQ14frac
//
//*****************************************************************************
    .section .text._IQ14frac
    .globl _IQ14frac
    .thumb_func
_IQ14frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #14

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #14

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
// _IQ15frac
//
//*****************************************************************************
    .section .text._IQ15frac
    .globl _IQ15frac
    .thumb_func
_IQ15frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #15

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #15

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
// _IQ16frac
//
//*****************************************************************************
    .section .text._IQ16frac
    .globl _IQ16frac
    .thumb_func
_IQ16frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #16

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #16

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
// _IQ17frac
//
//*****************************************************************************
    .section .text._IQ17frac
    .globl _IQ17frac
    .thumb_func
_IQ17frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #17

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #17

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
// _IQ18frac
//
//*****************************************************************************
    .section .text._IQ18frac
    .globl _IQ18frac
    .thumb_func
_IQ18frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #18

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #18

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
// _IQ19frac
//
//*****************************************************************************
    .section .text._IQ19frac
    .globl _IQ19frac
    .thumb_func
_IQ19frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #19

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #19

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
// _IQ20frac
//
//*****************************************************************************
    .section .text._IQ20frac
    .globl _IQ20frac
    .thumb_func
_IQ20frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #20

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #20

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
// _IQ21frac
//
//*****************************************************************************
    .section .text._IQ21frac
    .globl _IQ21frac
    .thumb_func
_IQ21frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #21

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #21

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
// _IQ22frac
//
//*****************************************************************************
    .section .text._IQ22frac
    .globl _IQ22frac
    .thumb_func
_IQ22frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #22

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #22

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
// _IQ23frac
//
//*****************************************************************************
    .section .text._IQ23frac
    .globl _IQ23frac
    .thumb_func
_IQ23frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #23

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #23

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
// _IQ24frac
//
//*****************************************************************************
    .section .text._IQ24frac
    .globl _IQ24frac
    .thumb_func
_IQ24frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #24

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #24

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
// _IQ25frac
//
//*****************************************************************************
    .section .text._IQ25frac
    .globl _IQ25frac
    .thumb_func
_IQ25frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #25

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #25

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
// _IQ26frac
//
//*****************************************************************************
    .section .text._IQ26frac
    .globl _IQ26frac
    .thumb_func
_IQ26frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #26

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #26

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
// _IQ27frac
//
//*****************************************************************************
    .section .text._IQ27frac
    .globl _IQ27frac
    .thumb_func
_IQ27frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #27

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #27

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
// _IQ28frac
//
//*****************************************************************************
    .section .text._IQ28frac
    .globl _IQ28frac
    .thumb_func
_IQ28frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #28

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #28

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
// _IQ29frac
//
//*****************************************************************************
    .section .text._IQ29frac
    .globl _IQ29frac
    .thumb_func
_IQ29frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #29

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #29

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
// _IQ30frac
//
//*****************************************************************************
    .section .text._IQ30frac
    .globl _IQ30frac
    .thumb_func
_IQ30frac:
    //
    // Copy A into r1, shifted by Q (integer portion only)
    //
    lsr     r1, r0, #30

    //
    // Subtract integer portion renormalized to get fraction
    //
    sub     r0, r0, r1, lsl #30

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

    .end
