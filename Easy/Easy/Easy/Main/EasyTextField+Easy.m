//
//  EasyTextField+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 7/15/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
//

#import <objc/runtime.h>

#import "EasyTextField+Easy.h"
#import "NSLocale+Easy.h"
#import "NSObject+Easy.h"
#import "NSArray+Easy.h"
#import "UITableView+Easy.h"
#import "UIViewController+Easy.h"
#import "UIView+Easy.h"
#import "ApplicationInfo.h"
#import "Constants.h"

static char EasyTextFieldDatePickerKey;
static char EasyTextFieldDatePickerInputCompletionHandlerKey;
static char EasyTextFieldDatePickerInputCancelHandlerKey;

static char EasyTextFieldPickerViewKey;
static char EasyTextFieldPickerViewDatasKey;
static char EasyTextFieldPickerViewInputCompletionHandlerKey;
static char EasyTextFieldPickerViewInputCancelHandlerKey;

static char EasyTextFieldTableViewKey;
static char EasyTextFieldTableViewDatasKey;
static char EasyTextFieldTableViewInputCompletionHandlerKey;
static char EasyTextFieldTableViewInputCancelHandlerKey;

@interface EasyTextField () 

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (copy, nonatomic) void (^datePickerInputCompletionHandler)(UIDatePicker *datePicker);
@property (copy, nonatomic) void (^datePickerInputCancelHandler)(void);

@property (copy, nonatomic) NSArray *pickerViewDatas;
@property (copy, nonatomic) void (^pickerViewInputCompletionHandler)(NSUInteger selectedIndex, NSString *selectedText);
@property (copy, nonatomic) void (^pickerViewInputCancelHandler)(void);

@property (copy, nonatomic) NSArray *tableViewDatas;
@property (copy, nonatomic) void (^tableViewInputCompletionHandler)(NSUInteger selectedIndex, NSString *selectedText);
@property (copy, nonatomic) void (^tableViewInputCancelHandler)(void);

@end

@implementation EasyTextField (Easy)

#pragma mark - Public

- (UIDatePicker *)datePickerInputWithCompletionHandler:(void (^)(UIDatePicker *datePicker))completionHandler
{
    return [self datePickerInputWithCompletionHandler:completionHandler cancelHandler:nil];
}

- (UIDatePicker *)datePickerInputWithCompletionHandler:(void (^)(UIDatePicker *datePicker))completionHandler cancelHandler:(void (^)(void))cancelHandler
{
//    self.hideCursor = YES;
//    [self setNeedsDisplay];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.timeZone = [NSTimeZone defaultTimeZone];
    datePicker.locale = [NSLocale currentLocale];
    
    
    self.datePicker = datePicker;
    self.datePickerInputCompletionHandler = completionHandler;
    self.datePickerInputCancelHandler = cancelHandler;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.translucent = YES;
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(datePickerCancelAction)];
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(datePickerDoneAction)];
    UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    toolbar.items = [NSArray arrayWithObjects:cancelBarButtonItem, spaceBarButtonItem, doneBarButtonItem, nil];
    
    self.inputView = datePicker;
    self.inputAccessoryView = toolbar;
    
    return self.datePicker;
}

- (UIPickerView *)pickerViewInputWithDatas:(NSArray *)datas completionHandler:(void (^)(NSUInteger selectedIndex, NSString *selectedText))completionHandler
{
    return [self pickerViewInputWithDatas:datas completionHandler:completionHandler cancelHandler:nil];
}

- (UIPickerView *)pickerViewInputWithDatas:(NSArray *)datas completionHandler:(void (^)(NSUInteger selectedIndex, NSString *selectedText))completionHandler cancelHandler:(void (^)(void))cancelHandler
{
    self.pickerViewDatas = datas;
    
//    if (self.pickerView == nil) {
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        self.pickerView = pickerView;
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
        toolbar.barStyle = UIBarStyleBlack;
        toolbar.translucent = YES;
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pickerViewCancelAction)];
        UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pickerViewDoneAction)];
        UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        toolbar.items = [NSArray arrayWithObjects:cancelBarButtonItem, spaceBarButtonItem, doneBarButtonItem, nil];
        
        self.inputView = self.pickerView;
        self.inputAccessoryView = toolbar;
//    }
    
    self.pickerViewInputCompletionHandler = completionHandler;
    self.pickerViewInputCancelHandler = cancelHandler;
    
    [self selectCurrentValueWithAnimated:YES];
    
    return self.pickerView;
}

- (UITableView *)tableViewInputWithDatas:(NSArray *)datas completionHandler:(void (^)(NSUInteger selectedIndex, NSString *selectText))completionHandler
{
    return [self tableViewInputWithDatas:datas completionHandler:completionHandler cancelHandler:nil];
}

