//
//  AmbiLocation.h
//  Locator
//
//  Created by Misha Gavronsky on 3/16/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AmbiLocation : NSObject {

NSString *country;
NSString *currency;

CLLocationCoordinate2D coordinate;

}

@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *currency;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

+ (NSString *) mapCountryToCurrency:(NSString *) country;
+ (NSString *) mapPriceToString:(NSInteger) price UsingCurrency:(NSString*) currency;
+ (NSString *) mapRatingToString:(double) rating;
- (void) set:(CLLocation *)location;

@end
