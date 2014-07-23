//
//  MasterTableViewCell.m
//  Easy
//
//  Created by Jayce Yang on 14-7-23.
//  Copyright (c) 2014年 Personal. All rights reserved.
//

#import "MasterTableViewCell.h"

@implementation MasterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
