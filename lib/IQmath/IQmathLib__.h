//*****************************************************************************
//
// IQmathLib.h - IQmath library C language function definitions.
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

#ifndef __IQMATHLIB_H__
#define __IQMATHLIB_H__

//*****************************************************************************
//
// If building with a C++ compiler, make all of the definitions in this header
// have a C binding.
//
//*****************************************************************************
#ifdef __cplusplus
extern "C"
{
#endif

//*****************************************************************************
//
// By redefining MATH_TYPE, all IQmath functions will be replaced by their
// floating point equivalents.
//
//*****************************************************************************
#define FLOAT_MATH              0
#define IQ_MATH                 1
#ifndef MATH_TYPE
#define MATH_TYPE               IQ_MATH
#endif

//*****************************************************************************
//
// The IQ format to be used when the IQ format is not explicitly specified
// (such as _IQcos instead of _IQ16cos).  This value must be between 1 and 30,
// inclusive.
//
//*****************************************************************************
#ifndef GLOBAL_Q
#define GLOBAL_Q                20
#endif

//*****************************************************************************
//
// Include some standard headers, as required based on the math type.
//
//*****************************************************************************
#if MATH_TYPE == FLOAT_MATH
#include <math.h>
#endif
#include <limits.h>
#include <stdlib.h>

//*****************************************************************************
//
// Various Useful Constant Definitions:
//
//*****************************************************************************
#define Q30                     30
#define Q29                     29
#define Q28                     28
#define Q27                     27
#define Q26                     26
#define Q25                     25
#define Q24                     24
#define Q23                     23
#define Q22                     22
#define Q21                     21
#define Q20                     20
#define Q19                     19
#define Q18                     18
#define Q17                     17
#define Q16                     16
#define Q15                     15
#define Q14                     14
#define Q13                     13
#define Q12                     12
#define Q11                     11
#define Q10                     10
#define Q9                      9
#define Q8                      8
#define Q7                      7
#define Q6                      6
#define Q5                      5
#define Q4                      4
#define Q3                      3
#define Q2                      2
#define Q1                      1
#define QG                      GLOBAL_Q

#define MAX_IQ_POS              LONG_MAX
#define MAX_IQ_NEG              LONG_MIN
#define MIN_IQ_POS              1
#define MIN_IQ_NEG              -1

//*****************************************************************************
//
// See if IQmath or floating point is being used.
//
//*****************************************************************************
#if MATH_TYPE == IQ_MATH

//*****************************************************************************
//
// The types for the various IQ formats.
//
//*****************************************************************************
typedef long _iq30;
typedef long _iq29;
typedef long _iq28;
typedef long _iq27;
typedef long _iq26;
typedef long _iq25;
typedef long _iq24;
typedef long _iq23;
typedef long _iq22;
typedef long _iq21;
typedef long _iq20;
typedef long _iq19;
typedef long _iq18;
typedef long _iq17;
typedef long _iq16;
typedef long _iq15;
typedef long _iq14;
typedef long _iq13;
typedef long _iq12;
typedef long _iq11;
typedef long _iq10;
typedef long _iq9;
typedef long _iq8;
typedef long _iq7;
typedef long _iq6;
typedef long _iq5;
typedef long _iq4;
typedef long _iq3;
typedef long _iq2;
typedef long _iq1;
typedef long _iq;

//*****************************************************************************
//
// Simple multiplies or divides, which are accomplished with simple shifts.
//
//*****************************************************************************
#define _IQmpy2(A)              ((A) << 1)
#define _IQmpy4(A)              ((A) << 2)
#define _IQmpy8(A)              ((A) << 3)
#define _IQmpy16(A)             ((A) << 4)
#define _IQmpy32(A)             ((A) << 5)
#define _IQmpy64(A)             ((A) << 6)
#define _IQdiv2(A)              ((A) >> 1)
#define _IQdiv4(A)              ((A) >> 2)
#define _IQdiv8(A)              ((A) >> 3)
#define _IQdiv16(A)             ((A) >> 4)
#define _IQdiv32(A)             ((A) >> 5)
#define _IQdiv64(A)             ((A) >> 6)

//*****************************************************************************
//
// Convert a value into an IQ number.
//
//*****************************************************************************
#define _IQ30(A)                ((_iq30)((A) * (1 << 30)))
#define _IQ29(A)                ((_iq29)((A) * (1 << 29)))
#define _IQ28(A)                ((_iq28)((A) * (1 << 28)))
#define _IQ27(A)                ((_iq27)((A) * (1 << 27)))
#define _IQ26(A)                ((_iq26)((A) * (1 << 26)))
#define _IQ25(A)                ((_iq25)((A) * (1 << 25)))
#define _IQ24(A)                ((_iq24)((A) * (1 << 24)))
#define _IQ23(A)                ((_iq23)((A) * (1 << 23)))
#define _IQ22(A)                ((_iq22)((A) * (1 << 22)))
#define _IQ21(A)                ((_iq21)((A) * (1 << 21)))
#define _IQ20(A)                ((_iq20)((A) * (1 << 20)))
#define _IQ19(A)                ((_iq19)((A) * (1 << 19)))
#define _IQ18(A)                ((_iq18)((A) * (1 << 18)))
#define _IQ17(A)                ((_iq17)((A) * (1 << 17)))
#define _IQ16(A)                ((_iq16)((A) * (1 << 16)))
#define _IQ15(A)                ((_iq15)((A) * (1 << 15)))
#define _IQ14(A)                ((_iq14)((A) * (1 << 14)))
#define _IQ13(A)                ((_iq13)((A) * (1 << 13)))
#define _IQ12(A)                ((_iq12)((A) * (1 << 12)))
#define _IQ11(A)                ((_iq11)((A) * (1 << 11)))
#define _IQ10(A)                ((_iq10)((A) * (1 << 10)))
#define _IQ9(A)                 ((_iq9)((A) * (1 << 9)))
#define _IQ8(A)                 ((_iq8)((A) * (1 << 8)))
#define _IQ7(A)                 ((_iq7)((A) * (1 << 7)))
#define _IQ6(A)                 ((_iq6)((A) * (1 << 6)))
#define _IQ5(A)                 ((_iq5)((A) * (1 << 5)))
#define _IQ4(A)                 ((_iq4)((A) * (1 << 4)))
#define _IQ3(A)                 ((_iq3)((A) * (1 << 3)))
#define _IQ2(A)                 ((_iq2)((A) * (1 << 2)))
#define _IQ1(A)                 ((_iq1)((A) * (1 << 1)))

#if GLOBAL_Q == 30
#define _IQ(A)                  _IQ30(A)
#endif
#if GLOBAL_Q == 29
#define _IQ(A)                  _IQ29(A)
#endif
#if GLOBAL_Q == 28
#define _IQ(A)                  _IQ28(A)
#endif
#if GLOBAL_Q == 27
#define _IQ(A)                  _IQ27(A)
#endif
#if GLOBAL_Q == 26
#define _IQ(A)                  _IQ26(A)
#endif
#if GLOBAL_Q == 25
#define _IQ(A)                  _IQ25(A)
#endif
#if GLOBAL_Q == 24
#define _IQ(A)                  _IQ24(A)
#endif
#if GLOBAL_Q == 23
#define _IQ(A)                  _IQ23(A)
#endif
#if GLOBAL_Q == 22
#define _IQ(A)                  _IQ22(A)
#endif
#if GLOBAL_Q == 21
#define _IQ(A)                  _IQ21(A)
#endif
#if GLOBAL_Q == 20
#define _IQ(A)                  _IQ20(A)
#endif
#if GLOBAL_Q == 19
#define _IQ(A)                  _IQ19(A)
#endif
#if GLOBAL_Q == 18
#define _IQ(A)                  _IQ18(A)
#endif
#if GLOBAL_Q == 17
#define _IQ(A)                  _IQ17(A)
#endif
#if GLOBAL_Q == 16
#define _IQ(A)                  _IQ16(A)
#endif
#if GLOBAL_Q == 15
#define _IQ(A)                  _IQ15(A)
#endif
#if GLOBAL_Q == 14
#define _IQ(A)                  _IQ14(A)
#endif
#if GLOBAL_Q == 13
#define _IQ(A)                  _IQ13(A)
#endif
#if GLOBAL_Q == 12
#define _IQ(A)                  _IQ12(A)
#endif
#if GLOBAL_Q == 11
#define _IQ(A)                  _IQ11(A)
#endif
#if GLOBAL_Q == 10
#define _IQ(A)                  _IQ10(A)
#endif
#if GLOBAL_Q == 9
#define _IQ(A)                  _IQ9(A)
#endif
#if GLOBAL_Q == 8
#define _IQ(A)                  _IQ8(A)
#endif
#if GLOBAL_Q == 7
#define _IQ(A)                  _IQ7(A)
#endif
#if GLOBAL_Q == 6
#define _IQ(A)                  _IQ6(A)
#endif
#if GLOBAL_Q == 5
#define _IQ(A)                  _IQ5(A)
#endif
#if GLOBAL_Q == 4
#define _IQ(A)                  _IQ4(A)
#endif
#if GLOBAL_Q == 3
#define _IQ(A)                  _IQ3(A)
#endif
#if GLOBAL_Q == 2
#define _IQ(A)                  _IQ2(A)
#endif
#if GLOBAL_Q == 1
#define _IQ(A)                  _IQ1(A)
#endif

//*****************************************************************************
//
// Convert an IQ number to a floating point value.
//
//*****************************************************************************
/*
extern float _IQ30toF(_iq30 A);
extern float _IQ29toF(_iq29 A);
extern float _IQ28toF(_iq28 A);
extern float _IQ27toF(_iq27 A);
extern float _IQ26toF(_iq26 A);
extern float _IQ25toF(_iq25 A);
extern float _IQ24toF(_iq24 A);
extern float _IQ23toF(_iq23 A);
extern float _IQ22toF(_iq22 A);
extern float _IQ21toF(_iq21 A);
extern float _IQ20toF(_iq20 A);
extern float _IQ19toF(_iq19 A);
extern float _IQ18toF(_iq18 A);
extern float _IQ17toF(_iq17 A);
extern float _IQ16toF(_iq16 A);
extern float _IQ15toF(_iq15 A);
extern float _IQ14toF(_iq14 A);
extern float _IQ13toF(_iq13 A);
extern float _IQ12toF(_iq12 A);
extern float _IQ11toF(_iq11 A);
extern float _IQ10toF(_iq10 A);
extern float _IQ9toF(_iq9 A);
extern float _IQ8toF(_iq8 A);
extern float _IQ7toF(_iq7 A);
extern float _IQ6toF(_iq6 A);
extern float _IQ5toF(_iq5 A);
extern float _IQ4toF(_iq4 A);
extern float _IQ3toF(_iq3 A);
extern float _IQ2toF(_iq2 A);
extern float _IQ1toF(_iq1 A);


#if GLOBAL_Q == 30
#define _IQtoF(A)               _IQ30toF(A)
#endif
#if GLOBAL_Q == 29
#define _IQtoF(A)               _IQ29toF(A)
#endif
#if GLOBAL_Q == 28
#define _IQtoF(A)               _IQ28toF(A)
#endif
#if GLOBAL_Q == 27
#define _IQtoF(A)               _IQ27toF(A)
#endif
#if GLOBAL_Q == 26
#define _IQtoF(A)               _IQ26toF(A)
#endif
#if GLOBAL_Q == 25
#define _IQtoF(A)               _IQ25toF(A)
#endif
#if GLOBAL_Q == 24
#define _IQtoF(A)               _IQ24toF(A)
#endif
#if GLOBAL_Q == 23
#define _IQtoF(A)               _IQ23toF(A)
#endif
#if GLOBAL_Q == 22
#define _IQtoF(A)               _IQ22toF(A)
#endif
#if GLOBAL_Q == 21
#define _IQtoF(A)               _IQ21toF(A)
#endif
#if GLOBAL_Q == 20
#define _IQtoF(A)               _IQ20toF(A)
#endif
#if GLOBAL_Q == 19
#define _IQtoF(A)               _IQ19toF(A)
#endif
#if GLOBAL_Q == 18
#define _IQtoF(A)               _IQ18toF(A)
#endif
#if GLOBAL_Q == 17
#define _IQtoF(A)               _IQ17toF(A)
#endif
#if GLOBAL_Q == 16
#define _IQtoF(A)               _IQ16toF(A)
#endif
#if GLOBAL_Q == 15
#define _IQtoF(A)               _IQ15toF(A)
#endif
#if GLOBAL_Q == 14
#define _IQtoF(A)               _IQ14toF(A)
#endif
#if GLOBAL_Q == 13
#define _IQtoF(A)               _IQ13toF(A)
#endif
#if GLOBAL_Q == 12
#define _IQtoF(A)               _IQ12toF(A)
#endif
#if GLOBAL_Q == 11
#define _IQtoF(A)               _IQ11toF(A)
#endif
#if GLOBAL_Q == 10
#define _IQtoF(A)               _IQ10toF(A)
#endif
#if GLOBAL_Q == 9
#define _IQtoF(A)               _IQ9toF(A)
#endif
#if GLOBAL_Q == 8
#define _IQtoF(A)               _IQ8toF(A)
#endif
#if GLOBAL_Q == 7
#define _IQtoF(A)               _IQ7toF(A)
#endif
#if GLOBAL_Q == 6
#define _IQtoF(A)               _IQ6toF(A)
#endif
#if GLOBAL_Q == 5
#define _IQtoF(A)               _IQ5toF(A)
#endif
#if GLOBAL_Q == 4
#define _IQtoF(A)               _IQ4toF(A)
#endif
#if GLOBAL_Q == 3
#define _IQtoF(A)               _IQ3toF(A)
#endif
#if GLOBAL_Q == 2
#define _IQtoF(A)               _IQ2toF(A)
#endif
#if GLOBAL_Q == 1
#define _IQtoF(A)               _IQ1toF(A)
#endif

*/
//*****************************************************************************
//
// Convert an IQ number to a double-precision floating point value.
//
//*****************************************************************************


//*****************************************************************************
//
// Saturates an IQ number in a given range.
//
//*****************************************************************************
#define _IQsat(A, Pos, Neg)     (((A) > (Pos)) ?                              \
                                 (Pos) :                                      \
                                 (((A) < (Neg)) ? (Neg) : (A)))

