//*****************************************************************************
//
// IQmpyI32int.S - Find integer portion of multiplying IQ by I32
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNmpyI32int
//
//*****************************************************************************
//
// C Usage:    extern long _IQmpyI32int(long A, long B); // no round or sat
//
//-----------------------------------------------------------------------------
//
// On Entry:   r0     = A in IQ format
//             r1     = B in 32-bit integer (long) format
//
// Regs Used:  r0, r1
//
// On Exit:    r0     = integer portion of A*B stored as "long"
//
// Q range:    30 to 1
//
//-----------------------------------------------------------------------------
//
// Algorithm:  The integer portion of the IQ*I32 number is calculated
//             as follows:
//
//                integer = A*B >> q_value;
//
//-----------------------------------------------------------------------------
//
// Benchmark:
//
// Cycles = 7-10 (not including call)
//
//*****************************************************************************

    .syntax unified
    .thumb
    .text

//*****************************************************************************
//
// _IQ1mpyI32int
//
//*****************************************************************************
    .section .text._IQ1mpyI32int
    .globl _IQ1mpyI32int
    .thumb_func
_IQ1mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative1
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        adds    r0, r0, #((1 << 1) - 1)
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative1:
    lsr     r0, r0, #1
    orr     r0, r0, r1, lsl #(32 - 1)

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
// _IQ2mpyI32int
//
//*****************************************************************************
    .section .text._IQ2mpyI32int
    .globl _IQ2mpyI32int
    .thumb_func
_IQ2mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative2
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        adds    r0, r0, #((1 << 2) - 1)
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative2:
    lsr     r0, r0, #2
    orr     r0, r0, r1, lsl #(32 - 2)

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
// _IQ3mpyI32int
//
//*****************************************************************************
    .section .text._IQ3mpyI32int
    .globl _IQ3mpyI32int
    .thumb_func
_IQ3mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative3
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        adds    r0, r0, #((1 << 3) - 1)
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative3:
    lsr     r0, r0, #3
    orr     r0, r0, r1, lsl #(32 - 3)

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
// _IQ4mpyI32int
//
//*****************************************************************************
    .section .text._IQ4mpyI32int
    .globl _IQ4mpyI32int
    .thumb_func
_IQ4mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative4
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        adds    r0, r0, #((1 << 4) - 1)
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative4:
    lsr     r0, r0, #4
    orr     r0, r0, r1, lsl #(32 - 4)

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
// _IQ5mpyI32int
//
//*****************************************************************************
    .section .text._IQ5mpyI32int
    .globl _IQ5mpyI32int
    .thumb_func
_IQ5mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative5
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        adds    r0, r0, #((1 << 5) - 1)
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative5:
    lsr     r0, r0, #5
    orr     r0, r0, r1, lsl #(32 - 5)

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
// _IQ6mpyI32int
//
//*****************************************************************************
    .section .text._IQ6mpyI32int
    .globl _IQ6mpyI32int
    .thumb_func
_IQ6mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative6
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        adds    r0, r0, #((1 << 6) - 1)
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative6:
    lsr     r0, r0, #6
    orr     r0, r0, r1, lsl #(32 - 6)

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
// _IQ7mpyI32int
//
//*****************************************************************************
    .section .text._IQ7mpyI32int
    .globl _IQ7mpyI32int
    .thumb_func
_IQ7mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative7
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        adds    r0, r0, #((1 << 7) - 1)
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative7:
    lsr     r0, r0, #7
    orr     r0, r0, r1, lsl #(32 - 7)

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
// _IQ8mpyI32int
//
//*****************************************************************************
    .section .text._IQ8mpyI32int
    .globl _IQ8mpyI32int
    .thumb_func
_IQ8mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative8
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        adds    r0, r0, #((1 << 8) - 1)
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative8:
    lsr     r0, r0, #8
    orr     r0, r0, r1, lsl #(32 - 8)

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
// _IQ9mpyI32int
//
//*****************************************************************************
    .section .text._IQ9mpyI32int
    .globl _IQ9mpyI32int
    .thumb_func
