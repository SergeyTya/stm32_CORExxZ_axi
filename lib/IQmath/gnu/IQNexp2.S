//*****************************************************************************
//
// IQexp2.S - Fixed point 2^x
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNexp2
//
//*****************************************************************************
//
// C Usage:    extern long _IQNexp2(long X); // with saturation and rounding
//
//-----------------------------------------------------------------------------
//
// On Entry:   r0     = Val in IQ format
//
// Regs Used:  r0-r3, r12
//
// On Exit:    r0     = 2^x result in IQ format
//             r0     = max value "0x7FFFFFFF" if result saturates
//
// Q range:    30 to 1
//
//-----------------------------------------------------------------------------
//
// Algorithm:
//
//      Step 1)  Separate the fractional and integer portion of the input. The
//               The integer portion is saved for step 4.  If it will saturate,
//               bail out now.
//
//      Step 2)  Calculate 2^frac(x) using a 7th order polynomial.  The
//               coefficients have been selected to minimize the maximal error
//               over the range of x=[0,1].  Please see the attached python
//               script that was used to find these optimal coefficients.
//               Using these coefficients, rather than a Taylor series, allows
//               us to use ~3-4 fewer terms in the expansion with similar
//               accuracy.
//
//      Step 3)  Shift result of step 3 per the integer portion of the input.
//               Saturate and round as appropriate.
//
//##### INTERNAL BEGIN #####
//-----------------------------------------------------------------------------
//
// Future Work:
//   It may be possible to reduce the number of terms in the approximating
//   polynomial for small values of Q.  (It has been proven that this is the
//   minimal size to achieve +/-2 counts at Q30).  Note that the coefficients
//   would need to be reoptimized for each set, because they all have positive
//   signs.
//
//   Also, some accuracy vs time may be recoverable by calculating the
//   polynomial in Q31 instead of Q30.  However, overflow will need to be
//   checked more carefully.  The current set was chosen to guarantee a lack
//   of overflow so that the code did not have to do expensive checking.
//
//##### INTERNAL END #####
//-----------------------------------------------------------------------------
//
// Benchmark:
//      Typical     : 72 Cycles
//      Overflow    : 14 Cycles
//
//*****************************************************************************

    .syntax unified
    .thumb
    .text

//*****************************************************************************
//
// _IQ1exp2
//
//*****************************************************************************
    .section .text._IQ1exp2
    .globl _IQ1exp2
    .thumb_func
_IQ1exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #1
    rsbs    r12, r12, #(30 - 1)
    bmi     exp_saturation_1
    lsl     r1, r0, #(32 - 1)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_1
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_1
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_1
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_1
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_1
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_1
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_1
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_1
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_1:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_1:
    .word 0x3ffffffe
coefficient_1_1:
    .word 0x2c5c861c
coefficient_2_1:
    .word 0x0f5fde0f
coefficient_3_1:
    .word 0x038d669b
coefficient_4_1:
    .word 0x009d817b
coefficient_5_1:
    .word 0x00160186
coefficient_6_1:
    .word 0x00025756
coefficient_7_1:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ2exp2
//
//*****************************************************************************
    .section .text._IQ2exp2
    .globl _IQ2exp2
    .thumb_func
_IQ2exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #2
    rsbs    r12, r12, #(30 - 2)
    bmi     exp_saturation_2
    lsl     r1, r0, #(32 - 2)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_2
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_2
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_2
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_2
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_2
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_2
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_2
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_2
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_2:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_2:
    .word 0x3ffffffe
coefficient_1_2:
    .word 0x2c5c861c
coefficient_2_2:
    .word 0x0f5fde0f
coefficient_3_2:
    .word 0x038d669b
coefficient_4_2:
    .word 0x009d817b
coefficient_5_2:
    .word 0x00160186
coefficient_6_2:
    .word 0x00025756
