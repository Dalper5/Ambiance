//
//  ViewController.m
//  Ambiance
//
//  Created by dalperovich on 1/23/13.
//  Copyright (c) 2013 Ambiance. All rights reserved.
//

#import "ViewController.h"
#import "Beat.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)go:(UIButton*)sender{
        
    RKObjectMapping *beatMapping = [RKObjectMapping mappingForClass:[Beat class]];
    [beatMapping addAttributeMappingsFromArray:@[@"BeatId", @"PlaceName", @"GPS", @"City", @"State", @"Zip", @"Self"]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:beatMapping pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    // Log all HTTP traffic with request and response bodies
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    NSLog(@"Start");
    
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://upbeat.azurewebsites.net/api/beats"]];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        Beat *beat = [result firstObject];
        NSLog(@"Mapped the article: %@", beat);
        
        NSLog(beat.City);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    
    [operation start];
}

@end