_IQ9mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative9
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 9)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative9:
    lsr     r0, r0, #9
    orr     r0, r0, r1, lsl #(32 - 9)

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
// _IQ10mpyI32int
//
//*****************************************************************************
    .section .text._IQ10mpyI32int
    .globl _IQ10mpyI32int
    .thumb_func
_IQ10mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative10
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 10)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative10:
    lsr     r0, r0, #10
    orr     r0, r0, r1, lsl #(32 - 10)

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
// _IQ11mpyI32int
//
//*****************************************************************************
    .section .text._IQ11mpyI32int
    .globl _IQ11mpyI32int
    .thumb_func
_IQ11mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative11
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 11)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative11:
    lsr     r0, r0, #11
    orr     r0, r0, r1, lsl #(32 - 11)

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
// _IQ12mpyI32int
//
//*****************************************************************************
    .section .text._IQ12mpyI32int
    .globl _IQ12mpyI32int
    .thumb_func
_IQ12mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative12
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 12)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative12:
    lsr     r0, r0, #12
    orr     r0, r0, r1, lsl #(32 - 12)

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
// _IQ13mpyI32int
//
//*****************************************************************************
    .section .text._IQ13mpyI32int
    .globl _IQ13mpyI32int
    .thumb_func
_IQ13mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative13
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 13)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative13:
    lsr     r0, r0, #13
    orr     r0, r0, r1, lsl #(32 - 13)

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
// _IQ14mpyI32int
//
//*****************************************************************************
    .section .text._IQ14mpyI32int
    .globl _IQ14mpyI32int
    .thumb_func
_IQ14mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative14
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 14)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative14:
    lsr     r0, r0, #14
    orr     r0, r0, r1, lsl #(32 - 14)

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
// _IQ15mpyI32int
//
//*****************************************************************************
    .section .text._IQ15mpyI32int
    .globl _IQ15mpyI32int
    .thumb_func
_IQ15mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative15
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 15)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative15:
    lsr     r0, r0, #15
    orr     r0, r0, r1, lsl #(32 - 15)

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
// _IQ16mpyI32int
//
//*****************************************************************************
    .section .text._IQ16mpyI32int
    .globl _IQ16mpyI32int
    .thumb_func
_IQ16mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative16
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 16)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative16:
    lsr     r0, r0, #16
    orr     r0, r0, r1, lsl #(32 - 16)

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
// _IQ17mpyI32int
//
//*****************************************************************************
    .section .text._IQ17mpyI32int
    .globl _IQ17mpyI32int
    .thumb_func
_IQ17mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative17
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 17)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative17:
    lsr     r0, r0, #17
    orr     r0, r0, r1, lsl #(32 - 17)

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
// _IQ18mpyI32int
//
//*****************************************************************************
    .section .text._IQ18mpyI32int
    .globl _IQ18mpyI32int
    .thumb_func
_IQ18mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative18
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 18)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative18:
    lsr     r0, r0, #18
    orr     r0, r0, r1, lsl #(32 - 18)

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
// _IQ19mpyI32int
//
//*****************************************************************************
    .section .text._IQ19mpyI32int
    .globl _IQ19mpyI32int
    .thumb_func
_IQ19mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative19
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 19)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative19:
    lsr     r0, r0, #19
    orr     r0, r0, r1, lsl #(32 - 19)

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
// _IQ20mpyI32int
//
//*****************************************************************************
    .section .text._IQ20mpyI32int
    .globl _IQ20mpyI32int
    .thumb_func
_IQ20mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative20
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 20)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative20:
    lsr     r0, r0, #20
    orr     r0, r0, r1, lsl #(32 - 20)

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
// _IQ21mpyI32int
//
//*****************************************************************************
    .section .text._IQ21mpyI32int
    .globl _IQ21mpyI32int
    .thumb_func