coefficient_7_2:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ3exp2
//
//*****************************************************************************
    .section .text._IQ3exp2
    .globl _IQ3exp2
    .thumb_func
_IQ3exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #3
    rsbs    r12, r12, #(30 - 3)
    bmi     exp_saturation_3
    lsl     r1, r0, #(32 - 3)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_3
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_3
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_3
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_3
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_3
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_3
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_3
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_3
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_3:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_3:
    .word 0x3ffffffe
coefficient_1_3:
    .word 0x2c5c861c
coefficient_2_3:
    .word 0x0f5fde0f
coefficient_3_3:
    .word 0x038d669b
coefficient_4_3:
    .word 0x009d817b
coefficient_5_3:
    .word 0x00160186
coefficient_6_3:
    .word 0x00025756
coefficient_7_3:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ4exp2
//
//*****************************************************************************
    .section .text._IQ4exp2
    .globl _IQ4exp2
    .thumb_func
_IQ4exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #4
    rsbs    r12, r12, #(30 - 4)
    bmi     exp_saturation_4
    lsl     r1, r0, #(32 - 4)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_4
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_4
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_4
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_4
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_4
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_4
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_4
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_4
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_4:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_4:
    .word 0x3ffffffe
coefficient_1_4:
    .word 0x2c5c861c
coefficient_2_4:
    .word 0x0f5fde0f
coefficient_3_4:
    .word 0x038d669b
coefficient_4_4:
    .word 0x009d817b
coefficient_5_4:
    .word 0x00160186
coefficient_6_4:
    .word 0x00025756
coefficient_7_4:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ5exp2
//
//*****************************************************************************
    .section .text._IQ5exp2
    .globl _IQ5exp2
    .thumb_func
_IQ5exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #5
    rsbs    r12, r12, #(30 - 5)
    bmi     exp_saturation_5
    lsl     r1, r0, #(32 - 5)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_5
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_5
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_5
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_5
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_5
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_5
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_5
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_5
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_5:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_5:
    .word 0x3ffffffe
coefficient_1_5:
    .word 0x2c5c861c
coefficient_2_5:
    .word 0x0f5fde0f
coefficient_3_5:
    .word 0x038d669b
coefficient_4_5:
    .word 0x009d817b
coefficient_5_5:
    .word 0x00160186
coefficient_6_5:
    .word 0x00025756
coefficient_7_5:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ6exp2
//
//*****************************************************************************
    .section .text._IQ6exp2
    .globl _IQ6exp2
    .thumb_func
_IQ6exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #6
    rsbs    r12, r12, #(30 - 6)
    bmi     exp_saturation_6
    lsl     r1, r0, #(32 - 6)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_6
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_6
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_6
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_6
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_6
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_6
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_6
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_6
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_6:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_6:
    .word 0x3ffffffe
coefficient_1_6:
    .word 0x2c5c861c
coefficient_2_6:
    .word 0x0f5fde0f
coefficient_3_6:
    .word 0x038d669b
coefficient_4_6:
    .word 0x009d817b
coefficient_5_6:
    .word 0x00160186
coefficient_6_6:
    .word 0x00025756
coefficient_7_6:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ7exp2
//
//*****************************************************************************
    .section .text._IQ7exp2
    .globl _IQ7exp2
    .thumb_func
_IQ7exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #7
    rsbs    r12, r12, #(30 - 7)
    bmi     exp_saturation_7
    lsl     r1, r0, #(32 - 7)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_7
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_7
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_7
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_7
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_7
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_7
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_7
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_7
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_7:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_7:
    .word 0x3ffffffe
coefficient_1_7:
    .word 0x2c5c861c
coefficient_2_7:
    .word 0x0f5fde0f
coefficient_3_7:
    .word 0x038d669b
coefficient_4_7:
    .word 0x009d817b
coefficient_5_7:
    .word 0x00160186
coefficient_6_7:
    .word 0x00025756
