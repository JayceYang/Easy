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

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.posts = [self.managedObjectContext executeFetchManagedObjectForManagedObjectClass:[Post class]];
    
    [self refresh];
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
        NSLog(@"%@", posts);
        target.posts = posts;
        [target.tableView reloadData];
    }];
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSManagedObject *object = [self.posts objectAtIndex:indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [self.posts objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (void)configureCell:(MasterTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Post *object = [self.posts objectAtIndex:indexPath.row];
    cell.userLabel.text = object.user.username;
    cell.contentLabel.text = object.text;
}

@end
