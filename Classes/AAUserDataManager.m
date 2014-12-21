//
//  AAUserDataManager.m
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserDataManager.h"
#import <CoreData/CoreData.h>





@interface AAUserDataManager ()


@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;


@end

@implementation AAUserDataManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager
{
    return nil;
}


#pragma mark - Fetching Objects

- (NSArray*)fetchItemsForEntityName:(NSString*)name
                withSortDescriptors:(NSArray*)descriptors
                      withPredicate:(NSPredicate*)predicate
{
    NSError* err;
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:name];
    
    request.sortDescriptors = descriptors;
    request.predicate = predicate;
    
    NSArray* fetchResult = [self.managedObjectContext executeFetchRequest:request error:&err];
    if (!fetchResult) {
        ALog(@"<ERROR> Unable to complete request for %@ items. Error: %@, %@", name, err, err.userInfo);
    }
    
    return fetchResult;
}


#pragma mark - Core Data Management

- (NSManagedObjectContext *)managedObjectContext {
	
    if (!_managedObjectContext) {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator != nil) {
            _managedObjectContext = [NSManagedObjectContext new];
            [_managedObjectContext setPersistentStoreCoordinator: coordinator];
        }
    }
    
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (!_persistentStoreCoordinator) {
        
        NSString* stepItemsPath = [[[self applicationDocumentsDirectory] path]
                                   stringByAppendingPathComponent:@"StepItems.sqlite"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:stepItemsPath]) {
            [[NSFileManager defaultManager] createFileAtPath:stepItemsPath contents:nil attributes:nil];
        }
        
        _persistentStoreCoordinator =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSError *error;
        NSURL *stepItemsURL = [NSURL fileURLWithPath:stepItemsPath];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:stepItemsURL
                                                             options:nil
                                                               error:&error]) {
            ALog(@"<ERROR> Unable to open Step Items database. Error %@", error);
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}


#pragma mark - Persistence

- (BOOL)synchronize
{
    NSError* err;
    BOOL result = [self.managedObjectContext save:&err];
    
    if (!result) {
        ALog(@"<ERROR> Unable to save changes to file\nError: %@, User Info: %@", err, [err userInfo]);
    }
    
    return result;
}

- (BOOL)flush
{
    BOOL result = [self synchronize];
    
    // if save was successful continue
    if (result) {
        // clean core data memory
        self.managedObjectContext = nil;
        self.managedObjectModel = nil;
        self.persistentStoreCoordinator = nil;
    } else {
        ALog(@"<ERROR> Unable to save changes to user data, aborting flush. Check log for error details");
    }
    
    return result;
}

@end