coefficient_7_7:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ8exp2
//
//*****************************************************************************
    .section .text._IQ8exp2
    .globl _IQ8exp2
    .thumb_func
_IQ8exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #8
    rsbs    r12, r12, #(30 - 8)
    bmi     exp_saturation_8
    lsl     r1, r0, #(32 - 8)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_8
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_8
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_8
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_8
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_8
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_8
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_8
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_8
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_8:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_8:
    .word 0x3ffffffe
coefficient_1_8:
    .word 0x2c5c861c
coefficient_2_8:
    .word 0x0f5fde0f
coefficient_3_8:
    .word 0x038d669b
coefficient_4_8:
    .word 0x009d817b
coefficient_5_8:
    .word 0x00160186
coefficient_6_8:
    .word 0x00025756
coefficient_7_8:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ9exp2
//
//*****************************************************************************
    .section .text._IQ9exp2
    .globl _IQ9exp2
    .thumb_func
_IQ9exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #9
    rsbs    r12, r12, #(30 - 9)
    bmi     exp_saturation_9
    lsl     r1, r0, #(32 - 9)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_9
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_9
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_9
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_9
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_9
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_9
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_9
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_9
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_9:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_9:
    .word 0x3ffffffe
coefficient_1_9:
    .word 0x2c5c861c
coefficient_2_9:
    .word 0x0f5fde0f
coefficient_3_9:
    .word 0x038d669b
coefficient_4_9:
    .word 0x009d817b
coefficient_5_9:
    .word 0x00160186
coefficient_6_9:
    .word 0x00025756
coefficient_7_9:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ10exp2
//
//*****************************************************************************
    .section .text._IQ10exp2
    .globl _IQ10exp2
    .thumb_func
_IQ10exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #10
    rsbs    r12, r12, #(30 - 10)
    bmi     exp_saturation_10
    lsl     r1, r0, #(32 - 10)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_10
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_10
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_10
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_10
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_10
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_10
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_10
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_10
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_10:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_10:
    .word 0x3ffffffe
coefficient_1_10:
    .word 0x2c5c861c
coefficient_2_10:
    .word 0x0f5fde0f
coefficient_3_10:
    .word 0x038d669b
coefficient_4_10:
    .word 0x009d817b
coefficient_5_10:
    .word 0x00160186
coefficient_6_10:
    .word 0x00025756
coefficient_7_10:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ11exp2
//
//*****************************************************************************
    .section .text._IQ11exp2
    .globl _IQ11exp2
    .thumb_func
_IQ11exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #11
    rsbs    r12, r12, #(30 - 11)
    bmi     exp_saturation_11
    lsl     r1, r0, #(32 - 11)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_11
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_11
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_11
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_11
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_11
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_11
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_11
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_11
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_11:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_11:
    .word 0x3ffffffe
coefficient_1_11:
    .word 0x2c5c861c
coefficient_2_11:
    .word 0x0f5fde0f
coefficient_3_11:
    .word 0x038d669b
coefficient_4_11:
    .word 0x009d817b
coefficient_5_11:
    .word 0x00160186
coefficient_6_11:
    .word 0x00025756
coefficient_7_11:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ12exp2
//
//*****************************************************************************
    .section .text._IQ12exp2
    .globl _IQ12exp2
    .thumb_func
_IQ12exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #12
    rsbs    r12, r12, #(30 - 12)
    bmi     exp_saturation_12
    lsl     r1, r0, #(32 - 12)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_12
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_12
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_12
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_12
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_12
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_12
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_12
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_12
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_12:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_12:
    .word 0x3ffffffe
coefficient_1_12:
    .word 0x2c5c861c
coefficient_2_12:
    .word 0x0f5fde0f
coefficient_3_12:
    .word 0x038d669b
coefficient_4_12:
    .word 0x009d817b
coefficient_5_12:
    .word 0x00160186
coefficient_6_12:
    .word 0x00025756
