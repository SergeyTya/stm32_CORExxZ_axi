//*****************************************************************************
//
// IQrsmpy.S - Fixed point multiply with rounding and saturation
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNrsmpy
//
//*****************************************************************************
//
// C Usage:    extern long _IQNrsmpy(long M, long X); // with round and sat
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
//                result = saturate ( (A*B >> q_value)+result[-1] );
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
// _IQ1rsmpy
//
//*****************************************************************************
    .section .text._IQ1rsmpy
    .globl _IQ1rsmpy
    .thumb_func
_IQ1rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    add     r2, r1, #1
    asr     r3, r2, #1
    cbnz    r3, saturated1

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated1:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ2rsmpy
//
//*****************************************************************************
    .section .text._IQ2rsmpy
    .globl _IQ2rsmpy
    .thumb_func
_IQ2rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(2 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated2

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated2:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ3rsmpy
//
//*****************************************************************************
    .section .text._IQ3rsmpy
    .globl _IQ3rsmpy
    .thumb_func
_IQ3rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(3 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated3

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated3:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ4rsmpy
//
//*****************************************************************************
    .section .text._IQ4rsmpy
    .globl _IQ4rsmpy
    .thumb_func
_IQ4rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(4 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated4

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated4:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ5rsmpy
//
//*****************************************************************************
    .section .text._IQ5rsmpy
    .globl _IQ5rsmpy
    .thumb_func
_IQ5rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(5 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated5

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated5:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ6rsmpy
//
//*****************************************************************************
    .section .text._IQ6rsmpy
    .globl _IQ6rsmpy
    .thumb_func
_IQ6rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(6 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated6

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated6:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ7rsmpy
//
//*****************************************************************************
    .section .text._IQ7rsmpy
    .globl _IQ7rsmpy
    .thumb_func
_IQ7rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(7 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated7

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated7:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ8rsmpy
//
//*****************************************************************************
    .section .text._IQ8rsmpy
    .globl _IQ8rsmpy
    .thumb_func
_IQ8rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(8 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated8

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated8:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ9rsmpy
//
//*****************************************************************************
    .section .text._IQ9rsmpy
    .globl _IQ9rsmpy
    .thumb_func
_IQ9rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(9 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated9

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated9:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ10rsmpy
//
//*****************************************************************************
    .section .text._IQ10rsmpy
    .globl _IQ10rsmpy
    .thumb_func
_IQ10rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(10 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated10

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated10:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ11rsmpy
//
//*****************************************************************************
    .section .text._IQ11rsmpy
    .globl _IQ11rsmpy
    .thumb_func
_IQ11rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(11 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated11

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated11:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ12rsmpy
//
//*****************************************************************************
    .section .text._IQ12rsmpy
    .globl _IQ12rsmpy
    .thumb_func
_IQ12rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(12 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated12

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated12:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ13rsmpy
//
//*****************************************************************************
    .section .text._IQ13rsmpy
    .globl _IQ13rsmpy
    .thumb_func
_IQ13rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(13 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated13

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated13:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ14rsmpy
//
//*****************************************************************************
    .section .text._IQ14rsmpy
    .globl _IQ14rsmpy
    .thumb_func
_IQ14rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(14 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated14

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated14:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ15rsmpy
//
//*****************************************************************************
    .section .text._IQ15rsmpy
    .globl _IQ15rsmpy
    .thumb_func
_IQ15rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(15 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated15

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated15:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ16rsmpy
//
//*****************************************************************************
    .section .text._IQ16rsmpy
    .globl _IQ16rsmpy
    .thumb_func
_IQ16rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(16 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated16

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated16:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ17rsmpy
//
//*****************************************************************************
    .section .text._IQ17rsmpy
    .globl _IQ17rsmpy
    .thumb_func
_IQ17rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(17 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated17

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated17:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ18rsmpy
//
//*****************************************************************************
    .section .text._IQ18rsmpy
    .globl _IQ18rsmpy
    .thumb_func
_IQ18rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(18 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated18

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated18:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ19rsmpy
//
//*****************************************************************************
    .section .text._IQ19rsmpy
    .globl _IQ19rsmpy
    .thumb_func
_IQ19rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(19 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated19

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated19:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ20rsmpy
//
//*****************************************************************************
    .section .text._IQ20rsmpy
    .globl _IQ20rsmpy
    .thumb_func
_IQ20rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(20 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated20

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated20:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ21rsmpy
//
//*****************************************************************************
    .section .text._IQ21rsmpy
    .globl _IQ21rsmpy
    .thumb_func
_IQ21rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(21 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated21

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated21:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ22rsmpy
//
//*****************************************************************************
    .section .text._IQ22rsmpy
    .globl _IQ22rsmpy
    .thumb_func
_IQ22rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(22 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated22

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated22:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ23rsmpy
//
//*****************************************************************************
    .section .text._IQ23rsmpy
    .globl _IQ23rsmpy
    .thumb_func
_IQ23rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(23 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated23

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated23:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ24rsmpy
//
//*****************************************************************************
    .section .text._IQ24rsmpy
    .globl _IQ24rsmpy
    .thumb_func
_IQ24rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(24 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated24

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated24:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ25rsmpy
//
//*****************************************************************************
    .section .text._IQ25rsmpy
    .globl _IQ25rsmpy
    .thumb_func
_IQ25rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(25 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated25

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated25:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ26rsmpy
//
//*****************************************************************************
    .section .text._IQ26rsmpy
    .globl _IQ26rsmpy
    .thumb_func
_IQ26rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(26 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated26

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated26:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ27rsmpy
//
//*****************************************************************************
    .section .text._IQ27rsmpy
    .globl _IQ27rsmpy
    .thumb_func
_IQ27rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(27 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated27

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated27:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ28rsmpy
//
//*****************************************************************************
    .section .text._IQ28rsmpy
    .globl _IQ28rsmpy
    .thumb_func
_IQ28rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(28 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated28

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated28:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ29rsmpy
//
//*****************************************************************************
    .section .text._IQ29rsmpy
    .globl _IQ29rsmpy
    .thumb_func
_IQ29rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(29 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated29

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated29:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ30rsmpy
//
//*****************************************************************************
    .section .text._IQ30rsmpy
    .globl _IQ30rsmpy
    .thumb_func
_IQ30rsmpy:
    //
    // Perform a 32x32-> 64 bit signed multiply
    //
    smull   r0, r1, r0, r1

    //
    // Test for Saturation
    // This is done by shifting the high 32 down so that only
    // saturating bits are present.  Unsaturated, this will be
    // all ones or all zeros.  Add 1 and shift down, unsaturated
    // will create all zeros.
    //
    // The typical saturate instruction takes just as long, but
    // does not provide a sign flag.
    //
    asr     r2, r1, #(30 - 1)
    add     r2, r2, #1
    asr     r3, r2, #1
    cbnz    r3, saturated30

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
    // Saturated Branch
    // R3 is used as a sign flag.  Shifted down, it is pure zeros or ones.
    // This is XORed with a constant to create the return values.
saturated30:
    mvn     r0, #0x80000000
    eor     r0, r0, r3, asr #32
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

    .end
