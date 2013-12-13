//
//  UITableView+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Easy)

- (void)scrollToBottom;
- (void)hideEmptyCells;
- (void)reloadDataWithCompletion:(void(^)(void))completionBlock;
- (void)configureBackgroundColorWithColor:(UIColor *)color;

@end
