//*****************************************************************************
//
// IQsin.S - Fixed point calculation of sin in radians
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNsin
//
//*****************************************************************************
//
// C Usage:    extern long _IQNsin(long U);
//
//-----------------------------------------------------------------------------
//
// On Entry:   r0    = U in IQ format
//
//
// Regs Used:  r0-r3, r12
//
// On Exit:    r0    = sin(U)
//
//
// Q range:    29 to 1
//      NOTE:   This will actually generate 30 to 1, but 30 is not officially
//              "on the list". C2000's documentation states that it is only
//              1-29, but has header entries for 30 as well.  In any case, Q30
//              generates up to 4 counts of error, but is otherwise usable.
//
//-----------------------------------------------------------------------------
//
// Algorithm:  The procedure for calculating "Y = sin(U)" is as follows:
//
//      Step 1)  Normalize U to be within Quadrant I
//
//      Step 2)  Use upper 9 bits to lookup sin(index) and cos(index).
//
//      Step 3)  Use Taylor series to estimate sin(index+remainder).
//               Up to 6 terms used, dependendent on Q
//
//      Note:   Index == 0 is handled as a special case.  It is a linear
//              approximation with a slope just less than pi.  Value was
//              chosen to minimize maximal error : +/-2 counts in Q30.
//
//##### INTERNAL BEGIN #####
//-----------------------------------------------------------------------------
//
// Future Work:
//
//   It may be possible to fold this function in with the PU implementation.
//   The differences are only at the head of the function, and are listed
//   below:
//      Load and multiply by 1/pi
//      The left shift to truncate is 64 bits instead of 32-bits.
//   Making the 64-bit left shift "fallable" may be difficult. Best guess would
//   be to change the macro definition to _IQsin(_iq x,0);.  This would allow
//   us to always use the add instruction without fear of what might be in r1.
//
//   As currently implemented, the residual is initialized to zero.
//   A quick improvement would be to skip the initialization and fold it into
//   the following add or rsb instruction.  This would be dependendant on Q.
//   A better option may be to initialize it to 1/(2*n!)*{sin,cos}(index).
//   This might allow us to fake out an entire order of the expansion as a
//   pseudo constant, and save us a few multiplies.  Optimal value not yet
//   calculated, it would have to be done similarly to the index == 0
//   optimization.
//
//   Consider returning to a full-wave implementation (instead of quarter-wave)
//   This would require signed math (2-3 cycle penalty per multiply, for SMULL
//   vs UMULL, plus additional shifting/ rounding), but would eliminate
//   the expensive setup / tear down of the function.  Would also eliminate
//   special case handling.  If this path is chosen, center-align the Taylor-
//   series.
//
//   This implementation is "tuneable", in that it is relatively easy to
//   choose how many terms in the expansion are active for each Q.  They are
//   currently chosen such that we hit +/-1 count of accuracy for all Q: it is
//   expensive to do better due to fixed point rounding. If desired, these
//   choices can be revisited later with speed in mind.
//
//##### INTERNAL END #####
//-----------------------------------------------------------------------------
// Benchmark:
//
//        Q <= 30       : 78 Cycles
//        Q <= 29       : 71 Cycles
//   9 <= Q <= 20       : 59 Cycles
//   1 <= Q <=  8       : 31 Cycles
//
//  These are all worst case: Quadrant 3.  Others are 1-4 quicker.
//
//*****************************************************************************

    .syntax unified
    .thumb
    .text

//*****************************************************************************
//
// The sin/cos table is used.
//
//*****************************************************************************
    .extern sincos_table

//*****************************************************************************
//
// _IQ1sin
//
//*****************************************************************************
    .section .text._IQ1sin
    .globl _IQ1sin
    .thumb_func
_IQ1sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_1
    smull   r1, r0, r1, r0

    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_1

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(31 - 1)
    add     r0, r0, r1, lsr #(1 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in per unit radians, and we only store
    // the [0,.5) in the table.
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000

    //
    // Remove the sign bit and store it in the carry flag
    //
    lsls    r0, r0, #1

    //
    // Lookup the value from the table.
    //
    ubfx    r1, r0, #(32 - 10), #10
    ldr     r0, [r3, r1, lsl #2]

    //
    // Sign compensate, shift down for Q and round.
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 1)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_1:
    .word sincos_table
invpiq32_1:
     .word 0x517cc1b7        // 1/pi in Q32

