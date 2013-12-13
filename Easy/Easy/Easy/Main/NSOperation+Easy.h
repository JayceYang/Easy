//
//  NSOperation+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 13-8-27.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeUndefined,
    RequestTypeGetDedicatedVideo,
    RequestTypeGetDedicatedVideoCount,
    RequestTypeDedicatedVideoSetViewed
};

typedef void(^NetworkingCompletionHandler)(id data, NSError *error);

@interface NSOperation (Easy)

@property (nonatomic) RequestType requestType;
@property (copy, nonatomic) NetworkingCompletionHandler completionHandler;

@end
