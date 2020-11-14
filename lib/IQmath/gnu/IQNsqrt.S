//*****************************************************************************
//
// IQsqrt.S - Fixed point square root
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNsqrt
//
//*****************************************************************************
//
// C Usage:    extern long _IQNsqrt(long X); // with rounding
//
//-----------------------------------------------------------------------------
//
// On Entry:   r0    = X in IQ format
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
// _IQ1sqrt
//
//*****************************************************************************
    .section .text._IQ1sqrt
    .globl _IQ1sqrt
    .thumb_func
_IQ1sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero1
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 1)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_1
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero1:
    mov     r0, #0
    bx      lr

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
// _IQ2sqrt
//
//*****************************************************************************
    .section .text._IQ2sqrt
    .globl _IQ2sqrt
    .thumb_func
_IQ2sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero2
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 2)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_2
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero2:
    mov     r0, #0
    bx      lr

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
// _IQ3sqrt
//
//*****************************************************************************
    .section .text._IQ3sqrt
    .globl _IQ3sqrt
    .thumb_func
_IQ3sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero3
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 3)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_3
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero3:
    mov     r0, #0
    bx      lr

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
// _IQ4sqrt
//
//*****************************************************************************
    .section .text._IQ4sqrt
    .globl _IQ4sqrt
    .thumb_func
_IQ4sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero4
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 4)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_4
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero4:
    mov     r0, #0
    bx      lr

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
// _IQ5sqrt
//
//*****************************************************************************
    .section .text._IQ5sqrt
    .globl _IQ5sqrt
    .thumb_func
_IQ5sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero5
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 5)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_5
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero5:
    mov     r0, #0
    bx      lr

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
// _IQ6sqrt
//
//*****************************************************************************
    .section .text._IQ6sqrt
    .globl _IQ6sqrt
    .thumb_func
_IQ6sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero6
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 6)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_6
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero6:
    mov     r0, #0
    bx      lr

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
// _IQ7sqrt
//
//*****************************************************************************
    .section .text._IQ7sqrt
    .globl _IQ7sqrt
    .thumb_func
_IQ7sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero7
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 7)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_7
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero7:
    mov     r0, #0
    bx      lr

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
// _IQ8sqrt
//
//*****************************************************************************
    .section .text._IQ8sqrt
    .globl _IQ8sqrt
    .thumb_func
_IQ8sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero8
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 8)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_8
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero8:
    mov     r0, #0
    bx      lr

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
// _IQ9sqrt
//
//*****************************************************************************
    .section .text._IQ9sqrt
    .globl _IQ9sqrt
    .thumb_func
_IQ9sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero9
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 9)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_9
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero9:
    mov     r0, #0
    bx      lr

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
// _IQ10sqrt
//
//*****************************************************************************
    .section .text._IQ10sqrt
    .globl _IQ10sqrt
    .thumb_func
_IQ10sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero10
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 10)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_10
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero10:
    mov     r0, #0
    bx      lr

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
// _IQ11sqrt
//
//*****************************************************************************
    .section .text._IQ11sqrt
    .globl _IQ11sqrt
    .thumb_func
_IQ11sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero11
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 11)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_11
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero11:
    mov     r0, #0
    bx      lr

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
// _IQ12sqrt
//
//*****************************************************************************
    .section .text._IQ12sqrt
    .globl _IQ12sqrt
    .thumb_func
_IQ12sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero12
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 12)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_12
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero12:
    mov     r0, #0
    bx      lr

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
// _IQ13sqrt
//
//*****************************************************************************
    .section .text._IQ13sqrt
    .globl _IQ13sqrt
    .thumb_func
_IQ13sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero13
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 13)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_13
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero13:
    mov     r0, #0
    bx      lr

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
// _IQ14sqrt
//
//*****************************************************************************
    .section .text._IQ14sqrt
    .globl _IQ14sqrt
    .thumb_func
_IQ14sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero14
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 14)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_14
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero14:
    mov     r0, #0
    bx      lr

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
// _IQ15sqrt
//
//*****************************************************************************
    .section .text._IQ15sqrt
    .globl _IQ15sqrt
    .thumb_func
_IQ15sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero15
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 15)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_15
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero15:
    mov     r0, #0
    bx      lr

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
// _IQ16sqrt
//
//*****************************************************************************
    .section .text._IQ16sqrt
    .globl _IQ16sqrt
    .thumb_func
_IQ16sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero16
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 16)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_16
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero16:
    mov     r0, #0
    bx      lr

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
// _IQ17sqrt
//
//*****************************************************************************
    .section .text._IQ17sqrt
    .globl _IQ17sqrt
    .thumb_func
_IQ17sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero17
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 17)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_17
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero17:
    mov     r0, #0
    bx      lr

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
// _IQ18sqrt
//
//*****************************************************************************
    .section .text._IQ18sqrt
    .globl _IQ18sqrt
    .thumb_func
