//
//  EasyTextField.m
//  iGuest
//
//  Created by Jayce Yang on 7/15/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
//


#import "EasyTextField.h"

#import "EasyTextField+Easy.h"
#import "NSArray+Easy.h"
#import "UIView+Easy.h"
#import "UIImage+Easy.h"

@interface EasyTextField ()

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSInteger lastSelectedIndex;
//@property (copy, nonatomic) NSString *selectedText;

@end

@implementation EasyTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        [self setupDefaults];
    }
    return self;
}

- (void)dealloc
{
    
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    if (_hideCursor) {
        return CGRectZero;
    } else {
        return [super caretRectForPosition:position];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if (_hideCursor) {
        CGFloat leftMargin = 5;
        CGFloat rightMargin = 0;
        if (self.leftViewMode == UITextFieldViewModeAlways) {
            leftMargin = CGRectGetWidth(self.leftView.bounds);
        }
        if (self.rightViewMode == UITextFieldViewModeAlways) {
            rightMargin = CGRectGetWidth(self.rightView.bounds);
        }
        return CGRectMake(leftMargin, 0, bounds.size.width - leftMargin - rightMargin, bounds.size.height);
    } else {
        return [super textRectForBounds:bounds];
    }
    
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    if (_hideCursor) {
        
        return [self textRectForBounds:bounds];
    } else {
        return [super editingRectForBounds:bounds];
    }
}

- (void)setHideCursor:(BOOL)hideCursor
{
    _hideCursor = hideCursor;
    
    if (_hideCursor == YES) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
        self.rightView = button;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    
    [self setNeedsDisplay];
}

- (void)selectCurrentValueWithAnimated:(BOOL)animated
{
    NSInteger selectedIndex = NSNotFound;
    if (self.tableView) {
        selectedIndex = [self.tableViewDatas indexOfObject:self.text];
    } else if (self.pickerView) {
        selectedIndex = [self.pickerViewDatas indexOfObject:self.text];
    }
    
//    if (selectedIndex == NSNotFound) {
//        selectedIndex = 0;
//    }
    [self selectRow:selectedIndex animated:animated];
}

- (void)selectRow:(NSInteger)row animated:(BOOL)animated
{
    if (self.tableView) {
        self.selectedIndex = row;
        if (self.selectedIndex != NSNotFound) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:animated scrollPosition:UITableViewScrollPositionTop];
        }
    } else if (self.pickerView) {
        self.selectedIndex = row;
        if (self.selectedIndex != NSNotFound) {
            [self.pickerView selectRow:self.selectedIndex inComponent:0 animated:animated];
        }
    }
}

#pragma mark - Private

- (void)setupDefaults
{
    self.defaultValue = _defaultValue;
    self.hideCursor = NO;
    self.canDeselect = NO;
    self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
//    self.textColor = [ThemeAccess generalFontColor];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.borderStyle = UITextBorderStyleNone;
}

- (void)dropdownAction:(UIButton *)sender
{
    [self becomeFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerViewDatas count];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerViewDatas objectAtTheIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tableViewDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, tableView.rowHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [cell.contentView backgroundColor];
        cell.accessoryView = imageView;
        
//        cell.doNotUseDefaultLayout = NO;
//        [cell configureBackground];
        
    }

    // Configure the cell...
    cell.textLabel.text = [self.tableViewDatas objectAtTheIndex:indexPath.row];
    if (indexPath.row == self.selectedIndex) {
        self.lastSelectedIndex = indexPath.row;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_canDeselect && indexPath.row == self.selectedIndex) {
        self.selectedIndex = NSNotFound;
//        [tableView reloadData];
    } else {
        self.selectedIndex = indexPath.row;
//        [tableView reloadData];
    }
    
    [tableView reloadData];
//    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_lastSelectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end