//*****************************************************************************
//
// Converts an IQ number between the global IQ format and a specified IQ
// format.
//
//*****************************************************************************
#define _IQtoIQ30(A)            ((_iq30)(A) << (30 - GLOBAL_Q))
#define _IQ30toIQ(A)            ((_iq30)(A) >> (30 - GLOBAL_Q))

#if (GLOBAL_Q >= 29)
#define _IQtoIQ29(A)            ((_iq29)(A) >> (GLOBAL_Q - 29))
#define _IQ29toIQ(A)            ((_iq29)(A) << (GLOBAL_Q - 29))
#else
#define _IQtoIQ29(A)            ((_iq29)(A) << (29 - GLOBAL_Q))
#define _IQ29toIQ(A)            ((_iq29)(A) >> (29 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 28)
#define _IQtoIQ28(A)            ((_iq28)(A) >> (GLOBAL_Q - 28))
#define _IQ28toIQ(A)            ((_iq28)(A) << (GLOBAL_Q - 28))
#else
#define _IQtoIQ28(A)            ((_iq28)(A) << (28 - GLOBAL_Q))
#define _IQ28toIQ(A)            ((_iq28)(A) >> (28 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 27)
#define _IQtoIQ27(A)            ((_iq27)(A) >> (GLOBAL_Q - 27))
#define _IQ27toIQ(A)            ((_iq27)(A) << (GLOBAL_Q - 27))
#else
#define _IQtoIQ27(A)            ((_iq27)(A) << (27 - GLOBAL_Q))
#define _IQ27toIQ(A)            ((_iq27)(A) >> (27 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 26)
#define _IQtoIQ26(A)            ((_iq26)(A) >> (GLOBAL_Q - 26))
#define _IQ26toIQ(A)            ((_iq26)(A) << (GLOBAL_Q - 26))
#else
#define _IQtoIQ26(A)            ((_iq26)(A) << (26 - GLOBAL_Q))
#define _IQ26toIQ(A)            ((_iq26)(A) >> (26 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 25)
#define _IQtoIQ25(A)            ((_iq25)(A) >> (GLOBAL_Q - 25))
#define _IQ25toIQ(A)            ((_iq25)(A) << (GLOBAL_Q - 25))
#else
#define _IQtoIQ25(A)            ((_iq25)(A) << (25 - GLOBAL_Q))
#define _IQ25toIQ(A)            ((_iq25)(A) >> (25 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 24)
#define _IQtoIQ24(A)            ((_iq24)(A) >> (GLOBAL_Q - 24))
#define _IQ24toIQ(A)            ((_iq24)(A) << (GLOBAL_Q - 24))
#else
#define _IQtoIQ24(A)            ((_iq24)(A) << (24 - GLOBAL_Q))
#define _IQ24toIQ(A)            ((_iq24)(A) >> (24 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 23)
#define _IQtoIQ23(A)            ((_iq23)(A) >> (GLOBAL_Q - 23))
#define _IQ23toIQ(A)            ((_iq23)(A) << (GLOBAL_Q - 23))
#else
#define _IQtoIQ23(A)            ((_iq23)(A) << (23 - GLOBAL_Q))
#define _IQ23toIQ(A)            ((_iq23)(A) >> (23 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 22)
#define _IQtoIQ22(A)            ((_iq22)(A) >> (GLOBAL_Q - 22))
#define _IQ22toIQ(A)            ((_iq22)(A) << (GLOBAL_Q - 22))
#else
#define _IQtoIQ22(A)            ((_iq22)(A) << (22 - GLOBAL_Q))
#define _IQ22toIQ(A)            ((_iq22)(A) >> (22 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 21)
#define _IQtoIQ21(A)            ((_iq21)(A) >> (GLOBAL_Q - 21))
#define _IQ21toIQ(A)            ((_iq21)(A) << (GLOBAL_Q - 21))
#else
#define _IQtoIQ21(A)            ((_iq21)(A) << (21 - GLOBAL_Q))
#define _IQ21toIQ(A)            ((_iq21)(A) >> (21 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 20)
#define _IQtoIQ20(A)            ((_iq20)(A) >> (GLOBAL_Q - 20))
#define _IQ20toIQ(A)            ((_iq20)(A) << (GLOBAL_Q - 20))
#else
#define _IQtoIQ20(A)            ((_iq20)(A) << (20 - GLOBAL_Q))
#define _IQ20toIQ(A)            ((_iq20)(A) >> (20 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 19)
#define _IQtoIQ19(A)            ((_iq19)(A) >> (GLOBAL_Q - 19))
#define _IQ19toIQ(A)            ((_iq19)(A) << (GLOBAL_Q - 19))
#else
#define _IQtoIQ19(A)            ((_iq19)(A) << (19 - GLOBAL_Q))
#define _IQ19toIQ(A)            ((_iq19)(A) >> (19 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 18)
#define _IQtoIQ18(A)            ((_iq18)(A) >> (GLOBAL_Q - 18))
#define _IQ18toIQ(A)            ((_iq18)(A) << (GLOBAL_Q - 18))
#else
#define _IQtoIQ18(A)            ((_iq18)(A) << (18 - GLOBAL_Q))
#define _IQ18toIQ(A)            ((_iq18)(A) >> (18 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 17)
#define _IQtoIQ17(A)            ((_iq17)(A) >> (GLOBAL_Q - 17))
#define _IQ17toIQ(A)            ((_iq17)(A) << (GLOBAL_Q - 17))
#else
#define _IQtoIQ17(A)            ((_iq17)(A) << (17 - GLOBAL_Q))
#define _IQ17toIQ(A)            ((_iq17)(A) >> (17 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 16)
#define _IQtoIQ16(A)            ((_iq16)(A) >> (GLOBAL_Q - 16))
#define _IQ16toIQ(A)            ((_iq16)(A) << (GLOBAL_Q - 16))
#else
#define _IQtoIQ16(A)            ((_iq16)(A) << (16 - GLOBAL_Q))
#define _IQ16toIQ(A)            ((_iq16)(A) >> (16 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 15)
#define _IQtoIQ15(A)            ((_iq15)(A) >> (GLOBAL_Q - 15))
#define _IQ15toIQ(A)            ((_iq15)(A) << (GLOBAL_Q - 15))
#else
#define _IQtoIQ15(A)            ((_iq15)(A) << (15 - GLOBAL_Q))
#define _IQ15toIQ(A)            ((_iq15)(A) >> (15 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 14)
#define _IQtoIQ14(A)            ((_iq14)(A) >> (GLOBAL_Q - 14))
#define _IQ14toIQ(A)            ((_iq14)(A) << (GLOBAL_Q - 14))
#else
#define _IQtoIQ14(A)            ((_iq14)(A) << (14 - GLOBAL_Q))
#define _IQ14toIQ(A)            ((_iq14)(A) >> (14 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 13)
#define _IQtoIQ13(A)            ((_iq13)(A) >> (GLOBAL_Q - 13))
#define _IQ13toIQ(A)            ((_iq13)(A) << (GLOBAL_Q - 13))
#else
#define _IQtoIQ13(A)            ((_iq13)(A) << (13 - GLOBAL_Q))
#define _IQ13toIQ(A)            ((_iq13)(A) >> (13 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 12)
#define _IQtoIQ12(A)            ((_iq12)(A) >> (GLOBAL_Q - 12))
#define _IQ12toIQ(A)            ((_iq12)(A) << (GLOBAL_Q - 12))
#else
#define _IQtoIQ12(A)            ((_iq12)(A) << (12 - GLOBAL_Q))
#define _IQ12toIQ(A)            ((_iq12)(A) >> (12 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 11)
#define _IQtoIQ11(A)            ((_iq11)(A) >> (GLOBAL_Q - 11))
#define _IQ11toIQ(A)            ((_iq11)(A) << (GLOBAL_Q - 11))
#else
#define _IQtoIQ11(A)            ((_iq11)(A) << (11 - GLOBAL_Q))
#define _IQ11toIQ(A)            ((_iq11)(A) >> (11 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 10)
#define _IQtoIQ10(A)            ((_iq10)(A) >> (GLOBAL_Q - 10))
#define _IQ10toIQ(A)            ((_iq10)(A) << (GLOBAL_Q - 10))
#else
#define _IQtoIQ10(A)            ((_iq10)(A) << (10 - GLOBAL_Q))
#define _IQ10toIQ(A)            ((_iq10)(A) >> (10 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 9)
#define _IQtoIQ9(A)             ((_iq9)(A) >> (GLOBAL_Q - 9))
#define _IQ9toIQ(A)             ((_iq9)(A) << (GLOBAL_Q - 9))
#else
#define _IQtoIQ9(A)             ((_iq9)(A) << (9 - GLOBAL_Q))
#define _IQ9toIQ(A)             ((_iq9)(A) >> (9 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 8)
#define _IQtoIQ8(A)             ((_iq8)(A) >> (GLOBAL_Q - 8))
#define _IQ8toIQ(A)             ((_iq8)(A) << (GLOBAL_Q - 8))
#else
#define _IQtoIQ8(A)             ((_iq8)(A) << (8 - GLOBAL_Q))
#define _IQ8toIQ(A)             ((_iq8)(A) >> (8 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 7)
#define _IQtoIQ7(A)             ((_iq7)(A) >> (GLOBAL_Q - 7))
#define _IQ7toIQ(A)             ((_iq7)(A) << (GLOBAL_Q - 7))
#else
#define _IQtoIQ7(A)             ((_iq7)(A) << (7 - GLOBAL_Q))
#define _IQ7toIQ(A)             ((_iq7)(A) >> (7 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 6)
#define _IQtoIQ6(A)             ((_iq6)(A) >> (GLOBAL_Q - 6))
#define _IQ6toIQ(A)             ((_iq6)(A) << (GLOBAL_Q - 6))
#else
#define _IQtoIQ6(A)             ((_iq6)(A) << (6 - GLOBAL_Q))
#define _IQ6toIQ(A)             ((_iq6)(A) >> (6 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 5)
#define _IQtoIQ5(A)             ((_iq5)(A) >> (GLOBAL_Q - 5))
#define _IQ5toIQ(A)             ((_iq5)(A) << (GLOBAL_Q - 5))
#else
#define _IQtoIQ5(A)             ((_iq5)(A) << (5 - GLOBAL_Q))
#define _IQ5toIQ(A)             ((_iq5)(A) >> (5 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 4)
#define _IQtoIQ4(A)             ((_iq4)(A) >> (GLOBAL_Q - 4))
#define _IQ4toIQ(A)             ((_iq4)(A) << (GLOBAL_Q - 4))
#else
#define _IQtoIQ4(A)             ((_iq4)(A) << (4 - GLOBAL_Q))
#define _IQ4toIQ(A)             ((_iq4)(A) >> (4 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 3)
#define _IQtoIQ3(A)             ((_iq3)(A) >> (GLOBAL_Q - 3))
#define _IQ3toIQ(A)             ((_iq3)(A) << (GLOBAL_Q - 3))
#else
#define _IQtoIQ3(A)             ((_iq3)(A) << (3 - GLOBAL_Q))
#define _IQ3toIQ(A)             ((_iq3)(A) >> (3 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 2)
#define _IQtoIQ2(A)             ((_iq2)(A) >> (GLOBAL_Q - 2))
#define _IQ2toIQ(A)             ((_iq2)(A) << (GLOBAL_Q - 2))
#else
#define _IQtoIQ2(A)             ((_iq2)(A) << (2 - GLOBAL_Q))
#define _IQ2toIQ(A)             ((_iq2)(A) >> (2 - GLOBAL_Q))
#endif

#define _IQtoIQ1(A)             ((_iq1)(A) >> (GLOBAL_Q - 1))
#define _IQ1toIQ(A)             ((_iq1)(A) << (GLOBAL_Q - 1))

