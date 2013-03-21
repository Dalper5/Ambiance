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
    if (rating <= 5. && rating > 4.) {
        result = [result stringByAppendingString:@"*****"];
    }

    return result;
}

+ (UIImage *) mapRatingToImage:(double) rating {
 
    UIImage *img = [[UIImage alloc] init];

    if (rating <= 1. && rating > 0.) {
        img = [UIImage imageNamed:@"star_1.png"];
    }
    if (rating <= 1.5 && rating > 1.) {
        img = [UIImage imageNamed:@"star_1_5.png"];
    }
    if (rating <= 2. && rating > 1.5) {
        img = [UIImage imageNamed:@"star_2.png"];
    }
    if (rating <= 2.5 && rating > 1.5) {
        img = [UIImage imageNamed:@"star_2_5.png"];
    }
    if (rating <= 3. && rating > 2.5) {
        img = [UIImage imageNamed:@"star_3.png"];
    }
    if (rating <= 3.5 && rating > 3.) {
        img = [UIImage imageNamed:@"star_3_5.png"];
    }
    if (rating <= 4. && rating > 3.5) {
        img = [UIImage imageNamed:@"star_4.png"];
    }
    if (rating <= 4.5 && rating > 4.) {
        img = [UIImage imageNamed:@"star_4_5.png"];
    }
    if (rating <= 5. && rating > 4.5) {
        img = [UIImage imageNamed:@"star_5.png"];
    }
    return img;
}

-(void) set:(CLLocation *) location {
    coordinate = [location coordinate];
}

@end
