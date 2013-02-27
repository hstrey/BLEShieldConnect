//
//  PTRTViewController.h
//  PushToRefreschTest
//
//  Created by Helmut Strey on 12/19/12.
//  Copyright (c) 2012 Helmut Strey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface BSCViewController : UIViewController <BLEDelegate>
@property (weak, nonatomic) IBOutlet UILabel *rssiValue;
@property (weak, nonatomic) IBOutlet UILabel *analogValue;
@property (weak, nonatomic) IBOutlet UILabel *packetSize;
@property (strong, nonatomic) BLE *ble;
@property (strong,nonatomic) NSIndexPath *path;

@end
