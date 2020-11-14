//*****************************************************************************
//
// IQcosPU.S - Fixed point calculation of cos in cycles per unit
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNcosPU
//
//*****************************************************************************
//
// C Usage:    extern long _IQNcosPU(long U);
//
//-----------------------------------------------------------------------------
//
// On Entry:   r0    = U in IQ format
//
//
// Regs Used:  r0-r3, r12
//
// On Exit:    r0    = cos(U)
//
//
// Q range:    30 to 1
//
//-----------------------------------------------------------------------------
//
// Algorithm:  The procedure for calculating "Y = cos(U)" is as follows:
//
//      Step 1)  Normalize U to be within Quadrant I
//
//      Step 2)  Use upper 9 bits to lookup sin(index) and cos(index).
//
//      Step 3)  Use Taylor series to estimate cos(index+remainder).
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
//##### INTERNAL END #####
//---------------------------------------------------------------------------
//
// Benchmark:
//
//  29 <= Q             : 83 Cycles
//        Q  = 28       : 64 Cycles
//  12 <= Q <= 27       : 51 Cycles
//        Q  = 11       : 44 Cycles
//   1 <= Q <= 10       : 23 Cycles
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
// _IQ1cosPU
//
//*****************************************************************************
    .section .text._IQ1cosPU
    .globl _IQ1cosPU
    .thumb_func
_IQ1cosPU:
    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_1

    //
    // Put the input into Q31.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(32 - 1)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in cycles per unit, and we only store
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
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_1:
    .word sincos_table

//*****************************************************************************
//
// _IQ2cosPU
//
//*****************************************************************************
    .section .text._IQ2cosPU
    .globl _IQ2cosPU
    .thumb_func
_IQ2cosPU:
    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_2

    //
    // Put the input into Q31.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(32 - 2)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in cycles per unit, and we only store
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
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_2:
    .word sincos_table

//*****************************************************************************
//
// _IQ3cosPU
//
//*****************************************************************************
    .section .text._IQ3cosPU
    .globl _IQ3cosPU
    .thumb_func
_IQ3cosPU:
    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_3

    //
    // Put the input into Q31.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(32 - 3)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in cycles per unit, and we only store
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
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_3:
    .word sincos_table

//*****************************************************************************
//
// _IQ4cosPU
//
//*****************************************************************************
    .section .text._IQ4cosPU
    .globl _IQ4cosPU
    .thumb_func
_IQ4cosPU:
    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_4

    //
    // Put the input into Q31.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(32 - 4)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in cycles per unit, and we only store
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
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_4:
    .word sincos_table

//*****************************************************************************
//
// _IQ5cosPU
//
//*****************************************************************************
    .section .text._IQ5cosPU
    .globl _IQ5cosPU
    .thumb_func
_IQ5cosPU:
    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_5

    //
    // Put the input into Q31.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(32 - 5)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in cycles per unit, and we only store
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
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_5:
    .word sincos_table

//*****************************************************************************
//
// _IQ6cosPU
//
//*****************************************************************************
    .section .text._IQ6cosPU
    .globl _IQ6cosPU
    .thumb_func
_IQ6cosPU:
    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_6

    //
    // Put the input into Q31.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(32 - 6)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in cycles per unit, and we only store
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
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_6:
    .word sincos_table

//*****************************************************************************
//
// _IQ7cosPU
//
//*****************************************************************************
    .section .text._IQ7cosPU
    .globl _IQ7cosPU
    .thumb_func
_IQ7cosPU:
    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_7

    //
    // Put the input into Q31.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(32 - 7)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in cycles per unit, and we only store
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
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_7:
    .word sincos_table

//*****************************************************************************
//
// _IQ8cosPU
//
//*****************************************************************************
    .section .text._IQ8cosPU
    .globl _IQ8cosPU
    .thumb_func
