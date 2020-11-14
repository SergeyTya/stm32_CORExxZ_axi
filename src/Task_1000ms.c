/*
 * Task_1000ms.c
 *
 *  Created on: 5 июн. 2019 г.
 *      Author: Sergey Tyagushev
 */


#include "stm32f10x_gpio.h"
#include "stm32f10x_usart.h"
#include "stm32f10x_rcc.h"

/* Scheduler includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

extern uint8_t TxBufferSize;
extern uint8_t TxBuffer[];
extern uint8_t RxBuffer[];


void send_command(int command, void *message)
{
   asm("mov r0, %[cmd];"
       "mov r1, %[msg];"
       "bkpt #0xAB"
         :
         : [cmd] "r" (command), [msg] "r" (message)
         : "r0", "r1", "memory");
}


char buf [] = "hello__________\n";
//char s[] = "Hello world\n";

volatile int32_t temp;

RCC_ClocksTypeDef RCC_ClocksStatus;

void vTask_1000ms(void *argument)
{
char cnt =0x31;
    while (1) {

    	cnt++;
    	if(cnt>0x39)cnt = 0x31;


//    	while (USART_GetFlagStatus(USART1, USART_FLAG_RXNE) == 1) {
//
//
//
//    		buf[i]=USART_ReceiveData(USART1);
//    		i++;
//    	}

//    	if(1){
//
//    					uint32_t m[] = { 2/*stderr*/, (uint32_t) buf, sizeof(buf) / sizeof(char)
//    							- 1 };
//    					send_command(0x05/* some interrupt ID */, m);
//    	}
     	memcpy(buf, RxBuffer, 8);
     	memset(RxBuffer, 0, 256);


    	vTaskDelay(1);

    	  /* Enable USARTy DMA Rx and TX request */
    	USART1->SR &=~(USART_SR_TC);
    	TxBuffer[2]=cnt;
    	DMA_Cmd(DMA1_Channel4, DISABLE);
    	DMA_SetCurrDataCounter(DMA1_Channel4, 8);
    	DMA_Cmd(DMA1_Channel4, ENABLE);

    	DMA_Cmd(DMA1_Channel5, DISABLE);
    	DMA_SetCurrDataCounter(DMA1_Channel5, 8);
    	DMA_Cmd(DMA1_Channel5, ENABLE);

//    	//USART_SendData(USART1, 'H');
    	//USART_SendData(USART1, 'i');

//    	  /* Wait until USARTy RX DMA1 Channel Transfer Complete */
//    	  if (DMA_GetFlagStatus(DMA1_FLAG_TC5) == RESET)
//    	  {
//    	  }
//
    	vTaskDelay(1000);



    }

}
