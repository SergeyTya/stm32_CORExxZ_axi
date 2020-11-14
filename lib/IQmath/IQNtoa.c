//*****************************************************************************
//
// IQntoa.c - Converts IQ number to an ASCII string
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:    __IQNtoa()
//
//*****************************************************************************
//
// C Usage:     __IQNtoa(char *string, const char *format, long x, int qvalue);
//
//-----------------------------------------------------------------------------
//
// Input Parameters:
//    string = output string
//    format = conversion format.  Must be of form "%xx.yyf" with
//             xx and yy at most 2 characters in length.
//               Examples: "%10.12f", "%2.4f", "%11.6f"
//             Maximum supported integer field width (xx) is 11
//             (including any negative sign).  This captures the full
//             integer range for I2Q30 to I31Q1 numbers.
//         x = input value (IQ format)
//    qvalue = IQ format of x (e.g., 24 means I8Q24)
//
// Return Value:
//     error = error code:
//               0 = no error
//               1 = iwidth too small to hold integer characters
//               2 = illegal format specified
//
//-----------------------------------------------------------------------------
//
// Notes:
//
// 1) Leading zeros are not printed for the integer part.  Hence, format
//    specifies the maximum width of the integer field.  The field may
//    be smaller.
// 2) The output string is terminated with the null character.
// 3) The integer width in "format" includes the negative sign for
//    negative numbers, e.g. -12.3456 is "%3.5f"
// 4) The decimal width in "format" includes the decimal point, e.g.
//    -12.3456 is "%3.5f"
// 5) "string" must be large enough to hold the output (including the
//    negative sign, and the terminating null character).  The program
//    does not check for overrun.  Memory corruption will occur if
//    "string" is too small.
// 6) A non-zero return value indicates that the output string is invalid.
// 7) Benchmark is roughly 200 to 800 cycles, depending on the format and
//    the input value.
//
//*****************************************************************************

//*****************************************************************************
//
// __IQNtoa
//
//*****************************************************************************
int
__IQNtoa(char *string, const char *format, long x, int qvalue)
{
    int count, error = 0, iwidth, dwidth, scale;
    char *bufptr, buf[11];
    unsigned long uval;

    //
    // Parse the format parameter.  Check that the first character is '%'.
    //
    if(*format++ != '%')
    {
        return(2);
    }

    //
    // Extract iwidth
    //
    if(*format == '.')
    {
        return(2);
    }
    count = 0;
    scale = 1;
    iwidth = 0;
    while(*format != '.')
    {
        count++;
        iwidth = (iwidth * scale) + (*format++ - '0');
        scale *= 10;

        //
        // If we don't find the '.' after 2 counts, something is wrong.
        //
        if(count > 2)
        {
            return(2);
        }
    }

    //
    // Make sure that iwidth is valid.
    //
    if((iwidth < 0) || (iwidth > 11))
    {
        return(2);
    }

    //
    // Extract dwidth.
    //
    format++;
    if(*format == 0)
    {
        return(2);
    }
    count = 0;
    scale = 1;
    dwidth = 0;
    while((*format != 'f') && (*format != 'F'))
    {
        count++;
        dwidth = (dwidth * scale) + (*format++ - '0');
        scale *= 10;

        //
        // If we don't find the conversion character after 2 counts, something
        // is wrong.
        //
        if(count > 2)
        {
            return(2);
        }
    }

    //
    // Make sure that dwidth is valid.
    //
    if(dwidth < 0)
    {
        return(2);
    }

    //
    // Check that the next character is the NULL string terminator
    //
    if(*++format != 0)
    {
        return(2);
    }

    //
    // Isolate the integer part.
    //
    if(x < 0)
    {
        uval = (0 - (unsigned long)x) >> qvalue;
    }
    else
    {
        uval = x >> qvalue;
    }

    //
    // Convert the integer part.
    //
    bufptr = buf;
    count = 0;
    do
    {
        *bufptr++ = (uval % 10) + '0';
        count++;
        uval /= 10;
    }
    while(uval != 0);

    //
    // Insert a '-' if the value is negative.
    //
    if(x < 0)
    {
        *bufptr++ = '-';
        count++;
    }

    //
    // Limit the number of digits if necessary.
    //
    if(count > iwidth)
    {
        count = iwidth;
        error = 1;
    }

    //
    // Copy the characters to the output string.
    //
    while(count--)
    {
        *string++ = *--bufptr;
    }

    //
    // Process the fractional part.
    //
    if(dwidth > 0)
    {
        //
        // Insert the decimal point.
        //
        *string++ = '.';
        dwidth--;

        //
        // Isolate the fractional part.
        //
        if(x < 0)
        {
            uval = (0 - (unsigned long)x) << (32 - qvalue);
        }
        else
        {
            uval = x << (32 - qvalue);
        }

        //
        // Convert the fractional part.
        //
        for(count = 0; count < dwidth; count++)
        {
            *string++ = '0' + (((long long)uval * 10) >> 32);
            uval *= 10;
        }
    }

    //
    // NUL terminate the string.
    //
    *string = 0;

    //
    // Return, indicating if an error was encountered.
    //
    return(error);
}
