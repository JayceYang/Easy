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

- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (self) {
        // Initialization code
        
        [self makePropertyNamesMappingForKey:@"postID" sourceKey:@"trackId"];
        [self makePropertyNamesMappingForKey:@"text" sourceKey:@"description"];
        
    }
    return self;
}

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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=599957686&entity=software"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            NSMutableArray *postsFromResponse = [[JSON valueForKeyPath:@"results"] mutableCopy];
            [postsFromResponse removeObjectAtIndex:0];
            if (block) {
                [[CoreDataStore privateQueueContext] deleteObjectsForEntityForManagedObjectClass:[Post class]];
                NSArray *objectIDs = [Post managedObjectIDsForArray:postsFromResponse insertIntoManagedObjectContext:[CoreDataStore privateQueueContext]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    block([[CoreDataStore mainQueueContext] objectsWithObjectIDs:objectIDs], nil);
                });
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            block(nil, error);
        }
    }];
}

@end
