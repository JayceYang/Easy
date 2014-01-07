//
//  XMLParser.h
//  Library
//
//  Created by Jayce Yang on 12-4-13.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "XMLParser.h"

@interface XMLParser ()

@property (strong, nonatomic) NSMutableArray *dictionaryStack;
@property (strong, nonatomic) NSMutableString *textInProgress;
@property (copy, nonatomic) NSCharacterSet *trimmingCharacterSet;

@end


@implementation XMLParser

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark -
#pragma mark Public methods

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data
{
    XMLParser *parser = [[XMLParser alloc] init];
    NSDictionary *rootDictionary = [parser objectWithData:data options:XMLParserOptionsProcessNamespaces];
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XMLParser dictionaryForXMLData:data];
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data options:(XMLParserOptions)options
{
    XMLParser *parser = [[XMLParser alloc] init];
    NSDictionary *rootDictionary = [parser objectWithData:data options:options];
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string options:(XMLParserOptions)options
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XMLParser dictionaryForXMLData:data options:options];
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data trimmingCharacterSet:(NSCharacterSet *)set
{
    XMLParser *parser = [[XMLParser alloc] init];
    parser.trimmingCharacterSet = set;
    NSDictionary *rootDictionary = [parser objectWithData:data options:XMLParserOptionsProcessNamespaces];
    return rootDictionary;
}

#pragma mark -
#pragma mark Parsing

- (NSDictionary *)objectWithData:(NSData *)data options:(XMLParserOptions)options
{
    // Clear out any old data
    self.dictionaryStack = [NSMutableArray array];
    self.textInProgress = [NSMutableString string];
    
    // Initialize the stack with a fresh dictionary
    [_dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    [parser setShouldProcessNamespaces:(options & XMLParserOptionsProcessNamespaces)];
    [parser setShouldReportNamespacePrefixes:(options & XMLParserOptionsReportNamespacePrefixes)];
    [parser setShouldResolveExternalEntities:(options & XMLParserOptionsResolveExternalEntities)];
    
    parser.delegate = self;
    BOOL success = [parser parse];
    
    // Return the stack's root dictionary on success
    if (success) {
        NSDictionary *resultDict = [_dictionaryStack objectAtIndex:0];
        return resultDict;
    } else {
        return nil;
    }
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [_dictionaryStack lastObject];

    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there's already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue) {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]]) {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        } else {
            // Create an array if it doesn't exist
            array = [NSMutableArray array];
            [array addObject:existingValue];

            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    } else {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [_dictionaryStack addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Pop the current dict
    [_dictionaryStack removeLastObject];
    
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [_dictionaryStack lastObject];
        
    // Set the text property
    if ([_textInProgress length] > 0) {
        [dictInProgress setObject:_textInProgress forKey:elementName];

        // Reset the text
        self.textInProgress = [NSMutableString string];
    } else if ([[dictInProgress objectForKey:elementName] count] == 0) {
        // Change the empty nodes dict to string
//        [dictInProgress setObject:_textInProgress forKey:elementName];
        [dictInProgress setObject:[NSString string] forKey:elementName];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    if (_trimmingCharacterSet) {
        [_textInProgress appendString:[string stringByTrimmingCharactersInSet:_trimmingCharacterSet]];
    } else {
        [_textInProgress appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@", [parseError localizedDescription]);
}

@end
