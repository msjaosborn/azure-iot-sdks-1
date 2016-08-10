//
//  ViewController.m
//  TestIoTHub
//
//  Created by James Osborne on 2/25/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import "ViewController.h"

#include "iothub_client.h"
#include "iothubtransporthttp.h"
#include "iothubtransportamqp.h"
#include "iothubtransportmqtt.h"
#include "iothubtransportamqp_websockets.h"
#include "certs.h"

@interface ViewController ()

@end

static int callbackCounter;

static void SendConfirmationCallback(IOTHUB_CLIENT_CONFIRMATION_RESULT result, void* userContextCallback)
{
 //   EVENT_INSTANCE* eventInstance = (EVENT_INSTANCE*)userContextCallback;
//    (void)printf("Confirmation[%d] received for message tracking id = %d with result = %s\r\n", callbackCounter, eventInstance->messageTrackingId, ENUM_TO_STRING(IOTHUB_CLIENT_CONFIRMATION_RESULT, result));
    /* Some device specific action code goes here... */
    callbackCounter++;
//    IoTHubMessage_Destroy(eventInstance->messageHandle);
}

static char msgText[1024];
static char propText[1024];
#define MESSAGE_COUNT 5


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

 //   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 //       [self getResultSetFromDB:docids];
 //   });
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doIt
{
    UIAlertView *helloWorldAlert = [[UIAlertView alloc]
                                    initWithTitle:@"My First App" message:@"Hello, World!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [helloWorldAlert show];
    
    IOTHUB_CLIENT_CONFIG config;
//    config.protocol = HTTP_Protocol;
    config.protocol = MQTT_Protocol;
//    config.protocol = AMQP_Protocol;
//    config.protocol = AMQP_Protocol_over_WebSocketsTls;
    config.deviceId = "new-device";
    config.deviceKey = "hYTrPIrJehaqDg2hDbE4KpfdxXTf6C6jIOMo2aJNdDA=";
    config.iotHubName = "JOHub1";
    config.iotHubSuffix = "azure-devices.net";
    config.deviceSasToken = nil;
    
    IOTHUB_CLIENT_HANDLE h = IoTHubClient_Create(&config);
    if ( h == NULL )
    {
        NSLog(@"Failed to create client");
    }
    else
    {
        // For mbed add the certificate information
        if (IoTHubClient_SetOption(h, "TrustedCerts", certificates) != IOTHUB_CLIENT_OK)
        {
            printf("failure to set option \"TrustedCerts\"\r\n");
        }

        char foo[1024];
        sprintf(foo, "iPhone says '%d'", callbackCounter);
        IOTHUB_MESSAGE_HANDLE msgHandle = IoTHubMessage_CreateFromString(foo);
        
        if (IoTHubClient_SendEventAsync(h, msgHandle, SendConfirmationCallback, NULL) != IOTHUB_CLIENT_OK)
        {
            NSLog(@"ERROR: IoTHubClient_SendEventAsync..........FAILED!");
        }
        else
        {
            NSLog(@"IoTHubClient_LL_SendEventAsync accepted message [] for transmission to IoT Hub.");
        }
    }
    
}
@end

