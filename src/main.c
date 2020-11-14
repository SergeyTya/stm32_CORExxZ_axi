
#include "stdint.h"
#include "MCUinit.h"

/* Scheduler includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"


#include "usb_lib.h"
#include "usb_desc.h"
#include "hw_config.h"
#include "usb_pwr.h"
#include "usb_istr.h"

#include "mb.h"
#include "mbport.h"
#include "mbproto.h"


#include "Prjct_cnfg.h"

extern void vTask_IND    		(void *);
extern void vTask_AXI    		(void *);
extern void vTask_MBsend    	(void *);
extern void vTask_MBread    	(void *);
extern void vTask_Scope			(void *);
extern void vTask_1000ms		(void *);

uint16_t iREG[32];
uint16_t hREG[100];
uint16_t SCP[10]={0,0,0,0};



xTaskHandle xHandleS;
xTaskHandle xHandleR;
eMBErrorCode    eStatus;
xSCOPETypeDef         xSCOPE;
QueueHandle_t     xQueue = NULL;

uint16_t  * usRegHoldingBuf[REG_HOLDING_NREGS] = MODBUS_DATAHOLDING_DEFAULT;
uint16_t  * usRegInputRegBuf[REG_INPUT_NREGS ] = MODBUS_DATAINPUTREG_DEFAULT;

volatile int16_t test_int = 0;

void main()
{

	iREG[0]=14;
	iREG[1]=45;
	iREG[2]=0x0202;

	SCP[0]=1;

	xSCOPE.adr[0] = &(SCP[0]);
	xSCOPE.adr[1] = &(SCP[1]);
	xSCOPE.adr[2] = &(SCP[2]);
	xSCOPE.adr[3] = &(SCP[3]);

	usRegHoldingBuf[35]=&xSCOPE.ctrl;
	usRegHoldingBuf[37]=&xSCOPE.adrLoHi[0];
	usRegHoldingBuf[38]=&xSCOPE.adrLoHi[1];

	MCUinit();
	Set_USB();

	test_int = 555;

    eStatus = eMBInit(MB_RTU, 1, 0 , 115200, MB_PAR_NONE);
	eStatus = eMBSetSlaveID( 1, TRUE, "5550", 4);
	eStatus = eMBEnable();

	xQueue =  xQueueCreate(6, sizeof(uint32_t));
	vQueueAddToRegistry(xQueue, "scope");

	//xTaskCreate(vTask_IND			 , "vTask_IND", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 5,  NULL);
	//xTaskCreate(vTask_AXI			 , "vTask_AXI", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY +7,  NULL);
	xTaskCreate(vTask_1000ms	     , "vTask_1000ms", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY +15,  NULL);
	xTaskCreate(vTask_MBread		 , "vTask_MBread", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 10,  &xHandleR);
	xTaskCreate(vTask_Scope			 , "vTask_Scope", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1,  NULL);



	/* Start the scheduler. */
	vTaskStartScheduler();

}

void USB_LP_CAN1_RX0_IRQHandler(void)
{
  USB_Istr();
}
