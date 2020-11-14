//*****************************************************************************
//
// IQmag.S - Fixed point magnitude
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNmag
//
//*****************************************************************************
//
// C Usage:    extern long _IQNmag(long X, long Y); // with rounding & sat
//
//-----------------------------------------------------------------------------
//
// On Entry:   r0    = X in IQ format
//             r1    = Y in IQ format
//
// Regs Used:  r0-r4
//             r4 is pushed/popped to prevent clobbering.
//
// On Exit:    r0    = sqrt(X) result in IQ format
//             r0    = 0 if input is -ve or 0
//
//                      Note: The square root of any number will never
//                            overflow, hence saturation is not required.
//
// Q range:    30 to 1
//
//-----------------------------------------------------------------------------
//
// Algorithm:  The procedure for calculating "Y = sqrt(X)" is as follows:
//
//      Step 1)  Calculate Z = isqrt(X).  See _IQisqrt.S for details.
//
//      Step 2)  Calculate Y = sqrt(X) = X*isqrt(X) = Z*x
//
//      Step 3) Denormalize result and round
//
//##### INTERNAL BEGIN #####
//-----------------------------------------------------------------------------
//
// Benchmark:
//
//  Q <= 20, L is even :
//  Q <= 20, L is odd  :
//  Q >  20, L is even :
//  Q >  20, L is odd  :
//  Negative or Zero   :
//  Overflow           :
//
//##### INTERNAL END #####
//*****************************************************************************

    .syntax unified
    .thumb
    .text

//*****************************************************************************
//
// The isqrt table is used.
//
//*****************************************************************************
    .extern isqrt_table

//*****************************************************************************
//
// _IQ1mag
//
//*****************************************************************************
    .section .text._IQ1mag
    .globl _IQ1mag
    .thumb_func
_IQ1mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_1
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow1
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_1
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow1:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_1:
    .word isqrt_table - 0x800
sqrt_half_1:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ2mag
//
//*****************************************************************************
    .section .text._IQ2mag
    .globl _IQ2mag
    .thumb_func
_IQ2mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_2
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow2
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_2
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow2:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_2:
    .word isqrt_table - 0x800
sqrt_half_2:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ3mag
//
//*****************************************************************************
    .section .text._IQ3mag
    .globl _IQ3mag
    .thumb_func
_IQ3mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_3
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow3
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_3
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow3:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_3:
    .word isqrt_table - 0x800
sqrt_half_3:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ4mag
//
//*****************************************************************************
    .section .text._IQ4mag
    .globl _IQ4mag
    .thumb_func
_IQ4mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_4
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow4
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_4
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow4:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_4:
    .word isqrt_table - 0x800
sqrt_half_4:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ5mag
//
//*****************************************************************************
    .section .text._IQ5mag
    .globl _IQ5mag
    .thumb_func
_IQ5mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_5
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow5
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_5
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow5:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_5:
    .word isqrt_table - 0x800
sqrt_half_5:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ6mag
//
//*****************************************************************************
    .section .text._IQ6mag
    .globl _IQ6mag
    .thumb_func
_IQ6mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_6
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow6
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_6
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow6:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_6:
    .word isqrt_table - 0x800
sqrt_half_6:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ7mag
//
//*****************************************************************************
    .section .text._IQ7mag
    .globl _IQ7mag
    .thumb_func
_IQ7mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_7
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow7
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_7
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow7:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_7:
    .word isqrt_table - 0x800
sqrt_half_7:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ8mag
//
//*****************************************************************************
    .section .text._IQ8mag
    .globl _IQ8mag
    .thumb_func
_IQ8mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_8
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow8
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_8
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow8:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_8:
    .word isqrt_table - 0x800
sqrt_half_8:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ9mag
//
//*****************************************************************************
    .section .text._IQ9mag
    .globl _IQ9mag
    .thumb_func
_IQ9mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_9
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow9
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_9
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow9:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_9:
    .word isqrt_table - 0x800