//*****************************************************************************
//
// _IQ2sin
//
//*****************************************************************************
    .section .text._IQ2sin
    .globl _IQ2sin
    .thumb_func
_IQ2sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_2
    smull   r1, r0, r1, r0

    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_2

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(31 - 2)
    add     r0, r0, r1, lsr #(2 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in per unit radians, and we only store
    // the [0,.5) in the table.
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000

    //
    // Remove the sign bit and store it in the carry flag
    //
    lsls    r0, r0, #1

    //
    // Lookup the value from the table.
    //
    ubfx    r1, r0, #(32 - 10), #10
    ldr     r0, [r3, r1, lsl #2]

    //
    // Sign compensate, shift down for Q and round.
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 2)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_2:
    .word sincos_table
invpiq32_2:
     .word 0x517cc1b7        // 1/pi in Q32

//*****************************************************************************
//
// _IQ3sin
//
//*****************************************************************************
    .section .text._IQ3sin
    .globl _IQ3sin
    .thumb_func
_IQ3sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_3
    smull   r1, r0, r1, r0

    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_3

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(31 - 3)
    add     r0, r0, r1, lsr #(3 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in per unit radians, and we only store
    // the [0,.5) in the table.
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000

    //
    // Remove the sign bit and store it in the carry flag
    //
    lsls    r0, r0, #1

    //
    // Lookup the value from the table.
    //
    ubfx    r1, r0, #(32 - 10), #10
    ldr     r0, [r3, r1, lsl #2]

    //
    // Sign compensate, shift down for Q and round.
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 3)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_3:
    .word sincos_table
invpiq32_3:
     .word 0x517cc1b7        // 1/pi in Q32

//*****************************************************************************
//
// _IQ4sin
//
//*****************************************************************************
    .section .text._IQ4sin
    .globl _IQ4sin
    .thumb_func
_IQ4sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_4
    smull   r1, r0, r1, r0

    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_4

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(31 - 4)
    add     r0, r0, r1, lsr #(4 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in per unit radians, and we only store
    // the [0,.5) in the table.
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000

    //
    // Remove the sign bit and store it in the carry flag
    //
    lsls    r0, r0, #1

    //
    // Lookup the value from the table.
    //
    ubfx    r1, r0, #(32 - 10), #10
    ldr     r0, [r3, r1, lsl #2]

    //
    // Sign compensate, shift down for Q and round.
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 4)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_4:
    .word sincos_table
invpiq32_4:
     .word 0x517cc1b7        // 1/pi in Q32

//*****************************************************************************
//
// _IQ5sin
//
//*****************************************************************************
    .section .text._IQ5sin
    .globl _IQ5sin
    .thumb_func
_IQ5sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_5
    smull   r1, r0, r1, r0

    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_5

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(31 - 5)
    add     r0, r0, r1, lsr #(5 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in per unit radians, and we only store
    // the [0,.5) in the table.
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000

    //
    // Remove the sign bit and store it in the carry flag
    //
    lsls    r0, r0, #1

    //
    // Lookup the value from the table.
    //
    ubfx    r1, r0, #(32 - 10), #10
    ldr     r0, [r3, r1, lsl #2]

    //
    // Sign compensate, shift down for Q and round.
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 5)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_5:
    .word sincos_table
invpiq32_5:
     .word 0x517cc1b7        // 1/pi in Q32

//*****************************************************************************
//
// _IQ6sin
//
//*****************************************************************************
    .section .text._IQ6sin
    .globl _IQ6sin
    .thumb_func
_IQ6sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_6
    smull   r1, r0, r1, r0

    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_6

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(31 - 6)
    add     r0, r0, r1, lsr #(6 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in per unit radians, and we only store
    // the [0,.5) in the table.
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000

    //
    // Remove the sign bit and store it in the carry flag
    //
    lsls    r0, r0, #1

    //
    // Lookup the value from the table.
    //
    ubfx    r1, r0, #(32 - 10), #10
    ldr     r0, [r3, r1, lsl #2]

    //
    // Sign compensate, shift down for Q and round.
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 6)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_6:
    .word sincos_table
invpiq32_6:
     .word 0x517cc1b7        // 1/pi in Q32

//*****************************************************************************
//
// _IQ7sin
//
//*****************************************************************************
    .section .text._IQ7sin
    .globl _IQ7sin
    .thumb_func
