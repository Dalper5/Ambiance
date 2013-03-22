//
//  AmbiViewController.h
//  Locator
//
//  Created by Misha Gavronsky on 3/10/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AmbiViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIButton  *myButton;
@property (nonatomic, strong) NSString  *key;

@property (nonatomic, strong) NSString  *row_height;
@property (nonatomic, strong) NSString  *search_entity;
@property (nonatomic, strong) NSString  *search_radius;

- (IBAction)Locate:(UIButton*)sender;
    
@end
