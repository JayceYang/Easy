//
//  Post.m
//  Easy
//
//  Created by Jayce Yang on 14-7-23.
//  Copyright (c) 2014年 Personal. All rights reserved.
//

#import "Post.h"
#import "User.h"

#import "Easy.h"

@implementation Post

@dynamic postID;
@dynamic text;
@dynamic trackName;
@dynamic user;

+ (NSOperationQueue *)sharedOperationQueue {
    static NSOperationQueue *_sharedProfileImageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedProfileImageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_sharedProfileImageRequestOperationQueue setMaxConcurrentOperationCount:0];
    });
    
    return _sharedProfileImageRequestOperationQueue;
}

+ (void)globalTimelinePostsWithBlock:(void (^)(NSError *error))block {
    
    NSManagedObjectContext *managedObjectContext = [CoreDataStore privateQueueContext];
    NSString *entityName = NSStringFromClass([self class]);
    
    // new entities from networking
    NSMutableArray *entities = [@[] mutableCopy];
    NSMutableArray *latestIDs = [@[] mutableCopy];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=599957686&entity=software"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        if (data) {
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error == nil) {
                NSMutableArray *results = [[JSON valueForKeyPath:@"results"] mutableCopy];
                [results removeObjectAtIndex:0];
                NSUInteger count = [results count];
                for (NSUInteger counter = 0; counter < count; counter ++) {
                    NSDictionary *dictionary = results[counter];
                    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
                    // create an managed object, but don't insert it in our managed object context yet
                    Post *entity = [[Post alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
                    entity.postID = [dictionary[@"trackId"] theStringValue];
                    [entities addObject:entity];
                    if (entity.postID) {
                        [latestIDs addObject:entity.postID];
                    }
                }
                
                // fetch existing entities
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                fetchRequest.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
                // before adding the entity, first check if there's a duplicate in the backing store
                for (NSUInteger counter = 0; counter < count; counter ++) {
                    NSDictionary *dictionary = results[counter];
                    Post *entity = [entities objectAtIndex:counter];
                    //            ELog(@"%@", entity.postID);
                    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"postID == %@", entity.postID];
                    NSArray *existingEntities = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
                    if (existingEntities.count == 0) {
                        // we found no duplicate entity, so insert this new one and update the value
                        [managedObjectContext insertObject:entity];
                    } else {
                        // update the value
                        entity = [existingEntities firstObject];
                    }
                    [entity updateValuesForKeysWithDictionary:dictionary];
                }
                
                // delete those are not in the latest data as well as the shopping cart item associated
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (postID IN %@)", latestIDs];
                [managedObjectContext deleteObjectsForEntityForManagedObjectClass:[self class] predicate:predicate];
                [managedObjectContext save];
//                [Post logAllInManagedObjectContext:managedObjectContext];
                if (block) {
                    block(nil);
                }
            } else {
                NSLog(@"%@", error.localizedDescription);
                block(error);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            block(error);
        }
    }];
}

@end
