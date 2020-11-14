//*****************************************************************************
//
// IQint.S - Return integer portion of fixed point number.
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:   _IQNint
//
//*****************************************************************************
//
// C Usage:    extern long _IQint(long A);   // no round or sat
//
//-----------------------------------------------------------------------------
//
// On Entry:   r0    = A in IQ format
//
// Regs Used:  r0
//
// On Exit:    r0    = integer portion of A stored as "long"
//
// Q range:    30 to 1
//
//-----------------------------------------------------------------------------
//
// Algorithm:  The integer portion of the IQ number is calculated
//             as follows:
//
//                integer = A >> q_value;
//			
//-----------------------------------------------------------------------------
//
// Benchmark:
//
// Cycles = 13 (includes LCR/LRETR)
//
//*****************************************************************************

    .syntax unified
    .thumb
    .text

//*****************************************************************************
//
// _IQ1int
//
//*****************************************************************************
    .section .text._IQ1int
    .globl _IQ1int
    .thumb_func
_IQ1int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #1

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
// _IQ2int
//
//*****************************************************************************
    .section .text._IQ2int
    .globl _IQ2int
    .thumb_func
_IQ2int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #2

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
// _IQ3int
//
//*****************************************************************************
    .section .text._IQ3int
    .globl _IQ3int
    .thumb_func
_IQ3int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #3

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
// _IQ4int
//
//*****************************************************************************
    .section .text._IQ4int
    .globl _IQ4int
    .thumb_func
_IQ4int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #4

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
// _IQ5int
//
//*****************************************************************************
    .section .text._IQ5int
    .globl _IQ5int
    .thumb_func
_IQ5int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #5

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
// _IQ6int
//
//*****************************************************************************
    .section .text._IQ6int
    .globl _IQ6int
    .thumb_func
_IQ6int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #6

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
// _IQ7int
//
//*****************************************************************************
    .section .text._IQ7int
    .globl _IQ7int
    .thumb_func
_IQ7int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #7

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
// _IQ8int
//
//*****************************************************************************
    .section .text._IQ8int
    .globl _IQ8int
    .thumb_func
_IQ8int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #8

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
// _IQ9int
//
//*****************************************************************************
    .section .text._IQ9int
    .globl _IQ9int
    .thumb_func
_IQ9int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #9

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
// _IQ10int
//
//*****************************************************************************
    .section .text._IQ10int
    .globl _IQ10int
    .thumb_func
_IQ10int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #10

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
// _IQ11int
//
//*****************************************************************************
    .section .text._IQ11int
    .globl _IQ11int
    .thumb_func
_IQ11int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #11

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
// _IQ12int
//
//*****************************************************************************
    .section .text._IQ12int
    .globl _IQ12int
    .thumb_func
_IQ12int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #12

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
// _IQ13int
//
//*****************************************************************************
    .section .text._IQ13int
    .globl _IQ13int
    .thumb_func
_IQ13int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #13

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
// _IQ14int
//
//*****************************************************************************
    .section .text._IQ14int
    .globl _IQ14int
    .thumb_func
_IQ14int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #14

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
// _IQ15int
//
//*****************************************************************************
    .section .text._IQ15int
    .globl _IQ15int
    .thumb_func
_IQ15int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #15

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
// _IQ16int
//
//*****************************************************************************
    .section .text._IQ16int
    .globl _IQ16int
    .thumb_func
_IQ16int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #16

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
// _IQ17int
//
//*****************************************************************************
    .section .text._IQ17int
    .globl _IQ17int
    .thumb_func
_IQ17int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #17

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
// _IQ18int
//
//*****************************************************************************
    .section .text._IQ18int
    .globl _IQ18int
    .thumb_func
_IQ18int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #18

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
// _IQ19int
//
//*****************************************************************************
    .section .text._IQ19int
    .globl _IQ19int
    .thumb_func
_IQ19int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #19

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
// _IQ20int
//
//*****************************************************************************
    .section .text._IQ20int
    .globl _IQ20int
    .thumb_func
_IQ20int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #20

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
// _IQ21int
//
//*****************************************************************************
    .section .text._IQ21int
    .globl _IQ21int
    .thumb_func
_IQ21int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #21

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
// _IQ22int
//
//*****************************************************************************
    .section .text._IQ22int
    .globl _IQ22int
    .thumb_func
_IQ22int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #22

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
// _IQ23int
//
//*****************************************************************************
    .section .text._IQ23int
    .globl _IQ23int
    .thumb_func
_IQ23int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #23

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
// _IQ24int
//
//*****************************************************************************
    .section .text._IQ24int
    .globl _IQ24int
    .thumb_func
_IQ24int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #24

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
// _IQ25int
//
//*****************************************************************************
    .section .text._IQ25int
    .globl _IQ25int
    .thumb_func
_IQ25int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #25

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
// _IQ26int
//
//*****************************************************************************
    .section .text._IQ26int
    .globl _IQ26int
    .thumb_func
_IQ26int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #26

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
// _IQ27int
//
//*****************************************************************************
    .section .text._IQ27int
    .globl _IQ27int
    .thumb_func
_IQ27int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #27

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
// _IQ28int
//
//*****************************************************************************
    .section .text._IQ28int
    .globl _IQ28int
    .thumb_func
_IQ28int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #28

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
// _IQ29int
//
//*****************************************************************************
    .section .text._IQ29int
    .globl _IQ29int
    .thumb_func
_IQ29int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #29

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
// _IQ30int
//
//*****************************************************************************
    .section .text._IQ30int
    .globl _IQ30int
    .thumb_func
_IQ30int:
    //
    // Shift first operand by Q and update sign flags
    //
    asrs    r0, r0, #30

    //
    // Return to the caller.
    //
    bx      lr

    //
    // Make sure that the end of the section is word aligned.
    //
    .balign 4

    .end
