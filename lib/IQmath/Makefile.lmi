#******************************************************************************
#
# Makefile.lmi - Rules to be run after buildproj finishes generating project
#                files.
#
# Copyright (c) 2010 Texas Instruments Incorporated.  All rights reserved.
#
#******************************************************************************

all:
	@if [ -f IQmathLib.ewp ];                       \
	 then                                           \
	     sed -i 's,\\ti\\,\\iar\\,g' IQmathLib.ewp; \
	 fi
	@if [ -f IQmathLib.uvopt ];                        \
	 then                                              \
	     sed -i 's,\\ti\\,\\keil\\,g' IQmathLib.uvopt; \
	 fi
	@if [ -f IQmathLib.uvproj ] ;                       \
	 then                                               \
	     sed -i 's,\\ti\\,\\keil\\,g' IQmathLib.uvproj; \
	 fi

clean:
	@rm -rf gnu iar keil ti IQmathCPP.h IQmathLib.h
