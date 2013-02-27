//
//  PTRTViewController.m
//  PushToRefreschTest
//
//  Created by Helmut Strey on 12/19/12.
//  Copyright (c) 2012 Helmut Strey. All rights reserved.
//

#import "BSCViewController.h"

@interface BSCViewController ()
@end

@implementation BSCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.ble.delegate=self;
    [self.ble connectPeripheral:[self.ble.peripherals objectAtIndex:self.path.row]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"ViewController will disappear");
    if (self.ble.activePeripheral)
        if(self.ble.activePeripheral.isConnected)
        {
            //send BLE shield "0" to turn off transmission
            UInt8 buf[1] = {0x30};
            
            NSData *data = [[NSData alloc] initWithBytes:buf length:1];
            [self.ble write:data];
            // after that cancel connection
            [[self.ble CM] cancelPeripheralConnection:[self.ble activePeripheral]];
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BLE delegate

- (void)bleDidDisconnect
{
    NSLog(@"->Disconnected VC");
}

// When RSSI is changed, this will be called
-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    
    self.rssiValue.text = rssi.stringValue;
}

// When disconnected, this will be called
-(void) bleDidConnect
{
    NSLog(@"->Connected VC");
    // send BLE shield "I" to turn on transmission
    UInt8 buf[1] = {0x49};
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [self.ble write:data];
}

// When data is comming, this will be called
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSLog(@"Length: %d", length);
    
    UInt16 Value;
    
    Value = data[length-1] | data[length-2] << 8;
    self.analogValue.text = [NSString stringWithFormat:@"%d", Value];
    self.packetSize.text = [NSString stringWithFormat:@"%d",length];
}

@end
