//
//  AmbiViewController.m
//  Locator
//
//  Created by Misha Gavronsky on 3/10/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import "AmbiViewController.h"
#import "AmbiAppDelegate.h"

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

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    
    AmbiAppDelegate *appDelegate=(AmbiAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([tableView isEqual:self.myTableView]) {
        static NSString *TableViewCellIdentifier = @"MyCells";
        result = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
        if (result == nil){
            result = [[UITableViewCell alloc]
                      initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
        }
        
        //result.textLabel.text = [NSString stringWithFormat:@"Section %ld, Cell %ld",
        //                         (long)indexPath.section,(long)indexPath.row];
        if ([appDelegate.places count] > 0) {
            result.textLabel.text = [appDelegate.places objectAtIndex:(long)indexPath.row];
        }
    }
    return result;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if ([tableView isEqual:self.myTableView]) {
        NSLog(@"%@", [NSString stringWithFormat:@"Cell %ld in Section %ld is selected", (long)indexPath.row, (long)indexPath.section]);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *gKey = @"AIzaSyC3G9bERz7ktJkqxvnnRx_Sb9ld8jKQErk";
    NSString *pipe = @"|";
    NSString *e_pipe = [pipe stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *type =@"restaurant";
    type = [type stringByAppendingString:e_pipe];
    type = [type stringByAppendingString:@"bar"];
    NSString *placeString  = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?types=%@&name=&location=%@,%@&radius=100&sensor=false&key=%@",type,lat,longt,gKey];
    NSLog(@"request string: %@",placeString);
    
    NSURL *placeURL = [NSURL URLWithString:placeString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:placeURL];
    [request setHTTPMethod:@"GET"];
    NSURLResponse* response;
    NSError* error = nil;
    
    //Capturing server response
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response       error:&error];
    
    //if (error != nil) {
        NSLog(@"connectionDidFinishLoading");
        
        // convert to JSON
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&myError];
        
        // show all values
        /*
        for(id key in res) {
            id value = [res objectForKey:key];
            NSString *keyAsString = (NSString *)key;
            NSString *valueAsString = (NSString *)value;
            NSString *name = [res objectForKey:@"name"];
            NSLog(@"key: %@", keyAsString);
            NSLog(@"name: %@", name);
            NSLog(@"value: %@", valueAsString);
            NSLog(@"\n");
        }
         */
    
        if (appDelegate.places == nil) {
            appDelegate.places = [[NSMutableArray alloc] init];
        
        }
    
        [appDelegate.places removeAllObjects];
    
        for(NSDictionary *result in [res objectForKey:@"results"])
        {
            //NSDictionary *location = [[result objectForKey:@"geometry"] objectForKey:@"location"];
            NSString *name = [result objectForKey:@"name"];
            NSLog(@"name: %@", name);
            [appDelegate.places addObject:name];
        }
    [self.myTableView reloadData];
    //}
    
}


@end
