//
//  EasyLabel.m
//  DJIStore
//
//  Created by Jayce Yang on 14-2-8.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "EasyLabel.h"

#import "NSObject+Easy.h"
#import "Macro.h"

@implementation EasyLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
//{
//    ELog(@"%@", NSStringFromCGSize(bounds.size));
//    return CGRectMake(self.contentEdgeInsets.left, self.contentEdgeInsets.top, CGRectGetWidth(bounds) - self.contentEdgeInsets.left * 2, CGRectGetHeight(bounds) - self.contentEdgeInsets.top * 2);
//}

- (void)drawTextInRect:(CGRect)rect
{
    ELog(@"%@", NSStringFromCGSize(rect.size));
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentEdgeInsets)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