//*****************************************************************************
//
// Converts a number between IQ format and 16-bit Qn format.
//
//*****************************************************************************
#if (GLOBAL_Q >= 15)
#define _IQtoQ15(A)             ((long)(A) >> (GLOBAL_Q - 15))
#define _Q15toIQ(A)             ((_iq15)(A) << (GLOBAL_Q - 15))
#else
#define _IQtoQ15(A)             ((long)(A) << (15 - GLOBAL_Q))
#define _Q15toIQ(A)             ((_iq15)(A) >> (15 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 14)
#define _IQtoQ14(A)             ((long)(A) >> (GLOBAL_Q - 14))
#define _Q14toIQ(A)             ((_iq14)(A) << (GLOBAL_Q - 14))
#else
#define _IQtoQ14(A)             ((long)(A) << (14 - GLOBAL_Q))
#define _Q14toIQ(A)             ((_iq14)(A) >> (14 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 13)
#define _IQtoQ13(A)             ((long)(A) >> (GLOBAL_Q - 13))
#define _Q13toIQ(A)             ((_iq13)(A) << (GLOBAL_Q - 13))
#else
#define _IQtoQ13(A)             ((long)(A) << (13 - GLOBAL_Q))
#define _Q13toIQ(A)             ((_iq13)(A) >> (13 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 12)
#define _IQtoQ12(A)             ((long)(A) >> (GLOBAL_Q - 12))
#define _Q12toIQ(A)             ((_iq12)(A) << (GLOBAL_Q - 12))
#else
#define _IQtoQ12(A)             ((long)(A) << (12 - GLOBAL_Q))
#define _Q12toIQ(A)             ((_iq12)(A) >> (12 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 11)
#define _IQtoQ11(A)             ((long)(A) >> (GLOBAL_Q - 11))
#define _Q11toIQ(A)             ((_iq11)(A) << (GLOBAL_Q - 11))
#else
#define _IQtoQ11(A)             ((long)(A) << (11 - GLOBAL_Q))
#define _Q11toIQ(A)             ((_iq11)(A) >> (11 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 10)
#define _IQtoQ10(A)             ((long)(A) >> (GLOBAL_Q - 10))
#define _Q10toIQ(A)             ((_iq10)(A) << (GLOBAL_Q - 10))
#else
#define _IQtoQ10(A)             ((long)(A) << (10 - GLOBAL_Q))
#define _Q10toIQ(A)             ((_iq10)(A) >> (10 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 9)
#define _IQtoQ9(A)              ((long)(A) >> (GLOBAL_Q - 9))
#define _Q9toIQ(A)              ((_iq9)(A) << (GLOBAL_Q - 9))
#else
#define _IQtoQ9(A)              ((long)(A) << (9 - GLOBAL_Q))
#define _Q9toIQ(A)              ((_iq9)(A) >> (9 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 8)
#define _IQtoQ8(A)              ((long)(A) >> (GLOBAL_Q - 8))
#define _Q8toIQ(A)              ((_iq8)(A) << (GLOBAL_Q - 8))
#else
#define _IQtoQ8(A)              ((long)(A) << (8 - GLOBAL_Q))
#define _Q8toIQ(A)              ((_iq8)(A) >> (8 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 7)
#define _IQtoQ7(A)              ((long)(A) >> (GLOBAL_Q - 7))
#define _Q7toIQ(A)              ((_iq7)(A) << (GLOBAL_Q - 7))
#else
#define _IQtoQ7(A)              ((long)(A) << (7 - GLOBAL_Q))
#define _Q7toIQ(A)              ((_iq7)(A) >> (7 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 6)
#define _IQtoQ6(A)              ((long)(A) >> (GLOBAL_Q - 6))
#define _Q6toIQ(A)              ((_iq6)(A) << (GLOBAL_Q - 6))
#else
#define _IQtoQ6(A)              ((long)(A) << (6 - GLOBAL_Q))
#define _Q6toIQ(A)              ((_iq6)(A) >> (6 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 5)
#define _IQtoQ5(A)              ((long)(A) >> (GLOBAL_Q - 5))
#define _Q5toIQ(A)              ((_iq5)(A) << (GLOBAL_Q - 5))
#else
#define _IQtoQ5(A)              ((long)(A) << (5 - GLOBAL_Q))
#define _Q5toIQ(A)              ((_iq5)(A) >> (5 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 4)
#define _IQtoQ4(A)              ((long)(A) >> (GLOBAL_Q - 4))
#define _Q4toIQ(A)              ((_iq4)(A) << (GLOBAL_Q - 4))
#else
#define _IQtoQ4(A)              ((long)(A) << (4 - GLOBAL_Q))
#define _Q4toIQ(A)              ((_iq4)(A) >> (4 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 3)
#define _IQtoQ3(A)              ((long)(A) >> (GLOBAL_Q - 3))
#define _Q3toIQ(A)              ((_iq3)(A) << (GLOBAL_Q - 3))
#else
#define _IQtoQ3(A)              ((long)(A) << (3 - GLOBAL_Q))
#define _Q3toIQ(A)              ((_iq3)(A) >> (3 - GLOBAL_Q))
#endif

#if (GLOBAL_Q >= 2)
#define _IQtoQ2(A)              ((long)(A) >> (GLOBAL_Q - 2))
#define _Q2toIQ(A)              ((_iq2)(A) << (GLOBAL_Q - 2))
#else
#define _IQtoQ2(A)              ((long)(A) << (2 - GLOBAL_Q))
#define _Q2toIQ(A)              ((_iq2)(A) >> (2 - GLOBAL_Q))
#endif

#define _IQtoQ1(A)              ((long)(A) >> (GLOBAL_Q - 1))
#define _Q1toIQ(A)              ((_iq1)(A) << (GLOBAL_Q - 1))

//*****************************************************************************
//
// Multiplies two IQ numbers.
//
//****************************************************************************

extern _iq30 _IQ30mpy(_iq30 A, _iq30 B);
extern _iq29 _IQ29mpy(_iq29 A, _iq29 B);
extern _iq28 _IQ28mpy(_iq28 A, _iq28 B);
extern _iq27 _IQ27mpy(_iq27 A, _iq27 B);
extern _iq26 _IQ26mpy(_iq26 A, _iq26 B);
extern _iq25 _IQ25mpy(_iq25 A, _iq25 B);
extern _iq24 _IQ24mpy(_iq24 A, _iq24 B);
extern _iq23 _IQ23mpy(_iq23 A, _iq23 B);
extern _iq22 _IQ22mpy(_iq22 A, _iq22 B);
extern _iq21 _IQ21mpy(_iq21 A, _iq21 B);

extern _iq19 _IQ19mpy(_iq19 A, _iq19 B);
extern _iq18 _IQ18mpy(_iq18 A, _iq18 B);
extern _iq17 _IQ17mpy(_iq17 A, _iq17 B);
extern _iq16 _IQ16mpy(_iq16 A, _iq16 B);
extern _iq15 _IQ15mpy(_iq15 A, _iq15 B);
extern _iq20 _IQ20mpy(_iq20 A, _iq20 B);
extern _iq14 _IQ14mpy(_iq14 A, _iq14 B);
extern _iq13 _IQ13mpy(_iq13 A, _iq13 B);
extern _iq12 _IQ12mpy(_iq12 A, _iq12 B);
extern _iq11 _IQ11mpy(_iq11 A, _iq11 B);
extern _iq10 _IQ10mpy(_iq10 A, _iq10 B);
extern _iq9 _IQ9mpy(_iq9 A, _iq9 B);
extern _iq8 _IQ8mpy(_iq8 A, _iq8 B);
extern _iq7 _IQ7mpy(_iq7 A, _iq7 B);
extern _iq6 _IQ6mpy(_iq6 A, _iq6 B);
extern _iq5 _IQ5mpy(_iq5 A, _iq5 B);
extern _iq4 _IQ4mpy(_iq4 A, _iq4 B);
extern _iq3 _IQ3mpy(_iq3 A, _iq3 B);
extern _iq2 _IQ2mpy(_iq2 A, _iq2 B);
extern _iq1 _IQ1mpy(_iq1 A, _iq1 B);

#if GLOBAL_Q == 30
#define _IQmpy(A, B)            _IQ30mpy(A, B)
#endif
#if GLOBAL_Q == 29
#define _IQmpy(A, B)            _IQ29mpy(A, B)
#endif
#if GLOBAL_Q == 28
#define _IQmpy(A, B)            _IQ28mpy(A, B)
#endif
#if GLOBAL_Q == 27
#define _IQmpy(A, B)            _IQ27mpy(A, B)
#endif
#if GLOBAL_Q == 26
#define _IQmpy(A, B)            _IQ26mpy(A, B)
#endif
#if GLOBAL_Q == 25
#define _IQmpy(A, B)            _IQ25mpy(A, B)
#endif
#if GLOBAL_Q == 24
#define _IQmpy(A, B)            _IQ24mpy(A, B)
#endif
#if GLOBAL_Q == 23
#define _IQmpy(A, B)            _IQ23mpy(A, B)
#endif
#if GLOBAL_Q == 22
#define _IQmpy(A, B)            _IQ22mpy(A, B)
#endif
#if GLOBAL_Q == 21
#define _IQmpy(A, B)            _IQ21mpy(A, B)
#endif
#if GLOBAL_Q == 20
#define _IQmpy(A, B)            _IQ20mpy(A, B)
#endif
#if GLOBAL_Q == 19
#define _IQmpy(A, B)            _IQ19mpy(A, B)
#endif
#if GLOBAL_Q == 18
#define _IQmpy(A, B)            _IQ18mpy(A, B)
#endif
#if GLOBAL_Q == 17
#define _IQmpy(A, B)            _IQ17mpy(A, B)
#endif
#if GLOBAL_Q == 16
#define _IQmpy(A, B)            _IQ16mpy(A, B)
#endif
#if GLOBAL_Q == 15
#define _IQmpy(A, B)            _IQ15mpy(A, B)
#endif
#if GLOBAL_Q == 14
#define _IQmpy(A, B)            _IQ14mpy(A, B)
#endif
#if GLOBAL_Q == 13
#define _IQmpy(A, B)            _IQ13mpy(A, B)
#endif
#if GLOBAL_Q == 12
#define _IQmpy(A, B)            _IQ12mpy(A, B)
#endif
#if GLOBAL_Q == 11
#define _IQmpy(A, B)            _IQ11mpy(A, B)
#endif
#if GLOBAL_Q == 10
#define _IQmpy(A, B)            _IQ10mpy(A, B)
#endif
#if GLOBAL_Q == 9
#define _IQmpy(A, B)            _IQ9mpy(A, B)
#endif
#if GLOBAL_Q == 8
#define _IQmpy(A, B)            _IQ8mpy(A, B)
#endif
#if GLOBAL_Q == 7
#define _IQmpy(A, B)            _IQ7mpy(A, B)
#endif
#if GLOBAL_Q == 6
#define _IQmpy(A, B)            _IQ6mpy(A, B)
#endif
#if GLOBAL_Q == 5
#define _IQmpy(A, B)            _IQ5mpy(A, B)
#endif
#if GLOBAL_Q == 4
#define _IQmpy(A, B)            _IQ4mpy(A, B)
#endif
#if GLOBAL_Q == 3
#define _IQmpy(A, B)            _IQ3mpy(A, B)
#endif
#if GLOBAL_Q == 2
#define _IQmpy(A, B)            _IQ2mpy(A, B)
#endif
#if GLOBAL_Q == 1
#define _IQmpy(A, B)            _IQ1mpy(A, B)
#endif

//*****************************************************************************
//
// Multiplies two IQ numbers, with rounding.
//
//*****************************************************************************


//*****************************************************************************
//
// Multiplies two IQ numbers, with rounding and saturation.
//
//*****************************************************************************


//*****************************************************************************
//
// Divides two IQ numbers.
//
//*****************************************************************************



//*****************************************************************************
//
// Computes the sin of an IQ number.
//
//*****************************************************************************

extern _iq20 _IQ20sin(_iq20 A);

#if GLOBAL_Q == 20
#define _IQsin(A)               _IQ20sin(A)
#endif


//*****************************************************************************
//
// Computes the sin of an IQ number, using cycles per unit instead of radians.
//
//*****************************************************************************

//*****************************************************************************
//
// Computes the arcsin of an IQ number.
//
//*****************************************************************************

//*****************************************************************************
//
// Computes the cos of an IQ number.
//
//*****************************************************************************
extern _iq29 _IQ29cos(_iq29 A);
extern _iq28 _IQ28cos(_iq28 A);
extern _iq27 _IQ27cos(_iq27 A);
extern _iq26 _IQ26cos(_iq26 A);
extern _iq25 _IQ25cos(_iq25 A);
extern _iq24 _IQ24cos(_iq24 A);
extern _iq23 _IQ23cos(_iq23 A);
extern _iq22 _IQ22cos(_iq22 A);
extern _iq21 _IQ21cos(_iq21 A);
extern _iq20 _IQ20cos(_iq20 A);
extern _iq19 _IQ19cos(_iq19 A);
extern _iq18 _IQ18cos(_iq18 A);
extern _iq17 _IQ17cos(_iq17 A);
extern _iq16 _IQ16cos(_iq16 A);
extern _iq15 _IQ15cos(_iq15 A);
extern _iq14 _IQ14cos(_iq14 A);
extern _iq13 _IQ13cos(_iq13 A);
extern _iq12 _IQ12cos(_iq12 A);
extern _iq11 _IQ11cos(_iq11 A);
extern _iq10 _IQ10cos(_iq10 A);
extern _iq9 _IQ9cos(_iq9 A);
extern _iq8 _IQ8cos(_iq8 A);
extern _iq7 _IQ7cos(_iq7 A);
extern _iq6 _IQ6cos(_iq6 A);
extern _iq5 _IQ5cos(_iq5 A);
extern _iq4 _IQ4cos(_iq4 A);
extern _iq3 _IQ3cos(_iq3 A);
extern _iq2 _IQ2cos(_iq2 A);
extern _iq1 _IQ1cos(_iq1 A);

#if GLOBAL_Q == 29
#define _IQcos(A)               _IQ29cos(A)
#endif
#if GLOBAL_Q == 28
#define _IQcos(A)               _IQ28cos(A)
#endif
#if GLOBAL_Q == 27
#define _IQcos(A)               _IQ27cos(A)
#endif
#if GLOBAL_Q == 26
#define _IQcos(A)               _IQ26cos(A)
#endif
#if GLOBAL_Q == 25
#define _IQcos(A)               _IQ25cos(A)
#endif
#if GLOBAL_Q == 24
#define _IQcos(A)               _IQ24cos(A)
#endif
#if GLOBAL_Q == 23
#define _IQcos(A)               _IQ23cos(A)
#endif
#if GLOBAL_Q == 22
#define _IQcos(A)               _IQ22cos(A)
#endif
#if GLOBAL_Q == 21
#define _IQcos(A)               _IQ21cos(A)
#endif
#if GLOBAL_Q == 20
#define _IQcos(A)               _IQ20cos(A)
#endif
#if GLOBAL_Q == 19
#define _IQcos(A)               _IQ19cos(A)
#endif
#if GLOBAL_Q == 18
#define _IQcos(A)               _IQ18cos(A)
#endif
#if GLOBAL_Q == 17
#define _IQcos(A)               _IQ17cos(A)
#endif
#if GLOBAL_Q == 16
#define _IQcos(A)               _IQ16cos(A)
#endif
#if GLOBAL_Q == 15
#define _IQcos(A)               _IQ15cos(A)
#endif
#if GLOBAL_Q == 14
#define _IQcos(A)               _IQ14cos(A)
#endif
#if GLOBAL_Q == 13
#define _IQcos(A)               _IQ13cos(A)
#endif
#if GLOBAL_Q == 12
#define _IQcos(A)               _IQ12cos(A)
#endif
#if GLOBAL_Q == 11
#define _IQcos(A)               _IQ11cos(A)
#endif
#if GLOBAL_Q == 10
#define _IQcos(A)               _IQ10cos(A)
#endif
#if GLOBAL_Q == 9
#define _IQcos(A)               _IQ9cos(A)
#endif
#if GLOBAL_Q == 8
#define _IQcos(A)               _IQ8cos(A)
#endif
#if GLOBAL_Q == 7
#define _IQcos(A)               _IQ7cos(A)
#endif
#if GLOBAL_Q == 6
#define _IQcos(A)               _IQ6cos(A)
#endif
#if GLOBAL_Q == 5
#define _IQcos(A)               _IQ5cos(A)
#endif
#if GLOBAL_Q == 4
#define _IQcos(A)               _IQ4cos(A)
#endif
#if GLOBAL_Q == 3
#define _IQcos(A)               _IQ3cos(A)
#endif
#if GLOBAL_Q == 2
#define _IQcos(A)               _IQ2cos(A)
#endif
#if GLOBAL_Q == 1
#define _IQcos(A)               _IQ1cos(A)
#endif

