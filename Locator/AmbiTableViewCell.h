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
    UIImageView *iconView;
    UIImageView *ratingView;
}
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIImageView *ratingView;

@end
