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

+ (void)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.app.net/stream/0/posts/stream/global"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
            if (block) {
                [[CoreDataStore privateQueueContext] deleteObjectsForEntityForManagedObjectClass:[Post class]];
                NSArray *objectIDs = [Post managedObjectIDsForArray:postsFromResponse insertIntoManagedObjectContext:[CoreDataStore privateQueueContext]];
                block([[CoreDataStore mainQueueContext] objectsWithObjectIDs:objectIDs], nil);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            block(nil, error);
        }
    }];
}

@end
