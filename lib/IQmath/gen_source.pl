#!/usr/bin/perl
#******************************************************************************
#
# gen_source.pl - Creates the IQmath source files (with all Q values) from the
#                 single Q templates.
#
# Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
# TI Information - Selective Disclosure
#
#******************************************************************************

use strict;
use Data::Dumper;
use File::Basename;

#******************************************************************************
#
# The substitutions that are done for GNU tool chains.
#
#******************************************************************************
my @subs_gnu =
(
    [ "__ALIGN__",            ".balign 4" ],
    [ "__END__",              ".end" ],
    [ "__EXPORT__",           ".globl" ],
    [ "__HEADER__",           ".syntax unified\n    .thumb" ],
    [ "__IMPORT__",           ".extern" ],
    [ "__LABEL__",            ":" ],
    [ "__LITERALS__",         ".balign 4" ],
    [ "__PREAMBLE__",         "\n    .syntax unified\n    .thumb\n    .text\n" ],
    [ "__SECTION__.*",        ".section .text.__NAME__" ],
    [ "__THUMB_LABEL__",      "\n    .thumb_func" ],
    [ "__WORD__",             ".word" ],
);

#******************************************************************************
#
# The substitutions that are done for the IAR tool chain.
#
#******************************************************************************
my @subs_iar =
(
    [ "__ALIGN__",            "alignrom 2" ],
    [ "__END__",              "end" ],
    [ "__EXPORT__",           "export " ],
    [ "__IMPORT__",           "import " ],
    [ "__LABEL__",            "" ],
    [ "__LITERALS__",         "alignrom 2\n    data" ],
    [ "__PREAMBLE__",         "" ],
    [ "__SECTION__.*",        "section CODE___NAME__:CODE(2)\n    thumb" ],
    [ "__THUMB_LABEL__",      "" ],
    [ "__WORD__",             "dcd    " ],
);

#******************************************************************************
#
# The substitutions that are done for the Keil tool chain.
#
#******************************************************************************
my @subs_keil =
(
    [ "__ALIGN__",            "align   4" ],
    [ "__END__",              "end" ],
    [ "__EXPORT__",           "export " ],
    [ "__IMPORT__",           "import " ],
    [ "__LABEL__",            "" ],
    [ "__LITERALS__",         "align   4" ],
    [ "__PREAMBLE__",         "\n    thumb\n    require8\n    preserve8\n" ],
    [ "__SECTION__.*",        "AREA ||__NAME__||, CODE, READONLY" ],
    [ "__THUMB_LABEL__",      "" ],
    [ "__WORD__",             "dcd    " ],
    [ "//",                   ";;" ],
);

#******************************************************************************
#
# The substitutions that are done for the TI tool chain.
#
#******************************************************************************
my @subs_ti =
(
    [ "__ALIGN__",            ".align 4" ],
    [ "__END__",              ".end" ],
    [ "__EXPORT__",           ".global" ],
    [ "__IMPORT__",           ".ref" ],
    [ "__LABEL__",            ":" ],
    [ "__LITERALS__",         ".align 4" ],
    [ "__PREAMBLE__",         "" ],
    [ "__SECTION__.*",        ".sect \".text:__NAME__\"" ],
    [ "__THUMB_LABEL__",      "" ],
    [ "__WORD__",             ".word" ],
    [ "//",                   ";;" ],
    [ "\\.S",                 ".asm" ],
    [ "addpl",                "addPL" ],
    [ "bxcc",                 "bxCC" ],
    [ "bxeq",                 "bxEQ" ],
    [ "bxge",                 "bxGE" ],
    [ "clzpl",                "clzPL" ],
    [ "it      cc",           "it      CC" ],
    [ "it      cs",           "it      CS" ],
    [ "it      eq",           "it      EQ" ],
    [ "it      ge",           "it      GE" ],
    [ "it      mi",           "it      MI" ],
    [ "it      ne",           "it      NE" ],
    [ "it      pl",           "it      PL" ],
    [ "ite     mi",           "ite     MI" ],
    [ "itt     cs",           "itt     CS" ],
    [ "itt     eq",           "itt     EQ" ],
    [ "itt     ge",           "itt     GE" ],
    [ "ittt    hi",           "ittt    HI" ],
    [ "ittt    pl",           "ittt    PL" ],
    [ "ldrcs",                "ldrCS" ],
    [ "lslpl",                "lslPL" ],
    [ "moveq",                "movEQ" ],
    [ "movge",                "movGE" ],
    [ "movhi",                "movHI" ],
    [ "movmi",                "movMI" ],
    [ "movpl",                "movPL" ],
    [ "mvnmi",                "mvnMI" ],
    [ "popeq",                "popEQ" ],
    [ "popge",                "popGE" ],
    [ "rsbcs",                "rsbCS" ],
    [ "rsbeq",                "rsbEQ" ],
    [ "rsbmi",                "rsbMI" ],
    [ "rsbne",                "rsbNE" ],
    [ "rsbpl",                "rsbPL" ],
    [ "subpl",                "subPL" ],
    [ "teqmi",                "teqMI" ],
    [ "umullcs",              "umullCS" ],
);