//*****************************************************************************
//
// Computes the cos of an IQ number, using cycles per unit instead of radians.
//
//*****************************************************************************

//*****************************************************************************
//
// Computes the arccos of an IQ number.
//
//*****************************************************************************

//*****************************************************************************
//
// Computes the arctan of a coordinate specified by two IQ numbers.
//
//*****************************************************************************
extern _iq29 _IQ29atan2(_iq29 A, _iq29 B);
extern _iq28 _IQ28atan2(_iq28 A, _iq28 B);
extern _iq27 _IQ27atan2(_iq27 A, _iq27 B);
extern _iq26 _IQ26atan2(_iq26 A, _iq26 B);
extern _iq25 _IQ25atan2(_iq25 A, _iq25 B);
extern _iq24 _IQ24atan2(_iq24 A, _iq24 B);
extern _iq23 _IQ23atan2(_iq23 A, _iq23 B);
extern _iq22 _IQ22atan2(_iq22 A, _iq22 B);
extern _iq21 _IQ21atan2(_iq21 A, _iq21 B);
extern _iq20 _IQ20atan2(_iq20 A, _iq20 B);
extern _iq19 _IQ19atan2(_iq19 A, _iq19 B);
extern _iq18 _IQ18atan2(_iq18 A, _iq18 B);
extern _iq17 _IQ17atan2(_iq17 A, _iq17 B);
extern _iq16 _IQ16atan2(_iq16 A, _iq16 B);
extern _iq15 _IQ15atan2(_iq15 A, _iq15 B);
extern _iq14 _IQ14atan2(_iq14 A, _iq14 B);
extern _iq13 _IQ13atan2(_iq13 A, _iq13 B);
extern _iq12 _IQ12atan2(_iq12 A, _iq12 B);
extern _iq11 _IQ11atan2(_iq11 A, _iq11 B);
extern _iq10 _IQ10atan2(_iq10 A, _iq10 B);
extern _iq9 _IQ9atan2(_iq9 A, _iq9 B);
extern _iq8 _IQ8atan2(_iq8 A, _iq8 B);
extern _iq7 _IQ7atan2(_iq7 A, _iq7 B);
extern _iq6 _IQ6atan2(_iq6 A, _iq6 B);
extern _iq5 _IQ5atan2(_iq5 A, _iq5 B);
extern _iq4 _IQ4atan2(_iq4 A, _iq4 B);
extern _iq3 _IQ3atan2(_iq3 A, _iq3 B);
extern _iq2 _IQ2atan2(_iq2 A, _iq2 B);
extern _iq1 _IQ1atan2(_iq1 A, _iq1 B);

#if GLOBAL_Q == 29
#define _IQatan2(A, B)          _IQ29atan2(A, B)
#endif
#if GLOBAL_Q == 28
#define _IQatan2(A, B)          _IQ28atan2(A, B)
#endif
#if GLOBAL_Q == 27
#define _IQatan2(A, B)          _IQ27atan2(A, B)
#endif
#if GLOBAL_Q == 26
#define _IQatan2(A, B)          _IQ26atan2(A, B)
#endif
#if GLOBAL_Q == 25
#define _IQatan2(A, B)          _IQ25atan2(A, B)
#endif
#if GLOBAL_Q == 24
#define _IQatan2(A, B)          _IQ24atan2(A, B)
#endif
#if GLOBAL_Q == 23
#define _IQatan2(A, B)          _IQ23atan2(A, B)
#endif
#if GLOBAL_Q == 22
#define _IQatan2(A, B)          _IQ22atan2(A, B)
#endif
#if GLOBAL_Q == 21
#define _IQatan2(A, B)          _IQ21atan2(A, B)
#endif
#if GLOBAL_Q == 20
#define _IQatan2(A, B)          _IQ20atan2(A, B)
#endif
#if GLOBAL_Q == 19
#define _IQatan2(A, B)          _IQ19atan2(A, B)
#endif
#if GLOBAL_Q == 18
#define _IQatan2(A, B)          _IQ18atan2(A, B)
#endif
#if GLOBAL_Q == 17
#define _IQatan2(A, B)          _IQ17atan2(A, B)
#endif
#if GLOBAL_Q == 16
#define _IQatan2(A, B)          _IQ16atan2(A, B)
#endif
#if GLOBAL_Q == 15
#define _IQatan2(A, B)          _IQ15atan2(A, B)
#endif
#if GLOBAL_Q == 14
#define _IQatan2(A, B)          _IQ14atan2(A, B)
#endif
#if GLOBAL_Q == 13
#define _IQatan2(A, B)          _IQ13atan2(A, B)
#endif
#if GLOBAL_Q == 12
#define _IQatan2(A, B)          _IQ12atan2(A, B)
#endif
#if GLOBAL_Q == 11
#define _IQatan2(A, B)          _IQ11atan2(A, B)
#endif
#if GLOBAL_Q == 10
#define _IQatan2(A, B)          _IQ10atan2(A, B)
#endif
#if GLOBAL_Q == 9
#define _IQatan2(A, B)          _IQ9atan2(A, B)
#endif
#if GLOBAL_Q == 8
#define _IQatan2(A, B)          _IQ8atan2(A, B)
#endif
#if GLOBAL_Q == 7
#define _IQatan2(A, B)          _IQ7atan2(A, B)
#endif
#if GLOBAL_Q == 6
#define _IQatan2(A, B)          _IQ6atan2(A, B)
#endif
#if GLOBAL_Q == 5
#define _IQatan2(A, B)          _IQ5atan2(A, B)
#endif
#if GLOBAL_Q == 4
#define _IQatan2(A, B)          _IQ4atan2(A, B)
#endif
#if GLOBAL_Q == 3
#define _IQatan2(A, B)          _IQ3atan2(A, B)
#endif
#if GLOBAL_Q == 2
#define _IQatan2(A, B)          _IQ2atan2(A, B)
#endif
#if GLOBAL_Q == 1
#define _IQatan2(A, B)          _IQ1atan2(A, B)
#endif

//*****************************************************************************
//
// Computes the arctan of a coordinate specified by two IQ numbers, returning
// the value in cycles per unit instead of radians.
//
//*****************************************************************************

//*****************************************************************************
//
// Computes the arctan of an IQ number.
//
//*****************************************************************************


//*****************************************************************************
//
// Computes the square root of an IQ number.
//
//*****************************************************************************

//*****************************************************************************
//
// Computes 1 over the square root of an IQ number.
//
//*****************************************************************************


//*****************************************************************************
//
// Computes e^x of an IQ number.
//
//*****************************************************************************

//*****************************************************************************
//
// Computes 2^x of an IQ number.
//
//*****************************************************************************


//*****************************************************************************
//
// Returns the integer portion of an IQ number.
//
//*****************************************************************************

//*****************************************************************************
//
// Computes the fractional portion of an IQ number.
//
//*****************************************************************************


//*****************************************************************************
//
// Multiplies two IQ numbers in the specified iQ formats, returning the result
// in another IQ format.
//
//*****************************************************************************


//*****************************************************************************
//
// Multiplies an IQ number by an integer.
//
//*****************************************************************************


//*****************************************************************************
//
// Multiplies an IQ number by an integer, and returns the integer portion.
//
//*****************************************************************************
extern _iq30 _IQ30mpyI32int(_iq30 A, long B);
extern _iq29 _IQ29mpyI32int(_iq29 A, long B);
extern _iq28 _IQ28mpyI32int(_iq28 A, long B);
extern _iq27 _IQ27mpyI32int(_iq27 A, long B);
extern _iq26 _IQ26mpyI32int(_iq26 A, long B);
extern _iq25 _IQ25mpyI32int(_iq25 A, long B);
extern _iq24 _IQ24mpyI32int(_iq24 A, long B);
extern _iq23 _IQ23mpyI32int(_iq23 A, long B);
extern _iq22 _IQ22mpyI32int(_iq22 A, long B);
extern _iq21 _IQ21mpyI32int(_iq21 A, long B);
extern _iq20 _IQ20mpyI32int(_iq20 A, long B);
extern _iq19 _IQ19mpyI32int(_iq19 A, long B);
extern _iq18 _IQ18mpyI32int(_iq18 A, long B);
extern _iq17 _IQ17mpyI32int(_iq17 A, long B);
extern _iq16 _IQ16mpyI32int(_iq16 A, long B);
extern _iq15 _IQ15mpyI32int(_iq15 A, long B);
extern _iq14 _IQ14mpyI32int(_iq14 A, long B);
extern _iq13 _IQ13mpyI32int(_iq13 A, long B);
extern _iq12 _IQ12mpyI32int(_iq12 A, long B);
extern _iq11 _IQ11mpyI32int(_iq11 A, long B);
extern _iq10 _IQ10mpyI32int(_iq10 A, long B);
extern _iq9 _IQ9mpyI32int(_iq9 A, long B);
extern _iq8 _IQ8mpyI32int(_iq8 A, long B);
extern _iq7 _IQ7mpyI32int(_iq7 A, long B);
extern _iq6 _IQ6mpyI32int(_iq6 A, long B);
extern _iq5 _IQ5mpyI32int(_iq5 A, long B);
extern _iq4 _IQ4mpyI32int(_iq4 A, long B);
extern _iq3 _IQ3mpyI32int(_iq3 A, long B);
extern _iq2 _IQ2mpyI32int(_iq2 A, long B);
extern _iq1 _IQ1mpyI32int(_iq1 A, long B);

#if GLOBAL_Q == 30
#define _IQmpyI32int(A, B)      _IQ30mpyI32int(A, B)
#endif
#if GLOBAL_Q == 29
#define _IQmpyI32int(A, B)      _IQ29mpyI32int(A, B)
#endif
#if GLOBAL_Q == 28
#define _IQmpyI32int(A, B)      _IQ28mpyI32int(A, B)
#endif
#if GLOBAL_Q == 27
#define _IQmpyI32int(A, B)      _IQ27mpyI32int(A, B)
#endif
#if GLOBAL_Q == 26
#define _IQmpyI32int(A, B)      _IQ26mpyI32int(A, B)
#endif
#if GLOBAL_Q == 25
#define _IQmpyI32int(A, B)      _IQ25mpyI32int(A, B)
#endif
#if GLOBAL_Q == 24
#define _IQmpyI32int(A, B)      _IQ24mpyI32int(A, B)
#endif
#if GLOBAL_Q == 23
#define _IQmpyI32int(A, B)      _IQ23mpyI32int(A, B)
#endif
#if GLOBAL_Q == 22
#define _IQmpyI32int(A, B)      _IQ22mpyI32int(A, B)
#endif
#if GLOBAL_Q == 21
#define _IQmpyI32int(A, B)      _IQ21mpyI32int(A, B)
#endif
#if GLOBAL_Q == 20
#define _IQmpyI32int(A, B)      _IQ20mpyI32int(A, B)
#endif
#if GLOBAL_Q == 19
#define _IQmpyI32int(A, B)      _IQ19mpyI32int(A, B)
#endif
#if GLOBAL_Q == 18
#define _IQmpyI32int(A, B)      _IQ18mpyI32int(A, B)
#endif
#if GLOBAL_Q == 17
#define _IQmpyI32int(A, B)      _IQ17mpyI32int(A, B)
#endif
#if GLOBAL_Q == 16
#define _IQmpyI32int(A, B)      _IQ16mpyI32int(A, B)
#endif
#if GLOBAL_Q == 15
#define _IQmpyI32int(A, B)      _IQ15mpyI32int(A, B)
#endif
#if GLOBAL_Q == 14
#define _IQmpyI32int(A, B)      _IQ14mpyI32int(A, B)
#endif
#if GLOBAL_Q == 13
#define _IQmpyI32int(A, B)      _IQ13mpyI32int(A, B)
#endif
#if GLOBAL_Q == 12
#define _IQmpyI32int(A, B)      _IQ12mpyI32int(A, B)
#endif
#if GLOBAL_Q == 11
#define _IQmpyI32int(A, B)      _IQ11mpyI32int(A, B)
#endif
#if GLOBAL_Q == 10
#define _IQmpyI32int(A, B)      _IQ10mpyI32int(A, B)
#endif
#if GLOBAL_Q == 9
#define _IQmpyI32int(A, B)      _IQ9mpyI32int(A, B)
#endif
#if GLOBAL_Q == 8
#define _IQmpyI32int(A, B)      _IQ8mpyI32int(A, B)
#endif
#if GLOBAL_Q == 7
#define _IQmpyI32int(A, B)      _IQ7mpyI32int(A, B)
#endif
#if GLOBAL_Q == 6
#define _IQmpyI32int(A, B)      _IQ6mpyI32int(A, B)
#endif
#if GLOBAL_Q == 5
#define _IQmpyI32int(A, B)      _IQ5mpyI32int(A, B)
#endif
#if GLOBAL_Q == 4
#define _IQmpyI32int(A, B)      _IQ4mpyI32int(A, B)
#endif
#if GLOBAL_Q == 3
#define _IQmpyI32int(A, B)      _IQ3mpyI32int(A, B)
#endif
#if GLOBAL_Q == 2
#define _IQmpyI32int(A, B)      _IQ2mpyI32int(A, B)
#endif
#if GLOBAL_Q == 1
#define _IQmpyI32int(A, B)      _IQ1mpyI32int(A, B)
#endif

//*****************************************************************************
//
// Multiplies an IQ number by an integer, and returns the fractional portion.
//
//*****************************************************************************


//*****************************************************************************
//
// Computes the square root of A^2 + B^2 using IQ numbers.
//
//*****************************************************************************


//*****************************************************************************
//
// Converts a string into an IQ number.
//
//*****************************************************************************


//*****************************************************************************
//
// Converts an IQ number into a string.
//
//*****************************************************************************


//*****************************************************************************
//
// Computes the absolute value of an IQ number.
//
//*****************************************************************************

//*****************************************************************************
//
// Otherwise, floating point math is being used.
//
//*****************************************************************************
#else // MATH_TYPE == FLOAT_MATH

