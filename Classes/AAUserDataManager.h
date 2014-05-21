//
//  AAUserDataManager.h
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "Amend.h"
#import "Contact.h"
#import "Resentment.h"
#import "DailyInventory.h"


@interface AAUserDataManager : NSObject

@property (nonatomic) BOOL hasUserAddressBookAccess;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

// *** CREATING OBJECTS ***

// info:    creates a singleton instance that should be shared by all objects. No controller should retain a unique copy
//          of an AAUserDataManager object
// returns: AAUserDataManager object on success, nil on failure
// use:     AAUserDataManager* manager = [AAUserDataManager sharedManager];
+ (AAUserDataManager*)sharedManager;

// info:    Creates a managed object of the desired type. The object will not be persistent unless a save event occurs
// returns: A newly created object or nil on error
// use:     Amend* amend = [manager createAmend];
- (Amend*)createAmend;
- (Contact*)createContact;
- (Resentment*)createResentment;
- (DailyInventory*)todaysDailyInventory;

- (void)deleteAmend:(Amend*)amend;
- (void)deleteResentment:(Resentment*)resentment;
- (void)deleteDailyInventory:(DailyInventory*)dailyInventory;

// *** ACCESSING PERSISTENT DATA OBJECTS ***

// info:    Convenience methods for fetching all entities of the given type,
// returns: An array containing the requested entity type sorted by creation date, or nil on error
// use:     NSArray* userAmends = [manager userAmends];
- (NSArray*)fetchUserAmends;
- (NSArray*)fetchUserResentments;
- (NSArray*)fetchUserDailyInventories;
- (NSArray*)fetchUserAAContacts;

// *** USER ADDRESS BOOK ***
- (ABRecordRef)personRecordForContact:(Contact*)contact;
- (BOOL)addContactForPersonRecord:(ABRecordRef)contact;
- (BOOL)addContactToUserAddressBook:(Contact*)contact;


// *** MAINTAINING PERSISTENCE ***

// info:    Saves the data changes to disk
// returns: void
// use:     [manager synchronize];
- (BOOL)synchronize;
- (BOOL)flush;

@end