_IQ8cosPU:
    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_8

    //
    // Put the input into Q31.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(32 - 8)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in cycles per unit, and we only store
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
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_8:
    .word sincos_table

//*****************************************************************************
//
// _IQ9cosPU
//
//*****************************************************************************
    .section .text._IQ9cosPU
    .globl _IQ9cosPU
    .thumb_func
_IQ9cosPU:
    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_9

    //
    // Put the input into Q31.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(32 - 9)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in cycles per unit, and we only store
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
    asrs    r0, r0, #(31 - 9)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_9:
    .word sincos_table

//*****************************************************************************
//
// _IQ10cosPU
//
//*****************************************************************************
    .section .text._IQ10cosPU
    .globl _IQ10cosPU
    .thumb_func
_IQ10cosPU:
    //
    // Load the table pointer into memory early, since we have more than
    // enough registers to handle it.
    //
    ldr     r3, sincos_table_10

    //
    // Put the input into Q31.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    //
    lsl     r0, r0, #(32 - 10)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is because sin(x) = sin(1-x) in cycles per unit, and we only store
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
    asrs    r0, r0, #(31 - 10)
    adc     r0, r0, #0

    //
    // Return to the caller.
    //
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_10:
    .word sincos_table

//*****************************************************************************
//
// _IQ11cosPU
//
//*****************************************************************************
    .section .text._IQ11cosPU
    .globl _IQ11cosPU
    .thumb_func
_IQ11cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 11)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_11
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 1st term of taylor series expansion.
    // This performs y = remainder/1*(cos(index)-y)
    // 4-6 cycles
    //
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
cosPUindex0_11:
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

//*****************************************************************************
//
// _IQ12cosPU
//
//*****************************************************************************
    .section .text._IQ12cosPU
    .globl _IQ12cosPU
    .thumb_func
_IQ12cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 12)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_12
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_12:
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

//*****************************************************************************
//
// _IQ13cosPU
//
//*****************************************************************************
    .section .text._IQ13cosPU
    .globl _IQ13cosPU
    .thumb_func
_IQ13cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 13)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_13
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_13:
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

//*****************************************************************************
//
// _IQ14cosPU
//
//*****************************************************************************
    .section .text._IQ14cosPU
    .globl _IQ14cosPU
    .thumb_func
_IQ14cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 14)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_14
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_14:
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

//*****************************************************************************
//
// _IQ15cosPU
//
//*****************************************************************************
    .section .text._IQ15cosPU
    .globl _IQ15cosPU
    .thumb_func
_IQ15cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 15)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_15
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_15:
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

//*****************************************************************************
//
// _IQ16cosPU
//
//*****************************************************************************
    .section .text._IQ16cosPU
    .globl _IQ16cosPU
    .thumb_func
_IQ16cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 16)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_16
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_16:
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

//*****************************************************************************
//
// _IQ17cosPU
//
//*****************************************************************************
    .section .text._IQ17cosPU
    .globl _IQ17cosPU
    .thumb_func
_IQ17cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 17)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_17
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_17:
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

//*****************************************************************************
//
// _IQ18cosPU
//
//*****************************************************************************
    .section .text._IQ18cosPU
    .globl _IQ18cosPU
    .thumb_func
_IQ18cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 18)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_18
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_18:
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

//*****************************************************************************
//
// _IQ19cosPU
//
//*****************************************************************************
    .section .text._IQ19cosPU
    .globl _IQ19cosPU
    .thumb_func
_IQ19cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 19)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_19
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_19:
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

//*****************************************************************************
//
// _IQ20cosPU
//
//*****************************************************************************
    .section .text._IQ20cosPU
    .globl _IQ20cosPU
    .thumb_func
_IQ20cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 20)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_20
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_20:
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

//*****************************************************************************
//
// _IQ21cosPU
//
//*****************************************************************************
    .section .text._IQ21cosPU
    .globl _IQ21cosPU
    .thumb_func
