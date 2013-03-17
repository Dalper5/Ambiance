//
//  AmbiAppDelegate.h
//  Locator
//
//  Created by Misha Gavronsky on 3/10/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmbiLocation.h"
#import "AmbiPlaceDetails.h"

//Add Location Framework
#import <CoreLocation/CoreLocation.h>

@interface AmbiAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

//Add a location manager property to this app delegate
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) AmbiLocation *current_location;
@property (strong, nonatomic) AmbiPlaceDetails *current_place;

@end
