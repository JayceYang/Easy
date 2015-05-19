//
//  XMLGenerator.h
//  Easy
//
//  Created by Jayce Yang on 15/5/19.
//  Copyright (c) 2015年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLDeclaration : NSObject

+ (instancetype)declarationWithVersion:(NSString *)version encoding:(NSString *)encoding;

@end

@interface XMLNode : NSObject

@property (readonly, copy, nonatomic) NSString *elementName;
@property (readonly, copy, nonatomic) NSDictionary *attributes;
@property (readonly, copy, nonatomic) NSString *elementValue;
@property (readonly, weak, nonatomic) XMLNode *parentNode;
@property (nonatomic) BOOL shouldWrapBefore;  //Default is YES
@property (nonatomic) BOOL shouldWrapAfter;  //Default is YES

+ (instancetype)nodeWithElementName:(NSString *)elementName;
+ (instancetype)nodeWithElementName:(NSString *)elementName attributes:(NSDictionary *)attributes;
+ (instancetype)nodeWithElementName:(NSString *)elementName elementValue:(NSString *)elementValue;
+ (instancetype)nodeWithElementName:(NSString *)elementName attributes:(NSDictionary *)attributes elementValue:(NSString *)elementValue;

- (void)addChildNode:(XMLNode *)childNode;
- (void)removeChildNode:(XMLNode *)childNode;
- (NSArray *)allChildNodes;
- (NSString *)stringValue;
- (NSString *)stringValueOfAttributes;

@end

@interface XMLGenerator : NSObject

+ (instancetype)generatorWithDeclaration:(XMLDeclaration *)declaration rootNode:(XMLNode *)rootNode;

- (NSString *)stringValue;

@end
