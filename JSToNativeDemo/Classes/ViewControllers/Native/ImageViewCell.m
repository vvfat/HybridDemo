//
//  ImageViewCell.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/8.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "ImageViewCell.h"
#import "UIView+Layout.h"

@interface ImageViewCell ()

{

  
}

@end

@implementation ImageViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor darkTextColor];
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.numberOfLines = 2;
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        _picIV = UIImageView.new;
        _picIV.frame = CGRectMake(10, 10, IV_CELL_HEIGHT - 20, IV_CELL_HEIGHT - 20);
        [self.contentView addSubview:_picIV];
        
        CALayer *layer = _picIV.layer;
        layer.borderWidth = .5;
        layer.borderColor = [UIColor grayColor].CGColor;
        layer.masksToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [self.textLabel setX:_picIV.relativeX + 5];
    [self.detailTextLabel setX:self.textLabel.x];
    
    
}
@end
