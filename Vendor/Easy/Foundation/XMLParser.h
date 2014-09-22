//
//  XMLParser.h
//  Library
//
//  Created by Jayce Yang on 12-4-13.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    XMLParserOptionsProcessNamespaces           = 1 << 0, // Specifies whether the receiver reports the namespace and the qualified name of an element.
    XMLParserOptionsReportNamespacePrefixes     = 1 << 1, // Specifies whether the receiver reports the scope of namespace declarations.
    XMLParserOptionsResolveExternalEntities     = 1 << 2, // Specifies whether the receiver reports declarations of external entities.
};
typedef NSUInteger XMLParserOptions;

@interface XMLParser : NSObject <NSXMLParserDelegate>

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string;
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data options:(XMLParserOptions)options;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string options:(XMLParserOptions)options;

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data trimmingCharacterSet:(NSCharacterSet *)set;

@end