coefficient_7_12:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ13exp2
//
//*****************************************************************************
    .section .text._IQ13exp2
    .globl _IQ13exp2
    .thumb_func
_IQ13exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #13
    rsbs    r12, r12, #(30 - 13)
    bmi     exp_saturation_13
    lsl     r1, r0, #(32 - 13)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_13
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_13
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_13
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_13
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_13
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_13
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_13
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_13
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_13:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_13:
    .word 0x3ffffffe
coefficient_1_13:
    .word 0x2c5c861c
coefficient_2_13:
    .word 0x0f5fde0f
coefficient_3_13:
    .word 0x038d669b
coefficient_4_13:
    .word 0x009d817b
coefficient_5_13:
    .word 0x00160186
coefficient_6_13:
    .word 0x00025756
coefficient_7_13:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ14exp2
//
//*****************************************************************************
    .section .text._IQ14exp2
    .globl _IQ14exp2
    .thumb_func
_IQ14exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #14
    rsbs    r12, r12, #(30 - 14)
    bmi     exp_saturation_14
    lsl     r1, r0, #(32 - 14)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_14
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_14
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_14
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_14
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_14
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_14
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_14
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_14
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_14:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_14:
    .word 0x3ffffffe
coefficient_1_14:
    .word 0x2c5c861c
coefficient_2_14:
    .word 0x0f5fde0f
coefficient_3_14:
    .word 0x038d669b
coefficient_4_14:
    .word 0x009d817b
coefficient_5_14:
    .word 0x00160186
coefficient_6_14:
    .word 0x00025756
coefficient_7_14:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ15exp2
//
//*****************************************************************************
    .section .text._IQ15exp2
    .globl _IQ15exp2
    .thumb_func
_IQ15exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #15
    rsbs    r12, r12, #(30 - 15)
    bmi     exp_saturation_15
    lsl     r1, r0, #(32 - 15)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_15
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_15
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_15
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_15
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_15
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_15
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_15
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_15
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_15:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_15:
    .word 0x3ffffffe
coefficient_1_15:
    .word 0x2c5c861c
coefficient_2_15:
    .word 0x0f5fde0f
coefficient_3_15:
    .word 0x038d669b
coefficient_4_15:
    .word 0x009d817b
coefficient_5_15:
    .word 0x00160186
coefficient_6_15:
    .word 0x00025756
coefficient_7_15:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ16exp2
//
//*****************************************************************************
    .section .text._IQ16exp2
    .globl _IQ16exp2
    .thumb_func
_IQ16exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #16
    rsbs    r12, r12, #(30 - 16)
    bmi     exp_saturation_16
    lsl     r1, r0, #(32 - 16)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_16
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_16
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_16
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_16
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_16
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_16
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_16
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_16
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_16:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_16:
    .word 0x3ffffffe
coefficient_1_16:
    .word 0x2c5c861c
coefficient_2_16:
    .word 0x0f5fde0f
coefficient_3_16:
    .word 0x038d669b
coefficient_4_16:
    .word 0x009d817b
coefficient_5_16:
    .word 0x00160186
coefficient_6_16:
    .word 0x00025756
coefficient_7_16:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ17exp2
//
//*****************************************************************************
    .section .text._IQ17exp2
    .globl _IQ17exp2
    .thumb_func
_IQ17exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #17
    rsbs    r12, r12, #(30 - 17)
    bmi     exp_saturation_17
    lsl     r1, r0, #(32 - 17)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_17
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_17
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_17
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_17
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_17
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_17
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_17
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_17
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_17:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_17:
    .word 0x3ffffffe
coefficient_1_17:
    .word 0x2c5c861c
coefficient_2_17:
    .word 0x0f5fde0f
coefficient_3_17:
    .word 0x038d669b
coefficient_4_17:
    .word 0x009d817b
coefficient_5_17:
    .word 0x00160186
coefficient_6_17:
    .word 0x00025756
