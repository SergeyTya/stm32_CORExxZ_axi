//*****************************************************************************
//
// IQtoF.S - Convert IQ to Single Precision Float
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNtoF
//
//*****************************************************************************
//
// C Usage:    extern float _IQtoF(long A);   // no round or sat
//
//-----------------------------------------------------------------------------
//
// On Entry:   ACC    = A in IQ format
//
// Regs Used:  XT, P
//
// On Exit:    ACC    = IEEE 754 floating-point equivalent of A
//
// Q range:    30 to 1
//
//-----------------------------------------------------------------------------
//
// Algorithm:  This operation converts an IQ number to the equivalent
//             IEEE 754 Single-Precision floating-point format. This
//             format is shown below:
//
//              31  30        23 22                                 0
//             +-----------------------------------------------------+
//             | s |      e     |                 f                  |
//             +-----------------------------------------------------+
//
//             Value = (-1)^s * 2^(e-127) * 1.f
//
//             where: e = 1 to 254, f = 0.000000000 to ~1.0
//                    e = 0, f = 0, s = 0, Value = 0.0
//                    e = 0 and f != 0 case cannot occur in IQmath
//                    e = 255 case cannot occur in IQmath
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
// _IQ1toF
//
//*****************************************************************************
    .section .text._IQ1toF
    .globl _IQ1toF
    .thumb_func
_IQ1toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero1

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 1)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero1:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ2toF
//
//*****************************************************************************
    .section .text._IQ2toF
    .globl _IQ2toF
    .thumb_func
_IQ2toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero2

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 2)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero2:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ3toF
//
//*****************************************************************************
    .section .text._IQ3toF
    .globl _IQ3toF
    .thumb_func
_IQ3toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero3

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 3)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero3:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ4toF
//
//*****************************************************************************
    .section .text._IQ4toF
    .globl _IQ4toF
    .thumb_func
_IQ4toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero4

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 4)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero4:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ5toF
//
//*****************************************************************************
    .section .text._IQ5toF
    .globl _IQ5toF
    .thumb_func
_IQ5toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero5

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 5)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero5:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ6toF
//
//*****************************************************************************
    .section .text._IQ6toF
    .globl _IQ6toF
    .thumb_func
_IQ6toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero6

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 6)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero6:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ7toF
//
//*****************************************************************************
    .section .text._IQ7toF
    .globl _IQ7toF
    .thumb_func
_IQ7toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero7

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 7)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero7:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ8toF
//
//*****************************************************************************
    .section .text._IQ8toF
    .globl _IQ8toF
    .thumb_func
_IQ8toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero8

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 8)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero8:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ9toF
//
//*****************************************************************************
    .section .text._IQ9toF
    .globl _IQ9toF
    .thumb_func
_IQ9toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero9

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 9)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero9:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ10toF
//
//*****************************************************************************
    .section .text._IQ10toF
    .globl _IQ10toF
    .thumb_func
_IQ10toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero10

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 10)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero10:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ11toF
//
//*****************************************************************************
    .section .text._IQ11toF
    .globl _IQ11toF
    .thumb_func
_IQ11toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero11

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 11)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero11:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ12toF
//
//*****************************************************************************
    .section .text._IQ12toF
    .globl _IQ12toF
    .thumb_func
_IQ12toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero12

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 12)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero12:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ13toF
//
//*****************************************************************************
    .section .text._IQ13toF
    .globl _IQ13toF
    .thumb_func
_IQ13toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero13

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 13)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero13:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ14toF
//
//*****************************************************************************
    .section .text._IQ14toF
    .globl _IQ14toF
    .thumb_func
_IQ14toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero14

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 14)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero14:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ15toF
//
//*****************************************************************************
    .section .text._IQ15toF
    .globl _IQ15toF
    .thumb_func
_IQ15toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero15

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 15)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero15:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ16toF
//
//*****************************************************************************
    .section .text._IQ16toF
    .globl _IQ16toF
    .thumb_func
_IQ16toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero16

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 16)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero16:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ17toF
//
//*****************************************************************************
    .section .text._IQ17toF
    .globl _IQ17toF
    .thumb_func
_IQ17toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero17

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 17)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero17:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ18toF
//
//*****************************************************************************
    .section .text._IQ18toF
    .globl _IQ18toF
    .thumb_func
_IQ18toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero18

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 18)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero18:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ19toF
//
//*****************************************************************************
    .section .text._IQ19toF
    .globl _IQ19toF
    .thumb_func
_IQ19toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero19

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 19)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero19:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ20toF
//
//*****************************************************************************
    .section .text._IQ20toF
    .globl _IQ20toF
    .thumb_func
_IQ20toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero20

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 20)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero20:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ21toF
//
//*****************************************************************************
    .section .text._IQ21toF
    .globl _IQ21toF
    .thumb_func
_IQ21toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero21

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 21)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero21:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ22toF
//
//*****************************************************************************
    .section .text._IQ22toF
    .globl _IQ22toF
    .thumb_func
_IQ22toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero22

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 22)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero22:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ23toF
//
//*****************************************************************************
    .section .text._IQ23toF
    .globl _IQ23toF
    .thumb_func
_IQ23toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero23

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 23)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero23:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ24toF
//
//*****************************************************************************
    .section .text._IQ24toF
    .globl _IQ24toF
    .thumb_func
_IQ24toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero24

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 24)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero24:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ25toF
//
//*****************************************************************************
    .section .text._IQ25toF
    .globl _IQ25toF
    .thumb_func
_IQ25toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero25

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 25)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero25:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ26toF
//
//*****************************************************************************
    .section .text._IQ26toF
    .globl _IQ26toF
    .thumb_func
_IQ26toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero26

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 26)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero26:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ27toF
//
//*****************************************************************************
    .section .text._IQ27toF
    .globl _IQ27toF
    .thumb_func
_IQ27toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero27

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 27)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero27:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ28toF
//
//*****************************************************************************
    .section .text._IQ28toF
    .globl _IQ28toF
    .thumb_func
_IQ28toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero28

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 28)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero28:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ29toF
//
//*****************************************************************************
    .section .text._IQ29toF
    .globl _IQ29toF
    .thumb_func
_IQ29toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero29

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 29)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero29:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

//*****************************************************************************
//
// _IQ30toF
//
//*****************************************************************************
    .section .text._IQ30toF
    .globl _IQ30toF
    .thumb_func
_IQ30toF:
    //
    // The only special case to cover is if the operand is zero.
    // In this case, we simply return - r0 is already appropriately set.
    //
    cbz     r0, r0isZero30

    //
    // Prepare working register r1 with sign
    // Take absolute value of input
    //
    ands    r1, r0, #0x80000000
        it      mi
        rsbmi   r0, r0, #0

    //
    // Prepare exponent portion in r3
    // This is calculated as follows:
    //    +127 per the definition from IEEE 754
    //    +31-Q to compensate hidden shift from IQ
    //    -r3 = the number of leading zeros
    //
    clz     r3, r0
    rsb     r2, r3, #(127 + 31 - 30)

    //
    // Prepare normalized mantissa.
    //
    lsl     r0, r0, r3
    lsr     r0, r0, #8

    //
    // Insert exponent bits.
    // This over-writes the extraneous leading 1 in bit 23
    //
    bfi     r0, r2, #23, #8

    //
    // OR Sign bit back into result.
    //
    orr     r0, r1, r0

    //
    // Return to the caller.
    //
r0isZero30:
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

    .end
