//
//  UIToolbar+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-8-29.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar (Easy)

typedef NS_ENUM(NSInteger, InputAccessoryViewType) {
    InputAccessoryViewTypeCancelDone,
    InputAccessoryViewTypePreviousNextDone
};

@property (copy, nonatomic) void (^cancelHandler)(void);
@property (copy, nonatomic) void (^doneHandler)(void);
@property (copy, nonatomic) void (^previousHandler)(void);
@property (copy, nonatomic) void (^nextHandler)(void);

+ (instancetype)toolbarWithInputAccessoryViewType:(InputAccessoryViewType)type;

- (void)setSeparatedByFlexibleSpaceItems:(NSArray *)items animated:(BOOL)animated;
- (void)setSeparatedByFlexibleSpaceViews:(NSArray *)views animated:(BOOL)animated;

@end
