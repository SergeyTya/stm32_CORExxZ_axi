//*****************************************************************************
//
// atoIQN.c - Converts an ASCII string to an IQ number
//
// Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
// TI Information - Selective Disclosure
//
//*****************************************************************************

//*****************************************************************************
//
// Function:    _atoIQN()
//
//*****************************************************************************
//
// C Usage:     _atoIQN(const char *string, long qvalue);
//
//-----------------------------------------------------------------------------
//
// Input Parameters:
//    string = input string
//    qvalue = IQ format for output (e.g., 24 means I8Q24)
//
// Return Value:
//    IQ number from string (0 if an error occurred)
//
//-----------------------------------------------------------------------------
//
// Algorithm:   The input string must only contain decimal characters
//              '0' to '9' and the characters '-' for negative value
//              if applicable and '.' character for delimiting integer and
//              fraction components. Some examples of valid inputs are:
//
//                        12.23456
//                       -12.23456
//                         0.2345
//                         0.0
//                         0
//                       127
//                       -89 
//              
//              If the input string converts to a number greater then
//              the max/min values for the given Q value, then the returned
//              value will be limited to the min/max values.
//
//              If the string contains illegal characters, it will return 
//              the value zero.
//
//*****************************************************************************

//*****************************************************************************
//
// _atoIQN
//
//*****************************************************************************
long
_atoIQN(const char *string, int qvalue)
{
    unsigned long value, digits, neg = 0, overflow = 0;
    unsigned long long frac, factor;

    //
    // Check for and remove the optional leading negative sign.
    //
    if(*string == '-')
    {
        string++;
        neg = 1;
    }

    //
    // Until digits are extracted, the integer and fractional portions are
    // zero.
    //
    value = 0;
    frac = 0;

    //
    // Loop while there are digits in the integer portion.
    //
    digits = 0;
    while((*string >= '0') && (*string <= '9'))
    {
        //
        // If there have been too many digits to fit, then indicate that an
        // overflow has occurred.
        //
        if((digits == 9) && (value > 107374182))
        {
            overflow = 1;
        }

        //
        // Add this digit to the integer portion.
        //
        value *= 10;
        value += *string - '0';
        string++;
        digits++;
    }

    //
    // Indicate an overflow if there were too many digits.
    //
    if(digits > 10)
    {
        overflow = 1;
    }

    //
    // See if there is a decimal point.
    //
    if(*string == '.')
    {
        //
        // Skip the decimal point.
        //
        string++;

        //
        // Loop while there are digits in the fractional portion.
        //
        factor = 0xffffffffffffffffLL / 10;
        while((*string >= '0') && (*string <= '9'))
        {
            //
            // Add this digit to the fractional portion if there have not been
            // too many digits already.
            //
            if(factor != 0)
            {
                frac += factor * (*string - '0');
                factor /= 10;
            }
            string++;
        }

        //
        // Round the fractional portion up by half a bit.
        //
        factor = 1LL << (63 - qvalue);
        if((frac + factor) < frac)
        {
            value++;
        }
        frac += factor;
    }

    //
    // Return an error if there are any remaining (i.e. non-digit) characters
    // in the string.
    //
    if(*string != '\0')
    {
        return(0);
    }

    //
    // See if the value should be positive or negative.
    //
    if(neg)
    {
        //
        // See if the value has overflowed (negative).
        //
        if(overflow || (value > (0x80000000 >> qvalue)) ||
           ((value == (0x80000000 >> qvalue)) && (frac != 0)))
        {
            //
            // The value overflowed, so return the maximum negative.
            //
            return(0x80000000);
        }

        //
        // Combine the integer and fractional portion into the negative result.
        //
        return(0 - ((value << qvalue) | (frac >> (64 - qvalue))));
    }
    else
    {
        //
        // See if the value has overflowed (positive).
        //
        if(overflow || (value > (0x7fffffff >> qvalue)))
        {
            //
            // The value overflowed, so return the maximum positive.
            //
            return(0x7fffffff);
        }

        //
        // Combine the integer and fractional portion into the positive result.
        //
        return((value << qvalue) | (frac >> (64 - qvalue)));
    }
}