sqrt_half_9:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ10mag
//
//*****************************************************************************
    .section .text._IQ10mag
    .globl _IQ10mag
    .thumb_func
_IQ10mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_10
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow10
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_10
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow10:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_10:
    .word isqrt_table - 0x800
sqrt_half_10:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ11mag
//
//*****************************************************************************
    .section .text._IQ11mag
    .globl _IQ11mag
    .thumb_func
_IQ11mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_11
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow11
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_11
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow11:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_11:
    .word isqrt_table - 0x800
sqrt_half_11:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ12mag
//
//*****************************************************************************
    .section .text._IQ12mag
    .globl _IQ12mag
    .thumb_func
_IQ12mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_12
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow12
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_12
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow12:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_12:
    .word isqrt_table - 0x800
sqrt_half_12:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ13mag
//
//*****************************************************************************
    .section .text._IQ13mag
    .globl _IQ13mag
    .thumb_func
_IQ13mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_13
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow13
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_13
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow13:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_13:
    .word isqrt_table - 0x800
sqrt_half_13:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ14mag
//
//*****************************************************************************
    .section .text._IQ14mag
    .globl _IQ14mag
    .thumb_func
_IQ14mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_14
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow14
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_14
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow14:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_14:
    .word isqrt_table - 0x800
sqrt_half_14:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ15mag
//
//*****************************************************************************
    .section .text._IQ15mag
    .globl _IQ15mag
    .thumb_func
_IQ15mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_15
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow15
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_15
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow15:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_15:
    .word isqrt_table - 0x800
sqrt_half_15:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ16mag
//
//*****************************************************************************
    .section .text._IQ16mag
    .globl _IQ16mag
    .thumb_func
_IQ16mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_16
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow16
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_16
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow16:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_16:
    .word isqrt_table - 0x800
sqrt_half_16:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ17mag
//
//*****************************************************************************
    .section .text._IQ17mag
    .globl _IQ17mag
    .thumb_func
_IQ17mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_17
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow17
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_17
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow17:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_17:
    .word isqrt_table - 0x800
sqrt_half_17:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ18mag
//
//*****************************************************************************
    .section .text._IQ18mag
    .globl _IQ18mag
    .thumb_func
_IQ18mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_18
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow18
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_18
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow18:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_18:
    .word isqrt_table - 0x800
sqrt_half_18:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ19mag
//
//*****************************************************************************
    .section .text._IQ19mag
    .globl _IQ19mag
    .thumb_func
_IQ19mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_19
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow19
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_19
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow19:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_19:
    .word isqrt_table - 0x800
sqrt_half_19:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ20mag
//
//*****************************************************************************
    .section .text._IQ20mag
    .globl _IQ20mag
    .thumb_func
_IQ20mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_20
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow20
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_20
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow20:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_20:
    .word isqrt_table - 0x800
sqrt_half_20:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ21mag
//
//*****************************************************************************
    .section .text._IQ21mag
    .globl _IQ21mag
    .thumb_func
_IQ21mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_21
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow21
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_21
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow21:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_21:
    .word isqrt_table - 0x800
sqrt_half_21:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ22mag
//
//*****************************************************************************
    .section .text._IQ22mag
    .globl _IQ22mag
    .thumb_func
_IQ22mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_22
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow22
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_22
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow22:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_22:
    .word isqrt_table - 0x800
sqrt_half_22:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ23mag
//
//*****************************************************************************
    .section .text._IQ23mag
    .globl _IQ23mag
    .thumb_func
_IQ23mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_23
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow23
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_23
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow23:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_23:
    .word isqrt_table - 0x800
sqrt_half_23:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ24mag
//
//*****************************************************************************
    .section .text._IQ24mag
    .globl _IQ24mag
    .thumb_func
_IQ24mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_24
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow24
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_24
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow24:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_24:
    .word isqrt_table - 0x800
