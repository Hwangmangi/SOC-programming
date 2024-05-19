#include "stdio.h"
#include "stdlib.h"
#include "platform.h"
#include "sleep.h"
#include "xparameters.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "xil_io.h"
#include "xsdps.h"
#include "ff.h"
#include "PmodGPS.h"

#define PERIPHERAL_CLK 100000000	// CLK definition for the GPS

void GPS_Initialize ();
void Get_GPS (char GPS_data[]);

PmodGPS GPS;

/************ SD card parameters ************/
static FATFS FS_instance;			// File System instance
static FIL file1;					// File instance
FRESULT result;						// FRESULT variable
char FileName[32];					// File name
static char *Log_File; 				// pointer to the log
static const char *Path = "0:/";	//  string pointer to the logical drive number
unsigned int BytesWr;				// Bytes written
int j = 0;							// file name index
/************ SD card parameters ************/

uint gpssize = 0;
char GPS_data[] = "<GPS did not get a ping...>";

int main()
{
    init_platform();

	GPS_Initialize ();

	result = f_mount(&FS_instance,Path, 1);

	for (int j = 0; j < 100; j++)
	{
	    sprintf(FileName, "File_%d.TXT",j);
		Log_File = (char *)FileName;
		result = f_open(&file1, Log_File, FA_CREATE_ALWAYS | FA_WRITE );

		Get_GPS(GPS_data);
		gpssize = strlen(GPS_data);
		result = f_write(&file1, (const void*)GPS_data, gpssize, &BytesWr);
		xil_printf("GPS data = %s\n\r", GPS_data);

	    result = f_close(&file1);
	    sleep(3);
	}

    cleanup_platform();
    return 0;
}

void GPS_Initialize () {
   GPS_begin(&GPS, XPAR_PMODGPS_0_AXI_LITE_GPIO_BASEADDR, XPAR_PMODGPS_0_AXI_LITE_UART_BASEADDR, PERIPHERAL_CLK);
   GPS_setUpdateRate(&GPS, 1000);
   xil_printf("GPS is Initialized.\n\r");
}

void Get_GPS (char GPS_data[]){
	GPS_getSentence(&GPS, GPS_data);
}

