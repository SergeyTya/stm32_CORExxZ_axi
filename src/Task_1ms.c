/*
 * Task_1ms.c
 *
 *  Created on: 5 июн. 2019 г.
 *      Author: Sergey Tyagushev
 */

/* Scheduler includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"


#include "stm32f10x_gpio.h"
#include "stm32f10x_i2c.h"

#include "stm32_tm1637.h"
#include "IQmathLIB.h"

volatile int32_t AXI[3];
volatile int32_t AXI_RMS[3];


void _DMA_Config(uint8_t* buffer){
	  DMA_InitTypeDef DMA_InitStructure;

	  RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA1, ENABLE);

	  /* Initialize the DMA_PeripheralBaseAddr member */
	  DMA_InitStructure.DMA_PeripheralBaseAddr =  (uint32_t) (&(I2C1->DR));
	  /* Initialize the DMA_MemoryBaseAddr member */
	  DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)buffer;
	   /* Initialize the DMA_PeripheralInc member */
	  DMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
	  /* Initialize the DMA_MemoryInc member */
	  DMA_InitStructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
	  /* Initialize the DMA_PeripheralDataSize member */
	  DMA_InitStructure.DMA_PeripheralDataSize = DMA_PeripheralDataSize_Byte;
	  /* Initialize the DMA_MemoryDataSize member */
	  DMA_InitStructure.DMA_MemoryDataSize = DMA_MemoryDataSize_Byte;
	  /* Initialize the DMA_Mode member */
	  DMA_InitStructure.DMA_Mode = DMA_Mode_Normal;
	  /* Initialize the DMA_Priority member */
	  DMA_InitStructure.DMA_Priority = DMA_Priority_VeryHigh;
	  /* Initialize the DMA_M2M member */
	  DMA_InitStructure.DMA_M2M = DMA_M2M_Disable;

	  /* Initialize the DMA_DIR member */
	  DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralSRC;

	  /* Initialize the DMA_BufferSize member */
	  DMA_InitStructure.DMA_BufferSize = 6;
	  DMA_DeInit(DMA1_Channel7);
	  DMA_Init(DMA1_Channel7, &DMA_InitStructure);
}

void vTask_IND(void *argument)
{
	int32_t INDI_OUT;
	tm1637Init();

    while (1) {

      	INDI_OUT =  _IQtoF(AXI_RMS[2])*100;
    	tm1637DisplayDecimal(INDI_OUT, 1);

    	vTaskDelay(250);

    }

}


