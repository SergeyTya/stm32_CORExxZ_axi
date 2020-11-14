/*
 *	Prjct_cnfg.h
 *
 *  Created on: 9.04.2019 г.
 *      Author: Sergey Tyagushev
 */


#ifndef   __PrjctcnfgH
#define __PrjctcnfgH


//
// MODBUS USER CONFIG
//

/*RS DATA CONFIG */
#define REG_HOLDING_START      1
#define REG_INPUT_START        1
#define REG_HOLDING_NREGS      51
#define REG_INPUT_NREGS        20

/* -----------------------MODBUS DATA HOLDING-----------------------------*/
#define MODBUS_DATAHOLDING_DEFAULT    {\
&hREG[0],\
&hREG[1],\
&hREG[2],\
&hREG[3],\
&hREG[4],\
&hREG[5],\
&hREG[6],\
&hREG[7],\
&hREG[8],\
&hREG[9],\
&hREG[10],\
&hREG[11],\
&hREG[12],\
&hREG[13],\
&hREG[14],\
&hREG[15],\
&hREG[16],\
&hREG[17],\
&hREG[18],\
&hREG[19],\
&hREG[20],\
&hREG[21],\
&hREG[22],\
&hREG[23],\
&hREG[24],\
&hREG[25],\
&hREG[26],\
&hREG[27],\
&hREG[28],\
&hREG[29],\
&hREG[30],\
&hREG[31],\
&hREG[32],\
&hREG[33],\
&hREG[34],\
&hREG[35],\
&hREG[36],\
&hREG[37],\
&hREG[38],\
&hREG[39],\
&hREG[40],\
&hREG[41],\
&hREG[42],\
&hREG[43],\
&hREG[44],\
&hREG[45],\
&hREG[46],\
&hREG[47],\
&hREG[48],\
&hREG[49],\
&hREG[50]\
}

/* -----------------------MODBUS DATA INPUT-----------------------------*/

#define MODBUS_DATAINPUTREG_DEFAULT   {\
&iREG[0],\
&iREG[1],\
&iREG[2],\
&SCP[0],\
&SCP[1],\
&SCP[2],\
&iREG[6],\
&iREG[7],\
&iREG[8],\
&iREG[9],\
&iREG[10],\
&iREG[11],\
&iREG[12],\
&iREG[13],\
&iREG[14],\
&iREG[15],\
&iREG[16],\
}


typedef struct { // Scope structure
	uint8_t  Send_buf[256*7];
	uint16_t ctrl;
	uint16_t adrLoHi[2];
	uint16_t * adr[4];
} xSCOPETypeDef;

#define _mSCPFSZ 240 // СЂР°Р·РјРµСЂ С„СЂРµР№РјР° РґР°РЅРЅС‹С… РѕСЃС†РёР»Р»РѕРіСЂР°С„Р°


#endif
