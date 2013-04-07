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
#import "AFHTTPClient.h"
#include "AFImageRequestOperation.h"

@interface AmbiViewController ()

@end

@implementation AmbiViewController

//@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    CGRect sizeLogoBar =  CGRectMake(0.0f, 0.0f, screenWidth, screenHeight/10.0f);
    CGRect sizeSearchBar =  CGRectMake(5.0f, 0.0f + screenHeight/10.0f + 1.0f, screenWidth-10.0f, screenHeight/10.0f);
    self.sizeSearchBar = sizeSearchBar;
    self.sizeLogoBar = sizeLogoBar;
    
    // Setup top view
    // Setup Location Button
    UIImage *locationButtonImage = [UIImage imageNamed:@"LocationImage.png"];
    self.myLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.myLocationButton.frame = CGRectMake(0.0f,0.0f + screenHeight/10.0f + screenHeight/10.0f + 1.0f,screenWidth/2.0f,screenWidth/2.0f);
    //[[self.myLocationButton layer] setBorderWidth:2.0f];
    //[[self.myLocationButton layer] setBorderColor:[UIColor blackColor].CGColor];
    //[self.myLocationButton setTitle:@"Location" forState:UIControlStateNormal];
    [self.myLocationButton setBackgroundImage:locationButtonImage forState:UIControlStateNormal];
    
    [self.myLocationButton addTarget:self action:@selector(LocationButtonIspressed:) forControlEvents:UIControlEventTouchUpInside];
    


    // Setup main top view
    self.myTopView = [[UIView alloc] initWithFrame:screenRect];
    self.myTopView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //self.myTopView.backgroundColor = [[UIColor alloc] initWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    self.myTopView.backgroundColor = [UIColor colorWithWhite: 0.95 alpha:1];
    
    // Setup logo view
    self.myTopViewLabelTop = [[UILabel alloc] initWithFrame:sizeLogoBar];
    self.myTopViewLabelTop.layer.borderColor = [UIColor colorWithWhite: 0.95 alpha:1].CGColor;
    self.myTopViewLabelTop.layer.borderWidth = 2.0;
    self.myTopViewLabelTop.text = @"Ambiance";
    self.myTopViewLabelTop.textAlignment = UITextAlignmentCenter;
    self.myTopViewLabelTop.backgroundColor = [UIColor colorWithWhite: 0.8 alpha:1];
    self.myTopViewLabelTop.textColor = [UIColor blackColor];
    UIImage *logoImage = [UIImage imageNamed:@"Ambiance_Logo_V1.png"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    [logoImageView setFrame:CGRectMake(screenWidth/2.0 + 40.0f,9,30,30)];
    [self.myTopViewLabelTop addSubview:logoImageView];

    // Setup search box
    self.myTopViewSearchText = [[UITextField alloc] initWithFrame:sizeSearchBar];
    self.myTopViewSearchText.backgroundColor = [UIColor whiteColor];
    self.myTopViewSearchText.textColor = [UIColor blackColor];
    self.myTopViewSearchText.font = [UIFont systemFontOfSize:16.0f];
    self.myTopViewSearchText.borderStyle = UITextBorderStyleRoundedRect;
    self.myTopViewSearchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.myTopViewSearchText.returnKeyType = UIReturnKeyDone;
    self.myTopViewSearchText.keyboardType = UIKeyboardTypeNamePhonePad;
    //self.myTopViewSearchText.textAlignment = UITextAlignmentLeft;
    self.myTopViewSearchText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //self.myTopViewSearchText.placeholder = @"Search for (restaurants, bars, etc.)";
    UIColor *color = [UIColor colorWithWhite: 0.1 alpha:1];
    self.myTopViewSearchText.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"        Search for (restaurants, bars, etc.)" attributes:@{NSForegroundColorAttributeName: color}];
    UIImage *zoomImage = [UIImage imageNamed:@"zoom_lens.png"];
    UIImageView *zoomImageView = [[UIImageView alloc] initWithImage:zoomImage];
    [zoomImageView setFrame:CGRectMake(5,8,30,30)];
    [self.myTopViewSearchText addSubview:zoomImageView];
    self.myTopViewSearchText.delegate = self;
    
    [self.myTopView addSubview:self.myLocationButton];
    [self.myTopView addSubview:self.myTopViewSearchText];
    [self.myTopView addSubview:self.myTopViewLabelTop];
    
    self.myListView = [[UIView alloc] initWithFrame:screenRect];
    self.myListView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //self.myListView.backgroundColor = [[UIColor alloc] initWithRed:226.0/255.0 green:131.0/255.0 blue:238.0/255.0 alpha:1];
    
    CGRect sizeListTable =  CGRectMake(1.0f, screenHeight/10.0f, screenWidth - 1.0f, screenHeight - screenHeight/10.0f);
    self.myTableListView = [[UITableView alloc] initWithFrame:sizeListTable style:UITableViewStylePlain];
    self.myTableListView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.myTableListView.delegate = self;
    self.myTableListView.dataSource = self;
    
    //Setup List View Lable
    self.myTableListLabelTop = [[UILabel alloc] initWithFrame:sizeLogoBar];
    self.myTableListLabelTop.layer.borderColor = [UIColor colorWithWhite: 0.95 alpha:1].CGColor;
    self.myTableListLabelTop.layer.borderWidth = 2.0;
    self.myTableListLabelTop.text = @"Ambiance";
    self.myTableListLabelTop.textAlignment = UITextAlignmentCenter;
    self.myTableListLabelTop.backgroundColor = [UIColor colorWithWhite: 0.8 alpha:1];
    self.myTableListLabelTop.textColor = [UIColor blackColor];
    UIImage *logoImage2 = [UIImage imageNamed:@"Ambiance_Logo_V1.png"];
    UIImageView *logoImageView2 = [[UIImageView alloc] initWithImage:logoImage2];
    [logoImageView2 setFrame:CGRectMake(screenWidth/2.0 + 40.0f,9,30,30)];
    [self.myTableListLabelTop addSubview:logoImageView2];
    //setup back button
    self.myTableListBackButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [self.myTableListBackButton setFrame:CGRectMake(3.0f, sizeLogoBar.size.height / 5.0f, 20.0f, 10.0f)];
    [self.myTableListBackButton addTarget:self action:@selector(BackFromTableList:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTableListBackButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [self.myListView addSubview:self.myTableListView];
    [self.myListView addSubview:self.myTableListLabelTop];
    [self.myListView addSubview:self.myTableListBackButton];
    
    //setup Search view
    self.mySearchView = [[UIView alloc] initWithFrame:screenRect];
    self.mySearchView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //self.myTopView.backgroundColor = [[UIColor alloc] initWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    self.mySearchView.backgroundColor = [UIColor colorWithWhite: 0.95 alpha:1];
    
    // Setup logo view
    self.mySearchViewLabelTop = [[UILabel alloc] initWithFrame:sizeLogoBar];
    self.mySearchViewLabelTop.layer.borderColor = [UIColor colorWithWhite: 0.95 alpha:1].CGColor;
    self.mySearchViewLabelTop.layer.borderWidth = 2.0;
    self.mySearchViewLabelTop.text = @"Ambiance";
    self.mySearchViewLabelTop.textAlignment = UITextAlignmentCenter;
    self.mySearchViewLabelTop.backgroundColor = [UIColor colorWithWhite: 0.8 alpha:1];
    self.mySearchViewLabelTop.textColor = [UIColor blackColor];
    UIImage *logoImage3 = [UIImage imageNamed:@"Ambiance_Logo_V1.png"];
    UIImageView *logoImageView3 = [[UIImageView alloc] initWithImage:logoImage3];
    [logoImageView3 setFrame:CGRectMake(screenWidth/2.0 + 40.0f,9,30,30)];
    [self.mySearchViewLabelTop addSubview:logoImageView3];
    
    // Setup search box
    self.mySearchViewSearchText = [[UITextField alloc] initWithFrame:sizeSearchBar];
    self.mySearchViewSearchText.backgroundColor = [UIColor whiteColor];
    self.mySearchViewSearchText.textColor = [UIColor blackColor];
    self.mySearchViewSearchText.font = [UIFont systemFontOfSize:16.0f];
    self.mySearchViewSearchText.borderStyle = UITextBorderStyleRoundedRect;
    self.mySearchViewSearchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mySearchViewSearchText.returnKeyType = UIReturnKeyDone;
    //self.myTopViewSearchText.textAlignment = UITextAlignmentLeft;
    self.mySearchViewSearchText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //self.mySearchViewSearchText.placeholder = @"Search for (restaurants, bars, etc.)";
    //UIColor *color3 = [UIColor colorWithWhite: 0.1 alpha:1];
    //self.mySearchViewSearchText.attributedPlaceholder =
    //[[NSAttributedString alloc] initWithString:@"        Search for (restaurants, bars, etc.)" attributes:@{NSForegroundColorAttributeName: color3}];
    //UIImage *zoomImage3 = [UIImage imageNamed:@"zoom_lens.png"];
    //UIImageView *zoomImageView3 = [[UIImageView alloc] initWithImage:zoomImage3];
    //[zoomImageView3 setFrame:CGRectMake(5,8,30,30)];
    //[self.mySearchViewSearchText addSubview:zoomImageView3];
    self.mySearchViewSearchText.delegate = self;
    self.mySearchBackButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [self.mySearchBackButton setFrame:CGRectMake(3.0f, sizeLogoBar.size.height / 5.0f, 20.0f, 10.0f)];
    [self.mySearchBackButton addTarget:self action:@selector(BackFromSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.mySearchBackButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [self.mySearchView addSubview:self.mySearchViewSearchText];
    [self.mySearchView addSubview:self.mySearchViewLabelTop];
    [self.mySearchView addSubview:self.mySearchBackButton];
    
    self.key = @"AIzaSyC3G9bERz7ktJkqxvnnRx_Sb9ld8jKQErk";
    self.row_height = @"80";
    self.search_radius = @"100";
    self.selectedColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1];
    NSString *pipe = @"|";
    NSString *e_pipe = [pipe stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *type =@"restaurant";
    type = [type stringByAppendingString:e_pipe];
    type = [type stringByAppendingString:@"bar"];
    type = [type stringByAppendingString:e_pipe];
    type = [type stringByAppendingString:@"cafe"];
    self.search_entity = type;
    
    [self.view addSubview:self.myListView];
    [self.view addSubview:self.myTopView];
    [self.view addSubview:self.mySearchView];

    
    [self.view bringSubviewToFront:self.myTopView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    /*--
     * This method is called when the textField becomes active, or is the First Responder
     --*/
    
    if ([textField isEqual:self.myTopViewSearchText]) {
        //textField.placeholder = nil;
        //bring up Search View
        NSLog(@"textFieldDidBeginEditing : Search Hit on Top View");

        [self.mySearchViewSearchText becomeFirstResponder];
        [self.view bringSubviewToFront:self.mySearchView];
        
    } else  if ([textField isEqual:self.mySearchViewSearchText]) {
        NSLog(@"textFieldDidBeginEditing : Search Hit on Search View");
        [self.mySearchViewSearchText becomeFirstResponder];

    }
    
}

-(void)stopSampling{
    [levelTimer invalidate];
    
    NSLog(@"title =%@", btnPressed);
    
    NSURL *baseURL = [NSURL URLWithString:@"http://upbeat.azurewebsites.net/api/soundsamples"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient defaultValueForHeader:@"Accept"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            btnPressed, @"googleid", [NSString stringWithFormat:@"%f", avgSound], @"soundsample", nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"http://upbeat.azurewebsites.net/api/soundsamples/postsoundsamplewithgoogleid" parameters:params];
    
    //Add your request object to an AFHTTPRequestOperation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                          initWithRequest:request];
    
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation,
       id responseObject) {
         NSString *response = [operation responseString];
         NSLog(@"response: [%@]",response);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error: %@", [operation error]);
     }];
    
    //call start on your request operation
    [operation start];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Average Volume"
														message:[NSString stringWithFormat: @"Average: %f", avgSound]
													   delegate:self cancelButtonTitle:@"Great"
											  otherButtonTitles:nil];
    
    [alertView show];
    
    
}

- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
	avgSound = [recorder averagePowerForChannel:0];
    NSLog(@"Average input: %f Peak input: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger result = 0;
    if ([tableView isEqual:self.myTableListView]) {
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
    
    if ([tableView isEqual:self.myTableListView]) {
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
            // NSString *row_text_details = @"";
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
                //NSLog(@"request string: %@",placeString);
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
            
            //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            //[button addTarget:self action:@selector(recordActionPressed:) forControlEvents:UIControlEventTouchDown];
            //[button setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
            //button.frame = CGRectMake(250.0f, 25.0f, 32.0f, 32.0f);
            
            //need a much better way to pass this - dave
            //[button setTitle:[NSString stringWithFormat:@"%@",place.place_id] forState:UIControlStateDisabled];
            
            //[result addSubview:button];
            
            
            NSString *placeString  = [NSString stringWithFormat:@"http://upbeat.azurewebsites.net/api/beats/getbeatbygoogleid/%@",place.place_id];
            //NSLog(@"request string: %@",placeString);
            
            NSURL *placeURL = [NSURL URLWithString:placeString];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:placeURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
            [request setHTTPMethod:@"GET"];
            
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                //NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
                NSLog(@"connectionDidFinishLoading");
                
                NSLog(@"%@", JSON);
                
                // convert to JSON
                NSError *myError = nil;
                NSString *sound_level = @"";
                
                //NSDictionary *res = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&myError];
                NSDictionary *res = (NSDictionary *) JSON;
                NSLog(@"error : %@", myError);
                
                NSString *sampleavg = [res objectForKey:@"SampleAvg"];
                
                NSLog(@"sampleavg: %@", sampleavg);
                
                //NSString *beatid = [res valueForKeyPath:@"Beat.BeatId"];
                
                //NSLog(@"beatid: %@", beatid);
                
                for(NSDictionary *sndresult in [res valueForKeyPath:@"Beat.SoundSamples"])
                {
                    sound_level = [sndresult objectForKey:@"SoundLevel"];
                    
                    NSLog(@"soundlevel: %@", sound_level);
                    
                    //NSLog(@"BeatId: %@", [result objectForKey:@"BeatId"]);
                }
                
                
                result.soundLabel.text = [NSString stringWithFormat: @"%@", sampleavg];
                
                //[self.myTableView reloadData];
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
            }];
        
            [operation start];

        }
    }
    return result;
}


