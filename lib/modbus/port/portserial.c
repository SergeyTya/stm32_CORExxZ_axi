/*
* FreeModbus Libary: BARE Port
* Copyright (C) 2006 Christian Walter <wolti@sil.at>
*
* This library is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with this library; if not, write to the Free Software
* Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*
* File: $Id: portserial.c,v 1.1 2006/08/22 21:35:13 wolti Exp $
*/
#include <mb.h>
#include "port.h"
#include "stm32f10x.h"


#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "semphr.h"


/* ----------------------- Modbus includes ----------------------------------*/
#include "mbport.h"

  #define MB_UART                   USART1
  #define USARTy_GPIO              GPIOA
  #define USARTy_CLK               RCC_APB2Periph_USART1
  #define USARTy_GPIO_CLK          RCC_APB2Periph_GPIOA
  #define USARTy_RxPin             GPIO_Pin_10
  #define USARTy_TxPin             GPIO_Pin_2
  #define MB_UART_IRQn             USART1_IRQn
  #define UARTMB_IRQHandler        USART1_IRQHandler

extern xTaskHandle xHandleS;
extern xTaskHandle xHandleR;
extern uint8_t uiMBRxBuf_cnt ;
extern uint8_t uiMBRxBuf[256];
uint32_t temp_RXITST=0;




/* ----------------------- Start implementation -----------------------------*/


BOOL xMBPortSerialInit( UCHAR ucPORT, ULONG ulBaudRate, UCHAR ucDataBits, eMBParity eParity )
{
   (void) ucPORT;
   (void) ucPORT;
    return TRUE;
}

void vMBPortSerialEnable( BOOL xRxEnable, BOOL xTxEnable )
{

  if(xRxEnable == TRUE)
  {

  }
  else
  {

  } 
  
  if(xTxEnable == TRUE)
  {

	  temp_RXITST = 1;


  }
  else
  {
	 temp_RXITST=0;
  }
}

BOOL xMBPortSerialPutByte( CHAR ucByte )
{
	USB_Send_Data(ucByte);
  return TRUE;
}

volatile uint8_t _xxbuf=0;
BOOL xMBPortSerialGetByte( CHAR * pucByte )
{
	*pucByte =_xxbuf;
  return TRUE;
}

extern uint16_t  * usRegHoldingBuf[];
extern uint16_t  * usRegInputRegBuf[];

void vTask_MBread() {

	EXTI->IMR |= EXTI_IMR_MR0;
	EXTI->EMR |= EXTI_EMR_MR0;
	EXTI->SWIER |= EXTI_IMR_MR0;
	NVIC_SetPriority(EXTI0_IRQn, 15);

	while (1) {

		 while (temp_RXITST == 1) pxMBFrameCBTransmitterEmpty();
		(void) eMBPoll();

		if( *(usRegInputRegBuf[3]) > *(usRegHoldingBuf[3])) (*usRegInputRegBuf[3])--;
		if( *(usRegInputRegBuf[3]) < *(usRegHoldingBuf[3])) (*usRegInputRegBuf[3])++;

		vTaskDelay(5);
	}

};


void EXTI0_IRQHandler(void)
{
	uint16_t cnt = 0;

	while (cnt < uiMBRxBuf_cnt) {
		_xxbuf = uiMBRxBuf[cnt];
		pxMBFrameCBByteReceived();
		cnt++;
	}
	pxMBPortCBTimerExpired();
	uiMBRxBuf_cnt = 0;

	//сбрасываем флаг прерывания
	NVIC_ClearPendingIRQ(EXTI0_IRQn);
	NVIC_DisableIRQ(EXTI0_IRQn);
}


/*-----------------------------------------------------------------------------------*/