_IQ7sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_7
    smull   r1, r0, r1, r0

    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_7

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(31 - 7)
    add     r0, r0, r1, lsr #(7 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in per unit radians, and we only store
    // the [0,.5) in the table.
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000

    //
    // Remove the sign bit and store it in the carry flag
    //
    lsls    r0, r0, #1

    //
    // Lookup the value from the table.
    //
    ubfx    r1, r0, #(32 - 10), #10
    ldr     r0, [r3, r1, lsl #2]

    //
    // Sign compensate, shift down for Q and round.
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 7)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_7:
    .word sincos_table
invpiq32_7:
     .word 0x517cc1b7        // 1/pi in Q32

//*****************************************************************************
//
// _IQ8sin
//
//*****************************************************************************
    .section .text._IQ8sin
    .globl _IQ8sin
    .thumb_func
_IQ8sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_8
    smull   r1, r0, r1, r0

    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_8

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(31 - 8)
    add     r0, r0, r1, lsr #(8 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in per unit radians, and we only store
    // the [0,.5) in the table.
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000

    //
    // Remove the sign bit and store it in the carry flag
    //
    lsls    r0, r0, #1

    //
    // Lookup the value from the table.
    //
    ubfx    r1, r0, #(32 - 10), #10
    ldr     r0, [r3, r1, lsl #2]

    //
    // Sign compensate, shift down for Q and round.
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 8)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_8:
    .word sincos_table
invpiq32_8:
     .word 0x517cc1b7        // 1/pi in Q32

//*****************************************************************************
//
// _IQ9sin
//
//*****************************************************************************
    .section .text._IQ9sin
    .globl _IQ9sin
    .thumb_func
_IQ9sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_9
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 9)
    add     r0, r0, r1, lsr #(9 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_9
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__9
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_9
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 9)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__9:
    ldr     r12, piq30_compensated_9
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 9)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_9:
    .word sincos_table
piq30_9:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_9:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_9:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ10sin
//
//*****************************************************************************
    .section .text._IQ10sin
    .globl _IQ10sin
    .thumb_func
_IQ10sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_10
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 10)
    add     r0, r0, r1, lsr #(10 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_10
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__10
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_10
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 10)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__10:
    ldr     r12, piq30_compensated_10
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 10)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_10:
    .word sincos_table
piq30_10:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_10:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_10:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ11sin
//
//*****************************************************************************
    .section .text._IQ11sin
    .globl _IQ11sin
    .thumb_func
_IQ11sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_11
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 11)
    add     r0, r0, r1, lsr #(11 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_11
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__11
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_11
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 11)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__11:
    ldr     r12, piq30_compensated_11
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 11)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_11:
    .word sincos_table
piq30_11:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_11:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_11:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ12sin
//
//*****************************************************************************
    .section .text._IQ12sin
    .globl _IQ12sin
    .thumb_func
_IQ12sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_12
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 12)
    add     r0, r0, r1, lsr #(12 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_12
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__12
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_12
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 12)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__12:
    ldr     r12, piq30_compensated_12
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 12)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_12:
    .word sincos_table
piq30_12:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_12:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_12:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ13sin
//
//*****************************************************************************
    .section .text._IQ13sin
    .globl _IQ13sin
    .thumb_func
_IQ13sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_13
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 13)
    add     r0, r0, r1, lsr #(13 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_13
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__13
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_13
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 13)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__13:
    ldr     r12, piq30_compensated_13
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 13)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_13:
    .word sincos_table
piq30_13:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_13:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_13:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ14sin
//
//*****************************************************************************
    .section .text._IQ14sin
    .globl _IQ14sin
    .thumb_func
_IQ14sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_14
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 14)
    add     r0, r0, r1, lsr #(14 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_14
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__14
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_14
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 14)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__14:
    ldr     r12, piq30_compensated_14
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 14)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_14:
    .word sincos_table
piq30_14:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_14:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_14:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ15sin
//
//*****************************************************************************
    .section .text._IQ15sin
    .globl _IQ15sin
    .thumb_func
_IQ15sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_15
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 15)
    add     r0, r0, r1, lsr #(15 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_15
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__15
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_15
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 15)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__15:
    ldr     r12, piq30_compensated_15
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 15)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_15:
    .word sincos_table
piq30_15:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_15:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_15:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ16sin
//
//*****************************************************************************
    .section .text._IQ16sin
    .globl _IQ16sin
    .thumb_func
