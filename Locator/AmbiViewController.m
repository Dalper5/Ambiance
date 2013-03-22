//
//  AmbiViewController.m
//  Locator
//
//  Created by Misha Gavronsky on 3/10/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import "AmbiViewController.h"
#import "AmbiAppDelegate.h"
#import "AmbiPlace.h"
#import "AmbiTableViewCell.h"

#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#include "AFImageRequestOperation.h"

@interface AmbiViewController ()

@end

@implementation AmbiViewController

//@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.myButton.frame = CGRectMake(110.0f,429.0f,80.0f,27.0f);
    [self.myButton setTitle:@"Find" forState:UIControlStateNormal];
    [self.myButton addTarget:self action:@selector(buttonIspressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect size =  CGRectMake(1.0f, 33.0f, 318.0f, 387.0f);
    self.myTableView = [[UITableView alloc] initWithFrame:size style:UITableViewStylePlain];
    //self.myTableView.frame = CGRectMake(10.0, 32.0, 298.0, 445.0);
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.key = @"AIzaSyC3G9bERz7ktJkqxvnnRx_Sb9ld8jKQErk";
    self.row_height = @"80";
    self.search_radius = @"100";
    NSString *pipe = @"|";
    NSString *e_pipe = [pipe stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *type =@"restaurant";
    type = [type stringByAppendingString:e_pipe];
    type = [type stringByAppendingString:@"bar"];
    type = [type stringByAppendingString:e_pipe];
    type = [type stringByAppendingString:@"cafe"];
    self.search_entity = type;
    
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.myButton];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger result = 0;
    if ([tableView isEqual:self.myTableView]) {
        result = 1;
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger result = 0;
    AmbiAppDelegate *appDelegate=(AmbiAppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.places != nil) {
        result = [appDelegate.places count];
    }
    
    return result;
}

- (AmbiTableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AmbiTableViewCell *result = nil;
    
    AmbiAppDelegate *appDelegate=(AmbiAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([tableView isEqual:self.myTableView]) {
        static NSString *TableViewCellIdentifier = @"MyCells";
        result = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
        
        if (result == nil){
            result = [[AmbiTableViewCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:TableViewCellIdentifier rowHeight:self.row_height];
            result.accessoryType = UITableViewCellAccessoryNone;
            result.row_height = self.row_height;
        }
        
        //result.textLabel.text = [NSString stringWithFormat:@"Section %ld, Cell %ld",
        //                         (long)indexPath.section,(long)indexPath.row];
        if ([appDelegate.places count] > 0) {
            AmbiPlace *place = [appDelegate.places objectAtIndex:(long)indexPath.row];
            NSString *row_text = @"";
            NSString *row_text_details = @"";
            NSString *price_level = @"";
            NSString *rating = @"";
            NSString *icon = @"";
            NSString *currency = appDelegate.current_location.currency;
            NSString *row_index = [NSString stringWithFormat:@"%d. ", indexPath.row+1];
            row_text = [row_text stringByAppendingString:row_index];
            row_text = [row_text stringByAppendingString:place.name];
            price_level = [AmbiLocation mapPriceToString:[place.price_level integerValue] UsingCurrency:currency];
            rating = [AmbiLocation mapRatingToString:[place.rating doubleValue]];
            UIImage *rating_img = [AmbiLocation mapRatingToImage:[place.rating doubleValue]];
            icon = place.icon;
            if ([icon rangeOfString:@"bar"].location != NSNotFound) {
                icon = @"bar.png";
            } else if ([icon rangeOfString:@"cafe"].location != NSNotFound) {
                icon = @"cafe.png";
            } else if ([icon rangeOfString:@"restaurant"].location != NSNotFound) {
                icon = @"restaurant.png";
            }
            else {
                icon = @"establishment.png";
            }
            result.photoView.image = [[UIImage alloc] init];
            UIImage *icon_img = [[UIImage alloc] init];
            icon_img = [UIImage imageNamed:icon];
            //row_text_details = [row_text_details stringByAppendingString:price_level];
            //row_text_details = [row_text_details stringByAppendingString:@"  "];
            //row_text_details = [row_text_details stringByAppendingString:rating];
            
            // download the photo
            if ([place.reference_photo length] != 0) {
                NSString *gKey = self.key;
                NSString *height = self.row_height;
                NSString *placeString  = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%@&photoreference=%@&sensor=false&key=%@",height,place.reference_photo,gKey];
                NSLog(@"request string: %@",placeString);
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:placeString]];
                AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
                
                
                // MyManagedObject has a custom setters (setPhoto:,setThumb:) that save the
                // images to disk and store the file path in the database
                    result.photoView.image = image;
                }];
                [operation start];
            }
            
            result.ratingView.image = rating_img;
            result.priceLabel.text = price_level;
            result.iconView.image = icon_img;
            result.nameLabel.text = row_text;
            //result.detailTextLabel.text = row_text_details;
            //[result.imageView setImage:imgView.image];
            //[result addSubview:imgView];
        }
    }
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if ([tableView isEqual:self.myTableView]) {
        //NSLog(@"%@", [NSString stringWithFormat:@"Cell %ld in Section %ld is selected", (long)indexPath.row, (long)indexPath.section]);
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1];        
        AmbiAppDelegate *appDelegate=(AmbiAppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *gKey = self.key;
        AmbiPlace *place = [appDelegate.places objectAtIndex:indexPath.row];
        NSString *reference = place.reference;

        NSString *placeString  = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=false&key=%@",reference,gKey];
        NSLog(@"request string: %@",placeString);
        
        NSURL *placeURL = [NSURL URLWithString:placeString];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:placeURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
        [request setHTTPMethod:@"GET"];
        NSURLResponse* response;
        NSError* error = nil;
        
        //Capturing server response
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response       error:&error];
        
        //if (error != nil) {
        //NSLog(@"connectionDidFinishLoading");
        
        // convert to JSON
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&myError];
        
        NSString *place_address = @"";
        NSString *place_phone = @"";
        NSMutableArray *place_reviews = [[NSMutableArray alloc] init];
        NSString *place_rating = @"";
        NSString *place_iconURL = @"";
        NSString *place_URL =@"";
        NSString *place_website = @"";
        NSString *place_pricelevel = @"";
        NSString *place_ref_photo = @"";
        
        for(NSDictionary *result in [res objectForKey:@"results"])
        {
            //NSDictionary *location = [[result objectForKey:@"geometry"] objectForKey:@"location"];
            place_address = [result objectForKey:@"formatted_address"];
            place_phone = [result objectForKey:@"international_phone_number"];
            place_rating = [result objectForKey:@"rating"];
            place_pricelevel = [result objectForKey:@"price_level"];
            place_iconURL = [result objectForKey:@"icon"];
            place_URL = [result objectForKey:@"url"];
            place_website = [result objectForKey:@"website"];
            
            for (NSDictionary *reviews in [result objectForKey:@"reviews"]) {
                NSString *review_text = [reviews objectForKey:@"text"];
                [place_reviews addObject:review_text];
            }

            for (NSDictionary *photo in [result objectForKey:@"photos"]) {
                place_ref_photo = [photo objectForKey:@"photo_reference"];
                break;
            }

        }


        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.row_height integerValue];
}


