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
#import <EstimoteSDK/EstimoteSDK.h>

@interface ViewController : UIViewController <CBCentralManagerDelegate, ESTBeaconManagerDelegate>

// Managers
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) ESTBeaconManager *locationManager;
@property (strong, nonatomic) CBCentralManager *bluetoothManager;
//@property CLProximity lastProximity;

// UI Elements
@property (weak, nonatomic) IBOutlet UILabel *inferredLocation;
@property (weak, nonatomic) IBOutlet UITextView *inferredInfo;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIImageView *signalIndicator;
@property NSString *lastUsedImage;

@end