_IQ16sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_16
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 16)
    add     r0, r0, r1, lsr #(16 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_16
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__16
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_16
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 16)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__16:
    ldr     r12, piq30_compensated_16
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 16)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_16:
    .word sincos_table
piq30_16:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_16:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_16:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ17sin
//
//*****************************************************************************
    .section .text._IQ17sin
    .globl _IQ17sin
    .thumb_func
_IQ17sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_17
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 17)
    add     r0, r0, r1, lsr #(17 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_17
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__17
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_17
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 17)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__17:
    ldr     r12, piq30_compensated_17
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 17)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_17:
    .word sincos_table
piq30_17:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_17:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_17:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ18sin
//
//*****************************************************************************
    .section .text._IQ18sin
    .globl _IQ18sin
    .thumb_func
_IQ18sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_18
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 18)
    add     r0, r0, r1, lsr #(18 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_18
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__18
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_18
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 18)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__18:
    ldr     r12, piq30_compensated_18
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 18)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_18:
    .word sincos_table
piq30_18:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_18:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_18:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ19sin
//
//*****************************************************************************
    .section .text._IQ19sin
    .globl _IQ19sin
    .thumb_func
_IQ19sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_19
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 19)
    add     r0, r0, r1, lsr #(19 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_19
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__19
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_19
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 19)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__19:
    ldr     r12, piq30_compensated_19
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 19)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_19:
    .word sincos_table
piq30_19:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_19:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_19:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ20sin
//
//*****************************************************************************
    .section .text._IQ20sin
    .globl _IQ20sin
    .thumb_func
_IQ20sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_20
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 20)
    add     r0, r0, r1, lsr #(20 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_20
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__20
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_20
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 20)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__20:
    ldr     r12, piq30_compensated_20
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 20)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_20:
    .word sincos_table
piq30_20:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_20:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_20:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ21sin
//
//*****************************************************************************
    .section .text._IQ21sin
    .globl _IQ21sin
    .thumb_func
_IQ21sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_21
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 21)
    add     r0, r0, r1, lsr #(21 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_21
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__21
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_21
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 5th term of taylor series expansion.
    // This performs y = remainder/5*(cos(index)-y)
    // 8-12 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x33333333    // 2**32/5
    umull   r12, r0, r12, r0

    //
    // Calculate 4th term of taylor series expansion.
    // This performs y = remainder/4*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #2

    //
    // Calculate 3rd term of taylor series expansion.
    // This performs y = remainder/3*(cos(index)-y)
    // 9-13 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x55555555    // 2**32/3
    umull   r12, r0, r12, r0

    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 21)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__21:
    ldr     r12, piq30_compensated_21
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 21)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_21:
    .word sincos_table
piq30_21:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_21:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_21:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ22sin
//
//*****************************************************************************
    .section .text._IQ22sin
    .globl _IQ22sin
    .thumb_func
_IQ22sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_22
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 22)
    add     r0, r0, r1, lsr #(22 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_22
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__22
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_22
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 5th term of taylor series expansion.
    // This performs y = remainder/5*(cos(index)-y)
    // 8-12 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x33333333    // 2**32/5
    umull   r12, r0, r12, r0

    //
    // Calculate 4th term of taylor series expansion.
    // This performs y = remainder/4*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #2

    //
    // Calculate 3rd term of taylor series expansion.
    // This performs y = remainder/3*(cos(index)-y)
    // 9-13 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x55555555    // 2**32/3
    umull   r12, r0, r12, r0

    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 22)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__22:
    ldr     r12, piq30_compensated_22
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 22)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_22:
    .word sincos_table
piq30_22:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_22:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_22:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ23sin
//
//*****************************************************************************
    .section .text._IQ23sin
    .globl _IQ23sin
    .thumb_func
_IQ23sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_23
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 23)
    add     r0, r0, r1, lsr #(23 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_23
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__23
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_23
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 5th term of taylor series expansion.
    // This performs y = remainder/5*(cos(index)-y)
    // 8-12 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x33333333    // 2**32/5
    umull   r12, r0, r12, r0

    //
    // Calculate 4th term of taylor series expansion.
    // This performs y = remainder/4*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #2

    //
    // Calculate 3rd term of taylor series expansion.
    // This performs y = remainder/3*(cos(index)-y)
    // 9-13 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x55555555    // 2**32/3
    umull   r12, r0, r12, r0

    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 23)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__23:
    ldr     r12, piq30_compensated_23
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 23)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_23:
    .word sincos_table