//- (IBAction)Locate:(UIButton*)sender {
- (void) buttonIspressed:(UIButton*)paramSender{
    NSLog(@"Current Location is \n");
    
    AmbiAppDelegate *appDelegate=(AmbiAppDelegate *)[UIApplication sharedApplication].delegate;
    CLLocation *currentLocation=appDelegate.locationManager.location;
    
    NSLog([NSString stringWithFormat:@"\nlatitude: %+.6f\nlongitude: %+.6f\naccuracy: %f",
                                        currentLocation.coordinate.latitude,
                                        currentLocation.coordinate.longitude,
                                        currentLocation.horizontalAccuracy]);
    
    NSString *lat = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *longt = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    NSString *gKey = self.key;
    NSString *radius = self.search_radius;
    NSString *type = self.search_entity;

    NSString *placeString  = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?types=%@&name=&location=%@,%@&radius=%@&sensor=false&key=%@",type,lat,longt,radius,gKey];
    NSLog(@"request string: %@",placeString);
    
    NSURL *placeURL = [NSURL URLWithString:placeString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:placeURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    [request setHTTPMethod:@"GET"];
    //NSURLResponse* response;
    //NSError* error = nil;
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
        NSLog(@"connectionDidFinishLoading");
        
        // convert to JSON
        //NSError *myError = nil;
        //NSDictionary *res = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&myError];
        NSDictionary *res = (NSDictionary *) JSON;
        
        if (appDelegate.places == nil) {
            appDelegate.places = [[NSMutableArray alloc] init];
        }
        
        [appDelegate.places removeAllObjects];
        
        for(NSDictionary *result in [res objectForKey:@"results"])
        {
            //NSDictionary *location = [[result objectForKey:@"geometry"] objectForKey:@"location"];
            AmbiPlace *place = [[AmbiPlace alloc] init];
            NSString *name = [result objectForKey:@"name"];
            NSString *photo_ref = @"";
           
                       
            NSString *reference = [result objectForKey:@"reference"];
            NSString *rating = [result objectForKey:@"rating"];
            NSString *price_level = [result objectForKey:@"price_level"];
            NSString *icon = [result objectForKey:@"icon"];
            NSString *place_id = [result objectForKey:@"id"];
            place.name = name;
            place.reference = reference;
            place.rating = rating;
            place.price_level = price_level;
            place.icon = icon;
            place.place_id = place_id;

            for (NSDictionary *photos in [result objectForKey:@"photos"]) {
                photo_ref = [photos objectForKey:@"photo_reference"];
            }

            
            NSDictionary *geo = [result objectForKey:@"geometry"];
            NSDictionary *locs = [geo objectForKey:@"location"];
            
            
            NSString *lat = [locs objectForKey:@"lat"];
            NSString *lng = [locs objectForKey:@"lng"];
            
            
            place.lattitude = lat;
            place.longitude = lng;
            place.reference_photo = photo_ref;
            
            //NSLog(@"name: %@", name);
            [appDelegate.places addObject:place];
            
        }
        
        [self.myTableView reloadData];
        
    } failure:nil];

    //Capturing server response
    //NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response       error:&error];
    
    //if (error != nil) {
    [operation start];
    //[self.myTableView reloadData];
    //}
    
}


@end
