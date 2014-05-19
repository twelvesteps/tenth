//
//  AAUserDataManager.m
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserDataManager.h"
#import "NSDate+AAAdditions.h"
#import <CoreData/CoreData.h>

#define AA_AMEND_ITEM_NAME              @"Amend"
#define AA_DAILY_INVENTORY_ITEM_NAME    @"DailyInventory"
#define AA_RESENTMENT_ITEM_NAME         @"Resentment"

@interface AAUserDataManager ()

@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@end

@implementation AAUserDataManager

#pragma mark - Initialization

+ (instancetype)sharedManager
{
    static AAUserDataManager* sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[AAUserDataManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Fetching Objects

- (NSArray*)fetchUserAmends
{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    return [self fetchItemsForEntityName:AA_AMEND_ITEM_NAME withSortDescriptors:@[sortByDate]];
}

- (NSArray*)fetchUserDailyInventories
{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    return [self fetchItemsForEntityName:AA_DAILY_INVENTORY_ITEM_NAME withSortDescriptors:@[sortByDate]];
}

- (NSArray*)fetchUserResentments
{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    return [self fetchItemsForEntityName:AA_RESENTMENT_ITEM_NAME withSortDescriptors:@[sortByDate]];
}

- (NSArray*)fetchUserContacts
{
    return nil;
}


- (NSArray*)fetchItemsForEntityName:(NSString*)name withSortDescriptors:(NSArray*)descriptors
{
    NSError* err;
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    
    // if no descriptors were passed then sort by the date
    // this may change as the project develops
    if (!descriptors) {
        descriptors = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    }
    
    [request setEntity:description];
    [request setSortDescriptors:descriptors];
    
    NSArray* fetchResult = [self.managedObjectContext executeFetchRequest:request error:&err];
    if (!fetchResult) {
        ALog(@"<ERROR> Unable to complete request for %@ items. Error: %@, %@", name, err, err.userInfo);
    }
    
    return fetchResult;
}


#pragma mark - Creating/Deleting Objects

- (Amend*)createAmend
{
    return [NSEntityDescription insertNewObjectForEntityForName:AA_AMEND_ITEM_NAME inManagedObjectContext:self.managedObjectContext];
}

- (DailyInventory*)todaysDailyInventory
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:AA_DAILY_INVENTORY_ITEM_NAME];
    NSPredicate* startDatePredicate = [NSPredicate predicateWithFormat:@"date >= %@", [NSDate dateForStartOfToday]];
    NSPredicate* endDatePredicate = [NSPredicate predicateWithFormat:@"date <= %@", [NSDate dateForEndOfToday]];
    NSPredicate* todayPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[startDatePredicate, endDatePredicate]];
    request.predicate = todayPredicate;
    
    NSError* err;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&err];
    
    if (results.count == 0) {
        return [NSEntityDescription insertNewObjectForEntityForName:AA_DAILY_INVENTORY_ITEM_NAME inManagedObjectContext:self.managedObjectContext];
    } else if (results.count == 1) {
        return [results lastObject];
    } else {
        ALog(@"<ERROR> Database state violates invariant \"Only one inventory per day\"\n %@, %@", err, err.userInfo);
        return nil;
    }
}

- (Resentment*)createResentment
{
    return [NSEntityDescription insertNewObjectForEntityForName:AA_RESENTMENT_ITEM_NAME inManagedObjectContext:self.managedObjectContext];
}

- (void)deleteAmend:(Amend *)amend
{
    [self.managedObjectContext deleteObject:amend];
}

- (void)deleteDailyInventory:(DailyInventory *)dailyInventory
{
    [self.managedObjectContext deleteObject:dailyInventory];
}

- (void)deleteResentment:(Resentment *)resentment
{
    [self.managedObjectContext deleteObject:resentment];

}

#pragma mark - Core Data Management

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
    if (result) {
        self.managedObjectContext = nil;
        self.managedObjectModel = nil;
        self.persistentStoreCoordinator = nil;
    }
    
    return result;
}


- (NSManagedObjectContext *)managedObjectContext {
	
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [NSManagedObjectContext new];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
	
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (!_persistentStoreCoordinator) {
        
        NSString* stepItemsPath = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:@"StepItems.sqlite"];
        
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

@end
