//
//  AmbiTableViewCell.m
//  Locator
//
//  Created by Misha Gavronsky on 3/18/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import "AmbiTableViewCell.h"

@implementation AmbiTableViewCell

@synthesize priceLabel,nameLabel,ratingView, iconView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        nameLabel = [[UILabel alloc]init];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:14];
        priceLabel = [[UILabel alloc]init];
        priceLabel.textAlignment = UITextAlignmentLeft;
        priceLabel.font = [UIFont systemFontOfSize:8];
        iconView = [[UIImageView alloc]init];
        ratingView = [[UIImageView alloc] init];
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:priceLabel];
        [self.contentView addSubview:iconView];
        [self.contentView addSubview:ratingView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    frame= CGRectMake(boundsX+5 ,10, 25, 25);
    iconView.frame = frame;
    
    frame= CGRectMake(boundsX+40 ,2, 200, 25);
    nameLabel.frame = frame;
    
    frame= CGRectMake(boundsX+40 ,25, 80, 15);
    ratingView.frame = frame;
    
    frame= CGRectMake(boundsX+125 ,25, 85, 15);
    priceLabel.frame = frame;
    UIFont* font = [UIFont fontWithName:@"Verdana" size:14.0];
    priceLabel.font = font;

}

@end
