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

// *** USER SETTINGS ***
// info:    The following keys are used for accessing user settings
#define AA_USER_SETTING_USE_ADDRESS_BOOK    @"AddressBook"      // NSNumber (boolean)
#define AA_USER_SETTING_USE_LOCK_SCREEN     @"LockScreen"       // NSNumber (boolean)
#define AA_USER_SETTING_SPONSOR             @"Sponsor"          // NSDictionary
#define AA_USER_SETTING_SPONSOR_FIRST_NAME  @"SponsorFirstName" // NSString
#define AA_USER_SETTING_SPONSOR_LAST_NAME   @"SponsorLastName"  // NSString
#define AA_USER_SETTING_SPONSOR_CONTACT_ID  @"SponsorContactID" // NSNumber (int)

@interface AAUserDataManager : NSObject

@property (nonatomic, readonly) BOOL hasUserAddressBookAccess;

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;


// *** CREATING OBJECTS ***

// info:    creates a singleton instance that should be shared by all objects. No controller should retain a unique copy
//          of an AAUserDataManager object
// returns: AAUserDataManager object on success, nil on failure
// use:     AAUserDataManager* manager = [AAUserDataManager sharedManager];
+ (AAUserDataManager*)sharedManager;

// info:    Creates an empty managed object of the desired type. The object will not be persistent unless a save event occurs
// returns: A newly created object or nil on error
// use:     Amend* amend = [manager createAmend];
- (Amend*)createAmend;
- (Resentment*)createResentment;
- (Contact*)createContact;

// info:    Creates a managed contact object with the properties of the address book contact already set
// returns: A newly created managed contact or nil on error
// use:     Contact* contact = [manager createContactWithPersonRecord:person];
- (Contact*)createContactWithPersonRecord:(ABRecordRef)person;

// info:    Creates a managed inventory for the current date if it does not already exist or fetches the inventory for today
// returns: An inventory for the current day (based on user's local calendar) or nil on error
// use:     DailyInventory* todaysInventory = [manager todaysDailyInventory];
- (DailyInventory*)todaysDailyInventory;

- (void)removeAmend:(Amend*)amend;
- (void)removeResentment:(Resentment*)resentment;
- (void)removeDailyInventory:(DailyInventory*)dailyInventory;
- (void)removeAAContact:(Contact*)contact;


// *** ACCESSING PERSISTENT DATA OBJECTS ***

// info:    Convenience methods for fetching all entities of the given type,
// returns: An array containing the requested entity type sorted by creation date, or nil on error
// use:     NSArray* userAmends = [manager userAmends];
- (NSArray*)fetchUserAmends;
- (NSArray*)fetchUserResentments;
- (NSArray*)fetchUserDailyInventories;
- (NSArray*)fetchUserAAContacts;

// info:
// returns:
// use:
- (Contact*)fetchContactForPersonRecord:(ABRecordRef)person;
- (Contact*)fetchSponsor;
- (void)setContactAsSponsor:(Contact*)contact;


// *** USER ADDRESS BOOK ***
// info:    These methods allow translation between a managed object and an address book record.
// returns: The requested person record or contact, NULL or nil on error or person not found
// use:     ABRecrdRef contactFromPhone = [manager personRecordFromAddressBookForContact:managedContact];
- (ABRecordRef)fetchPersonRecordForContact:(Contact*)contact;
- (void)syncContact:(Contact*)contact withPersonRecord:(ABRecordRef)person;

// info:    Fetches the address book record for the contact and syncs their properties.
// returns: YES if the contact was synced and no if the person record could not be found
// use:     BOOL contactSynced = [manager syncContactWithAssociatedPersonRecord:contact];
- (BOOL)syncContactWithAssociatedPersonRecord:(Contact*)contact;


// *** MAINTAINING PERSISTENCE ***

// info:    Saves the data changes to disk
// returns: void
// use:     [manager synchronize];
- (BOOL)synchronize;
- (BOOL)flush;

@end