coefficient_7_17:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ18exp2
//
//*****************************************************************************
    .section .text._IQ18exp2
    .globl _IQ18exp2
    .thumb_func
_IQ18exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #18
    rsbs    r12, r12, #(30 - 18)
    bmi     exp_saturation_18
    lsl     r1, r0, #(32 - 18)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_18
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_18
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_18
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_18
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_18
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_18
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_18
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_18
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_18:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_18:
    .word 0x3ffffffe
coefficient_1_18:
    .word 0x2c5c861c
coefficient_2_18:
    .word 0x0f5fde0f
coefficient_3_18:
    .word 0x038d669b
coefficient_4_18:
    .word 0x009d817b
coefficient_5_18:
    .word 0x00160186
coefficient_6_18:
    .word 0x00025756
coefficient_7_18:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ19exp2
//
//*****************************************************************************
    .section .text._IQ19exp2
    .globl _IQ19exp2
    .thumb_func
_IQ19exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #19
    rsbs    r12, r12, #(30 - 19)
    bmi     exp_saturation_19
    lsl     r1, r0, #(32 - 19)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_19
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_19
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_19
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_19
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_19
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_19
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_19
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_19
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_19:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_19:
    .word 0x3ffffffe
coefficient_1_19:
    .word 0x2c5c861c
coefficient_2_19:
    .word 0x0f5fde0f
coefficient_3_19:
    .word 0x038d669b
coefficient_4_19:
    .word 0x009d817b
coefficient_5_19:
    .word 0x00160186
coefficient_6_19:
    .word 0x00025756
coefficient_7_19:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ20exp2
//
//*****************************************************************************
    .section .text._IQ20exp2
    .globl _IQ20exp2
    .thumb_func
_IQ20exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #20
    rsbs    r12, r12, #(30 - 20)
    bmi     exp_saturation_20
    lsl     r1, r0, #(32 - 20)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_20
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_20
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_20
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_20
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_20
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_20
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_20
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_20
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_20:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_20:
    .word 0x3ffffffe
coefficient_1_20:
    .word 0x2c5c861c
coefficient_2_20:
    .word 0x0f5fde0f
coefficient_3_20:
    .word 0x038d669b
coefficient_4_20:
    .word 0x009d817b
coefficient_5_20:
    .word 0x00160186
coefficient_6_20:
    .word 0x00025756
coefficient_7_20:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ21exp2
//
//*****************************************************************************
    .section .text._IQ21exp2
    .globl _IQ21exp2
    .thumb_func
_IQ21exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #21
    rsbs    r12, r12, #(30 - 21)
    bmi     exp_saturation_21
    lsl     r1, r0, #(32 - 21)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_21
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_21
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_21
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_21
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_21
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_21
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_21
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_21
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_21:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_21:
    .word 0x3ffffffe
coefficient_1_21:
    .word 0x2c5c861c
coefficient_2_21:
    .word 0x0f5fde0f
coefficient_3_21:
    .word 0x038d669b
coefficient_4_21:
    .word 0x009d817b
coefficient_5_21:
    .word 0x00160186
coefficient_6_21:
    .word 0x00025756
coefficient_7_21:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ22exp2
//
//*****************************************************************************
    .section .text._IQ22exp2
    .globl _IQ22exp2
    .thumb_func
_IQ22exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #22
    rsbs    r12, r12, #(30 - 22)
    bmi     exp_saturation_22
    lsl     r1, r0, #(32 - 22)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_22
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_22
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_22
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_22
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_22
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_22
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_22
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_22
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_22:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_22:
    .word 0x3ffffffe
coefficient_1_22:
    .word 0x2c5c861c
coefficient_2_22:
    .word 0x0f5fde0f
coefficient_3_22:
    .word 0x038d669b
coefficient_4_22:
    .word 0x009d817b
coefficient_5_22:
    .word 0x00160186
