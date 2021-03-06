//
//  ViewController.h
//  Places@SST
//
//  Created by Pan Ziyue on 20/9/14.
//  Copyright (c) 2014 StatiX Industries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, CBCentralManagerDelegate>
{
    //BOOL iPadIsUsed;
}

// Managers
@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CBCentralManager *bluetoothManager;
@property CLProximity lastProximity;
@property short beaconDisconnectInteger;

// UI Elements
@property (weak, nonatomic) IBOutlet UILabel *inferredLocation;
@property (weak, nonatomic) IBOutlet UITextView *inferredInfo;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIImageView *signalIndicator;
@property NSString *lastUsedImage;

// UI Elements for DEBUGGING ONLY
@property (weak, nonatomic) IBOutlet UILabel *rawRSSI;
@property (weak, nonatomic) IBOutlet UILabel *beaconDisconnectThreshold;
@property (weak, nonatomic) IBOutlet UILabel *rawConnectivity;

// External available variable
@property BOOL iPadIsUsed;

-(UIImage *)applySignal:(short)imageId;

@end