-(void)recordActionPressed :(id)sender
{
    UIButton* b = (UIButton*) sender;
    
	//Get the superview from this button which will be our cell
	UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
	
	NSIndexPath *pathToCell = [self.myTableListView indexPathForCell:owningCell];
    
    
    //really ugly, need a better way to maintain googleid of button pressed
    btnPressed = [b titleForState:UIControlStateDisabled];
    
    //Constants for AVAudioRecorder
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
  	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
  	NSError *error;
    
  	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
  	if (recorder) {
  		[recorder prepareToRecord];
  		recorder.meteringEnabled = YES;
  		[recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
        
        [NSTimer scheduledTimerWithTimeInterval:3 target: self selector: @selector(stopSampling) userInfo:nil repeats: NO];
        
  	} else
  		NSLog([error description]);
	
	/*
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Custom Button Pressed"
														message:[NSString stringWithFormat: @"You pressed the custom button on cell #%i", pathToCell.row + 1]
													   delegate:self cancelButtonTitle:@"Great"
											  otherButtonTitles:nil];
	*/
    

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *selectedBackgroundViewForCell = [UIView new];
    [selectedBackgroundViewForCell setBackgroundColor:self.selectedColor];
    
    cell.selectedBackgroundView = selectedBackgroundViewForCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if ([tableView isEqual:self.myTableListView]) {
        //NSLog(@"%@", [NSString stringWithFormat:@"Cell %ld in Section %ld is selected", (long)indexPath.row, (long)indexPath.section]);
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UIView *selectedBackgroundViewForCell = [UIView new];
        [selectedBackgroundViewForCell setBackgroundColor:self.selectedColor];
        
        cell.selectedBackgroundView = selectedBackgroundViewForCell;
        //cell.contentView.backgroundColor = self.selectedColor;
        //cell.backgroundColor = self.selectedColor;
        AmbiAppDelegate *appDelegate=(AmbiAppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *gKey = self.key;
        AmbiPlace *place = [appDelegate.places objectAtIndex:indexPath.row];
        NSString *reference = place.reference;

        NSString *placeString  = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=false&key=%@",reference,gKey];
        //NSLog(@"request string: %@",placeString);
        
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

// Back Button is pressed from Search View
- (void) BackFromSearch:(UIButton*)paramSender{
    // hide the keyboard
    //[self.view endEditing:YES];
    [self.mySearchViewSearchText resignFirstResponder];
    [self.view bringSubviewToFront:self.myTopView ];
}

// Back Button is pressed from the Table List View
- (void) BackFromTableList:(UIButton*)paramSender{
    //[self.view endEditing:YES];
    [self.view bringSubviewToFront:self.myTopView ];
}

//- (IBAction)Locate:(UIButton*)sender {
- (void) LocationButtonIspressed:(UIButton*)paramSender{
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
        
        [self.view bringSubviewToFront:self.myListView];
        [self.myTableListView reloadData];
        
    } failure:nil];

    //Capturing server response
    //NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response       error:&error];
    
    //if (error != nil) {
    [operation start];
    //[self.myTableView reloadData];
    //}
    
}


@end
