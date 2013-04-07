//
//  AmbiViewController.h
//  Locator
//
//  Created by Misha Gavronsky on 3/10/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AmbiViewController : UIViewController <UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource>{
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    double avgSound;
    NSString *btnPressed;
    
}

//List View
@property (nonatomic, strong) UIView *myListView;
@property (nonatomic, strong) UITableView *myTableListView;
@property (nonatomic, strong) UIButton *myTableListBackButton;
@property (nonatomic, strong) UILabel  *myTableListLabelTop;

//Top View
@property (nonatomic, strong) UIView *myTopView;
@property (nonatomic, strong) UIButton  *myLocationButton;
@property (nonatomic, strong) UILabel  *myTopViewLabelTop;
@property (nonatomic, strong) UITextField *myTopViewSearchText;

//Search View
@property (nonatomic, strong) UIView *mySearchView;
@property (nonatomic, strong) UIButton *mySearchBackButton;
@property (nonatomic, strong) UILabel  *mySearchViewLabelTop;
@property (nonatomic, strong) UITextField *mySearchViewSearchText;

@property (nonatomic, strong) NSString  *key;
@property (nonatomic, strong) NSString  *row_height;
@property (nonatomic, strong) NSString  *search_entity;
@property (nonatomic, strong) NSString  *search_radius;
@property (nonatomic, assign) CGRect    sizeLogoBar;
@property (nonatomic, assign) CGRect    sizeSearchBar;

@property (nonatomic, strong) UIColor   *selectedColor;

- (IBAction)Locate:(UIButton*)sender;

- (void)levelTimerCallback:(NSTimer *)timer;
    
@end
