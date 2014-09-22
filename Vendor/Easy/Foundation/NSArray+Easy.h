//
//  NSArray+Easy.h
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Easy)

- (id)objectAtTheIndex:(NSUInteger)index;
- (id)theFirstObject;
- (id)theLastObject;

- (NSArray *)sortedArrayUsingIndexOfWSDL;
- (NSArray *)sortedArrayUsingKeyPath:(NSString *)path;
- (NSArray *)sortedArrayUsingKeyPath:(NSString *)path ascending:(BOOL)ascending;

//- (BOOL)containsObject:(id)anObject

@end
