//
//  EasyTextField+Easy.h
//  Easy
//
//  Created by Jayce Yang on 7/15/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import "EasyTextField.h"

@interface EasyTextField (Easy)

@property (readonly, strong, nonatomic) UIDatePicker *datePicker;

@property (readonly, strong, nonatomic) UIPickerView *pickerView;
@property (readonly, copy, nonatomic) NSArray *pickerViewDatas;

@property (readonly, strong, nonatomic) UITableView *tableView;
@property (readonly, copy, nonatomic) NSArray *tableViewDatas;

- (UIDatePicker *)datePickerInputWithCompletionHandler:(void (^)(UIDatePicker *datePicker))completionHandler;
- (UIDatePicker *)datePickerInputWithCompletionHandler:(void (^)(UIDatePicker *datePicker))completionHandler cancelHandler:(void (^)(void))cancelHandler;

- (UIPickerView *)pickerViewInputWithDatas:(NSArray *)datas completionHandler:(void (^)(NSUInteger selectedIndex, NSString *selectedText))completionHandler;
- (UIPickerView *)pickerViewInputWithDatas:(NSArray *)datas completionHandler:(void (^)(NSUInteger selectedIndex, NSString *selectedText))completionHandler cancelHandler:(void (^)(void))cancelHandler;

- (UITableView *)tableViewInputWithDatas:(NSArray *)datas completionHandler:(void (^)(NSUInteger selectedIndex, NSString *selectedText))completionHandler;
- (UITableView *)tableViewInputWithDatas:(NSArray *)datas completionHandler:(void (^)(NSUInteger selectedIndex, NSString *selectedText))completionHandler cancelHandler:(void (^)(void))cancelHandler;

@end