- (UITableView *)tableViewInputWithDatas:(NSArray *)datas completionHandler:(void (^)(NSUInteger selectedIndex, NSString *selectText))completionHandler cancelHandler:(void (^)(void))cancelHandler
{
    self.tableViewDatas = datas;
    
//    if (self.tableView == nil) {
        CGFloat rowHeight = 44;
        CGFloat heightLitmit = 216;
//        CGFloat height = MIN(datas.count * rowHeight, heightLitmit);
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), heightLitmit)];
        inputView.backgroundColor = [UIColor clearColor];
//        [[inputView currentNavigationController] configureBackgroundBasedOnPageTypeForView:inputView];
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(inputView.bounds) - height) / 2, CGRectGetWidth(inputView.bounds), height) style:UITableViewStylePlain];
        UITableView *tableView = [[UITableView alloc] initWithFrame:inputView.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = rowHeight;
        if (systemVersionGreaterThanOrEqualTo(7)) {
            tableView.separatorInset = UIEdgeInsetsZero;
        }
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView configureBackgroundColorWithColor:[UIColor whiteColor]];
//        tableView.center = inputView.center;
//        [tableView.currentNavigationController configureBackgroundForView:tableView];
        [tableView hideEmptyCells];
    
        CGFloat tableViewContentHeight = datas.count * rowHeight;
    if (heightLitmit > tableViewContentHeight) {
        CGFloat spaceHeight = (heightLitmit - tableViewContentHeight) / 2.f;
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), spaceHeight)];
        tableHeaderView.backgroundColor = [UIColor clearColor];
        tableView.tableHeaderView = tableHeaderView;
    }
        self.tableView = tableView;
        [inputView addSubview:self.tableView];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
        toolbar.barStyle = UIBarStyleBlack;
        toolbar.translucent = YES;
//        CGFloat buttonWidth = 50;
//        CGFloat buttonHeight = 30;
//        UIButton *cancelButton = [self buttonWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight) target:self action:@selector(tableViewCancelAction) title:NSLocalizedString(@"Cancel", nil) backgroundImage:nil];
//        [cancelButton configureGeneralAppearance];
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(tableViewCancelAction)];
        UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(tableViewDoneAction)];
        UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        toolbar.items = [NSArray arrayWithObjects:cancelBarButtonItem, spaceBarButtonItem, doneBarButtonItem, nil];
        
        self.inputView = inputView;
        self.inputAccessoryView = toolbar;
//    }
    
    self.tableViewInputCompletionHandler = completionHandler;
    self.tableViewInputCancelHandler = cancelHandler;
    
    [self selectCurrentValueWithAnimated:YES];
    
    return self.tableView;
}

#pragma mark - date picker

- (UIDatePicker *)datePicker
{
    UIDatePicker *picker = objc_getAssociatedObject(self, &EasyTextFieldDatePickerKey);
    return picker;
}

- (void)setDatePicker:(UIDatePicker *)datePicker
{
    [self willChangeValueForKey:@"datePicker"];
    objc_setAssociatedObject(self, &EasyTextFieldDatePickerKey, datePicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"datePicker"];
}

- (void (^)(UIDatePicker *))datePickerInputCompletionHandler
{
    return objc_getAssociatedObject(self, &EasyTextFieldDatePickerInputCompletionHandlerKey);
}

- (void)setDatePickerInputCompletionHandler:(void (^)(UIDatePicker *))datePickerInputCompletionHandler
{
    [self willChangeValueForKey:@"datePickerInputCompletionHandler"];
    objc_setAssociatedObject(self, &EasyTextFieldDatePickerInputCompletionHandlerKey, datePickerInputCompletionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"datePickerInputCompletionHandler"];
}

- (void (^)(void))datePickerInputCancelHandler
{
    return objc_getAssociatedObject(self, &EasyTextFieldDatePickerInputCancelHandlerKey);
}

- (void)setDatePickerInputCancelHandler:(void (^)(void))datePickerInputCancelHandler
{
    [self willChangeValueForKey:@"datePickerInputCancelHandler"];
    objc_setAssociatedObject(self, &EasyTextFieldDatePickerInputCancelHandlerKey, datePickerInputCancelHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"datePickerInputCancelHandler"];
}

- (void)datePickerCancelAction
{
    if (self.datePickerInputCancelHandler) {
        self.datePickerInputCancelHandler();
    }
}

- (void)datePickerDoneAction
{
    if (self.datePickerInputCompletionHandler) {
        self.datePickerInputCompletionHandler(self.datePicker);
    }
}

#pragma mark - picker view

- (UIPickerView *)pickerView
{
    UIPickerView *picker = objc_getAssociatedObject(self, &EasyTextFieldPickerViewKey);
    return picker;
}

- (void)setPickerView:(UIPickerView *)pickerView
{
    [self willChangeValueForKey:@"pickerView"];
    objc_setAssociatedObject(self, &EasyTextFieldPickerViewKey, pickerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"pickerView"];
}

