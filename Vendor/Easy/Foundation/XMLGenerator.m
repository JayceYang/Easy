//
//  XMLGenerator.m
//  Easy
//
//  Created by Jayce Yang on 15/5/19.
//  Copyright (c) 2015年 Personal. All rights reserved.
//

#import "XMLGenerator.h"

#pragma mark - XMLDeclaration

@interface XMLDeclaration ()

@property (copy, nonatomic) NSString *version;
@property (copy, nonatomic) NSString *encoding;

@end

@implementation XMLDeclaration

+ (instancetype)declarationWithVersion:(NSString *)version encoding:(NSString *)encoding {
    XMLDeclaration *instance = [[XMLDeclaration alloc] init];
    instance.version = version;
    instance.encoding = encoding;
    return instance;
}

//- (void)dealloc {
//    NSLog(@"%@", [@"dealloc in " stringByAppendingString:NSStringFromClass([self class])]);
//}

- (NSString *)stringValue {
    if (self.version.length == 0 || self.encoding.length == 0) {
        return [NSString string];
    } else {
        return [NSString stringWithFormat:@"<?xml version=\"%@\" encoding=\"%@\"?>", self.version, self.encoding];
    }
}

@end

#pragma mark - XMLNode

@interface XMLNode ()

@property (copy, nonatomic) NSString *elementName;
@property (copy, nonatomic) NSDictionary *attributes;
@property (copy, nonatomic) NSString *elementValue;
@property (strong, nonatomic) NSMutableArray *childNodes;
@property (weak, nonatomic) XMLNode *parentNode;

@end

@implementation XMLNode

+ (instancetype)nodeWithElementName:(NSString *)elementName {
    return [self nodeWithElementName:elementName attributes:nil elementValue:nil];
}

+ (instancetype)nodeWithElementName:(NSString *)elementName attributes:(NSDictionary *)attributes {
    return [self nodeWithElementName:elementName attributes:attributes elementValue:nil];
}

+ (instancetype)nodeWithElementName:(NSString *)elementName elementValue:(NSString *)elementValue {
    return [self nodeWithElementName:elementName attributes:nil elementValue:elementValue];
}

+ (instancetype)nodeWithElementName:(NSString *)elementName attributes:(NSDictionary *)attributes elementValue:(NSString *)elementValue {
    XMLNode *instance = [[XMLNode alloc] init];
    instance.elementName = elementName;
    instance.attributes = attributes;
    instance.elementValue = elementValue;
    instance.shouldWrapBefore = YES;
    instance.shouldWrapAfter = YES;
    return instance;
}

//- (void)dealloc {
//    NSLog(@"%@", [@"dealloc in " stringByAppendingString:NSStringFromClass([self class])]);
//}

- (void)addChildNode:(XMLNode *)childNode {
    if (childNode) {
        if (self.childNodes == nil) {
            self.childNodes = [NSMutableArray array];
        }
        
        [self.childNodes addObject:childNode];
        childNode.parentNode = self;
    } else {
        NSLog(@"Ignore nil node");
    }
}

- (void)removeChildNode:(XMLNode *)childNode {
    if (childNode) {
        childNode.parentNode = nil;
        [self.childNodes removeObject:childNode];
    } else {
        NSLog(@"Ignore nil node");
    }
}

- (NSArray *)allChildNodes {
    return [self.childNodes copy];
}

- (NSString *)stringValue {
    NSString *spaceOrEmptyString = [NSString string];
    if (self.attributes.count > 0) {
        spaceOrEmptyString = @" ";
    }
    return [NSString stringWithFormat:@"<%@%@%@>%@", self.elementName, spaceOrEmptyString, [self stringValueOfAttributes], [self stringValueRemaining]];
}

- (NSString *)stringValueOfAttributes {
    if (self.attributes.count == 0) {
        return [NSString string];
    } else {
        NSMutableString *result = [NSMutableString string];
        for (NSUInteger counter = 0; counter < self.attributes.count; counter ++) {
            NSString *key = self.attributes.allKeys[counter];
            NSString *value = self.attributes[key];
            if (counter != self.attributes.count - 1) {
                [result appendFormat:@"%@=\"%@\" ", key, value];
            } else {
                [result appendFormat:@"%@=\"%@\"", key, value];
            }
        }
        return [result copy];
    }
}

- (NSString *)stringValueRemaining {
    NSString *result = [NSString string];
    if (self.childNodes.count != 0) {
        XMLNode *firstChildNode  = [self.childNodes firstObject];
        BOOL shouldWrapBefore = firstChildNode.shouldWrapBefore;
        result = shouldWrapBefore ? @"\n" : [NSString string];
        for (NSUInteger counter = 0; counter < self.childNodes.count; counter ++) {
            XMLNode *node = self.childNodes[counter];
            XMLNode *nextNode = nil;
            if (counter != self.childNodes.count - 1) {
                nextNode = self.childNodes[counter + 1];
            }
            BOOL shouldWrapAfter = nextNode ? nextNode.shouldWrapBefore : node.shouldWrapAfter;
            result = [NSString stringWithFormat:@"%@%@%@", result, node.stringValue, shouldWrapAfter ? @"\n" : [NSString string]];
        }
        result = [NSString stringWithFormat:@"%@</%@>", result, self.elementName];
    } else {
        NSString *elementValue = self.elementValue.length > 0 ? self.elementValue : [NSString string];
        result = [NSString stringWithFormat:@"%@</%@>", elementValue, self.elementName];
    }
    return [result copy];
}

@end

#pragma mark - XMLGenerator

@interface XMLGenerator ()

@property (strong, nonatomic) XMLDeclaration *declaration;
@property (strong, nonatomic) XMLNode *rootNode;

@end

@implementation XMLGenerator

+ (instancetype)generatorWithDeclaration:(XMLDeclaration *)declaration rootNode:(XMLNode *)rootNode {
    XMLGenerator *instance = [[XMLGenerator alloc] init];
    instance.declaration = declaration;
    instance.rootNode = rootNode;
    return instance;
}

//- (void)dealloc {
//    NSLog(@"%@", [@"dealloc in " stringByAppendingString:NSStringFromClass([self class])]);
//}

- (NSString *)stringValue {
    if (!self.declaration || !self.rootNode) {
        return [NSString string];
    } else {
        return [[self.declaration stringValue] stringByAppendingFormat:@"%@%@", self.rootNode.shouldWrapBefore ? @"\n" : [NSString string], [self.rootNode stringValue]];
    }
}

@end
