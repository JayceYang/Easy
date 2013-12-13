//
//  NSOperation+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 13-8-27.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <objc/runtime.h>

#import "NSOperation+Easy.h"

static char RequestTypeKey;
static char NetworkingCompletionHandlerKey;

@interface NSOperation ()

//@property (nonatomic) RequestType requestType;

@end

@implementation NSOperation (Easy)

- (RequestType)requestType
{
    NSNumber *value = objc_getAssociatedObject(self, &RequestTypeKey);
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    } else {
        return RequestTypeUndefined;
    }
}

- (void)setRequestType:(RequestType)requestType
{
    [self willChangeValueForKey:@"requestType"];
    objc_setAssociatedObject(self, &RequestTypeKey, [NSNumber numberWithInteger:requestType], OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"requestType"];
}

- (NetworkingCompletionHandler)completionHandler
{
    return objc_getAssociatedObject(self, &NetworkingCompletionHandlerKey);
}

- (void)setCompletionHandler:(NetworkingCompletionHandler)completionHandler
{
    [self willChangeValueForKey:@"completionHandler"];
    objc_setAssociatedObject(self, &NetworkingCompletionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"completionHandler"];
}

@end