piq30_23:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_23:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_23:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ24sin
//
//*****************************************************************************
    .section .text._IQ24sin
    .globl _IQ24sin
    .thumb_func
_IQ24sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_24
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 24)
    add     r0, r0, r1, lsr #(24 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_24
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__24
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_24
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 5th term of taylor series expansion.
    // This performs y = remainder/5*(cos(index)-y)
    // 8-12 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x33333333    // 2**32/5
    umull   r12, r0, r12, r0

    //
    // Calculate 4th term of taylor series expansion.
    // This performs y = remainder/4*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #2

    //
    // Calculate 3rd term of taylor series expansion.
    // This performs y = remainder/3*(cos(index)-y)
    // 9-13 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x55555555    // 2**32/3
    umull   r12, r0, r12, r0

    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 24)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__24:
    ldr     r12, piq30_compensated_24
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 24)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_24:
    .word sincos_table
piq30_24:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_24:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_24:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ25sin
//
//*****************************************************************************
    .section .text._IQ25sin
    .globl _IQ25sin
    .thumb_func
_IQ25sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_25
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 25)
    add     r0, r0, r1, lsr #(25 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_25
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__25
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_25
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 5th term of taylor series expansion.
    // This performs y = remainder/5*(cos(index)-y)
    // 8-12 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x33333333    // 2**32/5
    umull   r12, r0, r12, r0

    //
    // Calculate 4th term of taylor series expansion.
    // This performs y = remainder/4*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #2

    //
    // Calculate 3rd term of taylor series expansion.
    // This performs y = remainder/3*(cos(index)-y)
    // 9-13 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x55555555    // 2**32/3
    umull   r12, r0, r12, r0

    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 25)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__25:
    ldr     r12, piq30_compensated_25
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 25)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_25:
    .word sincos_table
piq30_25:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_25:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_25:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ26sin
//
//*****************************************************************************
    .section .text._IQ26sin
    .globl _IQ26sin
    .thumb_func
_IQ26sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_26
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 26)
    add     r0, r0, r1, lsr #(26 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_26
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__26
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_26
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 5th term of taylor series expansion.
    // This performs y = remainder/5*(cos(index)-y)
    // 8-12 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x33333333    // 2**32/5
    umull   r12, r0, r12, r0

    //
    // Calculate 4th term of taylor series expansion.
    // This performs y = remainder/4*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #2

    //
    // Calculate 3rd term of taylor series expansion.
    // This performs y = remainder/3*(cos(index)-y)
    // 9-13 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x55555555    // 2**32/3
    umull   r12, r0, r12, r0

    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 26)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__26:
    ldr     r12, piq30_compensated_26
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 26)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_26:
    .word sincos_table
piq30_26:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_26:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_26:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ27sin
//
//*****************************************************************************
    .section .text._IQ27sin
    .globl _IQ27sin
    .thumb_func
_IQ27sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_27
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 27)
    add     r0, r0, r1, lsr #(27 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_27
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__27
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_27
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 5th term of taylor series expansion.
    // This performs y = remainder/5*(cos(index)-y)
    // 8-12 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x33333333    // 2**32/5
    umull   r12, r0, r12, r0

    //
    // Calculate 4th term of taylor series expansion.
    // This performs y = remainder/4*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #2

    //
    // Calculate 3rd term of taylor series expansion.
    // This performs y = remainder/3*(cos(index)-y)
    // 9-13 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x55555555    // 2**32/3
    umull   r12, r0, r12, r0

    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 27)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__27:
    ldr     r12, piq30_compensated_27
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 27)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_27:
    .word sincos_table
piq30_27:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_27:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_27:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ28sin
//
//*****************************************************************************
    .section .text._IQ28sin
    .globl _IQ28sin
    .thumb_func
_IQ28sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_28
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 28)
    add     r0, r0, r1, lsr #(28 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_28
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__28
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_28
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 5th term of taylor series expansion.
    // This performs y = remainder/5*(cos(index)-y)
    // 8-12 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x33333333    // 2**32/5
    umull   r12, r0, r12, r0

    //
    // Calculate 4th term of taylor series expansion.
    // This performs y = remainder/4*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #2

    //
    // Calculate 3rd term of taylor series expansion.
    // This performs y = remainder/3*(cos(index)-y)
    // 9-13 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x55555555    // 2**32/3
    umull   r12, r0, r12, r0

    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 28)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__28:
    ldr     r12, piq30_compensated_28
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 28)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_28:
    .word sincos_table
