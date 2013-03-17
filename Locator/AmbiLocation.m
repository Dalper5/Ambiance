//
//  AmbiLocation.m
//  Locator
//
//  Created by Misha Gavronsky on 3/16/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import "AmbiLocation.h"

@implementation AmbiLocation

@synthesize country, currency, coordinate;

+ (NSString *) mapCountryToCurrency:(NSString *) countryCode {
    
    NSString   *language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    NSString *language_country = language;
    language_country = [language_country stringByAppendingString:@"_"];
    language_country =[language_country stringByAppendingString:countryCode];
    
    NSLocale *lcl = [[NSLocale alloc] initWithLocaleIdentifier:language_country];
    NSNumberFormatter *fmtr = [[NSNumberFormatter alloc] init];
    [fmtr setNumberStyle:NSNumberFormatterCurrencyStyle];
    [fmtr setLocale:lcl];
    
    NSLog( @"Currency Code:%@", [fmtr currencyCode] );
    NSLog( @"Currency Symbol:%@", [fmtr currencySymbol] );
    
    return [fmtr currencySymbol];
}

+ (NSString *) mapPriceToString:(NSInteger) price UsingCurrency:(NSString*) currency {
    NSString *result = @"";
    if (price <= 1 && price > 0) {
        result = [result stringByAppendingString:currency];
    }
    if (price <= 2 && price > 1) {
        result = [result stringByAppendingString:currency];
        result = [result stringByAppendingString:currency];
    }
    if (price <= 3 && price > 2) {
        result = [result stringByAppendingString:currency];
        result = [result stringByAppendingString:currency];
        result = [result stringByAppendingString:currency];
    }
    if (price <= 4 && price > 3) {
        result = [result stringByAppendingString:currency];
        result = [result stringByAppendingString:currency];
        result = [result stringByAppendingString:currency];
        result = [result stringByAppendingString:currency];
    }
    return result;
}

+ (NSString *) mapRatingToString:(double) rating {
    NSString *result = @"";
    if (rating <= 1. && rating > 0.) {
        result = [result stringByAppendingString:@"*"];
    }
    if (rating <= 2. && rating > 1.) {
        result = [result stringByAppendingString:@"**"];
    }
    if (rating <= 3. && rating > 2.) {
        result = [result stringByAppendingString:@"***"];
    }
    if (rating <= 4. && rating > 3.) {
        result = [result stringByAppendingString:@"****"];
    }
    return result;
}

-(void) set:(CLLocation *) location {
    coordinate = [location coordinate];
}

@end
