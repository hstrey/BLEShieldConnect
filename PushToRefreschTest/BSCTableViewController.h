//
//  PTRTTableViewController.h
//  PushToRefreschTest
//
//  Created by Helmut Strey on 12/23/12.
//  Copyright (c) 2012 Helmut Strey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface BSCTableViewController : UITableViewController <BLEDelegate>

@property (strong, nonatomic) BLE *ble;

@end
