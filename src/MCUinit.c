/*
 * MCUinit.c
 *
 *  Created on: 5 июн. 2019 г.
 *      Author: Sergey Tyagushev
 */

#include "stm32f10x_gpio.h"
#include "stm32f10x_rcc.h"
#include "stm32f10x_tim.h"
#include "stm32f10x_spi.h"
#include "stm32f10x_i2c.h"
#include "stm32f10x_usart.h"

void Uart_config();



static void NVIC_Configuration(void)
{
  NVIC_InitTypeDef NVIC_InitStructure;

  /* Enable and configure RCC global IRQ channel*/
  NVIC_InitStructure.NVIC_IRQChannel = RCC_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);


  /* Enable the TIM3 global Interrupt */
  NVIC_InitStructure.NVIC_IRQChannel = TIM3_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);

//  __enable_irq();


}

static void SetSysClockTo72(void)
{
  ErrorStatus HSEStartUpStatus;
  /* SYSCLK, HCLK, PCLK2 and PCLK1 configuration -----------------------------*/
  /* RCC system reset(for debug purpose) */
  RCC_DeInit();

  /* Enable HSE */
  RCC_HSEConfig(RCC_HSE_ON);

  /* Wait till HSE is ready */
  HSEStartUpStatus = RCC_WaitForHSEStartUp();

  if (HSEStartUpStatus == SUCCESS)
  {
    /* Enable Prefetch Buffer */
    FLASH_PrefetchBufferCmd(FLASH_PrefetchBuffer_Enable);

    /* Flash 2 wait state */
    FLASH_SetLatency(FLASH_Latency_2);

    /* HCLK = SYSCLK */
    RCC_HCLKConfig(RCC_SYSCLK_Div1);

    /* PCLK2 = HCLK */
    RCC_PCLK2Config(RCC_HCLK_Div1);

    /* PCLK1 = HCLK/2 */
    RCC_PCLK1Config(RCC_HCLK_Div2);


    /* PLLCLK = 8MHz * 9 = 72 MHz */
    RCC_PLLConfig(RCC_PLLSource_HSE_Div1, RCC_PLLMul_9);

    /* Enable PLL */
    RCC_PLLCmd(ENABLE);

    /* Wait till PLL is ready */
    while (RCC_GetFlagStatus(RCC_FLAG_PLLRDY) == RESET)
    {
    }

    /* Select PLL as system clock source */
    RCC_SYSCLKConfig(RCC_SYSCLKSource_PLLCLK);

    /* Wait till PLL is used as system clock source */
    while(RCC_GetSYSCLKSource() != 0x08)
    {
    }
  }
  else
  { /* If HSE fails to start-up, the application will have wrong clock configuration.
       User can add here some code to deal with this error */

    /* Go to infinite loop */
    while (1)
    {
    }
  }
};

static void TIM3_config(){

	TIM_TimeBaseInitTypeDef  TIM_TimeBaseStructure;
	TIM_OCInitTypeDef  TIM_OCInitStructure;
	GPIO_InitTypeDef GPIO_InitStructure;

	uint16_t CCR1_Val = 333;
	uint16_t CCR2_Val = 249;
	uint16_t CCR3_Val = 166;
	uint16_t CCR4_Val = 83;
	uint16_t PrescalerValue = 0;


	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM3, ENABLE);

	  /* -----------------------------------------------------------------------
	    TIM3 Configuration: generate 4 PWM signals with 4 different duty cycles:
	    The TIM3CLK frequency is set to SystemCoreClock (Hz), to get TIM3 counter
	    clock at 24 MHz the Prescaler is computed as following:
	     - Prescaler = (TIM3CLK / TIM3 counter clock) - 1
	    SystemCoreClock is set to 72 MHz for Low-density, Medium-density, High-density
	    and Connectivity line devices and to 24 MHz for Low-Density Value line and
	    Medium-Density Value line devices

	    The TIM3 is running at 36 KHz: TIM3 Frequency = TIM3 counter clock/(ARR + 1)
	                                                  = 24 MHz / 666 = 36 KHz
	    TIM3 Channel1 duty cycle = (TIM3_CCR1/ TIM3_ARR)* 100 = 50%
	    TIM3 Channel2 duty cycle = (TIM3_CCR2/ TIM3_ARR)* 100 = 37.5%
	    TIM3 Channel3 duty cycle = (TIM3_CCR3/ TIM3_ARR)* 100 = 25%
	    TIM3 Channel4 duty cycle = (TIM3_CCR4/ TIM3_ARR)* 100 = 12.5%
	  ----------------------------------------------------------------------- */
	  /* Compute the prescaler value */
	  PrescalerValue = (uint16_t) (72000000 / 24000000) - 1;
	  /* Time base configuration */
	  TIM_TimeBaseStructure.TIM_Period = 665;
	  TIM_TimeBaseStructure.TIM_Prescaler = PrescalerValue;
	  TIM_TimeBaseStructure.TIM_ClockDivision = 0;
	  TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Up;

	  TIM_TimeBaseInit(TIM3, &TIM_TimeBaseStructure);

	  /* PWM1 Mode configuration: Channel1 */
	  TIM_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;
	  TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
	  TIM_OCInitStructure.TIM_Pulse = CCR1_Val;
	  TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity_High;

	  TIM_OC1Init(TIM3, &TIM_OCInitStructure);

	  TIM_OC1PreloadConfig(TIM3, TIM_OCPreload_Enable);

	  /* PWM1 Mode configuration: Channel2 */
	  TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
	  TIM_OCInitStructure.TIM_Pulse = CCR2_Val;

	  TIM_OC2Init(TIM3, &TIM_OCInitStructure);

	  TIM_OC2PreloadConfig(TIM3, TIM_OCPreload_Enable);

	  /* PWM1 Mode configuration: Channel3 */
	  TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
	  TIM_OCInitStructure.TIM_Pulse = CCR3_Val;

	  TIM_OC3Init(TIM3, &TIM_OCInitStructure);

	  TIM_OC3PreloadConfig(TIM3, TIM_OCPreload_Enable);

	  /* PWM1 Mode configuration: Channel4 */
	  TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
	  TIM_OCInitStructure.TIM_Pulse = CCR4_Val;

	  TIM_OC4Init(TIM3, &TIM_OCInitStructure);

	  TIM_OC4PreloadConfig(TIM3, TIM_OCPreload_Enable);

	  TIM_ARRPreloadConfig(TIM3, ENABLE);

	  /* TIM3 enable counter */
	 TIM_Cmd(TIM3, ENABLE);

	// TIM_ITConfig(TIM3, TIM_IT_Update, ENABLE);
	//  NVIC_EnableIRQ(TIM3_IRQn);



	  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
	  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOF, ENABLE);
	  RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA1, ENABLE);


	//   /* GPIOA Configuration:TIM3 Channel1, 2, 3 and 4 as alternate function push-pull */
	//   GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6 | GPIO_Pin_7;
	//   GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	//   GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;

	//   GPIO_Init(GPIOA, &GPIO_InitStructure);

	   GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1;
	   GPIO_Init(GPIOB, &GPIO_InitStructure);

	   /* GPIOA Configuration:TIM3 Channel1, 2, 3 and 4 as alternate function push-pull */
	  	   GPIO_InitStructure.GPIO_Pin = GPIO_Pin_13;
	  	   GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	  	   GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;

	  	   GPIO_Init(GPIOB, &GPIO_InitStructure);



}