//*****************************************************************************
//
// The floating point equivalent of the various IQ formats.
//
//*****************************************************************************


//*****************************************************************************
//
// Simple multiplies or divides.
//
//*****************************************************************************

//*****************************************************************************
//
// Convert a value into an IQ number.
//
//*****************************************************************************
#define _IQ30(A)                (A)
#define _IQ29(A)                (A)
#define _IQ28(A)                (A)
#define _IQ27(A)                (A)
#define _IQ26(A)                (A)
#define _IQ25(A)                (A)
#define _IQ24(A)                (A)
#define _IQ23(A)                (A)
#define _IQ22(A)                (A)
#define _IQ21(A)                (A)
#define _IQ20(A)                (A)
#define _IQ19(A)                (A)
#define _IQ18(A)                (A)
#define _IQ17(A)                (A)
#define _IQ16(A)                (A)
#define _IQ15(A)                (A)
#define _IQ14(A)                (A)
#define _IQ13(A)                (A)
#define _IQ12(A)                (A)
#define _IQ11(A)                (A)
#define _IQ10(A)                (A)
#define _IQ9(A)                 (A)
#define _IQ8(A)                 (A)
#define _IQ7(A)                 (A)
#define _IQ6(A)                 (A)
#define _IQ5(A)                 (A)
#define _IQ4(A)                 (A)
#define _IQ3(A)                 (A)
#define _IQ2(A)                 (A)
#define _IQ1(A)                 (A)
#define _IQ(A)                  (A)

//*****************************************************************************
//
// Convert an IQ number to a floating point value.
//
//*****************************************************************************
#define _IQ30toF(A)             (A)
#define _IQ29toF(A)             (A)
#define _IQ28toF(A)             (A)
#define _IQ27toF(A)             (A)
#define _IQ26toF(A)             (A)
#define _IQ25toF(A)             (A)
#define _IQ24toF(A)             (A)
#define _IQ23toF(A)             (A)
#define _IQ22toF(A)             (A)
#define _IQ21toF(A)             (A)
#define _IQ20toF(A)             (A)
#define _IQ19toF(A)             (A)
#define _IQ18toF(A)             (A)
#define _IQ17toF(A)             (A)
#define _IQ16toF(A)             (A)
#define _IQ15toF(A)             (A)
#define _IQ14toF(A)             (A)
#define _IQ13toF(A)             (A)
#define _IQ12toF(A)             (A)
#define _IQ11toF(A)             (A)
#define _IQ10toF(A)             (A)
#define _IQ9toF(A)              (A)
#define _IQ8toF(A)              (A)
#define _IQ7toF(A)              (A)
#define _IQ6toF(A)              (A)
#define _IQ5toF(A)              (A)
#define _IQ4toF(A)              (A)
#define _IQ3toF(A)              (A)
#define _IQ2toF(A)              (A)
#define _IQ1toF(A)              (A)
#define _IQtoF(A)               (A)

//*****************************************************************************
//
// Convert an IQ number to a double-precision floating point value.
//
//*****************************************************************************
#define _IQ30toD(A)             (A)
#define _IQ29toD(A)             (A)
#define _IQ28toD(A)             (A)
#define _IQ27toD(A)             (A)
#define _IQ26toD(A)             (A)
#define _IQ25toD(A)             (A)
#define _IQ24toD(A)             (A)
#define _IQ23toD(A)             (A)
#define _IQ22toD(A)             (A)
#define _IQ21toD(A)             (A)
#define _IQ20toD(A)             (A)
#define _IQ19toD(A)             (A)
#define _IQ18toD(A)             (A)
#define _IQ17toD(A)             (A)
#define _IQ16toD(A)             (A)
#define _IQ15toD(A)             (A)
#define _IQ14toD(A)             (A)
#define _IQ13toD(A)             (A)
#define _IQ12toD(A)             (A)
#define _IQ11toD(A)             (A)
#define _IQ10toD(A)             (A)
#define _IQ9toD(A)              (A)
#define _IQ8toD(A)              (A)
#define _IQ7toD(A)              (A)
#define _IQ6toD(A)              (A)
#define _IQ5toD(A)              (A)
#define _IQ4toD(A)              (A)
#define _IQ3toD(A)              (A)
#define _IQ2toD(A)              (A)
#define _IQ1toD(A)              (A)
#define _IQtoD(A)               (A)

//*****************************************************************************
//
// Saturates an IQ number in a given range.
//
//*****************************************************************************
#define _IQsat(A, Pos, Neg)     (((A) > (Pos)) ?                              \
                                 (Pos) :                                      \
                                 (((A) < (Neg)) ? (Neg) : (A)))

//*****************************************************************************
//
// Converts an IQ number between the global IQ format and a specified IQ
// format.
//
//*****************************************************************************
#define _IQtoIQ30(A)            (A)
#define _IQ30toIQ(A)            (A)
#define _IQtoIQ29(A)            (A)
#define _IQ29toIQ(A)            (A)
#define _IQtoIQ28(A)            (A)
#define _IQ28toIQ(A)            (A)
#define _IQtoIQ27(A)            (A)
#define _IQ27toIQ(A)            (A)
#define _IQtoIQ26(A)            (A)
#define _IQ26toIQ(A)            (A)
#define _IQtoIQ25(A)            (A)
#define _IQ25toIQ(A)            (A)
#define _IQtoIQ24(A)            (A)
#define _IQ24toIQ(A)            (A)
#define _IQtoIQ23(A)            (A)
#define _IQ23toIQ(A)            (A)
#define _IQtoIQ22(A)            (A)
#define _IQ22toIQ(A)            (A)
#define _IQtoIQ21(A)            (A)
#define _IQ21toIQ(A)            (A)
#define _IQtoIQ20(A)            (A)
#define _IQ20toIQ(A)            (A)
#define _IQtoIQ19(A)            (A)
#define _IQ19toIQ(A)            (A)
#define _IQtoIQ18(A)            (A)
#define _IQ18toIQ(A)            (A)
#define _IQtoIQ17(A)            (A)
#define _IQ17toIQ(A)            (A)
#define _IQtoIQ16(A)            (A)
#define _IQ16toIQ(A)            (A)
#define _IQtoIQ15(A)            (A)
#define _IQ15toIQ(A)            (A)
#define _IQtoIQ14(A)            (A)
#define _IQ14toIQ(A)            (A)
#define _IQtoIQ13(A)            (A)
#define _IQ13toIQ(A)            (A)
#define _IQtoIQ12(A)            (A)
#define _IQ12toIQ(A)            (A)
#define _IQtoIQ11(A)            (A)
#define _IQ11toIQ(A)            (A)
#define _IQtoIQ10(A)            (A)
#define _IQ10toIQ(A)            (A)
#define _IQtoIQ9(A)             (A)
#define _IQ9toIQ(A)             (A)
#define _IQtoIQ8(A)             (A)
#define _IQ8toIQ(A)             (A)
#define _IQtoIQ7(A)             (A)
#define _IQ7toIQ(A)             (A)
#define _IQtoIQ6(A)             (A)
#define _IQ6toIQ(A)             (A)
#define _IQtoIQ5(A)             (A)
#define _IQ5toIQ(A)             (A)
#define _IQtoIQ4(A)             (A)
#define _IQ4toIQ(A)             (A)
#define _IQtoIQ3(A)             (A)
#define _IQ3toIQ(A)             (A)
#define _IQtoIQ2(A)             (A)
#define _IQ2toIQ(A)             (A)
#define _IQtoIQ1(A)             (A)
#define _IQ1toIQ(A)             (A)

//*****************************************************************************
//
// Converts a number between IQ format and 16-bit Qn format.
//
//*****************************************************************************
#define _IQtoQ15(A)             ((short)((long)((A) * (1 << 15))))
#define _Q15toIQ(A)             (((float)(A)) * (1.0 / (1 << 15)))
#define _IQtoQ14(A)             ((short)((long)((A) * (1 << 14))))
#define _Q14toIQ(A)             (((float)(A)) * (1.0 / (1 << 14)))
#define _IQtoQ13(A)             ((short)((long)((A) * (1 << 13))))
#define _Q13toIQ(A)             (((float)(A)) * (1.0 / (1 << 13)))
#define _IQtoQ12(A)             ((short)((long)((A) * (1 << 12))))
#define _Q12toIQ(A)             (((float)(A)) * (1.0 / (1 << 12)))
#define _IQtoQ11(A)             ((short)((long)((A) * (1 << 11))))
#define _Q11toIQ(A)             (((float)(A)) * (1.0 / (1 << 11)))
#define _IQtoQ10(A)             ((short)((long)((A) * (1 << 10))))
#define _Q10toIQ(A)             (((float)(A)) * (1.0 / (1 << 10)))
#define _IQtoQ9(A)              ((short)((long)((A) * (1 << 9))))
#define _Q9toIQ(A)              (((float)(A)) * (1.0 / (1 << 9)))
#define _IQtoQ8(A)              ((short)((long)((A) * (1 << 8))))
#define _Q8toIQ(A)              (((float)(A)) * (1.0 / (1 << 8)))
#define _IQtoQ7(A)              ((short)((long)((A) * (1 << 7))))
#define _Q7toIQ(A)              (((float)(A)) * (1.0 / (1 << 7)))
#define _IQtoQ6(A)              ((short)((long)((A) * (1 << 6))))
#define _Q6toIQ(A)              (((float)(A)) * (1.0 / (1 << 6)))
#define _IQtoQ5(A)              ((short)((long)((A) * (1 << 5))))
#define _Q5toIQ(A)              (((float)(A)) * (1.0 / (1 << 5)))
#define _IQtoQ4(A)              ((short)((long)((A) * (1 << 4))))
#define _Q4toIQ(A)              (((float)(A)) * (1.0 / (1 << 4)))
#define _IQtoQ3(A)              ((short)((long)((A) * (1 << 3))))
#define _Q3toIQ(A)              (((float)(A)) * (1.0 / (1 << 3)))
#define _IQtoQ2(A)              ((short)((long)((A) * (1 << 2))))
#define _Q2toIQ(A)              (((float)(A)) * (1.0 / (1 << 2)))
#define _IQtoQ1(A)              ((short)((long)((A) * (1 << 1))))
#define _Q1toIQ(A)              (((float)(A)) * (1.0 / (1 << 1)))

//*****************************************************************************
//
// Multiplies two IQ numbers.
//
//*****************************************************************************
#define _IQ30mpy(A, B)          ((A) * (B))
#define _IQ29mpy(A, B)          ((A) * (B))
#define _IQ28mpy(A, B)          ((A) * (B))
#define _IQ27mpy(A, B)          ((A) * (B))
#define _IQ26mpy(A, B)          ((A) * (B))
#define _IQ25mpy(A, B)          ((A) * (B))
#define _IQ24mpy(A, B)          ((A) * (B))
#define _IQ23mpy(A, B)          ((A) * (B))
#define _IQ22mpy(A, B)          ((A) * (B))
#define _IQ21mpy(A, B)          ((A) * (B))
#define _IQ20mpy(A, B)          ((A) * (B))
#define _IQ19mpy(A, B)          ((A) * (B))
#define _IQ18mpy(A, B)          ((A) * (B))
#define _IQ17mpy(A, B)          ((A) * (B))
#define _IQ16mpy(A, B)          ((A) * (B))
#define _IQ15mpy(A, B)          ((A) * (B))
#define _IQ14mpy(A, B)          ((A) * (B))
#define _IQ13mpy(A, B)          ((A) * (B))
#define _IQ12mpy(A, B)          ((A) * (B))
#define _IQ11mpy(A, B)          ((A) * (B))
#define _IQ10mpy(A, B)          ((A) * (B))
#define _IQ9mpy(A, B)           ((A) * (B))
#define _IQ8mpy(A, B)           ((A) * (B))
#define _IQ7mpy(A, B)           ((A) * (B))
#define _IQ6mpy(A, B)           ((A) * (B))
#define _IQ5mpy(A, B)           ((A) * (B))
#define _IQ4mpy(A, B)           ((A) * (B))
#define _IQ3mpy(A, B)           ((A) * (B))
#define _IQ2mpy(A, B)           ((A) * (B))
#define _IQ1mpy(A, B)           ((A) * (B))
#define _IQmpy(A, B)            ((A) * (B))

//*****************************************************************************
//
// Multiplies two IQ numbers, with rounding.
//
//*****************************************************************************
#define _IQ30rmpy(A, B)         ((A) * (B))
#define _IQ29rmpy(A, B)         ((A) * (B))
#define _IQ28rmpy(A, B)         ((A) * (B))
#define _IQ27rmpy(A, B)         ((A) * (B))
#define _IQ26rmpy(A, B)         ((A) * (B))
#define _IQ25rmpy(A, B)         ((A) * (B))
#define _IQ24rmpy(A, B)         ((A) * (B))
#define _IQ23rmpy(A, B)         ((A) * (B))
#define _IQ22rmpy(A, B)         ((A) * (B))
#define _IQ21rmpy(A, B)         ((A) * (B))
#define _IQ20rmpy(A, B)         ((A) * (B))
#define _IQ19rmpy(A, B)         ((A) * (B))
#define _IQ18rmpy(A, B)         ((A) * (B))
#define _IQ17rmpy(A, B)         ((A) * (B))
#define _IQ16rmpy(A, B)         ((A) * (B))
#define _IQ15rmpy(A, B)         ((A) * (B))
#define _IQ14rmpy(A, B)         ((A) * (B))
#define _IQ13rmpy(A, B)         ((A) * (B))
#define _IQ12rmpy(A, B)         ((A) * (B))
#define _IQ11rmpy(A, B)         ((A) * (B))
#define _IQ10rmpy(A, B)         ((A) * (B))
#define _IQ9rmpy(A, B)          ((A) * (B))
#define _IQ8rmpy(A, B)          ((A) * (B))
#define _IQ7rmpy(A, B)          ((A) * (B))
#define _IQ6rmpy(A, B)          ((A) * (B))
#define _IQ5rmpy(A, B)          ((A) * (B))
#define _IQ4rmpy(A, B)          ((A) * (B))
#define _IQ3rmpy(A, B)          ((A) * (B))
#define _IQ2rmpy(A, B)          ((A) * (B))
#define _IQ1rmpy(A, B)          ((A) * (B))
#define _IQrmpy(A, B)           ((A) * (B))

