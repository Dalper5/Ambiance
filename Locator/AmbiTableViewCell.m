//
//  AmbiTableViewCell.m
//  Locator
//
//  Created by Misha Gavronsky on 3/18/13.
//  Copyright (c) 2013 Misha Gavronsky. All rights reserved.
//

#import "AmbiTableViewCell.h"

@implementation AmbiTableViewCell

@synthesize priceLabel,nameLabel,ratingView, photoView, iconView, row_height;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier rowHeight:(NSString*)height {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        row_height = height;
        nameLabel = [[UILabel alloc]init];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        priceLabel = [[UILabel alloc]init];
        priceLabel.textAlignment = UITextAlignmentLeft;
        priceLabel.font = [UIFont boldSystemFontOfSize:14];
        iconView = [[UIImageView alloc]init];
        ratingView = [[UIImageView alloc] init];
        photoView = [[UIImageView alloc] init];
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:priceLabel];
        [self.contentView addSubview:iconView];
        [self.contentView addSubview:ratingView];
        [self.contentView addSubview:photoView];
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
    NSInteger height = [self.row_height integerValue];
    
    frame= CGRectMake(boundsX+0 ,1, height-4, height-3);
    photoView.frame = frame;

    frame= CGRectMake(boundsX+height+4 ,2, 200, 25);
    nameLabel.frame = frame;

    frame= CGRectMake(boundsX+height+6 ,30, 15, 15);
    iconView.frame = frame;
     
    frame= CGRectMake(boundsX+height+28 ,26, 100, 20);
    ratingView.frame = frame;
    
    frame= CGRectMake(boundsX+height +135 ,30, 40, 15);
    priceLabel.frame = frame;
    
    UIFont* font = [UIFont fontWithName:@"Verdana" size:16.0];
    priceLabel.font = font;

}

@end