static void I2C_StartTransmission(I2C_TypeDef* I2Cx, uint8_t transmissionDirection,  uint8_t slaveAddress)
{

  //  while(I2C_GetFlagStatus(I2Cx, I2C_FLAG_BUSY));

    I2C_GenerateSTART(I2Cx, ENABLE);

    while(!I2C_CheckEvent(I2Cx, I2C_EVENT_MASTER_MODE_SELECT));


    I2C_Send7bitAddress(I2Cx, slaveAddress<<1, transmissionDirection);

    // А теперь у нас два варианта развития событий - в зависимости от выбранного направления обмена данными
    if(transmissionDirection== I2C_Direction_Transmitter)
    {
    	while(!I2C_CheckEvent(I2Cx, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
    }

    if(transmissionDirection== I2C_Direction_Receiver)
    {
	while(!I2C_CheckEvent(I2Cx, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED));
    }
}


static void I2C_WriteData(I2C_TypeDef* I2Cx, uint8_t data)
{
    // Просто вызываем готоваую функцию из SPL и ждем, пока данные улетят
    I2C_SendData(I2Cx, data);
    while(!I2C_CheckEvent(I2Cx, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
}



/*******************************************************************/
static uint8_t I2C_ReadData(I2C_TypeDef* I2Cx)
{
    uint8_t data;
    // Тут картина похожа, как только данные пришли быстренько считываем их и возвращаем
    while( !I2C_CheckEvent(I2Cx, I2C_EVENT_MASTER_BYTE_RECEIVED) );
    data = I2C_ReceiveData(I2Cx);
    return data;
}



extern uint16_t SCP[10];
uint8_t res[10];

void vTask_AXI(void *argument)
{


	uint8_t slaveAddress= 0x53;
	I2C_StartTransmission(I2C1, I2C_Direction_Transmitter,slaveAddress);
	I2C_WriteData(I2C1,0x2d);
	I2C_WriteData(I2C1,0x08);
	I2C_GenerateSTOP(I2C1, ENABLE);
	I2C_StartTransmission(I2C1, I2C_Direction_Transmitter,slaveAddress);
	I2C_WriteData(I2C1,0x31);
	//I2C_WriteData(I2C1,0x0D);
	I2C_WriteData(I2C1,0x03);
	I2C_GenerateSTOP(I2C1, ENABLE);
	I2C_StartTransmission(I2C1, I2C_Direction_Transmitter,slaveAddress);
	I2C_WriteData(I2C1,0x2C);
	I2C_WriteData(I2C1,0x0F);
	I2C_GenerateSTOP(I2C1, ENABLE);
	NVIC_EnableIRQ(DMA1_Channel7_IRQn);

    while (1) {
/*DMA I2C*/
    	_DMA_Config(res) ;
    	I2C_DMACmd(I2C1,ENABLE);
        DMA_Cmd(DMA1_Channel7, ENABLE);
        I2C_DMALastTransferCmd(I2C1, ENABLE);
        DMA_ITConfig(DMA1_Channel7, DMA_IT_TC, ENABLE);

    	I2C_StartTransmission(I2C1, I2C_Direction_Transmitter,slaveAddress);
    	I2C_Cmd(I2C1, ENABLE);
    	I2C_WriteData(I2C1,0x32);
    	I2C_StartTransmission(I2C1, I2C_Direction_Receiver,slaveAddress);


/* Poling I2C
    	__disable_irq();
    	I2C_StartTransmission(I2C1, I2C_Direction_Transmitter,slaveAddress);
    	I2C_Cmd(I2C1, ENABLE);
    	I2C_WriteData(I2C1,0x32);
    	I2C_StartTransmission(I2C1, I2C_Direction_Receiver,slaveAddress);
    	I2C_AcknowledgeConfig(I2C1, ENABLE);

    	uint8_t i=0; for(i=0;i<6;i++)res[i]=I2C_ReadData(I2C1);
    	I2C_AcknowledgeConfig(I2C1, DISABLE);
    	I2C_GenerateSTOP(I2C1, ENABLE);

    	__enable_irq();

        for(i=0;i<3;i++){
        //	AXI[i]=((int16_t *) res)[i];
        	AXI[i]=_IQmpy( _IQ( ((int16_t *) res)[i] ), _IQ( (float) (0.03125) ) );
        	AXI_RMS[i]+=_IQmpy( (_IQabs(AXI[i])-AXI_RMS[i]), _IQ( (0.001*100) ) );
        	SCP[i]=(AXI[i]*100)>>16;
        	//SCP[i]=AXI[i];
        }


*/

      vTaskDelay(1);
    }

}

void DMA1_Channel7_IRQHandler(void)
{
  /* Test on DMA1 Channel6 Transfer Complete interrupt */
  if(DMA_GetITStatus(DMA1_IT_TC7))
  {
    /* Get Current Data Counter value after complete transfer */

	  I2C_GenerateSTOP(I2C1, ENABLE);
	  DMA_Cmd(DMA1_Channel7, DISABLE);
	  I2C_DMACmd(I2C1,DISABLE);
	  DMA_ClearFlag(DMA1_FLAG_TC7);

	  uint8_t i=0; for(i=0;i<3;i++){
	         	AXI[i]=_IQmpy( _IQ( ((int16_t *) res)[i] ), _IQ( (float) (0.03125) ) );
	         	AXI_RMS[i]+=_IQmpy( (_IQabs(AXI[i])-AXI_RMS[i]), _IQ( (0.001*100) ) );
	         	SCP[i]=(AXI[i]*100)>>16;
	  }

    /* Clear DMA1 Channel6 Half Transfer, Transfer Complete and Global interrupt pending bits */
    DMA_ClearITPendingBit(DMA1_IT_GL7);
  }
}

