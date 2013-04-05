//
//  AmbiTableViewCell.h
//  Locator
//
//  Created by Misha Gavronsky on 3/18/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmbiTableViewCell : UITableViewCell {
    
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *soundLabel;
    UIImageView *iconView;
    UIImageView *ratingView;
    UIImageView *photoView;
    
    NSString *row_height;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier rowHeight:(NSString*)height;

@property (nonatomic, strong) NSString *row_height;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *soundLabel;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIImageView *ratingView;
@property(nonatomic,strong)UIImageView *photoView;

@end
