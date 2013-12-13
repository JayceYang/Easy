//
//  NSDictionary+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 13-10-15.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import "NSDictionary+Easy.h"

#import "Macro.h"

@implementation NSDictionary (Easy)

- (id)objectForTreeStyleKey:(NSString*)key
{
    NSDictionary *result = nil;
    @try {
        NSArray *keys = [key componentsSeparatedByString:@"/"];
        NSDictionary *dictionary = [self copy];
        NSInteger count = [keys count];
        for (NSInteger n = 0; n < count - 1; n ++) {
            dictionary = [dictionary objectForKey:[keys objectAtIndex:n]];
        }
        result = [dictionary objectForKey:[keys objectAtIndex:count - 1]];
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception.reason);
    }
    @finally {
        return result;
    }
	
	
}

@end
