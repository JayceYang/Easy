//
//  EasyDraggableView.h
//  Sales
//
//  Created by Jayce Yang on 14-9-2.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasyDraggableView : UIView

@property (strong, nonatomic) UIImage *background;
@property (copy, nonatomic) void (^tapHandler)(EasyDraggableView *draggableView);

@end
