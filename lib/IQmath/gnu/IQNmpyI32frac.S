//*****************************************************************************
//
// IQmpyI32frac.S - Find fractional portion of multiplying IQ by I32
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNmpyI32frac
//
//*****************************************************************************
//
// C Usage:    extern long _IQmpyI32frac(long A, long B); // no round or sat
//
//-----------------------------------------------------------------------------
//
// On Entry:   r0     = A in IQ format
//             r1     = B in 32-bit integer (long) format
//
// Regs Used:
//
// On Exit:    r0   = fractional portion of A*B stored as IQ
//
// Q range:    30 to 1
//
//-----------------------------------------------------------------------------
//
// Algorithm:  The fractional portion of the IQ*I32 number is calculated
//             as follows:
//
//    1) Multiply in 32x32->32 mode, and store the sign of the result
//    2) Strip off bits past Q.  For positive results, we are done.
//    3) For negative results, check if there is a fractional portion.
//    4) If there is, subtract one.
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
// _IQ1mpyI32frac
//
//*****************************************************************************
    .section .text._IQ1mpyI32frac
    .globl _IQ1mpyI32frac
    .thumb_func
_IQ1mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 1)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #1, #(32 - 1)

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
// _IQ2mpyI32frac
//
//*****************************************************************************
    .section .text._IQ2mpyI32frac
    .globl _IQ2mpyI32frac
    .thumb_func
_IQ2mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 2)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #2, #(32 - 2)

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
// _IQ3mpyI32frac
//
//*****************************************************************************
    .section .text._IQ3mpyI32frac
    .globl _IQ3mpyI32frac
    .thumb_func
_IQ3mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 3)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #3, #(32 - 3)

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
// _IQ4mpyI32frac
//
//*****************************************************************************
    .section .text._IQ4mpyI32frac
    .globl _IQ4mpyI32frac
    .thumb_func
_IQ4mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 4)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #4, #(32 - 4)

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
// _IQ5mpyI32frac
//
//*****************************************************************************
    .section .text._IQ5mpyI32frac
    .globl _IQ5mpyI32frac
    .thumb_func
_IQ5mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 5)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #5, #(32 - 5)

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
// _IQ6mpyI32frac
//
//*****************************************************************************
    .section .text._IQ6mpyI32frac
    .globl _IQ6mpyI32frac
    .thumb_func
_IQ6mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 6)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #6, #(32 - 6)

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
// _IQ7mpyI32frac
//
//*****************************************************************************
    .section .text._IQ7mpyI32frac
    .globl _IQ7mpyI32frac
    .thumb_func
_IQ7mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 7)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #7, #(32 - 7)

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
// _IQ8mpyI32frac
//
//*****************************************************************************
    .section .text._IQ8mpyI32frac
    .globl _IQ8mpyI32frac
    .thumb_func
_IQ8mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 8)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #8, #(32 - 8)

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
// _IQ9mpyI32frac
//
//*****************************************************************************
    .section .text._IQ9mpyI32frac
    .globl _IQ9mpyI32frac
    .thumb_func
_IQ9mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 9)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #9, #(32 - 9)

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
// _IQ10mpyI32frac
//
//*****************************************************************************
    .section .text._IQ10mpyI32frac
    .globl _IQ10mpyI32frac
    .thumb_func
_IQ10mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 10)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #10, #(32 - 10)

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
// _IQ11mpyI32frac
//
//*****************************************************************************
    .section .text._IQ11mpyI32frac
    .globl _IQ11mpyI32frac
    .thumb_func
_IQ11mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 11)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #11, #(32 - 11)

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
// _IQ12mpyI32frac
//
//*****************************************************************************
    .section .text._IQ12mpyI32frac
    .globl _IQ12mpyI32frac
    .thumb_func
_IQ12mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 12)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #12, #(32 - 12)

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
// _IQ13mpyI32frac
//
//*****************************************************************************
    .section .text._IQ13mpyI32frac
    .globl _IQ13mpyI32frac
    .thumb_func
_IQ13mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 13)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #13, #(32 - 13)

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
// _IQ14mpyI32frac
//
//*****************************************************************************
    .section .text._IQ14mpyI32frac
    .globl _IQ14mpyI32frac
    .thumb_func
_IQ14mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 14)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #14, #(32 - 14)

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
// _IQ15mpyI32frac
//
//*****************************************************************************
    .section .text._IQ15mpyI32frac
    .globl _IQ15mpyI32frac
    .thumb_func
