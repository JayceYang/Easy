//
//  UISearchBar+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 13-7-19.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import "UISearchBar+Easy.h"

@implementation UISearchBar (Easy)

- (UITextField *)textField
{
    UITextField *theTextField = nil;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            theTextField = (UITextField *)view;
            break;
        }
    }
    
    return theTextField;
}

- (UIButton *)cancelButton
{
    UIButton *theButton = nil;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            theButton = (UIButton *)view;
            break;
        }
    }
    
    return theButton;
}

@end
