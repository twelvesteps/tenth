//
//  AAUserDataManager.h
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "Contact.h"
#import "Meeting+AAAdditions.h"

@interface AAUserDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;


@property (nonatomic, readonly) BOOL hasUserAddressBookAccess;

// *** CREATING OBJECTS ***
// info:    creates a singleton instance that should be shared by all objects. No controller should retain a unique copy
//          of an AAUserDataManager object
// returns: AAUserDataManager object on success, nil on failure
// use:     AAUserDataManager* manager = [AAUserDataManager sharedManager];
+ (AAUserDataManager*)sharedManager;

// info:    Creates an empty managed object of the desired type. The object will not be persistent unless a save event occurs
// returns: A newly created object or nil on error
// use:     Amend* amend = [manager createAmend];
- (Contact*)createContact;
- (Meeting*)createMeeting;

// info:    Creates a managed contact object with the properties of the address book contact already set
// returns: A newly created managed contact or nil on error
// use:     Contact* contact = [manager createContactWithPersonRecord:person];
- (Contact*)createContactWithPersonRecord:(ABRecordRef)person;

// info:    Creates a managed inventory for the current date if it does not already exist or fetches the inventory for today
// returns: An inventory for the current day (based on user's local calendar) or nil on error
// use:     DailyInventory* todaysInventory = [manager todaysDailyInventory];
- (void)removeAAContact:(Contact*)contact;
- (void)removeMeeting:(Meeting*)meeting;


// *** ACCESSING PERSISTENT DATA OBJECTS ***
// info:    Convenience methods for fetching all entities of the given type,
// returns: An array containing the requested entity type sorted by creation date, or nil on error
// use:     NSArray* userAmends = [manager userAmends];
- (NSArray*)fetchUserAAContacts; // sorted by last name, first name, contact ID
- (NSArray*)fetchMeetings; // sorted by startDate

// info: Returns the managed contact object associated with the given person record
// returns: A managed contact or nil if the record cannot be located
// use: Contact* contact = [manager fetchContactForPersonRecord:person];
- (Contact*)fetchContactForPersonRecord:(ABRecordRef)person;

// info: Returns the managed contact object currently set as the user's sponsor
// returns: The user's sponsor or nil if no sponsor has been set
// use: Contact* sponsor = [manager fetchSponsor];
- (Contact*)fetchSponsor;

// info: Sets the given contact as the user's sponsor. Only one contact is allowed as a sponsor at a time.
//       The user's current sponsor (if any) will have this designation removed.
// use: [manager setContactAsSponsor:newSponsor];
- (void)setContactAsSponsor:(Contact*)contact;


// *** USER ADDRESS BOOK ***
// info:    These methods allow translation between a managed object and an address book record.
// returns: The requested person record or contact, NULL or nil on error or person not found
// use:     ABRecrdRef contactFromPhone = [manager personRecordFromAddressBookForContact:managedContact];
- (ABRecordRef)fetchPersonRecordForContact:(Contact*)contact;
- (NSArray*)fetchPersonRecords;
- (void)syncContact:(Contact*)contact withPersonRecord:(ABRecordRef)person;

// info:    Fetches the address book record for the contact and syncs their properties.
// returns: YES if the contact was synced and no if the person record could not be found
// use:     BOOL contactSynced = [manager syncContactWithAssociatedPersonRecord:contact];
- (BOOL)syncContactWithAssociatedPersonRecord:(Contact*)contact;

// *** USER MEETING CALENDAR ***
//


// *** MAINTAINING PERSISTENCE ***
// info:    Saves the data changes to disk
// returns: void
// use:     [manager synchronize];
- (BOOL)synchronize;
- (BOOL)flush;

@end