_IQ15mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 15)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #15, #(32 - 15)

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
// _IQ16mpyI32frac
//
//*****************************************************************************
    .section .text._IQ16mpyI32frac
    .globl _IQ16mpyI32frac
    .thumb_func
_IQ16mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 16)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #16, #(32 - 16)

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
// _IQ17mpyI32frac
//
//*****************************************************************************
    .section .text._IQ17mpyI32frac
    .globl _IQ17mpyI32frac
    .thumb_func
_IQ17mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 17)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #17, #(32 - 17)

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
// _IQ18mpyI32frac
//
//*****************************************************************************
    .section .text._IQ18mpyI32frac
    .globl _IQ18mpyI32frac
    .thumb_func
_IQ18mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 18)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #18, #(32 - 18)

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
// _IQ19mpyI32frac
//
//*****************************************************************************
    .section .text._IQ19mpyI32frac
    .globl _IQ19mpyI32frac
    .thumb_func
_IQ19mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 19)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #19, #(32 - 19)

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
// _IQ20mpyI32frac
//
//*****************************************************************************
    .section .text._IQ20mpyI32frac
    .globl _IQ20mpyI32frac
    .thumb_func
_IQ20mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 20)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #20, #(32 - 20)

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
// _IQ21mpyI32frac
//
//*****************************************************************************
    .section .text._IQ21mpyI32frac
    .globl _IQ21mpyI32frac
    .thumb_func
_IQ21mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 21)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #21, #(32 - 21)

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
// _IQ22mpyI32frac
//
//*****************************************************************************
    .section .text._IQ22mpyI32frac
    .globl _IQ22mpyI32frac
    .thumb_func
_IQ22mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 22)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #22, #(32 - 22)

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
// _IQ23mpyI32frac
//
//*****************************************************************************
    .section .text._IQ23mpyI32frac
    .globl _IQ23mpyI32frac
    .thumb_func
_IQ23mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 23)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #23, #(32 - 23)

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
// _IQ24mpyI32frac
//
//*****************************************************************************
    .section .text._IQ24mpyI32frac
    .globl _IQ24mpyI32frac
    .thumb_func
_IQ24mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 24)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #24, #(32 - 24)

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
// _IQ25mpyI32frac
//
//*****************************************************************************
    .section .text._IQ25mpyI32frac
    .globl _IQ25mpyI32frac
    .thumb_func
_IQ25mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 25)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #25, #(32 - 25)

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
// _IQ26mpyI32frac
//
//*****************************************************************************
    .section .text._IQ26mpyI32frac
    .globl _IQ26mpyI32frac
    .thumb_func
_IQ26mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 26)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #26, #(32 - 26)

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
// _IQ27mpyI32frac
//
//*****************************************************************************
    .section .text._IQ27mpyI32frac
    .globl _IQ27mpyI32frac
    .thumb_func
_IQ27mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 27)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #27, #(32 - 27)

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
// _IQ28mpyI32frac
//
//*****************************************************************************
    .section .text._IQ28mpyI32frac
    .globl _IQ28mpyI32frac
    .thumb_func
_IQ28mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 28)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #28, #(32 - 28)

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
// _IQ29mpyI32frac
//
//*****************************************************************************
    .section .text._IQ29mpyI32frac
    .globl _IQ29mpyI32frac
    .thumb_func
_IQ29mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 29)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #29, #(32 - 29)

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
// _IQ30mpyI32frac
//
//*****************************************************************************
    .section .text._IQ30mpyI32frac
    .globl _IQ30mpyI32frac
    .thumb_func
_IQ30mpyI32frac:
    //
    // Perform the multiply in 32x32 -> 32 mode.
    // This will over flow, but we do not need the upper 32 bits.
    // Also, the sign of the result is stored in the flags.
    //
    muls    r0, r1, r0

    //
    // Store the sign of the final result in r2.
    // The case of -.0 is handled as +.0 : Otherwise, it would be come -1.0
    //
    ite     mi
        mvnmi   r2, #0x00000000
        movpl   r2, #0x00000000
    lsls    r1, r0, #(32 - 30)
    it      eq
        moveq   r2, #0x00000000

    //
    // Overwrite the Integer bits with the sign information in r2.
    //
    bfi     r0, r2, #30, #(32 - 30)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

    .end