piq30_28:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_28:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_28:
    .word 0x517cc1b7         // 1/pi in Q32

//*****************************************************************************
//
// _IQ29sin
//
//*****************************************************************************
    .section .text._IQ29sin
    .globl _IQ29sin
    .thumb_func
_IQ29sin:
    //
    // Convert from radians to radians per unit by dividing by pi
    // This is done by multiplying by 1/pi in Q32
    //
    ldr     r1, invpiq32_29
    smull   r1, r0, r1, r0

    //
    // Put the input into Q31.
    // Since this is in Per Unit radians, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in per unit radians.
    //
    lsl     r0, r0, #(31 - 29)
    add     r0, r0, r1, lsr #(29 + 1)

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in per unit radians.
    // r0 becomes UQ32 representation of input constrained to 1st Quadrant PU:
    // [0,.5)
    //
    lsls    r1, r0, #2
    it      cs
        rsbcs   r0, r0, #0x80000000
    lsls    r0, r0, #1

    //
    // Use the top 9 fractional bits as an index into the look up table.
    // Pull sine and cosine of the index.
    // Jump out if we're close enough to 0 to do a fully odd approximation.
    //
    ldr     r12, sincos_table_29
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, sin_index0__29
    ldr     r2, [r12, r1, lsl #2]
    rsb     r1, r1, #512
    ldr     r3, [r12, r1, lsl #2]

    //
    // Put delta x in r1.
    // This is (x-index)*pi/2  in Q32
    // Consider replacing lsl/lsr combo with UBFX:
    // 1 cycle faster, but slightly less accurate delta x.
    //
    lsl     r1, r0, #(9 + 1)
    ldr     r12, piq30_29
    umull   r12, r1, r1, r12
    lsr     r1, r1, #9-1
    mov     r0, #0

    //
    // Calculates the taylor series expansion of sin(x)
    // Interval is 0:90 degrees.
    // Preconditions:
    // r0 = 0x00000000
    // r1 = remainder (x-index) in Q32 Radians
    // r2 = sin(index) in Q32
    // r3 = cos(index) in Q32
    // r12 is available as scratch space
    // ASPR contains sign flag as MI=flip sign.
    //
    // Calculate 6th term of taylor series expansion.
    // This performs y = remainder/6*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    ldr     r12, max6_29      // 2**32/6
    umull   r12, r0, r0, r12

    //
    // Calculate 5th term of taylor series expansion.
    // This performs y = remainder/5*(cos(index)-y)
    // 8-12 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x33333333    // 2**32/5
    umull   r12, r0, r12, r0

    //
    // Calculate 4th term of taylor series expansion.
    // This performs y = remainder/4*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #2

    //
    // Calculate 3rd term of taylor series expansion.
    // This performs y = remainder/3*(cos(index)-y)
    // 9-13 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x55555555    // 2**32/3
    umull   r12, r0, r12, r0

    //
    // Calculate 2ND term of taylor series expansion.
    // This performs y = remainder/2*(sin(index)+y)
    // 5-7 cycles
    //
    add     r0, r2, r0
    umull   r12, r0, r0, r1
    lsr     r0, r0, #1

    //
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    sub     r0, r3, r0
    umull   r12, r0, r0, r1

    //
    // Calculate 0th term of taylor series expansion.
    // This performs y = (sin(index)+y)
    //
    add     r0, r2, r0

    //
    // Compensate for sign flag in r5
    //
    lsr     r0, r0, #1
    it      cs
        rsbcs   r0, r0, #0
    asrs    r0, r0, #(31 - 29)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx    lr

    //
    // This branch handles the case very close to 0.
    // It uses the sin(x)=x approximation, but the constant is fudged down
    // a bit from pi to minimize the maximum error to +/-2 counts at Q30
    //
sin_index0__29:
    ldr     r12, piq30_compensated_29
    umull   r12, r0, r0, r12
    lsr     r0, r0, #(30 - 29)
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_29:
    .word sincos_table
piq30_29:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_29:
    .word 0xc90fcd37         // slightly less than pi in Q30
invpiq32_29:
    .word 0x517cc1b7         // 1/pi in Q32
max6_29:
    .word 0x2aaaaaaa         // 2**32/6

    .end
