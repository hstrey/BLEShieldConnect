//
//  PTRTTableViewController.m
//  PushToRefreschTest
//
//  Created by Helmut Strey on 12/23/12.
//  Copyright (c) 2012 Helmut Strey. All rights reserved.
//

#import "BSCTableViewController.h"
#import "BSCViewController.h"

@interface BSCTableViewController ()

@end

@implementation BSCTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Inside a Table View Controller's viewDidLoad method
    [self.refreshControl addTarget:self
                         action:@selector(refreshView:)
                         forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    self.ble = [[BLE alloc] init];
    [self.ble controlSetup:1];
    self.ble.delegate = self;
    self.title=@"BLE Shields available";
}

-(void)viewWillAppear:(BOOL)animated
{
    //reconnect delegate when coming back to table view
    self.ble.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.ble.peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bluetooth Device Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //get ble.peripheral at row and extract uuid and name
    CBPeripheral *p = [self.ble.peripherals objectAtIndex:[indexPath row]];
    const char* uuidString = [self.ble UUIDToString:p.UUID];
    const char* nameString = [p.name cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    cell.textLabel.text=[NSString stringWithCString:uuidString encoding:NSUTF8StringEncoding];
    cell.detailTextLabel.text=[NSString stringWithCString:nameString encoding:NSUTF8StringEncoding];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - refreshView

-(void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Looking for Bluetooth LE devices..."];
    // custom refresh logic would be placed here...
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                            [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    if (self.ble.activePeripheral)
        if(self.ble.activePeripheral.isConnected)
        {
            [[self.ble CM] cancelPeripheralConnection:[self.ble activePeripheral]];
            return;
        }
    
    if (self.ble.peripherals)
        self.ble.peripherals = nil;
    
    [self.ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

-(void) connectionTimer:(NSTimer *)timer
{
    // turn off refreshing
    [self.refreshControl endRefreshing];
    // update table view in case bluetooth devices were found
    [self.tableView reloadData];
}

#pragma mark - BLE delegate

- (void)bleDidDisconnect
{
    NSLog(@"->Disconnected TVC");
}

// When RSSI is changed, this will be called
-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
 //   NSLog(@)rssi.stringValue;
}

// When disconnected, this will be called
-(void) bleDidConnect
{
    NSLog(@"->Connected TVC");
    
//    UInt8 buf[1] = {0xA0};
    
//    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
//    [ble write:data];
}

// When data is comming, this will be called
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSLog(@"Length: %d", length);
    
//    UInt16 Value;
    
//    Value = data[length-1] | data[length-2] << 8;
//    lblAnalogIn.text = [NSString stringWithFormat:@"%d", Value];
}

#pragma mark - seques

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Bluetooth Data"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        BSCViewController *s = segue.destinationViewController;
        s.ble=self.ble;
        s.path=path;
    }
}

@end