_IQ21cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 21)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_21
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_21:
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

//*****************************************************************************
//
// _IQ22cosPU
//
//*****************************************************************************
    .section .text._IQ22cosPU
    .globl _IQ22cosPU
    .thumb_func
_IQ22cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 22)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_22
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_22:
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

//*****************************************************************************
//
// _IQ23cosPU
//
//*****************************************************************************
    .section .text._IQ23cosPU
    .globl _IQ23cosPU
    .thumb_func
_IQ23cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 23)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_23
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_23:
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

//*****************************************************************************
//
// _IQ24cosPU
//
//*****************************************************************************
    .section .text._IQ24cosPU
    .globl _IQ24cosPU
    .thumb_func
_IQ24cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 24)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_24
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_24:
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

//*****************************************************************************
//
// _IQ25cosPU
//
//*****************************************************************************
    .section .text._IQ25cosPU
    .globl _IQ25cosPU
    .thumb_func
_IQ25cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 25)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_25
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_25:
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

//*****************************************************************************
//
// _IQ26cosPU
//
//*****************************************************************************
    .section .text._IQ26cosPU
    .globl _IQ26cosPU
    .thumb_func
_IQ26cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 26)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_26
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_26:
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

//*****************************************************************************
//
// _IQ27cosPU
//
//*****************************************************************************
    .section .text._IQ27cosPU
    .globl _IQ27cosPU
    .thumb_func
_IQ27cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 27)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_27
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_27:
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

//*****************************************************************************
//
// _IQ28cosPU
//
//*****************************************************************************
    .section .text._IQ28cosPU
    .globl _IQ28cosPU
    .thumb_func
_IQ28cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 28)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_28
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 3rd term of taylor series expansion.
    // This performs y = remainder/3*(cos(index)-y)
    // 9-13 cycles
    //
    sub     r0, r3, r0
    umull   r12, r0, r0, r1
    mov     r12, #0x55555555    // 2**32/3
    umull   r12, r0, r12, r0

    //
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_28:
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

//*****************************************************************************
//
// _IQ29cosPU
//
//*****************************************************************************
    .section .text._IQ29cosPU
    .globl _IQ29cosPU
    .thumb_func
_IQ29cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 29)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    cbz     r1, cosPUindex0_29
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
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
cosPUindex0_29:
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

//*****************************************************************************
//
// _IQ30cosPU
//
//*****************************************************************************
    .section .text._IQ30cosPU
    .globl _IQ30cosPU
    .thumb_func
_IQ30cosPU:
    //
    // Put the input into Q32.
    // Since this is in Cycles Per Unit, we only care about the 1s digit
    // to determine sign of the result.  Higher bits are useless.
    // This is equivalent to sin(x) = sin(x+2*n) in cycles per unit.
    //
    lsl     r0, r0, #(32 - 30)
    add     r0, r0, #0x40000000

    //
    // If the fractional portion is greater than 0.5, subtract it from 1.0
    // This is equivalent to sin(x) = sin(1-x) in cycles per unit.
    //
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
    ldr     r12, sincos_table_30
    ubfx    r1, r0, #(31 - 9), #10
    cbz     r1, cosPUindex0_30
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
    ldr     r12, piq30_30
    umull   r12, r1, r1, r12
    lsr     r1, r1, #(9 - 1)
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
    // Calculate 2nd term of taylor series expansion.
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
    //
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
    asrs    r0, r0, #(31 - 30)
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
cosPUindex0_30:
    ldr     r12, piq30_compensated_30
    umull   r12, r0, r0, r12
    it      cs
        rsbcs   r0, r0, #0
    bx      lr

    //
    // The literal pool.
    //
    .balign 4
sincos_table_30:
    .word sincos_table
piq30_30:
    .word 0xc90fdaa2         // pi in Q30
piq30_compensated_30:
    .word 0xc90fcd37         // slightly less than pi in Q30

    .end
