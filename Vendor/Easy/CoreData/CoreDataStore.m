//
//  CoreDataStore.m
//  Store
//
//  Created by Jayce Yang on 14-7-23.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "CoreDataStore.h"

#pragma mark - Core Data Store Interface

@interface CoreDataStore ()

@property (strong, nonatomic) dispatch_queue_t privateQueue;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *mainQueueContext;
@property (strong, nonatomic) NSManagedObjectContext *privateQueueContext;
@property (nonatomic) NSUInteger referenceCount;

@end

#pragma mark - Core Data Store Context Interface

@interface CoreDataStoreContext : NSManagedObjectContext

@property (weak, nonatomic) CoreDataStore *store;

@end

#pragma mark - Core Data Store Context Implementation

@implementation CoreDataStoreContext

- (void)dealloc {
    [[CoreDataStore defaultStore].referenceCountCondition lock];
    self.store.referenceCount--;
    [[CoreDataStore defaultStore].referenceCountCondition signal];
    [[CoreDataStore defaultStore].referenceCountCondition unlock];
}

@end

@implementation CoreDataStore

#pragma mark - Public

+ (instancetype)defaultStore {
    static CoreDataStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setup {
    @synchronized(self) {
        self.privateQueue = dispatch_queue_create("com.CoreDataStore.PrivateQueue", DISPATCH_QUEUE_CONCURRENT);
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] withExtension:@"momd"];
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSError *error = nil;
        if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:[self persistentStoreOptions] error:&error]) {
            // Delete all data if something goes wrong
            [[NSFileManager defaultManager] removeItemAtURL:[self persistentStoreURL] error:NULL];
            NSLog(@"Error adding persistent store. %@, %@", error, error.userInfo);
        } else {
            self.mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            self.mainQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
            self.mainQueueContext.mergePolicy = NSOverwriteMergePolicy;
            self.privateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            self.privateQueueContext.persistentStoreCoordinator = self.mainQueueContext.persistentStoreCoordinator;
            self.privateQueueContext.mergePolicy = self.mainQueueContext.mergePolicy;
            
            [self startReceivingContextNotifications];
        }
    }
}

- (void)clean {
    [self.mainQueueContext performBlock:^{
        [self.mainQueueContext deleteObjectsForAllEntitiesForManagedObjectModel:self.managedObjectModel];
        [self.mainQueueContext save];
    }];
}

- (void)destroy {
    @synchronized(self) {
        NSPersistentStore *persistentStore = [self.persistentStoreCoordinator persistentStoreForURL:self.persistentStoreURL];
        if (persistentStore) {
            [self stopReceivingContextNotifications];
            
            [self.mainQueueContext reset];
            [self.privateQueueContext reset];
            self.mainQueueContext = nil;
            self.privateQueueContext = nil;
            
            NSError *error = nil;
            if ([self.persistentStoreCoordinator removePersistentStore:persistentStore error:&error]) {
                [[NSFileManager defaultManager] removeItemAtURL:self.persistentStoreURL error:&error];
                if (error) {
                    NSLog(@"Remove persistent file error: %@", error.userInfo);
                }
            }
            NSLog(@"Removed persistent store.");
            self.persistentStoreCoordinator = nil;
            self.managedObjectModel = nil;
        }
    }
}

- (void)reset {
    while (true) {
        [self.referenceCountCondition lock];
        if (self.referenceCount == 0) {
            [self destroy];
            [self setup];
            [self.referenceCountCondition unlock];
            break;
        } else {
            [self.referenceCountCondition wait];
        }
    }
}

+ (dispatch_queue_t)privateQueue {
    return [[self defaultStore] privateQueue];
}

+ (NSManagedObjectModel *)managedObjectModel {
    return [[self defaultStore] managedObjectModel];
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    return [[self defaultStore] persistentStoreCoordinator];
}

+ (NSManagedObjectContext *)mainQueueContext {
    return [[self defaultStore] mainQueueContext];
}

