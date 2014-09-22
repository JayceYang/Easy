//
//  MasterViewController.m
//  Easy
//
//  Created by Jayce Yang on 13-12-13.
//  Copyright (c) 2013年 Jayce Yang. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "Easy.h"
#import "Post.h"
#import "User.h"
#import "MasterTableViewCell.h"

@interface MasterViewController ()

@property (copy, nonatomic) NSArray *posts;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.posts = [self.managedObjectContext executeFetchManagedObjectForManagedObjectClass:[Post class]];
    
    [self refresh];
    
    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(changeValue) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    __weak typeof(self) target = self;
    [Post globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error) {
//        NSLog(@"%@", posts);
        target.posts = posts;
//        target.posts = [self.managedObjectContext executeFetchManagedObjectForManagedObjectClass:[Post class]];
//        [Post logAllInManagedObjectContext:self.managedObjectContext];
        [target.tableView reloadData];
    }];
}

- (void)changeValue
{
    Post *object = [self.posts objectAtIndex:0];
    NSMutableDictionary *value = [object.dictionaryValue mutableCopy];
    value[@"description"] = [[NSDate date] stringValueWithStyleShort];
    [object updateValuesForKeysWithDictionary:value];
    [self.tableView reloadData];
//    ELog(@"%@", object.dictionaryValue);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Post *object = [self.posts objectAtIndex:indexPath.row];
    cell.userLabel.text = object.user.username;
    cell.contentLabel.text = object.text;
    // force layout
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
//    [cell setNeedsLayout];
//    [cell layoutIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Post *object = [self.posts objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object.postID];
    }
}

- (void)configureCell:(MasterTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Post *object = [self.posts objectAtIndex:indexPath.row];
    cell.userLabel.text = object.trackName;
    cell.contentLabel.text = object.text;
}

@end