- (NSArray *)pickerViewDatas
{
    NSArray *datas = objc_getAssociatedObject(self, &EasyTextFieldPickerViewDatasKey);
    return datas;
}

- (void)setPickerViewDatas:(NSArray *)pickerViewDatas
{
    [self willChangeValueForKey:@"pickerViewDatas"];
    objc_setAssociatedObject(self, &EasyTextFieldPickerViewDatasKey, pickerViewDatas, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"pickerViewDatas"];
}

- (void (^)(NSUInteger, NSString *))pickerViewInputCompletionHandler
{
    return objc_getAssociatedObject(self, &EasyTextFieldPickerViewInputCompletionHandlerKey);
}

- (void)setPickerViewInputCompletionHandler:(void (^)(NSUInteger, NSString *))pickerViewInputCompletionHandler
{
    [self willChangeValueForKey:@"pickerViewInputCompletionHandler"];
    objc_setAssociatedObject(self, &EasyTextFieldPickerViewInputCompletionHandlerKey, pickerViewInputCompletionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"pickerViewInputCompletionHandler"];
}

- (void (^)(void))pickerViewInputCancelHandler
{
    return objc_getAssociatedObject(self, &EasyTextFieldPickerViewInputCancelHandlerKey);
}

- (void)setPickerViewInputCancelHandler:(void (^)(void))pickerViewInputCancelHandler
{
    [self willChangeValueForKey:@"pickerViewInputCancelHandler"];
    objc_setAssociatedObject(self, &EasyTextFieldPickerViewInputCancelHandlerKey, pickerViewInputCancelHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"pickerViewInputCancelHandler"];
}

- (void)pickerViewCancelAction
{
    if (self.pickerViewInputCancelHandler) {
        self.pickerViewInputCancelHandler();
    }
    
    [self resignFirstResponder];
}

- (void)pickerViewDoneAction
{
    NSString *selectedText = nil;
    if (self.selectedIndex != NSNotFound) {
        selectedText = [self.pickerViewDatas objectAtTheIndex:self.selectedIndex];
    } else {
        selectedText = [NSString string];
    }
    
    self.text = selectedText;
    
    if (self.pickerViewInputCompletionHandler) {
        self.pickerViewInputCompletionHandler(self.selectedIndex, selectedText);
    }
    
    [self resignFirstResponder];
}

#pragma mark - table view

- (UITableView *)tableView
{
    UITableView *table = objc_getAssociatedObject(self, &EasyTextFieldTableViewKey);
    return table;
}

- (void)setTableView:(UITableView *)tableView
{
    [self willChangeValueForKey:@"tableView"];
    objc_setAssociatedObject(self, &EasyTextFieldTableViewKey, tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"tableView"];
}

- (NSArray *)tableViewDatas
{
    NSArray *datas = objc_getAssociatedObject(self, &EasyTextFieldTableViewDatasKey);
    return datas;
}

- (void)setTableViewDatas:(NSArray *)tableViewDatas
{
    [self willChangeValueForKey:@"tableViewDatas"];
    objc_setAssociatedObject(self, &EasyTextFieldTableViewDatasKey, tableViewDatas, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"tableViewDatas"];
}

- (void (^)(NSUInteger, NSString *))tableViewInputCompletionHandler
{
    return objc_getAssociatedObject(self, &EasyTextFieldTableViewInputCompletionHandlerKey);
}

- (void)setTableViewInputCompletionHandler:(void (^)(NSUInteger, NSString *))tableViewInputCompletionHandler
{
    [self willChangeValueForKey:@"tableViewInputCompletionHandler"];
    objc_setAssociatedObject(self, &EasyTextFieldTableViewInputCompletionHandlerKey, tableViewInputCompletionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"tableViewInputCompletionHandler"];
}

- (void (^)(void))tableViewInputCancelHandler
{
    return objc_getAssociatedObject(self, &EasyTextFieldTableViewInputCancelHandlerKey);
}

- (void)setTableViewInputCancelHandler:(void (^)(void))tableViewInputCancelHandler
{
    [self willChangeValueForKey:@"tableViewInputCancelHandler"];
    objc_setAssociatedObject(self, &EasyTextFieldTableViewInputCancelHandlerKey, tableViewInputCancelHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"tableViewInputCancelHandler"];
}

- (void)tableViewCancelAction
{
    if (self.tableViewInputCancelHandler) {
        self.tableViewInputCancelHandler();
    }
    
    [self resignFirstResponder];
}

- (void)tableViewDoneAction
{
    NSString *selectedText = nil;
    if (self.selectedIndex != NSNotFound) {
        selectedText = [self.tableViewDatas objectAtTheIndex:self.selectedIndex];
    } else {
        selectedText = self.defaultValue;
    }
    
    self.text = selectedText;
    
    if (self.tableViewInputCompletionHandler) {
        self.tableViewInputCompletionHandler(self.selectedIndex, selectedText);
    }
    
    [self resignFirstResponder];
}

@end
