//
//  AppDelegate.m
//  Easy
//
//  Created by Jayce Yang on 13-12-13.
//  Copyright (c) 2013年 Jayce Yang. All rights reserved.
//

#import "AppDelegate.h"

#import "Easy.h"
#import "EntityMappingManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[CoreDataStore defaultStore] setup];
    [EntityMappingManager sharedManager];
    
    XMLDeclaration *declaration = [XMLDeclaration declarationWithVersion:@"1.0" encoding:@"utf-8"];
    
    XMLNode *categoryList  = [XMLNode nodeWithElementName:@" CategoryList"];
//    categoryList.shouldWrapBefore = NO;
//    categoryList.shouldWrapAfter = NO;
    
    XMLNode *category = [XMLNode nodeWithElementName:@"Category" attributes:@{@"ID": @"01"}];
//    category.shouldWrapBefore = NO;
//    category.shouldWrapAfter = YES;
    [categoryList addChildNode:category];
    
    XMLNode *mainCategory = [XMLNode nodeWithElementName:@"MainCategory" elementValue:@"XML"];
//    mainCategory.shouldWrapBefore = NO;
//    mainCategory.shouldWrapAfter = YES;
    [category addChildNode:mainCategory];
    
    XMLNode *description = [XMLNode nodeWithElementName:@"Description" elementValue:@"This is a list my XML articles."];
    [category addChildNode:description];
    
    XMLNode *active = [XMLNode nodeWithElementName:@"Active" elementValue:@"true"];
    active.shouldWrapBefore = NO;
    [category addChildNode:active];
    
    XMLGenerator *generator = [XMLGenerator generatorWithDeclaration:declaration rootNode:categoryList];
    NSLog(@"Generator:\n%@", [generator stringValue]);
//    NSLog(@"Category's attributes dictionary:\n%@", [category attributes]);
//    NSLog(@"Category's attributes string:\n%@", [category stringValueOfAttributes]);
//    NSLog(@"Category and it's children:\n%@", [category stringValue]);
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[CoreDataStore mainQueueContext] save];
}

@end
