//
//  UITableViewCell+Easy.h
//  DJIStore
//
//  Created by Jayce Yang on 14-1-15.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Easy)

@property (weak, nonatomic) UITableView *tableView;

- (void)addAttachmentBehaviorWithReferenceTableView:(UITableView *)tableView;
- (void)hideSeparator;

@end