+ (NSManagedObjectContext *)privateQueueContext {
    return [[self defaultStore] privateQueueContext];
}

+ (NSManagedObjectContext *)newMainQueueContext {
    return [[self defaultStore] newMainQueueContext];
}

+ (NSManagedObjectContext *)newPrivateQueueContext {
    return [[self defaultStore] newPrivateQueueContext];
}

+ (NSManagedObjectContext *)newContextWithParentContext:(NSManagedObjectContext *)parentContext concurrencyType: (NSManagedObjectContextConcurrencyType) concurrencyType {
    return [[self defaultStore] newContextWithParentContext:parentContext concurrencyType:concurrencyType];
}

+ (NSURL *)persistentStoreURL {
    return [[self defaultStore] persistentStoreURL];
}

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    [self stopReceivingContextNotifications];
}

#pragma mark - Private

- (NSURL *)persistentStoreURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *fileName = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] stringByAppendingString:@".sqlite"];
    NSString *directoryName = @"CoreData";
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:directoryName];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if (error) {
        NSLog(@"Can't create directory at path %@, and the localized description is \"%@\"", filePath, [error localizedDescription]);
        return [documentURL URLByAppendingPathComponent:fileName];
    } else {
        // add skip backup attribute
        NSURL *directoryURL = [documentURL URLByAppendingPathComponent:directoryName];
        BOOL success = [directoryURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [directoryURL lastPathComponent], error);
        }
        
        return [[documentURL URLByAppendingPathComponent:directoryName] URLByAppendingPathComponent:fileName];
    }
}

- (NSDictionary *)persistentStoreOptions {
    return @{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES, NSSQLitePragmasOption: @{@"synchronous": @"OFF"}};
}

- (void)startReceivingContextNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSavePrivateQueueContext:)name:NSManagedObjectContextDidSaveNotification object:self.privateQueueContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveMainQueueContext:) name:NSManagedObjectContextDidSaveNotification object:self.mainQueueContext];
}

- (void)stopReceivingContextNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSManagedObjectContext *)newMainQueueContext {
    [self.referenceCountCondition lock];
    CoreDataStoreContext *context = [[CoreDataStoreContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.parentContext = self.mainQueueContext;
    context.store = self;
    self.referenceCount++;
    [self.referenceCountCondition unlock];
    return context;
}

- (NSManagedObjectContext *)newPrivateQueueContext {
    [self.referenceCountCondition lock];
    CoreDataStoreContext *context = [[CoreDataStoreContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = self.privateQueueContext;
    context.store = self;
    self.referenceCount++;
    [self.referenceCountCondition unlock];
    return context;
}

#pragma mark - Notifications

- (void)contextDidSavePrivateQueueContext:(NSNotification *)notification {
    @synchronized(self) {
        [self.mainQueueContext performBlockAndWait:^{
            [[CoreDataStore defaultStore].referenceCountCondition lock];
            /*
             Guess this is a bug of Core Data, more info see:
             http://stackoverflow.com/questions/3923826/nsfetchedresultscontroller-with-predicate-ignores-changes-merged-from-different/3927811#3927811
             */
            NSManagedObjectContext *context = self.mainQueueContext;
            for (NSManagedObject *object in [[notification userInfo] objectForKey:NSUpdatedObjectsKey]) {
                if (object.managedObjectContext != context && object.managedObjectContext != self.privateQueueContext) {
                    return;
                }
                [[context objectWithID:[object objectID]] willAccessValueForKey:nil];
            }
            [context mergeChangesFromContextDidSaveNotification:notification];
            [[CoreDataStore defaultStore].referenceCountCondition unlock];
            
//            [self.mainQueueContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

- (void)contextDidSaveMainQueueContext:(NSNotification *)notification {
    @synchronized(self) {
        [self.privateQueueContext performBlockAndWait:^{
            [self.privateQueueContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

@end