_IQ18sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero18
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 18)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_18
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero18:
    mov     r0, #0
    bx      lr

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
// _IQ19sqrt
//
//*****************************************************************************
    .section .text._IQ19sqrt
    .globl _IQ19sqrt
    .thumb_func
_IQ19sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero19
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 19)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_19
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero19:
    mov     r0, #0
    bx      lr

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
// _IQ20sqrt
//
//*****************************************************************************
    .section .text._IQ20sqrt
    .globl _IQ20sqrt
    .thumb_func
_IQ20sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero20
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 20)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_20
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero20:
    mov     r0, #0
    bx      lr

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
// _IQ21sqrt
//
//*****************************************************************************
    .section .text._IQ21sqrt
    .globl _IQ21sqrt
    .thumb_func
_IQ21sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero21
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 21)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_21
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero21:
    mov     r0, #0
    bx      lr

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
// _IQ22sqrt
//
//*****************************************************************************
    .section .text._IQ22sqrt
    .globl _IQ22sqrt
    .thumb_func
_IQ22sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero22
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 22)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_22
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero22:
    mov     r0, #0
    bx      lr

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
// _IQ23sqrt
//
//*****************************************************************************
    .section .text._IQ23sqrt
    .globl _IQ23sqrt
    .thumb_func
_IQ23sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero23
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 23)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_23
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero23:
    mov     r0, #0
    bx      lr

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
// _IQ24sqrt
//
//*****************************************************************************
    .section .text._IQ24sqrt
    .globl _IQ24sqrt
    .thumb_func
_IQ24sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero24
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 24)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_24
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero24:
    mov     r0, #0
    bx      lr

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
// _IQ25sqrt
//
//*****************************************************************************
    .section .text._IQ25sqrt
    .globl _IQ25sqrt
    .thumb_func
_IQ25sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero25
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 25)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_25
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero25:
    mov     r0, #0
    bx      lr

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
// _IQ26sqrt
//
//*****************************************************************************
    .section .text._IQ26sqrt
    .globl _IQ26sqrt
    .thumb_func
_IQ26sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero26
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 26)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_26
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero26:
    mov     r0, #0
    bx      lr

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
// _IQ27sqrt
//
//*****************************************************************************
    .section .text._IQ27sqrt
    .globl _IQ27sqrt
    .thumb_func
_IQ27sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero27
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 27)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_27
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero27:
    mov     r0, #0
    bx      lr

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
// _IQ28sqrt
//
//*****************************************************************************
    .section .text._IQ28sqrt
    .globl _IQ28sqrt
    .thumb_func
_IQ28sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero28
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 28)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_28
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero28:
    mov     r0, #0
    bx      lr

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
// _IQ29sqrt
//
//*****************************************************************************
    .section .text._IQ29sqrt
    .globl _IQ29sqrt
    .thumb_func
_IQ29sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero29
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 29)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_29
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero29:
    mov     r0, #0
    bx      lr

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
// _IQ30sqrt
//
//*****************************************************************************
    .section .text._IQ30sqrt
    .globl _IQ30sqrt
    .thumb_func
_IQ30sqrt:
    //
    // Normalize Input to (1.0 0.5) in Q32
    // If the input is zero or negative, bail out early
    //
    clz     r3, r0
    and     r2, r3, #0x1F
    cbz     r2, sqrt_neg_or_zero30
    lsl     r0, r0, r3

    //
    // Push lr on to the stack so it can be used as temporary space
    //
    push    {lr}

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
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Newton Raphson Iteration  #2
    // 11-17 Cycles
    //
    umull   lr, r2, r0, r1
    umull   lr, r2, r2, r1
    rsb     r2, r2, #0xC0000000
    umull   lr, r1, r2, r1
    lsl     r1, r1, #1

    //
    // Multiply isqrt(x) by x to get sqrt(x)
    //
    umull   lr, r0, r0, r1

    //
    // Prepare to Denormalize result
    // r3 stores the necessary shift.
    //
    add     r3, r3, #(30 - 30)
    asrs    r3, r3, #1

    //
    // Correct by sqrt(2) if carry bit is set
    // This is due to the normalization to (1.0 0.5) instead of (1.0 0.25)
    itt     cs
        ldrcs   r2, sqrt_half_30
        umullcs r1, r0, r2, r0

    //
    // Actually denormalize per above preparation
    // Round result
    //
    lsrs    r0, r0, r3
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    pop     {pc}

    //
    // Returns 0 if the input value is negative or zero
    //
sqrt_neg_or_zero30:
    mov     r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
isqrt_table_30:
    .word isqrt_table - 0x800
sqrt_half_30:
    .word 0xb504f334         // sqrt(1/2) in Q32

    .end