sqrt_half_24:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ25mag
//
//*****************************************************************************
    .section .text._IQ25mag
    .globl _IQ25mag
    .thumb_func
_IQ25mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_25
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow25
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_25
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow25:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_25:
    .word isqrt_table - 0x800
sqrt_half_25:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ26mag
//
//*****************************************************************************
    .section .text._IQ26mag
    .globl _IQ26mag
    .thumb_func
_IQ26mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_26
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow26
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_26
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow26:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_26:
    .word isqrt_table - 0x800
sqrt_half_26:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ27mag
//
//*****************************************************************************
    .section .text._IQ27mag
    .globl _IQ27mag
    .thumb_func
_IQ27mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_27
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow27
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_27
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow27:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_27:
    .word isqrt_table - 0x800
sqrt_half_27:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ28mag
//
//*****************************************************************************
    .section .text._IQ28mag
    .globl _IQ28mag
    .thumb_func
_IQ28mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_28
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow28
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_28
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow28:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_28:
    .word isqrt_table - 0x800
sqrt_half_28:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ29mag
//
//*****************************************************************************
    .section .text._IQ29mag
    .globl _IQ29mag
    .thumb_func
_IQ29mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_29
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow29
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_29
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow29:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_29:
    .word isqrt_table - 0x800
sqrt_half_29:
    .word 0xb504f334         // sqrt(1/2) in Q32

//*****************************************************************************
//
// _IQ30mag
//
//*****************************************************************************
    .section .text._IQ30mag
    .globl _IQ30mag
    .thumb_func
_IQ30mag:
    //
    // Save non-volatile registers.
    //
    push    {r4, lr}

    //
    // Sum of Squares
    // Keep 64 bit version in r12lr
    // Place 32 bit version in r0
    //
    smull   r12, lr, r0, r0
    smlal   r12, lr, r1, r1

    //
    // Place upper 32 used bits of result into r0, effectively creating a
    // normalized Q32 representation.
    // This is implemented as a 64 bit clz shift followed
    // by a 32 bit clz shift.
    // Total shift amount is stored in r3
    //
    clz     r3, lr
    rsb     r2, r3, #32
    lsrs    r0, r12, r2
    lsl     r1, lr, r3
    adcs    r0, r0, r1
    ittt    pl
        clzpl   r2, r0
        lslpl   r0, r0, r2
        addpl   r3, r2, r3

    //
    // If the result is 0, bail early.
    // We are guaranteed that the result is not negative,
    // so those checks are omitted.
    //
    teq     r0, #0
    it      eq
        popeq  {r4, pc}

    //
    // Table Lookup for Initial Estimate
    // Uses  the top 9 actual bits as index
    // The top bit (#10) is ignored, because it is always one.  This is done
    // with the -0x800.  (0x200 is 10th bit, shift up two for 4 byte words).
    //
    lsr     r2, r0, #(32 - 10)
    ldr     r1, isqrt_table_30
    ldr     r1, [r1, r2, lsl #2]

    //
    // Newton Raphson Iteration  #1
    // 11-17 Cycles
    // r0 is Q32, r1 is Q31
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   r4, r2, r0, r1
    umull   r4, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   r4, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    subs    r3, r3, #2
    bmi     mag_will_overflow30
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_30
        umullcs r2, r1, r2, r1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   r4, r0, r0, r1

    //
    // Actually denormalize per above preparation
    // Round result
    // Note:  If r3 == 0, no rounding is performed.  This potentially creates
    // an additional count worth of error if the result is nearly saturated.
    // The extra execution time to check for this is not worthwhile.
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Restore r4 and return.
    ///
    pop     {r4, pc}

    //
    // The result will overflow.
    //
mag_will_overflow30:
    mvn     r0, #0x80000000
    pop     {r4, pc}

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_30:
    .word isqrt_table - 0x800
sqrt_half_30:
    .word 0xb504f334         // sqrt(1/2) in Q32

    .end
