//
//  EasyTextField.h
//  iGuest
//
//  Created by Jayce Yang on 7/15/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasyTextField : UITextField <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSString *defaultValue; //Default is empty string
@property (nonatomic) BOOL hideCursor;  //Default is NO
@property (nonatomic) BOOL canDeselect; //Default is NO
@property (readonly, nonatomic) NSInteger selectedIndex;

- (void)selectCurrentValueWithAnimated:(BOOL)animated;
- (void)selectRow:(NSInteger)row animated:(BOOL)animated;

@end
