/*
 * Tasks.c
 *
 *  Created on: 22 РјР°СЏ 2018 Рі.
 *      Author: Sergey Tyagushev
 */



#include "stdint.h"
#include "stdlib.h"

#include "mb.h"
#include "mbport.h"
#include "mbproto.h"
#include "Prjct_cnfg.h"





#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "semphr.h"


extern xQueueHandle xQueue;
extern xSCOPETypeDef         xSCOPE;
extern uint16_t * SCP;

void vTask_Scope(void *argument) {

	uint16_t frm_cnt = 0;
	uint16_t scp_cnt = 0;
	uint8_t chnum = 1;
	uint8_t delay = 1;

	//xSCOPE.adr[0] = &(SCP[0]);
	//xSCOPE.adr[1] = &(SCP[1]);
	//xSCOPE.adr[2] = &(SCP[2]);
	//xSCOPE.adr[3] = &(SCP[3]);

	while (1) {

		vTaskDelay(delay);
		uint16_t temp = xSCOPE.ctrl>>10;
		if (temp != 0)
			if (temp <5){
				xSCOPE.adr[temp - 1] = (uint16_t *) (  ( (uint32_t* ) xSCOPE.adrLoHi)[0] );
				xSCOPE.ctrl&=0x3FF;
			}

		for (uint8_t i = 0; i < chnum;) {
			xSCOPE.Send_buf[frm_cnt + scp_cnt] = ((uint8_t *) xSCOPE.adr[i])[1];
			scp_cnt++;
			xSCOPE.Send_buf[frm_cnt + scp_cnt] = ((uint8_t *) xSCOPE.adr[i++])[0];
			scp_cnt++;
		};

		if (scp_cnt >= (_mSCPFSZ - 0)) {
			xSCOPE.Send_buf[frm_cnt + scp_cnt] = delay;
			scp_cnt++;
			xSCOPE.Send_buf[frm_cnt + scp_cnt] = chnum;
			scp_cnt++;
			xSCOPE.Send_buf[frm_cnt + scp_cnt] = (uint8_t) (uxQueueMessagesWaiting(xQueue));
			scp_cnt = 0;
			chnum = (xSCOPE.ctrl & 0x3) + 1;
			delay = ((xSCOPE.ctrl >> 2) & 0xF) + 1;
				uint32_t temp_pntr = (uint32_t) &(xSCOPE.Send_buf[frm_cnt]);
				frm_cnt += (_mSCPFSZ + 3);
				if (frm_cnt >= (6 * (_mSCPFSZ + 3))) frm_cnt = 0;
				xQueueSendToBack(xQueue, &temp_pntr, ( TickType_t ) portMAX_DELAY);
		};


	}
}
/*-----------------------RTOS SERVICE FUNC-----------------------------------*/
void vApplicationIdleHook( void )
{

	    static int counter;
	    static int max_count;
	    static portTickType LastTick;
	    counter++;
	        if(xTaskGetTickCount() - LastTick>1000)
	        {
	            LastTick = xTaskGetTickCount();
	            if(counter > max_count) max_count = counter;
	           // Dev_Sens.MCULOAD = 100-(counter*100/max_count);
	            counter = 0;
	        }
}
void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName )
{
	( void ) pcTaskName;
	( void ) pxTask;

	taskDISABLE_INTERRUPTS();
	vMCUReset();
	for( ;; );
}

void vApplicationMallocFailedHook( void )
{
	taskDISABLE_INTERRUPTS();
	vMCUReset();
	for( ;; );
}