//*****************************************************************************
//
// Multiplies two IQ numbers, with rounding and saturation.
//
//*****************************************************************************
#define _IQ30rsmpy(A, B)        ((A) * (B))
#define _IQ29rsmpy(A, B)        ((A) * (B))
#define _IQ28rsmpy(A, B)        ((A) * (B))
#define _IQ27rsmpy(A, B)        ((A) * (B))
#define _IQ26rsmpy(A, B)        ((A) * (B))
#define _IQ25rsmpy(A, B)        ((A) * (B))
#define _IQ24rsmpy(A, B)        ((A) * (B))
#define _IQ23rsmpy(A, B)        ((A) * (B))
#define _IQ22rsmpy(A, B)        ((A) * (B))
#define _IQ21rsmpy(A, B)        ((A) * (B))
#define _IQ20rsmpy(A, B)        ((A) * (B))
#define _IQ19rsmpy(A, B)        ((A) * (B))
#define _IQ18rsmpy(A, B)        ((A) * (B))
#define _IQ17rsmpy(A, B)        ((A) * (B))
#define _IQ16rsmpy(A, B)        ((A) * (B))
#define _IQ15rsmpy(A, B)        ((A) * (B))
#define _IQ14rsmpy(A, B)        ((A) * (B))
#define _IQ13rsmpy(A, B)        ((A) * (B))
#define _IQ12rsmpy(A, B)        ((A) * (B))
#define _IQ11rsmpy(A, B)        ((A) * (B))
#define _IQ10rsmpy(A, B)        ((A) * (B))
#define _IQ9rsmpy(A, B)         ((A) * (B))
#define _IQ8rsmpy(A, B)         ((A) * (B))
#define _IQ7rsmpy(A, B)         ((A) * (B))
#define _IQ6rsmpy(A, B)         ((A) * (B))
#define _IQ5rsmpy(A, B)         ((A) * (B))
#define _IQ4rsmpy(A, B)         ((A) * (B))
#define _IQ3rsmpy(A, B)         ((A) * (B))
#define _IQ2rsmpy(A, B)         ((A) * (B))
#define _IQ1rsmpy(A, B)         ((A) * (B))
#define _IQrsmpy(A, B)          ((A) * (B))

//*****************************************************************************
//
// Divides two IQ numbers.
//
//*****************************************************************************
#define _IQ30div(A, B)          ((A) / (B))
#define _IQ29div(A, B)          ((A) / (B))
#define _IQ28div(A, B)          ((A) / (B))
#define _IQ27div(A, B)          ((A) / (B))
#define _IQ26div(A, B)          ((A) / (B))
#define _IQ25div(A, B)          ((A) / (B))
#define _IQ24div(A, B)          ((A) / (B))
#define _IQ23div(A, B)          ((A) / (B))
#define _IQ22div(A, B)          ((A) / (B))
#define _IQ21div(A, B)          ((A) / (B))
#define _IQ20div(A, B)          ((A) / (B))
#define _IQ19div(A, B)          ((A) / (B))
#define _IQ18div(A, B)          ((A) / (B))
#define _IQ17div(A, B)          ((A) / (B))
#define _IQ16div(A, B)          ((A) / (B))
#define _IQ15div(A, B)          ((A) / (B))
#define _IQ14div(A, B)          ((A) / (B))
#define _IQ13div(A, B)          ((A) / (B))
#define _IQ12div(A, B)          ((A) / (B))
#define _IQ11div(A, B)          ((A) / (B))
#define _IQ10div(A, B)          ((A) / (B))
#define _IQ9div(A, B)           ((A) / (B))
#define _IQ8div(A, B)           ((A) / (B))
#define _IQ7div(A, B)           ((A) / (B))
#define _IQ6div(A, B)           ((A) / (B))
#define _IQ5div(A, B)           ((A) / (B))
#define _IQ4div(A, B)           ((A) / (B))
#define _IQ3div(A, B)           ((A) / (B))
#define _IQ2div(A, B)           ((A) / (B))
#define _IQ1div(A, B)           ((A) / (B))
#define _IQdiv(A, B)            ((A) / (B))

//*****************************************************************************
//
// Computes the sin of an IQ number.
//
//*****************************************************************************
#define _IQ29sin(A)             sin(A)
#define _IQ28sin(A)             sin(A)
#define _IQ27sin(A)             sin(A)
#define _IQ26sin(A)             sin(A)
#define _IQ25sin(A)             sin(A)
#define _IQ24sin(A)             sin(A)
#define _IQ23sin(A)             sin(A)
#define _IQ22sin(A)             sin(A)
#define _IQ21sin(A)             sin(A)
#define _IQ20sin(A)             sin(A)
#define _IQ19sin(A)             sin(A)
#define _IQ18sin(A)             sin(A)
#define _IQ17sin(A)             sin(A)
#define _IQ16sin(A)             sin(A)
#define _IQ15sin(A)             sin(A)
#define _IQ14sin(A)             sin(A)
#define _IQ13sin(A)             sin(A)
#define _IQ12sin(A)             sin(A)
#define _IQ11sin(A)             sin(A)
#define _IQ10sin(A)             sin(A)
#define _IQ9sin(A)              sin(A)
#define _IQ8sin(A)              sin(A)
#define _IQ7sin(A)              sin(A)
#define _IQ6sin(A)              sin(A)
#define _IQ5sin(A)              sin(A)
#define _IQ4sin(A)              sin(A)
#define _IQ3sin(A)              sin(A)
#define _IQ2sin(A)              sin(A)
#define _IQ1sin(A)              sin(A)
#define _IQsin(A)               sin(A)

//*****************************************************************************
//
// Computes the sin of an IQ number, using cycles per unit instead of radians.
//
//*****************************************************************************
#define _IQ30sinPU(A)           sin((A) * 6.283185307)
#define _IQ29sinPU(A)           sin((A) * 6.283185307)
#define _IQ28sinPU(A)           sin((A) * 6.283185307)
#define _IQ27sinPU(A)           sin((A) * 6.283185307)
#define _IQ26sinPU(A)           sin((A) * 6.283185307)
#define _IQ25sinPU(A)           sin((A) * 6.283185307)
#define _IQ24sinPU(A)           sin((A) * 6.283185307)
#define _IQ23sinPU(A)           sin((A) * 6.283185307)
#define _IQ22sinPU(A)           sin((A) * 6.283185307)
#define _IQ21sinPU(A)           sin((A) * 6.283185307)
#define _IQ20sinPU(A)           sin((A) * 6.283185307)
#define _IQ19sinPU(A)           sin((A) * 6.283185307)
#define _IQ18sinPU(A)           sin((A) * 6.283185307)
#define _IQ17sinPU(A)           sin((A) * 6.283185307)
#define _IQ16sinPU(A)           sin((A) * 6.283185307)
#define _IQ15sinPU(A)           sin((A) * 6.283185307)
#define _IQ14sinPU(A)           sin((A) * 6.283185307)
#define _IQ13sinPU(A)           sin((A) * 6.283185307)
#define _IQ12sinPU(A)           sin((A) * 6.283185307)
#define _IQ11sinPU(A)           sin((A) * 6.283185307)
#define _IQ10sinPU(A)           sin((A) * 6.283185307)
#define _IQ9sinPU(A)            sin((A) * 6.283185307)
#define _IQ8sinPU(A)            sin((A) * 6.283185307)
#define _IQ7sinPU(A)            sin((A) * 6.283185307)
#define _IQ6sinPU(A)            sin((A) * 6.283185307)
#define _IQ5sinPU(A)            sin((A) * 6.283185307)
#define _IQ4sinPU(A)            sin((A) * 6.283185307)
#define _IQ3sinPU(A)            sin((A) * 6.283185307)
#define _IQ2sinPU(A)            sin((A) * 6.283185307)
#define _IQ1sinPU(A)            sin((A) * 6.283185307)
#define _IQsinPU(A)             sin((A) * 6.283185307)

//*****************************************************************************
//
// Computes the arcsin of an IQ number.
//
//*****************************************************************************
#define _IQ29asin(A)            asin(A)
#define _IQ28asin(A)            asin(A)
#define _IQ27asin(A)            asin(A)
#define _IQ26asin(A)            asin(A)
#define _IQ25asin(A)            asin(A)
#define _IQ24asin(A)            asin(A)
#define _IQ23asin(A)            asin(A)
#define _IQ22asin(A)            asin(A)
#define _IQ21asin(A)            asin(A)
#define _IQ20asin(A)            asin(A)
#define _IQ19asin(A)            asin(A)
#define _IQ18asin(A)            asin(A)
#define _IQ17asin(A)            asin(A)
#define _IQ16asin(A)            asin(A)
#define _IQ15asin(A)            asin(A)
#define _IQ14asin(A)            asin(A)
#define _IQ13asin(A)            asin(A)
#define _IQ12asin(A)            asin(A)
#define _IQ11asin(A)            asin(A)
#define _IQ10asin(A)            asin(A)
#define _IQ9asin(A)             asin(A)
#define _IQ8asin(A)             asin(A)
#define _IQ7asin(A)             asin(A)
#define _IQ6asin(A)             asin(A)
#define _IQ5asin(A)             asin(A)
#define _IQ4asin(A)             asin(A)
#define _IQ3asin(A)             asin(A)
#define _IQ2asin(A)             asin(A)
#define _IQ1asin(A)             asin(A)
#define _IQasin(A)              asin(A)

//*****************************************************************************
//
// Computes the cos of an IQ number.
//
//*****************************************************************************
#define _IQ29cos(A)             cos(A)
#define _IQ28cos(A)             cos(A)
#define _IQ27cos(A)             cos(A)
#define _IQ26cos(A)             cos(A)
#define _IQ25cos(A)             cos(A)
#define _IQ24cos(A)             cos(A)
#define _IQ23cos(A)             cos(A)
#define _IQ22cos(A)             cos(A)
#define _IQ21cos(A)             cos(A)
#define _IQ20cos(A)             cos(A)
#define _IQ19cos(A)             cos(A)
#define _IQ18cos(A)             cos(A)
#define _IQ17cos(A)             cos(A)
#define _IQ16cos(A)             cos(A)
#define _IQ15cos(A)             cos(A)
#define _IQ14cos(A)             cos(A)
#define _IQ13cos(A)             cos(A)
#define _IQ12cos(A)             cos(A)
#define _IQ11cos(A)             cos(A)
#define _IQ10cos(A)             cos(A)
#define _IQ9cos(A)              cos(A)
#define _IQ8cos(A)              cos(A)
#define _IQ7cos(A)              cos(A)
#define _IQ6cos(A)              cos(A)
#define _IQ5cos(A)              cos(A)
#define _IQ4cos(A)              cos(A)
#define _IQ3cos(A)              cos(A)
#define _IQ2cos(A)              cos(A)
#define _IQ1cos(A)              cos(A)
#define _IQcos(A)               cos(A)

//*****************************************************************************
//
// Computes the cos of an IQ number, using cycles per unit instead of radians.
//
//*****************************************************************************
#define _IQ30cosPU(A)           cos((A) * 6.283185307)
#define _IQ29cosPU(A)           cos((A) * 6.283185307)
#define _IQ28cosPU(A)           cos((A) * 6.283185307)
#define _IQ27cosPU(A)           cos((A) * 6.283185307)
#define _IQ26cosPU(A)           cos((A) * 6.283185307)
#define _IQ25cosPU(A)           cos((A) * 6.283185307)
#define _IQ24cosPU(A)           cos((A) * 6.283185307)
#define _IQ23cosPU(A)           cos((A) * 6.283185307)
#define _IQ22cosPU(A)           cos((A) * 6.283185307)
#define _IQ21cosPU(A)           cos((A) * 6.283185307)
#define _IQ20cosPU(A)           cos((A) * 6.283185307)
#define _IQ19cosPU(A)           cos((A) * 6.283185307)
#define _IQ18cosPU(A)           cos((A) * 6.283185307)
#define _IQ17cosPU(A)           cos((A) * 6.283185307)
#define _IQ16cosPU(A)           cos((A) * 6.283185307)
#define _IQ15cosPU(A)           cos((A) * 6.283185307)
#define _IQ14cosPU(A)           cos((A) * 6.283185307)
#define _IQ13cosPU(A)           cos((A) * 6.283185307)
#define _IQ12cosPU(A)           cos((A) * 6.283185307)
#define _IQ11cosPU(A)           cos((A) * 6.283185307)
#define _IQ10cosPU(A)           cos((A) * 6.283185307)
#define _IQ9cosPU(A)            cos((A) * 6.283185307)
#define _IQ8cosPU(A)            cos((A) * 6.283185307)
#define _IQ7cosPU(A)            cos((A) * 6.283185307)
#define _IQ6cosPU(A)            cos((A) * 6.283185307)
#define _IQ5cosPU(A)            cos((A) * 6.283185307)
#define _IQ4cosPU(A)            cos((A) * 6.283185307)
#define _IQ3cosPU(A)            cos((A) * 6.283185307)
#define _IQ2cosPU(A)            cos((A) * 6.283185307)
#define _IQ1cosPU(A)            cos((A) * 6.283185307)
#define _IQcosPU(A)             cos((A) * 6.283185307)

//*****************************************************************************
//
// Computes the arccos of an IQ number.
//
//*****************************************************************************
#define _IQ29acos(A)            acos(A)
#define _IQ28acos(A)            acos(A)
#define _IQ27acos(A)            acos(A)
#define _IQ26acos(A)            acos(A)
#define _IQ25acos(A)            acos(A)
#define _IQ24acos(A)            acos(A)
#define _IQ23acos(A)            acos(A)
#define _IQ22acos(A)            acos(A)
#define _IQ21acos(A)            acos(A)
#define _IQ20acos(A)            acos(A)
#define _IQ19acos(A)            acos(A)
#define _IQ18acos(A)            acos(A)
#define _IQ17acos(A)            acos(A)
#define _IQ16acos(A)            acos(A)
#define _IQ15acos(A)            acos(A)
#define _IQ14acos(A)            acos(A)
#define _IQ13acos(A)            acos(A)
#define _IQ12acos(A)            acos(A)
#define _IQ11acos(A)            acos(A)
#define _IQ10acos(A)            acos(A)
#define _IQ9acos(A)             acos(A)
#define _IQ8acos(A)             acos(A)
#define _IQ7acos(A)             acos(A)
#define _IQ6acos(A)             acos(A)
#define _IQ5acos(A)             acos(A)
#define _IQ4acos(A)             acos(A)
#define _IQ3acos(A)             acos(A)
#define _IQ2acos(A)             acos(A)
#define _IQ1acos(A)             acos(A)
#define _IQacos(A)              acos(A)

