/* 
 * FreeModbus Libary: A portable Modbus implementation for Modbus ASCII/RTU.
 * Copyright (c) 2006 Christian Walter <wolti@sil.at>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * File: $Id: mbfuncother.c,v 1.8 2006/12/07 22:10:34 wolti Exp $
 */


#define _mFIELD1 "AXISENS_________" //
#define _mFIELD2 "________________"        // char[9]
#define _mFIELD3 "________________"      // char[11]


/* ----------------------- System includes ----------------------------------*/
#include "stdlib.h"
#include "string.h"

/* ----------------------- Platform includes --------------------------------*/
#include "port.h"
#include "Prjct_cnfg.h"

#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
/* ----------------------- Modbus includes ----------------------------------*/
#include "mb.h"
#include "mbframe.h"
#include "mbproto.h"
#include "mbconfig.h"

#if MB_FUNC_OTHER_REP_SLAVEID_ENABLED > 0

/* ----------------------- Static variables ---------------------------------*/
static UCHAR    ucMBSlaveID[MB_FUNC_OTHER_REP_SLAVEID_BUF];
static USHORT   usMBSlaveIDLen;
extern signed short int *   usRegHoldingBuf[REG_HOLDING_NREGS];
extern signed short int *   usRegInputRegBuf[REG_INPUT_NREGS ];


/* ----------------------- Start implementation -----------------------------*/

eMBErrorCode
eMBSetSlaveID( UCHAR ucSlaveID, BOOL xIsRunning,
               UCHAR const *pucAdditional, USHORT usAdditionalLen )
{
    eMBErrorCode    eStatus = MB_ENOERR;

    /* the first byte and second byte in the buffer is reserved for
     * the parameter ucSlaveID and the running flag. The rest of
     * the buffer is available for additional data. */
    if( usAdditionalLen + 2 < MB_FUNC_OTHER_REP_SLAVEID_BUF )
    {
        usMBSlaveIDLen = 0;
        ucMBSlaveID[usMBSlaveIDLen++] = ucSlaveID;
        ucMBSlaveID[usMBSlaveIDLen++] = ( UCHAR )( xIsRunning ? 0xFF : 0x00 );
        if( usAdditionalLen > 0 )
        {
            memcpy( &ucMBSlaveID[usMBSlaveIDLen], pucAdditional,
                    ( size_t )usAdditionalLen );
            usMBSlaveIDLen += usAdditionalLen;
        }
    }
    else
    {
        eStatus = MB_ENORES;
    }
   
    return eStatus;
}

eMBException
eMBFuncReportSlaveID( UCHAR * pucFrame, USHORT * usLen )
{
    memcpy( &pucFrame[MB_PDU_DATA_OFF], &ucMBSlaveID[0], ( size_t )usMBSlaveIDLen );
    *usLen = ( USHORT )( MB_PDU_DATA_OFF + usMBSlaveIDLen );
    return MB_EX_NONE;
}

const CHAR EXTEND_ID[]={
0x0E, 0x01,0x01,0x00,0x00,0x04,0x00,0x08,
_mFIELD1[0],_mFIELD1[1],_mFIELD1[2],_mFIELD1[3],_mFIELD1[4],_mFIELD1[5],_mFIELD1[6],_mFIELD1[7],
0x01, 0x09,\
_mFIELD2[0],_mFIELD2[1],_mFIELD2[2],_mFIELD2[3],_mFIELD2[4],_mFIELD2[5],_mFIELD2[6],_mFIELD2[7],_mFIELD2[8],
0x02, 0x0B,
_mFIELD3[0],_mFIELD3[1],_mFIELD3[2],_mFIELD3[3],_mFIELD3[4],_mFIELD3[5],_mFIELD3[6],_mFIELD3[7],_mFIELD3[8],_mFIELD3[9],_mFIELD3[10],
0x03, 0x0A,
__DATE__[4],__DATE__[5],__DATE__[0],__DATE__[1],__DATE__[9],__DATE__[10],__TIME__[0],__TIME__[1],__TIME__[3],
0x31, 0x36};

eMBException
eMBFuncReportOtherData( UCHAR * pucFrame, USHORT * usLen )
{

  uint8_t j=0;while(j<sizeof(EXTEND_ID)-1)
   {
     pucFrame[1+j]=EXTEND_ID[j];
     j++;
   };      
   *usLen=sizeof(EXTEND_ID)-1;
    return MB_EX_NONE;
  
}


extern QueueHandle_t xQueue;

eMBException
eMBFuncSendScopeData( UCHAR * pucFrame, USHORT * usLen )
{
    uint32_t Fadr;
    
 portBASE_TYPE xStatus = xQueueReceive( xQueue, &Fadr, 0);

 if( xStatus != pdPASS ) 
 { 
 return MB_EX_SLAVE_BUSY;
 }

		memcpy(&pucFrame[MB_PDU_DATA_OFF],(uint8_t *) Fadr, (240+3));
		*usLen = (USHORT) ( MB_PDU_DATA_OFF + (240+3));
                
		return MB_EX_NONE;

}
#endif


