//
//  PlacesKit.h
//  Places@SST
//
//  Created by Pan Ziyue on 26/5/15.
//  Copyright (c) 2015 StatiX Industries. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PlacesKit : NSObject

// iOS Controls Customization Outlets
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* half_iPadTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* fullTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* halfTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* low_iPadTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* none_iPadTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* noneTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* lowTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* full_iPadTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* calendar_IconTargets;

// Generated Images
+ (UIImage*)imageOfHalf_iPad;
+ (UIImage*)imageOfFull;
+ (UIImage*)imageOfHalf;
+ (UIImage*)imageOfLow_iPad;
+ (UIImage*)imageOfNone_iPad;
+ (UIImage*)imageOfNone;
+ (UIImage*)imageOfLow;
+ (UIImage*)imageOfFull_iPad;
+ (UIImage*)imageOfCalendar_Icon;

@end