//*****************************************************************************
//
// Computes the arctan of an IQ number.
//
//*****************************************************************************
#define _IQ29atan(A)            atan(A)
#define _IQ28atan(A)            atan(A)
#define _IQ27atan(A)            atan(A)
#define _IQ26atan(A)            atan(A)
#define _IQ25atan(A)            atan(A)
#define _IQ24atan(A)            atan(A)
#define _IQ23atan(A)            atan(A)
#define _IQ22atan(A)            atan(A)
#define _IQ21atan(A)            atan(A)
#define _IQ20atan(A)            atan(A)
#define _IQ19atan(A)            atan(A)
#define _IQ18atan(A)            atan(A)
#define _IQ17atan(A)            atan(A)
#define _IQ16atan(A)            atan(A)
#define _IQ15atan(A)            atan(A)
#define _IQ14atan(A)            atan(A)
#define _IQ13atan(A)            atan(A)
#define _IQ12atan(A)            atan(A)
#define _IQ11atan(A)            atan(A)
#define _IQ10atan(A)            atan(A)
#define _IQ9atan(A)             atan(A)
#define _IQ8atan(A)             atan(A)
#define _IQ7atan(A)             atan(A)
#define _IQ6atan(A)             atan(A)
#define _IQ5atan(A)             atan(A)
#define _IQ4atan(A)             atan(A)
#define _IQ3atan(A)             atan(A)
#define _IQ2atan(A)             atan(A)
#define _IQ1atan(A)             atan(A)
#define _IQatan(A)              atan(A)

//*****************************************************************************
//
// Computes the arctan of a coordinate specified by two IQ numbers.
//
//*****************************************************************************
#define _IQ30atan2(A, B)        atan2(A, B)
#define _IQ29atan2(A, B)        atan2(A, B)
#define _IQ28atan2(A, B)        atan2(A, B)
#define _IQ27atan2(A, B)        atan2(A, B)
#define _IQ26atan2(A, B)        atan2(A, B)
#define _IQ25atan2(A, B)        atan2(A, B)
#define _IQ24atan2(A, B)        atan2(A, B)
#define _IQ23atan2(A, B)        atan2(A, B)
#define _IQ22atan2(A, B)        atan2(A, B)
#define _IQ21atan2(A, B)        atan2(A, B)
#define _IQ20atan2(A, B)        atan2(A, B)
#define _IQ19atan2(A, B)        atan2(A, B)
#define _IQ18atan2(A, B)        atan2(A, B)
#define _IQ17atan2(A, B)        atan2(A, B)
#define _IQ16atan2(A, B)        atan2(A, B)
#define _IQ15atan2(A, B)        atan2(A, B)
#define _IQ14atan2(A, B)        atan2(A, B)
#define _IQ13atan2(A, B)        atan2(A, B)
#define _IQ12atan2(A, B)        atan2(A, B)
#define _IQ11atan2(A, B)        atan2(A, B)
#define _IQ10atan2(A, B)        atan2(A, B)
#define _IQ9atan2(A, B)         atan2(A, B)
#define _IQ8atan2(A, B)         atan2(A, B)
#define _IQ7atan2(A, B)         atan2(A, B)
#define _IQ6atan2(A, B)         atan2(A, B)
#define _IQ5atan2(A, B)         atan2(A, B)
#define _IQ4atan2(A, B)         atan2(A, B)
#define _IQ3atan2(A, B)         atan2(A, B)
#define _IQ2atan2(A, B)         atan2(A, B)
#define _IQ1atan2(A, B)         atan2(A, B)
#define _IQatan2(A, B)          atan2(A, B)

//*****************************************************************************
//
// Computes the arctan of a coordinate specified by two IQ numbers, returning
// the value in cycles per unit instead of radians.
//
//*****************************************************************************
#define _IQ30atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ29atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ28atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ27atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ26atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ25atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ24atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ23atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ22atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ21atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ20atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ19atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ18atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ17atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ16atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ15atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ14atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ13atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ12atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ11atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ10atan2PU(A, B)      (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ9atan2PU(A, B)       (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ8atan2PU(A, B)       (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ7atan2PU(A, B)       (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ6atan2PU(A, B)       (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ5atan2PU(A, B)       (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ4atan2PU(A, B)       (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ3atan2PU(A, B)       (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ2atan2PU(A, B)       (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQ1atan2PU(A, B)       (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))
#define _IQatan2PU(A, B)        (((atan2(A, B) * (1.0 / 6.283185307)) >=      \
                                  0.0) ?                                      \
                                 (atan2(A, B) * (1.0 / 6.283185307)) :        \
                                 (atan2(A, B) * (1.0 / 6.283185307) + 1.0))

//*****************************************************************************
//
// Computes the square root of an IQ number.
//
//*****************************************************************************
#define _IQ30sqrt(A)            sqrt(A)
#define _IQ29sqrt(A)            sqrt(A)
#define _IQ28sqrt(A)            sqrt(A)
#define _IQ27sqrt(A)            sqrt(A)
#define _IQ26sqrt(A)            sqrt(A)
#define _IQ25sqrt(A)            sqrt(A)
#define _IQ24sqrt(A)            sqrt(A)
#define _IQ23sqrt(A)            sqrt(A)
#define _IQ22sqrt(A)            sqrt(A)
#define _IQ21sqrt(A)            sqrt(A)
#define _IQ20sqrt(A)            sqrt(A)
#define _IQ19sqrt(A)            sqrt(A)
#define _IQ18sqrt(A)            sqrt(A)
#define _IQ17sqrt(A)            sqrt(A)
#define _IQ16sqrt(A)            sqrt(A)
#define _IQ15sqrt(A)            sqrt(A)
#define _IQ14sqrt(A)            sqrt(A)
#define _IQ13sqrt(A)            sqrt(A)
#define _IQ12sqrt(A)            sqrt(A)
#define _IQ11sqrt(A)            sqrt(A)
#define _IQ10sqrt(A)            sqrt(A)
#define _IQ9sqrt(A)             sqrt(A)
#define _IQ8sqrt(A)             sqrt(A)
#define _IQ7sqrt(A)             sqrt(A)
#define _IQ6sqrt(A)             sqrt(A)
#define _IQ5sqrt(A)             sqrt(A)
#define _IQ4sqrt(A)             sqrt(A)
#define _IQ3sqrt(A)             sqrt(A)
#define _IQ2sqrt(A)             sqrt(A)
#define _IQ1sqrt(A)             sqrt(A)
#define _IQsqrt(A)              sqrt(A)

//*****************************************************************************
//
// Computes 1 over the square root of an IQ number.
//
//*****************************************************************************
#define _IQ30isqrt(A)           (1.0 / sqrt(A))
#define _IQ29isqrt(A)           (1.0 / sqrt(A))
#define _IQ28isqrt(A)           (1.0 / sqrt(A))
#define _IQ27isqrt(A)           (1.0 / sqrt(A))
#define _IQ26isqrt(A)           (1.0 / sqrt(A))
#define _IQ25isqrt(A)           (1.0 / sqrt(A))
#define _IQ24isqrt(A)           (1.0 / sqrt(A))
#define _IQ23isqrt(A)           (1.0 / sqrt(A))
#define _IQ22isqrt(A)           (1.0 / sqrt(A))
#define _IQ21isqrt(A)           (1.0 / sqrt(A))
#define _IQ20isqrt(A)           (1.0 / sqrt(A))
#define _IQ19isqrt(A)           (1.0 / sqrt(A))
#define _IQ18isqrt(A)           (1.0 / sqrt(A))
#define _IQ17isqrt(A)           (1.0 / sqrt(A))
#define _IQ16isqrt(A)           (1.0 / sqrt(A))
#define _IQ15isqrt(A)           (1.0 / sqrt(A))
#define _IQ14isqrt(A)           (1.0 / sqrt(A))
#define _IQ13isqrt(A)           (1.0 / sqrt(A))
#define _IQ12isqrt(A)           (1.0 / sqrt(A))
#define _IQ11isqrt(A)           (1.0 / sqrt(A))
#define _IQ10isqrt(A)           (1.0 / sqrt(A))
#define _IQ9isqrt(A)            (1.0 / sqrt(A))
#define _IQ8isqrt(A)            (1.0 / sqrt(A))
#define _IQ7isqrt(A)            (1.0 / sqrt(A))
#define _IQ6isqrt(A)            (1.0 / sqrt(A))
#define _IQ5isqrt(A)            (1.0 / sqrt(A))
#define _IQ4isqrt(A)            (1.0 / sqrt(A))
#define _IQ3isqrt(A)            (1.0 / sqrt(A))
#define _IQ2isqrt(A)            (1.0 / sqrt(A))
#define _IQ1isqrt(A)            (1.0 / sqrt(A))
#define _IQisqrt(A)             (1.0 / sqrt(A))

//*****************************************************************************
//
// Computes e^x of an IQ number.
//
//*****************************************************************************
#define _IQ30exp(A)             exp(A)
#define _IQ29exp(A)             exp(A)
#define _IQ28exp(A)             exp(A)
#define _IQ27exp(A)             exp(A)
#define _IQ26exp(A)             exp(A)
#define _IQ25exp(A)             exp(A)
#define _IQ24exp(A)             exp(A)
#define _IQ23exp(A)             exp(A)
#define _IQ22exp(A)             exp(A)
#define _IQ21exp(A)             exp(A)
#define _IQ20exp(A)             exp(A)
#define _IQ19exp(A)             exp(A)
#define _IQ18exp(A)             exp(A)
#define _IQ17exp(A)             exp(A)
#define _IQ16exp(A)             exp(A)
#define _IQ15exp(A)             exp(A)
#define _IQ14exp(A)             exp(A)
#define _IQ13exp(A)             exp(A)
#define _IQ12exp(A)             exp(A)
#define _IQ11exp(A)             exp(A)
#define _IQ10exp(A)             exp(A)
#define _IQ9exp(A)              exp(A)
#define _IQ8exp(A)              exp(A)
#define _IQ7exp(A)              exp(A)
#define _IQ6exp(A)              exp(A)
#define _IQ5exp(A)              exp(A)
#define _IQ4exp(A)              exp(A)
#define _IQ3exp(A)              exp(A)
#define _IQ2exp(A)              exp(A)
#define _IQ1exp(A)              exp(A)
#define _IQexp(A)               exp(A)

//*****************************************************************************
//
// Computes 2^x of an IQ number.
//
//*****************************************************************************
#define _IQ30exp2(A)            exp2(A)
#define _IQ29exp2(A)            exp2(A)
#define _IQ28exp2(A)            exp2(A)
#define _IQ27exp2(A)            exp2(A)
#define _IQ26exp2(A)            exp2(A)
#define _IQ25exp2(A)            exp2(A)
#define _IQ24exp2(A)            exp2(A)
#define _IQ23exp2(A)            exp2(A)
#define _IQ22exp2(A)            exp2(A)
#define _IQ21exp2(A)            exp2(A)
#define _IQ20exp2(A)            exp2(A)
#define _IQ19exp2(A)            exp2(A)
#define _IQ18exp2(A)            exp2(A)
#define _IQ17exp2(A)            exp2(A)
#define _IQ16exp2(A)            exp2(A)
#define _IQ15exp2(A)            exp2(A)
#define _IQ14exp2(A)            exp2(A)
#define _IQ13exp2(A)            exp2(A)
#define _IQ12exp2(A)            exp2(A)
#define _IQ11exp2(A)            exp2(A)
#define _IQ10exp2(A)            exp2(A)
#define _IQ9exp2(A)             exp2(A)
#define _IQ8exp2(A)             exp2(A)
#define _IQ7exp2(A)             exp2(A)
#define _IQ6exp2(A)             exp2(A)
#define _IQ5exp2(A)             exp2(A)
#define _IQ4exp2(A)             exp2(A)
#define _IQ3exp2(A)             exp2(A)
#define _IQ2exp2(A)             exp2(A)
#define _IQ1exp2(A)             exp2(A)
#define _IQexp2(A)              exp2(A)

//*****************************************************************************
//
// Returns the integer portion of an IQ number.
//
//*****************************************************************************
#define _IQ30int(A)             ((long)(A))
#define _IQ29int(A)             ((long)(A))
#define _IQ28int(A)             ((long)(A))
#define _IQ27int(A)             ((long)(A))
#define _IQ26int(A)             ((long)(A))
#define _IQ25int(A)             ((long)(A))
#define _IQ24int(A)             ((long)(A))
#define _IQ23int(A)             ((long)(A))
#define _IQ22int(A)             ((long)(A))
#define _IQ21int(A)             ((long)(A))
#define _IQ20int(A)             ((long)(A))
#define _IQ19int(A)             ((long)(A))
#define _IQ18int(A)             ((long)(A))
#define _IQ17int(A)             ((long)(A))
#define _IQ16int(A)             ((long)(A))
#define _IQ15int(A)             ((long)(A))
#define _IQ14int(A)             ((long)(A))
#define _IQ13int(A)             ((long)(A))
#define _IQ12int(A)             ((long)(A))
#define _IQ11int(A)             ((long)(A))
#define _IQ10int(A)             ((long)(A))
#define _IQ9int(A)              ((long)(A))
#define _IQ8int(A)              ((long)(A))
#define _IQ7int(A)              ((long)(A))
#define _IQ6int(A)              ((long)(A))
#define _IQ5int(A)              ((long)(A))
#define _IQ4int(A)              ((long)(A))
#define _IQ3int(A)              ((long)(A))
#define _IQ2int(A)              ((long)(A))
#define _IQ1int(A)              ((long)(A))
#define _IQint(A)               ((long)(A))

