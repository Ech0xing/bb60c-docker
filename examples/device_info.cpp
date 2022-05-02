#include <bb_api.h>

#include <cstdio>



int main(int argc, char **argv)
{
    bbStatus status;
    int handle = -1;
    int serials[8] = {0};
    int count = 0;

    printf("[*] API Version: %s\n", bbGetAPIVersion());

    bbGetSerialNumberList(serials, &count);
    if (count < 1)
    { 
        fprintf(stderr, "[!] no BB60 devices found\n");
        return -1;
    }

    printf("[*] attempting to open device with serial number %d\n", serials[0]);

    status = bbOpenDeviceBySerialNumber(&handle, serials[0]);

    if (status != bbNoError)
    {
        fprintf(stderr, "[!] unable to open device\n");
        fprintf(stderr, "%s\n", bbGetErrorString(status));
        return 0;
    }

    printf("[*] device opened successfully\n");

    printf("[*] device info:\n");
    
    int type = 0;
    bbGetDeviceType(handle, &type);
    if (type == BB_DEVICE_BB60A)
    {
        printf("    device type: BB60A\n");
    } else if (type == BB_DEVICE_BB60C)
    {
        printf("    device type: BB60C\n");    
    }
    else
    {
        fprintf(stderr, "[!] unknown device type: %d\n", type);
        return -1;
    }

    int firmware_ver = 0;
    bbGetFirmwareVersion(handle, &firmware_ver);
    printf("    firmware version: %d\n", firmware_ver);

    float temp, voltage, current;
    bbGetDeviceDiagnostics(handle, &temp, &voltage, &current);
    printf("    device internal temperature:    %f C\n", temp);
    printf("    device voltage:                 %f V\n", voltage);
    printf("    device current draw:            %f mA\n", current);

    bbCloseDevice(handle);

    return 0;
}