_IQ21mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative21
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 21)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative21:
    lsr     r0, r0, #21
    orr     r0, r0, r1, lsl #(32 - 21)

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
// _IQ22mpyI32int
//
//*****************************************************************************
    .section .text._IQ22mpyI32int
    .globl _IQ22mpyI32int
    .thumb_func
_IQ22mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative22
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 22)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative22:
    lsr     r0, r0, #22
    orr     r0, r0, r1, lsl #(32 - 22)

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
// _IQ23mpyI32int
//
//*****************************************************************************
    .section .text._IQ23mpyI32int
    .globl _IQ23mpyI32int
    .thumb_func
_IQ23mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative23
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mov     r2, #(1 << 23)
        sub     r2, r2, #1
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative23:
    lsr     r0, r0, #23
    orr     r0, r0, r1, lsl #(32 - 23)

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
// _IQ24mpyI32int
//
//*****************************************************************************
    .section .text._IQ24mpyI32int
    .globl _IQ24mpyI32int
    .thumb_func
_IQ24mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative24
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mvn     r2, #((0xff000000 << (24 - 24)) & 0xff000000)
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative24:
    lsr     r0, r0, #24
    orr     r0, r0, r1, lsl #(32 - 24)

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
// _IQ25mpyI32int
//
//*****************************************************************************
    .section .text._IQ25mpyI32int
    .globl _IQ25mpyI32int
    .thumb_func
_IQ25mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative25
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mvn     r2, #((0xff000000 << (25 - 24)) & 0xff000000)
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative25:
    lsr     r0, r0, #25
    orr     r0, r0, r1, lsl #(32 - 25)

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
// _IQ26mpyI32int
//
//*****************************************************************************
    .section .text._IQ26mpyI32int
    .globl _IQ26mpyI32int
    .thumb_func
_IQ26mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative26
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mvn     r2, #((0xff000000 << (26 - 24)) & 0xff000000)
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative26:
    lsr     r0, r0, #26
    orr     r0, r0, r1, lsl #(32 - 26)

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
// _IQ27mpyI32int
//
//*****************************************************************************
    .section .text._IQ27mpyI32int
    .globl _IQ27mpyI32int
    .thumb_func
_IQ27mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative27
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mvn     r2, #((0xff000000 << (27 - 24)) & 0xff000000)
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative27:
    lsr     r0, r0, #27
    orr     r0, r0, r1, lsl #(32 - 27)

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
// _IQ28mpyI32int
//
//*****************************************************************************
    .section .text._IQ28mpyI32int
    .globl _IQ28mpyI32int
    .thumb_func
_IQ28mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative28
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mvn     r2, #((0xff000000 << (28 - 24)) & 0xff000000)
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative28:
    lsr     r0, r0, #28
    orr     r0, r0, r1, lsl #(32 - 28)

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
// _IQ29mpyI32int
//
//*****************************************************************************
    .section .text._IQ29mpyI32int
    .globl _IQ29mpyI32int
    .thumb_func
_IQ29mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative29
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mvn     r2, #((0xff000000 << (29 - 24)) & 0xff000000)
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative29:
    lsr     r0, r0, #29
    orr     r0, r0, r1, lsl #(32 - 29)

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
// _IQ30mpyI32int
//
//*****************************************************************************
    .section .text._IQ30mpyI32int
    .globl _IQ30mpyI32int
    .thumb_func
_IQ30mpyI32int:
    //
    // Perform a signed 32->64 bit multiply
    //
    smull   r0, r1, r0, r1

    //
    // See if the result is negative.
    //
    cmp     r1, #0
    bpl     not_negative30
        //
        // Since the result is negative, add 0.99999999 to the result so that
        // must fully reach -1 to return -1, fully reach -2 to return -2, and
        // so on.
        //
        mvn     r2, #((0xff000000 << (30 - 24)) & 0xff000000)
        adds    r0, r0, r2
        adc     r1, r1, #0

    //
    // Shift the result down by Q
    //
not_negative30:
    lsr     r0, r0, #30
    orr     r0, r0, r1, lsl #(32 - 30)

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

    .end
