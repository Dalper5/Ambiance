//
//  AmbiPlace.m
//  Locator
//
//  Created by Misha Gavronsky on 3/16/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import "AmbiPlace.h"

@implementation AmbiPlace

@synthesize name, reference, place_id, icon, rating, price_level, longitude, lattitude;

/*
 *	Finds an address component of a specific type inside the given address components array
 */
+ (NSString *)addressComponent:(NSString *)component inAddressArray:(NSArray *)array ofType:(NSString *)type{
	int index = [array indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop){
        return [(NSString *)([[obj objectForKey:@"types"] objectAtIndex:0]) isEqualToString:component];
	}];
    
	if(index == NSNotFound) return nil;
    
	return [[array objectAtIndex:index] valueForKey:type];
}

@end