//*****************************************************************************
//
// Computes the fractional portion of an IQ number.
//
//*****************************************************************************
#define _IQ30frac(A)            ((A) - (float)((long)(A)))
#define _IQ29frac(A)            ((A) - (float)((long)(A)))
#define _IQ28frac(A)            ((A) - (float)((long)(A)))
#define _IQ27frac(A)            ((A) - (float)((long)(A)))
#define _IQ26frac(A)            ((A) - (float)((long)(A)))
#define _IQ25frac(A)            ((A) - (float)((long)(A)))
#define _IQ24frac(A)            ((A) - (float)((long)(A)))
#define _IQ23frac(A)            ((A) - (float)((long)(A)))
#define _IQ22frac(A)            ((A) - (float)((long)(A)))
#define _IQ21frac(A)            ((A) - (float)((long)(A)))
#define _IQ20frac(A)            ((A) - (float)((long)(A)))
#define _IQ19frac(A)            ((A) - (float)((long)(A)))
#define _IQ18frac(A)            ((A) - (float)((long)(A)))
#define _IQ17frac(A)            ((A) - (float)((long)(A)))
#define _IQ16frac(A)            ((A) - (float)((long)(A)))
#define _IQ15frac(A)            ((A) - (float)((long)(A)))
#define _IQ14frac(A)            ((A) - (float)((long)(A)))
#define _IQ13frac(A)            ((A) - (float)((long)(A)))
#define _IQ12frac(A)            ((A) - (float)((long)(A)))
#define _IQ11frac(A)            ((A) - (float)((long)(A)))
#define _IQ10frac(A)            ((A) - (float)((long)(A)))
#define _IQ9frac(A)             ((A) - (float)((long)(A)))
#define _IQ8frac(A)             ((A) - (float)((long)(A)))
#define _IQ7frac(A)             ((A) - (float)((long)(A)))
#define _IQ6frac(A)             ((A) - (float)((long)(A)))
#define _IQ5frac(A)             ((A) - (float)((long)(A)))
#define _IQ4frac(A)             ((A) - (float)((long)(A)))
#define _IQ3frac(A)             ((A) - (float)((long)(A)))
#define _IQ2frac(A)             ((A) - (float)((long)(A)))
#define _IQ1frac(A)             ((A) - (float)((long)(A)))
#define _IQfrac(A)              ((A) - (float)((long)(A)))

//*****************************************************************************
//
// Multiplies two IQ numbers in the specified IQ formats, returning the result
// in another IQ format.
//
//*****************************************************************************
#define _IQ30mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ29mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ28mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ27mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ26mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ25mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ24mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ23mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ22mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ21mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ20mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ19mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ18mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ17mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ16mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ15mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ14mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ13mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ12mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ11mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ10mpyIQX(A, IQA, B, IQB) ((A) * (B))
#define _IQ9mpyIQX(A, IQA, B, IQB)  ((A) * (B))
#define _IQ8mpyIQX(A, IQA, B, IQB)  ((A) * (B))
#define _IQ7mpyIQX(A, IQA, B, IQB)  ((A) * (B))
#define _IQ6mpyIQX(A, IQA, B, IQB)  ((A) * (B))
#define _IQ5mpyIQX(A, IQA, B, IQB)  ((A) * (B))
#define _IQ4mpyIQX(A, IQA, B, IQB)  ((A) * (B))
#define _IQ3mpyIQX(A, IQA, B, IQB)  ((A) * (B))
#define _IQ2mpyIQX(A, IQA, B, IQB)  ((A) * (B))
#define _IQ1mpyIQX(A, IQA, B, IQB)  ((A) * (B))
#define _IQmpyIQX(A, IQA, B, IQB)   ((A) * (B))

//*****************************************************************************
//
// Multiplies an IQ number by an integer.
//
//*****************************************************************************
#define _IQ30mpyI32(A, B)       ((A) * (float)(B))
#define _IQ29mpyI32(A, B)       ((A) * (float)(B))
#define _IQ28mpyI32(A, B)       ((A) * (float)(B))
#define _IQ27mpyI32(A, B)       ((A) * (float)(B))
#define _IQ26mpyI32(A, B)       ((A) * (float)(B))
#define _IQ25mpyI32(A, B)       ((A) * (float)(B))
#define _IQ24mpyI32(A, B)       ((A) * (float)(B))
#define _IQ23mpyI32(A, B)       ((A) * (float)(B))
#define _IQ22mpyI32(A, B)       ((A) * (float)(B))
#define _IQ21mpyI32(A, B)       ((A) * (float)(B))
#define _IQ20mpyI32(A, B)       ((A) * (float)(B))
#define _IQ19mpyI32(A, B)       ((A) * (float)(B))
#define _IQ18mpyI32(A, B)       ((A) * (float)(B))
#define _IQ17mpyI32(A, B)       ((A) * (float)(B))
#define _IQ16mpyI32(A, B)       ((A) * (float)(B))
#define _IQ15mpyI32(A, B)       ((A) * (float)(B))
#define _IQ14mpyI32(A, B)       ((A) * (float)(B))
#define _IQ13mpyI32(A, B)       ((A) * (float)(B))
#define _IQ12mpyI32(A, B)       ((A) * (float)(B))
#define _IQ11mpyI32(A, B)       ((A) * (float)(B))
#define _IQ10mpyI32(A, B)       ((A) * (float)(B))
#define _IQ9mpyI32(A, B)        ((A) * (float)(B))
#define _IQ8mpyI32(A, B)        ((A) * (float)(B))
#define _IQ7mpyI32(A, B)        ((A) * (float)(B))
#define _IQ6mpyI32(A, B)        ((A) * (float)(B))
#define _IQ5mpyI32(A, B)        ((A) * (float)(B))
#define _IQ4mpyI32(A, B)        ((A) * (float)(B))
#define _IQ3mpyI32(A, B)        ((A) * (float)(B))
#define _IQ2mpyI32(A, B)        ((A) * (float)(B))
#define _IQ1mpyI32(A, B)        ((A) * (float)(B))
#define _IQmpyI32(A, B)         ((A) * (float)(B))

//*****************************************************************************
//
// Multiplies an IQ number by an integer, and returns the integer portion.
//
//*****************************************************************************
#define _IQ30mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ29mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ28mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ27mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ26mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ25mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ24mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ23mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ22mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ21mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ20mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ19mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ18mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ17mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ16mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ15mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ14mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ13mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ12mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ11mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ10mpyI32int(A, B)    ((long)((A) * (float)(B)))
#define _IQ9mpyI32int(A, B)     ((long)((A) * (float)(B)))
#define _IQ8mpyI32int(A, B)     ((long)((A) * (float)(B)))
#define _IQ7mpyI32int(A, B)     ((long)((A) * (float)(B)))
#define _IQ6mpyI32int(A, B)     ((long)((A) * (float)(B)))
#define _IQ5mpyI32int(A, B)     ((long)((A) * (float)(B)))
#define _IQ4mpyI32int(A, B)     ((long)((A) * (float)(B)))
#define _IQ3mpyI32int(A, B)     ((long)((A) * (float)(B)))
#define _IQ2mpyI32int(A, B)     ((long)((A) * (float)(B)))
#define _IQ1mpyI32int(A, B)     ((long)((A) * (float)(B)))
#define _IQmpyI32int(A, B)      ((long)((A) * (float)(B)))

//*****************************************************************************
//
// Multiplies an IQ number by an integer, and returns the fractional portion.
//
//*****************************************************************************
#define _IQ30mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ29mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ28mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ27mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ26mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ25mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ24mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ23mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ22mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ21mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ20mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ19mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ18mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ17mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ16mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ15mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ14mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ13mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ12mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ11mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ10mpyI32frac(A, B)   (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ9mpyI32frac(A, B)    (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ8mpyI32frac(A, B)    (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ7mpyI32frac(A, B)    (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ6mpyI32frac(A, B)    (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ5mpyI32frac(A, B)    (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ4mpyI32frac(A, B)    (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ3mpyI32frac(A, B)    (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ2mpyI32frac(A, B)    (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQ1mpyI32frac(A, B)    (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))
#define _IQmpyI32frac(A, B)     (((A) * (B)) -                                \
                                 (float)((long)((A) * (float)(B))))

//*****************************************************************************
//
// Computes the square root of A^2 + B^2 using IQ numbers.
//
//*****************************************************************************
#define _IQ30mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ29mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ28mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ27mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ26mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ25mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ24mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ23mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ22mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ21mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ20mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ19mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ18mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ17mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ16mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ15mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ14mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ13mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ12mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ11mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ10mag(A, B)          sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ9mag(A, B)           sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ8mag(A, B)           sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ7mag(A, B)           sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ6mag(A, B)           sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ5mag(A, B)           sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ4mag(A, B)           sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ3mag(A, B)           sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ2mag(A, B)           sqrt(((A) * (A)) + ((B) * (B)))
#define _IQ1mag(A, B)           sqrt(((A) * (A)) + ((B) * (B)))
#define _IQmag(A, B)            sqrt(((A) * (A)) + ((B) * (B)))

//*****************************************************************************
//
// Converts a string into an IQ number.
//
//*****************************************************************************
#define _atoIQ30(A)             atof(A)
#define _atoIQ29(A)             atof(A)
#define _atoIQ28(A)             atof(A)
#define _atoIQ27(A)             atof(A)
#define _atoIQ26(A)             atof(A)
#define _atoIQ25(A)             atof(A)
#define _atoIQ24(A)             atof(A)
#define _atoIQ23(A)             atof(A)
#define _atoIQ22(A)             atof(A)
#define _atoIQ21(A)             atof(A)
#define _atoIQ20(A)             atof(A)
#define _atoIQ19(A)             atof(A)
#define _atoIQ18(A)             atof(A)
#define _atoIQ17(A)             atof(A)
#define _atoIQ16(A)             atof(A)
#define _atoIQ15(A)             atof(A)
#define _atoIQ14(A)             atof(A)
#define _atoIQ13(A)             atof(A)
#define _atoIQ12(A)             atof(A)
#define _atoIQ11(A)             atof(A)
#define _atoIQ10(A)             atof(A)
#define _atoIQ9(A)              atof(A)
#define _atoIQ8(A)              atof(A)
#define _atoIQ7(A)              atof(A)
#define _atoIQ6(A)              atof(A)
#define _atoIQ5(A)              atof(A)
#define _atoIQ4(A)              atof(A)
#define _atoIQ3(A)              atof(A)
#define _atoIQ2(A)              atof(A)
#define _atoIQ1(A)              atof(A)
#define _atoIQ(A)               atof(A)

//*****************************************************************************
//
// Converts an IQ number into a string.
//
//*****************************************************************************
#define _IQ30toa(A, B, C)       sprintf(A, B, C)
#define _IQ29toa(A, B, C)       sprintf(A, B, C)
#define _IQ28toa(A, B, C)       sprintf(A, B, C)
#define _IQ27toa(A, B, C)       sprintf(A, B, C)
#define _IQ26toa(A, B, C)       sprintf(A, B, C)
#define _IQ25toa(A, B, C)       sprintf(A, B, C)
#define _IQ24toa(A, B, C)       sprintf(A, B, C)
#define _IQ23toa(A, B, C)       sprintf(A, B, C)
#define _IQ22toa(A, B, C)       sprintf(A, B, C)
#define _IQ21toa(A, B, C)       sprintf(A, B, C)
#define _IQ20toa(A, B, C)       sprintf(A, B, C)
#define _IQ19toa(A, B, C)       sprintf(A, B, C)
#define _IQ18toa(A, B, C)       sprintf(A, B, C)
#define _IQ17toa(A, B, C)       sprintf(A, B, C)
#define _IQ16toa(A, B, C)       sprintf(A, B, C)
#define _IQ15toa(A, B, C)       sprintf(A, B, C)
#define _IQ14toa(A, B, C)       sprintf(A, B, C)
#define _IQ13toa(A, B, C)       sprintf(A, B, C)
#define _IQ12toa(A, B, C)       sprintf(A, B, C)
#define _IQ11toa(A, B, C)       sprintf(A, B, C)
#define _IQ10toa(A, B, C)       sprintf(A, B, C)
#define _IQ9toa(A, B, C)        sprintf(A, B, C)
#define _IQ8toa(A, B, C)        sprintf(A, B, C)
#define _IQ7toa(A, B, C)        sprintf(A, B, C)
#define _IQ6toa(A, B, C)        sprintf(A, B, C)
#define _IQ5toa(A, B, C)        sprintf(A, B, C)
#define _IQ4toa(A, B, C)        sprintf(A, B, C)
#define _IQ3toa(A, B, C)        sprintf(A, B, C)
#define _IQ2toa(A, B, C)        sprintf(A, B, C)
#define _IQ1toa(A, B, C)        sprintf(A, B, C)
#define _IQtoa(A, B, C)         sprintf(A, B, C)

//*****************************************************************************
//
// Computes the absolute value of an IQ number.
//
//*****************************************************************************
#define _IQ30abs(A)             fabs(A)
#define _IQ29abs(A)             fabs(A)
#define _IQ28abs(A)             fabs(A)
#define _IQ27abs(A)             fabs(A)
#define _IQ26abs(A)             fabs(A)
#define _IQ25abs(A)             fabs(A)
#define _IQ24abs(A)             fabs(A)
#define _IQ23abs(A)             fabs(A)
#define _IQ22abs(A)             fabs(A)
#define _IQ21abs(A)             fabs(A)
#define _IQ20abs(A)             fabs(A)
#define _IQ19abs(A)             fabs(A)
#define _IQ18abs(A)             fabs(A)
#define _IQ17abs(A)             fabs(A)
#define _IQ16abs(A)             fabs(A)
#define _IQ15abs(A)             fabs(A)
#define _IQ14abs(A)             fabs(A)
#define _IQ13abs(A)             fabs(A)
#define _IQ12abs(A)             fabs(A)
#define _IQ11abs(A)             fabs(A)
#define _IQ10abs(A)             fabs(A)
#define _IQ9abs(A)              fabs(A)
#define _IQ8abs(A)              fabs(A)
#define _IQ7abs(A)              fabs(A)
#define _IQ6abs(A)              fabs(A)
#define _IQ5abs(A)              fabs(A)
#define _IQ4abs(A)              fabs(A)
#define _IQ3abs(A)              fabs(A)
#define _IQ2abs(A)              fabs(A)
#define _IQ1abs(A)              fabs(A)
#define _IQabs(A)               fabs(A)

#endif // MATH_TYPE == IQ_MATH

//*****************************************************************************
//
// Mark the end of the C bindings section for C++ compilers.
//
//*****************************************************************************
#ifdef __cplusplus
}
#endif

#endif // __IQMATHLIB_H__
