//
//  NSArray+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "NSArray+Easy.h"

#import "NSString+Easy.h"
#import "Macro.h"

@implementation NSArray (Easy)

- (id)objectAtTheIndex:(NSUInteger)index
{
    id result = nil;
    @try {
        result = [self objectAtIndex:index];
    }
    @catch (NSException *exception) {
//        ELog(@"%@",exception.reason);
    }
    @finally {
        return result;
    }
}

- (id)theFirstObject
{
    return [self objectAtTheIndex:0];
}

- (id)theLastObject
{
    if (self.count >= 1) {
        return [self objectAtTheIndex:self.count - 1];
    } else {
        return [self objectAtTheIndex:0];
    }
}

- (NSArray *)sortedArrayUsingIndexOfWSDL
{
    NSArray *result = nil;
    @try {
        result = [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSManagedObject *object = obj1;
            NSManagedObject *objectAnother = obj2;
            NSNumber *objectIDNumber = [[[[[[[object objectID] URIRepresentation] absoluteString] componentsSeparatedByString:@"/"] lastObject] substringFromIndex:1] numberValue];
            NSNumber *objectIDNumberAnother = [[[[[[[objectAnother objectID] URIRepresentation] absoluteString] componentsSeparatedByString:@"/"] lastObject] substringFromIndex:1] numberValue];
            return [objectIDNumber compare:objectIDNumberAnother];
        }];
    }
    @catch (NSException *exception) {
        ELog(@"%@", exception.reason);
    }
    @finally {
        if (result.count == 0) {
            result = self;
        }
        return result;
    }
}

- (NSArray *)sortedArrayUsingKeyPath:(NSString *)path
{
    return [self sortedArrayUsingKeyPath:path ascending:NO];
}

- (NSArray *)sortedArrayUsingKeyPath:(NSString *)path ascending:(BOOL)ascending
{
    NSArray *result = nil;
    @try {
        result = [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSManagedObject *object = obj1;
            NSManagedObject *objectAnother = obj2;
            NSNumber *number = [object valueForKeyPath:path];
            NSNumber *numberAnother = [objectAnother valueForKeyPath:path];
            if (ascending) {
                return [number compare:numberAnother];
            } else {
                return [numberAnother compare:number];
            }
        }];
    }
    @catch (NSException *exception) {
        ELog(@"%@", exception.reason);
    }
    @finally {
        if (result.count == 0) {
            result = self;
        }
        return result;
    }
}

@end
