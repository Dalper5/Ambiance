//
//  AmbiPlace.h
//  Locator
//
//  Created by Misha Gavronsky on 3/16/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AmbiPlace : NSObject {

    NSString *name;
    NSString *reference;
    NSString *rating;
    NSString *price_level;
    NSString *icon;
    NSString *place_id;
    NSString *longitude;
    NSString *lattitude;
}

+ (NSString *)addressComponent:(NSString *)component inAddressArray:(NSArray *)array ofType:(NSString *)type;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *reference;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *place_id;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *price_level;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *lattitude;


@end