void MCUinit(){

	GPIO_InitTypeDef GPIO_InitStructure;
	SetSysClockTo72();
	RCC_ClockSecuritySystemCmd(ENABLE);
	  /* NVIC configuration ------------------------------------------------------*/
//	NVIC_Configuration();

	TIM3_config();

	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_14;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);

  	Uart_config();

};

uint8_t TxBufferSize = 25;
//char TxBuffer[256]= {0xC9, 0x45, 0x02, 0x00, 0x08, 0x00, 0x03, 0x01};
char TxBuffer[256]= {0x01, 0x03, 0x00, 0x08, 0x00, 0x02, 0x45, 0xC9};
char RxBuffer[256]="no data here";


void Uart_config(){

	  DMA_InitTypeDef DMA_InitStructure;

	  /* USARTy TX DMA1 Channel (triggered by USARTy Tx event) Config */
	  DMA_DeInit(DMA1_Channel4);
	  DMA_InitStructure.DMA_PeripheralBaseAddr = (uint32_t)&(USART1->DR);
	  DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)TxBuffer;
	  DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralDST;
	  DMA_InitStructure.DMA_BufferSize = TxBufferSize;
	  DMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
	  DMA_InitStructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
	  DMA_InitStructure.DMA_PeripheralDataSize = DMA_PeripheralDataSize_Byte;
	  DMA_InitStructure.DMA_MemoryDataSize = DMA_MemoryDataSize_Byte;
	  DMA_InitStructure.DMA_Mode = DMA_Mode_Normal;
	  DMA_InitStructure.DMA_Priority = DMA_Priority_VeryHigh;
	  DMA_InitStructure.DMA_M2M = DMA_M2M_Disable;
	  DMA_Init(DMA1_Channel4, &DMA_InitStructure);

	  /* USARTy RX DMA1 Channel (triggered by USARTy Rx event) Config */
	  DMA_DeInit(DMA1_Channel5);
	  DMA_InitStructure.DMA_PeripheralBaseAddr = (uint32_t)&(USART1->DR);
	  DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)RxBuffer;
	  DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralSRC;
	  DMA_InitStructure.DMA_BufferSize = 25;
	  DMA_Init(DMA1_Channel5, &DMA_InitStructure);

	USART_InitTypeDef USART_InitStructure;
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE); //Разрешаем тактирование

	USART_InitStructure.USART_BaudRate = 38400; // скорость
	USART_InitStructure.USART_WordLength = USART_WordLength_8b; //8 бит данных
	USART_InitStructure.USART_StopBits = USART_StopBits_1; //один стоп бит
	USART_InitStructure.USART_Parity = USART_Parity_No; //четность - нет
	USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None; // управлени потоком - нет
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx; // разрешаем прием и передачу

	USART_Init(USART1, &USART_InitStructure);



	/* Configure the GPIOs */
	GPIO_InitTypeDef GPIO_InitStructure;

	/* Configure USART1 Tx (PA.09) as alternate function push-pull */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	GPIO_Init(GPIOA, &GPIO_InitStructure);

	/* Configure USART1 Rx (PA.10) as input floating */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	GPIO_Init(GPIOA, &GPIO_InitStructure);

	  /* Enable USART1 */
	  USART_Cmd(USART1, ENABLE);
	  USART_DMACmd(USART1, USART_DMAReq_Rx | USART_DMAReq_Tx, ENABLE);
}