#******************************************************************************
#
# A subroutine to read the contents of a file into an array.
#
#******************************************************************************
sub
ReadFile($)
{
    #
    # Open the file.
    #
    open(FILE, $_[0]) || die("Failed to open $_[0]");

    #
    # Read the file contents into an array.
    #
    my @list = <FILE>;

    #
    # Close the file.
    #
    close(FILE);

    #
    # Return the array.
    #
    return(@list);
}

#******************************************************************************
#
# A subroutine to write the contents of an array into a file.
#
#******************************************************************************
sub
WriteFile($\@)
{
    #
    # Create the file.
    #
    open(FILE, "> $_[0]") || die("Failed to create $_[0]");

    #
    # Read the file contents into an array.
    #
    print FILE @{$_[1]};

    #
    # Close the file.
    #
    close(FILE);
}

#******************************************************************************
#
# A subroutine to unroll the source code based on a tag an range of values.
#
#******************************************************************************
sub
Unroll(\@)
{
    #
    # Get the subroutine arguments.
    #
    my @lines = @{$_[0]};

    #
    # Loop through the input lines.
    #
    for(my $line = 0; $line <= $#lines; $line++)
    {
        #
        # See if this is the start of an unroll tag.
        #
        if($lines[$line] =~ /^\/\/\$ BEGIN_UNROLL /)
        {
            #
            # Get the values associated with this unroll tag.  They are the
            # tag name, the start value, and the end value.
            #
            my @tokens = split(' ', $lines[$line]);
            chomp(@tokens);

            #
            # Find the end of the unroll tag.
            #
            my $endline;
            for($endline = $line + 1; $endline <= $#lines; $endline++)
            {
                if($lines[$endline] =~ /^\/\/\$ END_UNROLL $tokens[2]/)
                {
                    last;
                }
            }

            #
            # Bail out if this unroll tag was not terminated.
            #
            if($endline > $#lines)
            {
                die("Unterminated $tokens[2] BEGIN_UNROLL");
            }

            #
            # Remove the tag start and end lines.  The end is removed first
            # since removing the start first would affect the line number of
            # the end.
            #
            splice(@lines, $endline, 1);
            splice(@lines, $line, 1);

            #
            # Remove the body of the unroll section.
            #
            my @body = splice(@lines, $line, $endline - $line - 1);

            #
            # Start inserting the unrolled section at the location of the
            # unroll start tag.
            #
            $endline = $line;

            #
            # See if the loop should be unrolled going up or down.
            #
            if($tokens[3] < $tokens[5])
            {
                #
                # Loop through the tag values counting up.
                #
                for(my $value = $tokens[3]; $value <= $tokens[5]; $value++)
                {
                    #
                    # Replace the variable in the body text with the current
                    # tag value.
                    #
                    my @body2 = @body;
                    for (@body2)
                    {
                        s/$tokens[2]/$value/g;
                    }

                    #
                    # Insert the unrolled body into the text.
                    #
                    splice(@lines, $endline, 0, @body2);

                    #
                    # Increment the location where the next unrolled body will
                    # be inserted.
                    #
                    $endline += $#body2 + 1;
                }
            }
            else
            {
                #
                # Loop through the tag values.
                #
                for(my $value = $tokens[3]; $value >= $tokens[5]; $value--)
                {
                    #
                    # Replace the variable in the body text with the current
                    # tag value.
                    #
                    my @body2 = @body;
                    for (@body2)
                    {
                        s/$tokens[2]/$value/g;
                    }

                    #
                    # Insert the unrolled body into the text.
                    #
                    splice(@lines, $endline, 0, @body2);

                    #
                    # Increment the location where the next unrolled body will
                    # be inserted.
                    #
                    $endline += $#body2 + 1;
                }
            }

            #
            # Decrement the line number by one so that the first line of the
            # newly unrolled text will be examined (in case there is a nested
            # unroll).
            #
            $line--;
        }
    }

    #
    # Return the resulting list of lines.
    #
    return(@lines);
}

#******************************************************************************
#
# A subroutine to handle the #if statements in the source.
#
#******************************************************************************
sub
HandleIfs(\@)
{
    #
    # Get the subroutine arguments.
    #
    my @lines = @{$_[0]};

    #
    # Loop through the input lines.
    #
    for(my $line = 0; $line <= $#lines; $line++)
    {
        #
        # See if this is the start of a #if block.
        #
        if($lines[$line] =~ /^#if /)
        {
            #
            # Remove the #if from teh beginning of the line.
            #
            $lines[$line] =~ s/^#if //;

            #
            # Find the end of the #if block.
            #
            my $endline;
            for($endline = $line + 1; $endline <= $#lines; $endline++)
            {
                if($lines[$endline] =~ /^#endif/)
                {
                    last;
                }
            }

            #
            # Bail out if this #if block was not terminated.
            #
            if($endline > $#lines)
            {
                die("Unterminated #if");
            }

            #
            # See if the contents of this #if block should be kept or removed.
            #
            if(eval $lines[$line])
            {
                #
                # Keep the block by removing the #if and #endif.  The #endif is
                # removed first since removing the #if first would affect the
                # line number of the #endif.
                #
                splice(@lines, $endline, 1);
                splice(@lines, $line, 1);
            }
            else
            {
                #
                # Remove the entire #if block.
                #
                splice(@lines, $line, $endline - $line + 1);
            }

            #
            # Decrement the line number by one so that the first line of the
            # resulting text will be examined (in case there is a nested #if).
            #
            $line--;
        }
    }

    #
    # Return the resulting list of lines.
    #
    return(@lines);
}

#******************************************************************************
#
# A subroutine to convert #defines into the appropriate equ statements for the
# Keil assembler.
#
#******************************************************************************
sub
HandleDefines(\@$)
{
    #
    # Get the subroutine arguments.
    #
    my @lines = @{$_[0]};
    my $mnemonic = $_[1];

    #
    # Loop through the input lines.
    #
    for(my $line = 0; $line <= $#lines; $line++)
    {
        #
        # See if this is a #define.
        #
        if($lines[$line] =~ /^#define /)
        {
            my @tokens = split(' ', $lines[$line]);
            chomp(@tokens);
            $lines[$line] = sprintf("%-31s %-7s %s\n", $tokens[1], $mnemonic,
                                    $tokens[2]);
        }
    }

    #
    # Return the resulting list of lines.
    #
    return(@lines);
}

#******************************************************************************
#
# A subroutine to substitute assembler-generic nmemonics with their
# assembler-specific counterparts.
#
#******************************************************************************
sub
Substitute(\@\@$)
{
    #
    # Get the subroutine arguments.
    #
    my @lines = @{$_[0]};
    my @subs = @{$_[1]};
    my $section_string = $_[2];

    #
    # Loop through the substitutions.
    #
    my @tokens;
    for(my $sub_idx = 0; $sub_idx <= $#subs; $sub_idx++)
    {
        #
        # See if this is the section substitution, which needs special
        # treatment.
        #
        if($subs[$sub_idx]->[0] =~ /__SECTION__/)
        {
            #
            # Loop through the lines in the file.
            #
            for(@lines)
            {
                #
                # Tokenize this line.
                #
                my @tokens = split;

                #
                # Perform this substitution.
                #
                s/$subs[$sub_idx]->[0]/$subs[$sub_idx]->[1]/g;

                #
                # If there is a __NAME__ (which would come from the __SECTION__
                # substitution), then replace it with the original argument.
                #
                s/__NAME__/$tokens[1]/g;
            }
        }
        else
        {
            #
            # Loop through the lines in the file.
            #
            for(@lines)
            {
                #
                # Perform this substitution.
                #
                s/$subs[$sub_idx]->[0]/$subs[$sub_idx]->[1]/g;
            }
        }
    }

    #
    # Return the resulting list of lines.
    #
    return(@lines);
}

#******************************************************************************
#
# The subroutine that puts it all together and does all the heavy lifting.
#
#******************************************************************************
sub
main()
{
    #
    # Create the output directories.
    #
    mkdir("gnu");
    mkdir("iar");
    mkdir("keil");
    mkdir("ti");

    #
    # Loop through all the template files.
    #
    for my $fn (glob("templates/*.S.tmpl"))
    {
        #
        # Get the base file name.
        #
        my $basefn = basename($fn, ".S.tmpl");

        #
        # Read in the template file.
        #
        my @lines = ReadFile("$fn");

        #
        # Unroll the functions in this file.
        #
        @lines = Unroll(@lines);

        #
        # Handle any #ifs in this file.
        #
        @lines = HandleIfs(@lines);

        #
        # Perform GNU-specific substitutions and write the file.
        #
        my @gnu = Substitute(@lines, @subs_gnu, ".text .text.__NAME__");
        WriteFile("gnu/${basefn}.S", @gnu);

        #
        # Perform any IAR-specific substitutions and write the file.
        #
        my @iar = Substitute(@lines, @subs_iar, "");
        WriteFile("iar/${basefn}.S", @iar);

        #
        # Perform any Keil-specific substitutions and write the file.
        #
        my @keil = Substitute(@lines, @subs_keil, "");
        @keil = HandleDefines(@keil, "equ");
        WriteFile("keil/${basefn}.S", @keil);

        #
        # Perform any TI-specific substitutions and write the file.
        #
        my @ti = Substitute(@lines, @subs_ti, "");
        @ti = HandleDefines(@ti, ".equ");
        WriteFile("ti/${basefn}.asm", @ti);
    }

    #
    # Read in the template file for the C header file.
    #
    my @lines = ReadFile("templates/IQmathLib.h.tmpl");

    #
    # Unroll the functions in this file.
    #
    @lines = Unroll(@lines);

    #
    # Write the C header file.
    #
    WriteFile("IQmathLib.h", @lines);

    #
    # Read in the template file for the C++ header file.
    #
    my @lines = ReadFile("templates/IQmathCPP.h.tmpl");

    #
    # Unroll the functions in this file.
    #
    @lines = Unroll(@lines);

    #
    # Write the C++ header file.
    #
    WriteFile("IQmathCPP.h", @lines);
}

#******************************************************************************
#
# Call the main function.
#
#******************************************************************************
main