coefficient_6_22:
    .word 0x00025756
coefficient_7_22:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ23exp2
//
//*****************************************************************************
    .section .text._IQ23exp2
    .globl _IQ23exp2
    .thumb_func
_IQ23exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #23
    rsbs    r12, r12, #(30 - 23)
    bmi     exp_saturation_23
    lsl     r1, r0, #(32 - 23)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_23
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_23
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_23
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_23
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_23
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_23
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_23
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_23
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_23:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_23:
    .word 0x3ffffffe
coefficient_1_23:
    .word 0x2c5c861c
coefficient_2_23:
    .word 0x0f5fde0f
coefficient_3_23:
    .word 0x038d669b
coefficient_4_23:
    .word 0x009d817b
coefficient_5_23:
    .word 0x00160186
coefficient_6_23:
    .word 0x00025756
coefficient_7_23:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ24exp2
//
//*****************************************************************************
    .section .text._IQ24exp2
    .globl _IQ24exp2
    .thumb_func
_IQ24exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #24
    rsbs    r12, r12, #(30 - 24)
    bmi     exp_saturation_24
    lsl     r1, r0, #(32 - 24)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_24
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_24
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_24
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_24
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_24
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_24
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_24
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_24
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_24:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_24:
    .word 0x3ffffffe
coefficient_1_24:
    .word 0x2c5c861c
coefficient_2_24:
    .word 0x0f5fde0f
coefficient_3_24:
    .word 0x038d669b
coefficient_4_24:
    .word 0x009d817b
coefficient_5_24:
    .word 0x00160186
coefficient_6_24:
    .word 0x00025756
coefficient_7_24:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ25exp2
//
//*****************************************************************************
    .section .text._IQ25exp2
    .globl _IQ25exp2
    .thumb_func
_IQ25exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #25
    rsbs    r12, r12, #(30 - 25)
    bmi     exp_saturation_25
    lsl     r1, r0, #(32 - 25)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_25
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_25
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_25
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_25
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_25
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_25
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_25
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_25
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_25:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_25:
    .word 0x3ffffffe
coefficient_1_25:
    .word 0x2c5c861c
coefficient_2_25:
    .word 0x0f5fde0f
coefficient_3_25:
    .word 0x038d669b
coefficient_4_25:
    .word 0x009d817b
coefficient_5_25:
    .word 0x00160186
coefficient_6_25:
    .word 0x00025756
coefficient_7_25:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ26exp2
//
//*****************************************************************************
    .section .text._IQ26exp2
    .globl _IQ26exp2
    .thumb_func
_IQ26exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #26
    rsbs    r12, r12, #(30 - 26)
    bmi     exp_saturation_26
    lsl     r1, r0, #(32 - 26)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_26
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_26
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_26
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_26
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_26
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_26
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_26
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_26
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_26:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_26:
    .word 0x3ffffffe
coefficient_1_26:
    .word 0x2c5c861c
coefficient_2_26:
    .word 0x0f5fde0f
coefficient_3_26:
    .word 0x038d669b
coefficient_4_26:
    .word 0x009d817b
coefficient_5_26:
    .word 0x00160186
coefficient_6_26:
    .word 0x00025756
coefficient_7_26:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ27exp2
//
//*****************************************************************************
    .section .text._IQ27exp2
    .globl _IQ27exp2
    .thumb_func
_IQ27exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #27
    rsbs    r12, r12, #(30 - 27)
    bmi     exp_saturation_27
    lsl     r1, r0, #(32 - 27)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_27
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_27
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_27
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_27
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_27
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_27
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_27
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_27
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_27:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_27:
    .word 0x3ffffffe
coefficient_1_27:
    .word 0x2c5c861c
coefficient_2_27:
    .word 0x0f5fde0f
coefficient_3_27:
    .word 0x038d669b
coefficient_4_27:
    .word 0x009d817b
coefficient_5_27:
    .word 0x00160186
