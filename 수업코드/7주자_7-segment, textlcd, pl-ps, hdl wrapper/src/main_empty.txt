#include "xil_types.h"
#include "xparameters.h"
#include "xiicps.h"
#include "seven_seg.h"
#include "textlcd.h"


#define	IIC_SLAVE_ADDR	0x51
#define	IIC_SCLK_RATE	100000


void	WriteTLCDReg(char *pRegVal, int val);
int		ReadRTC(XIicPs Iic, u8 *SendBuffer, u8 *RecvBuffer);
//
/*
XPAR_SEVEN_SEG_0_S00_AXI_BASEADDR
#define SEVEN_SEG_S00_AXI_SLV_REG0_OFFSET 0
#define SEVEN_SEG_mReadReg()
#define SEVEN_SEG_mWriteReg()

#define XPAR_TEXTLCD_0_S00_AXI_BASEADDR
#define TEXTLCD_S00_AXI_SLV_REG0_OFFSET 0
#define TEXTLCD_S00_AXI_SLV_REG1_OFFSET 4

#define TEXTLCD_S00_AXI_SLV_REG2_OFFSET 8
#define TEXTLCD_S00_AXI_SLV_REG3_OFFSET 12

#define TEXTLCD_S00_AXI_SLV_REG4_OFFSET 16
#define TEXTLCD_S00_AXI_SLV_REG5_OFFSET 20

#define TEXTLCD_S00_AXI_SLV_REG6_OFFSET 24
#define TEXTLCD_S00_AXI_SLV_REG7_OFFSET 28

#define TEXTLCD_mWriteReg(BaseAddress, RegOffset, Data)
#define TEXTLCD_mReadReg(BaseAddress, RegOffset)
*/
int main(void)
{
	XIicPs	Iic;			/**< Instance of the IIC Device */
	int 	IicStatus;
	u8		*SendBuffer;	/**< Buffer for Transmitting Data 총 8bit*/
	u8		RecvBuffer[3];	/**< Buffer for Receiving Data   총 24bit*/

	int		SegReg;
	char	TlcdReg_upline[16];
	char	TlcdReg_downline[16];

	int		i;
	int		wait;


	sprintf(TlcdReg_upline, "Digital Clock   ");

	while(TRUE)
	{
		IicStatus = ReadRTC(Iic, SendBuffer, RecvBuffer);//무슨 객체값, 8bit, 24bit들어감
		//이건 32bit 정수값, peripheral 상태값인듯
		if (IicStatus != XST_SUCCESS)
		{
			return XST_FAILURE;
		}
		SegReg=(RecvBuffer[2] << 24) | (0b1010 << 20) | (RecvBuffer[1] << 12) | (0b1010 << 8) | RecvBuffer[0];
		SEVEN_SEG_mWriteReg(XPAR_SEVEN_SEG_0_S00_AXI_BASEADDR,SEVEN_SEG_S00_AXI_SLV_REG0_OFFSET,SegReg);

		// Coding here!
		//

		WriteTLCDReg(TlcdReg_downline, SegReg);
		for(i = 0; i < 4; i++)
		{
			TEXTLCD_mWriteReg(XPAR_TEXTLCD_0_S00_AXI_BASEADDR, TEXTLCD_S00_AXI_SLV_REG0_OFFSET+i, TlcdReg_upline[TEXTLCD_S00_AXI_SLV_REG0_OFFSET+i]);
			TEXTLCD_mWriteReg(XPAR_TEXTLCD_0_S00_AXI_BASEADDR, TEXTLCD_S00_AXI_SLV_REG1_OFFSET+i, TlcdReg_upline[TEXTLCD_S00_AXI_SLV_REG1_OFFSET+i]);
			TEXTLCD_mWriteReg(XPAR_TEXTLCD_0_S00_AXI_BASEADDR, TEXTLCD_S00_AXI_SLV_REG2_OFFSET+i, TlcdReg_upline[TEXTLCD_S00_AXI_SLV_REG2_OFFSET+i]);
			TEXTLCD_mWriteReg(XPAR_TEXTLCD_0_S00_AXI_BASEADDR, TEXTLCD_S00_AXI_SLV_REG3_OFFSET+i, TlcdReg_upline[TEXTLCD_S00_AXI_SLV_REG3_OFFSET+i]);

			TEXTLCD_mWriteReg(XPAR_TEXTLCD_0_S00_AXI_BASEADDR, TEXTLCD_S00_AXI_SLV_REG4_OFFSET+i, TlcdReg_downline[TEXTLCD_S00_AXI_SLV_REG4_OFFSET+i]);
			TEXTLCD_mWriteReg(XPAR_TEXTLCD_0_S00_AXI_BASEADDR, TEXTLCD_S00_AXI_SLV_REG5_OFFSET+i, TlcdReg_downline[TEXTLCD_S00_AXI_SLV_REG5_OFFSET+i]);
			TEXTLCD_mWriteReg(XPAR_TEXTLCD_0_S00_AXI_BASEADDR, TEXTLCD_S00_AXI_SLV_REG6_OFFSET+i, TlcdReg_downline[TEXTLCD_S00_AXI_SLV_REG6_OFFSET+i]);
			TEXTLCD_mWriteReg(XPAR_TEXTLCD_0_S00_AXI_BASEADDR, TEXTLCD_S00_AXI_SLV_REG7_OFFSET+i, TlcdReg_downline[TEXTLCD_S00_AXI_SLV_REG7_OFFSET+i]);
			// Coding here!
			//

		}

		for(wait = 0; wait < 1200; wait++);
	}
}

void WriteTLCDReg(char *pRegVal, int val) //pRegVal은 16Byte의 배열
{
	int		i = 0;
	char	temp;

	for(i = 0; i < 8; i++)
	{
		temp=((u8)(val>>(28-i)) & 0x0F)|0x30;
		// Coding here!
		pRegVal[i] = temp;
		pRegVal[i+8] = 0x20;
	}
}

int ReadRTC(XIicPs Iic, u8 *SendBuffer, u8 *RecvBuffer)
{
	int				Status;
	XIicPs_Config	*Config;

	Config = XIicPs_LookupConfig(XPAR_XIICPS_0_DEVICE_ID);
	if (Config == NULL)
	{
		return XST_FAILURE;
	}

	Status = XIicPs_CfgInitialize(&Iic, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	XIicPs_SetSClk(&Iic, IIC_SCLK_RATE);

	*SendBuffer		= 0x02;
	RecvBuffer[0]	= 0x00;
	RecvBuffer[1]	= 0x00;
	RecvBuffer[2]	= 0x00;

	Status = XIicPs_MasterSendPolled(&Iic, SendBuffer, 1, IIC_SLAVE_ADDR);
	if(Status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	while(XIicPs_BusIsBusy(&Iic))
	{
		/* NOP */
	}

	Status = XIicPs_MasterRecvPolled(&Iic, RecvBuffer, 3, IIC_SLAVE_ADDR);
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}
