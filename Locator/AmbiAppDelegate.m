//
//  AmbiAppDelegate.m
//  Locator
//
//  Created by Misha Gavronsky on 3/10/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import "AmbiAppDelegate.h"
#import "AmbiPlace.h"

@implementation AmbiAppDelegate

@synthesize locationManager=_locationManager;
@synthesize places=_places;
@synthesize current_location=_current_location;
@synthesize current_place = _current_place;


#pragma mark - CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        //Location timestamp is within the last 15.0 seconds, let's use it!
        if(newLocation.horizontalAccuracy<35.0){
            //Location seems pretty accurate, let's use it!
            NSLog(@"latitude %+.6f, longitude %+.6f\n",
                  newLocation.coordinate.latitude,
                  newLocation.coordinate.longitude);
            NSLog(@"Horizontal Accuracy:%f", newLocation.horizontalAccuracy);

 
            NSString *lat = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
            NSString *longt = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
            //NSString *gKey = @"AIzaSyC3G9bERz7ktJkqxvnnRx_Sb9ld8jKQErk";
            //NSString *radius = @"100";
            //NSString *pipe = @"|";
            //NSString *e_pipe = [pipe stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSString *type =@"restaurant";
            //type = [type stringByAppendingString:e_pipe];
            //type = [type stringByAppendingString:@"bar"];
            NSString *placeString  = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true",lat,longt];
            NSLog(@"request string: %@",placeString);
            
            NSURL *placeURL = [NSURL URLWithString:placeString];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:placeURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
            [request setHTTPMethod:@"GET"];
            NSURLResponse* response;
            NSError* error = nil;
            
            //Capturing server response
            NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response       error:&error];
            NSError *myError = nil;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&myError];
            
                
            NSArray *firstResultAddress = [[[res objectForKey:@"results"] objectAtIndex:0] objectForKey:@"address_components"];
            
    
            NSString *countryName = [AmbiPlace addressComponent:@"country" inAddressArray:firstResultAddress ofType:@"short_name"];
            NSString *currencySymbol = [AmbiLocation mapCountryToCurrency:countryName];
  
            NSLog(@"CurrencyCode: %@", countryName);
            NSLog(@"Country Code: %@", currencySymbol);
            
            AmbiLocation *location = [[AmbiLocation alloc] init];
            location.country = [[NSString alloc] initWithString:countryName];
            location.currency = [[NSString alloc] initWithString:currencySymbol];
            //Record location and figure out currency code
            [location set:newLocation];
            self.current_location = location;
            
            //Optional: turn off location services once we've gotten a good location
            //[manager stopUpdatingLocation];
            
        }
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[self.window makeKeyAndVisible];
    
    //If object has not been created, create it.
    if(self.locationManager==nil){
        _locationManager=[[CLLocationManager alloc] init];
        //I'm using ARC with this project so no need to release
        
        _locationManager.delegate=self;
        
        //Included in the prompt to use location services
        _locationManager.purpose = @"We will try to tell you where you are if you get lost";
        
        
        //The desired accuracy that you want, not guaranteed though
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        
        //The distance in meters a device must move before an update event is triggered
        _locationManager.distanceFilter=50;
        self.locationManager=_locationManager;
    }
    
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
        [self.current_location init];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.locationManager stopUpdatingLocation];
    [self.places removeAllObjects];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