coefficient_6_27:
    .word 0x00025756
coefficient_7_27:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ28exp2
//
//*****************************************************************************
    .section .text._IQ28exp2
    .globl _IQ28exp2
    .thumb_func
_IQ28exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #28
    rsbs    r12, r12, #(30 - 28)
    bmi     exp_saturation_28
    lsl     r1, r0, #(32 - 28)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_28
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_28
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_28
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_28
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_28
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_28
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_28
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_28
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_28:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_28:
    .word 0x3ffffffe
coefficient_1_28:
    .word 0x2c5c861c
coefficient_2_28:
    .word 0x0f5fde0f
coefficient_3_28:
    .word 0x038d669b
coefficient_4_28:
    .word 0x009d817b
coefficient_5_28:
    .word 0x00160186
coefficient_6_28:
    .word 0x00025756
coefficient_7_28:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ29exp2
//
//*****************************************************************************
    .section .text._IQ29exp2
    .globl _IQ29exp2
    .thumb_func
_IQ29exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #29
    rsbs    r12, r12, #(30 - 29)
    bmi     exp_saturation_29
    lsl     r1, r0, #(32 - 29)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_29
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_29
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_29
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_29
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_29
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_29
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_29
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_29
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_29:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_29:
    .word 0x3ffffffe
coefficient_1_29:
    .word 0x2c5c861c
coefficient_2_29:
    .word 0x0f5fde0f
coefficient_3_29:
    .word 0x038d669b
coefficient_4_29:
    .word 0x009d817b
coefficient_5_29:
    .word 0x00160186
coefficient_6_29:
    .word 0x00025756
coefficient_7_29:
    .word 0x00005ae7

//*****************************************************************************
//
// _IQ30exp2
//
//*****************************************************************************
    .section .text._IQ30exp2
    .globl _IQ30exp2
    .thumb_func
_IQ30exp2:
    //
    // Calculate the final shift required.
    // This calculation is (integer portion of X)-(30-Q)
    // If this is negative, it will cause saturation later: bail now.
    //
    asr     r12, r0, #30
    rsbs    r12, r12, #(30 - 30)
    bmi     exp_saturation_30
    lsl     r1, r0, #(32 - 30)

    //
    // Calculate the approximating polynomial.
    // R0 Result in Q30
    // R1 X, fractional portion in Q32
    // R2 Coefficient
    // R3 Multiplication scratch space.
    //
    ldr     r2, coefficient_7_30
    umull   r3, r0, r2, r1
    ldr     r2, coefficient_6_30
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_5_30
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_4_30
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_3_30
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_2_30
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_1_30
    add     r0, r0, r2
    umull   r3, r0, r0, r1
    ldr     r2, coefficient_0_30
    add     r0, r0, r2

    //
    // Shift answer down per previously calculated value and round.
    //
    lsrs    r0, r0, r12
    adc     r0, r0, #0

    //
    // The shift instruction above will incorrectly handle large shift values
    // and ignore everything past the first byte. This will sometimes cause
    // large negative inputs to incorrectly give a non zero answer. This will
    // explicitly find these cases and zero them out.
    //
    lsrs    r12, r12, #5
    it      ne
        movne   r0, #0

    //
    // Return
    //
    bx    lr

    //
    // Handles the case where the result saturates.
    //
exp_saturation_30:
    mvn   r0, #0x80000000
    bx    lr

    //
    // The literal pool.
    //
    .balign 4
coefficient_0_30:
    .word 0x3ffffffe
coefficient_1_30:
    .word 0x2c5c861c
coefficient_2_30:
    .word 0x0f5fde0f
coefficient_3_30:
    .word 0x038d669b
coefficient_4_30:
    .word 0x009d817b
coefficient_5_30:
    .word 0x00160186
coefficient_6_30:
    .word 0x00025756
coefficient_7_30:
    .word 0x00005ae7

    .end
