//
//  AmbiPlaceDetails.h
//  Locator
//
//  Created by Misha Gavronsky on 3/16/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmbiPlaceDetails : NSObject {

    NSString *name;
    NSString *url;
    NSString *website;
    NSString *address;
    NSString *rating;
    NSString *price_level;
    NSString *phone;
    NSString *icon;
    NSString *place_id;
    NSMutableArray *reviews;
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *price_level;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *place_id;
@property (nonatomic, strong) NSMutableArray *reviews;


@end
