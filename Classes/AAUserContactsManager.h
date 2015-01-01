//
//  AAUserContactsManager.h
//  Steps
//
//  Created by Tom on 12/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserDataManager.h"
#import <AddressBook/AddressBook.h>

#import "Contact.h"

@interface AAUserContactsManager : AAUserDataManager

@property (nonatomic, readonly) BOOL hasUserAddressBookAccess;

/**-----------------------------------------------------------------------------
 *  @name Accessing Manager
 *------------------------------------------------------------------------------
 */
/**
 *  Gives access to the singelton instance of AAUserContactsManager
 *
 *  @return A shared singleton instance of AAUserContactsMananger
 */
+ (instancetype)sharedManager;

/**-----------------------------------------------------------------------------
 *  @name Creating and Removing Contacts
 *------------------------------------------------------------------------------
 */

/**
 *  Creates a new, empty Contact object and places it in the user's object graph
 *
 *  @return A newly created Contact object
 */
- (Contact*)createContact;

/**
 *  Creates a new Contact object with its fields already set to the corresponding values
 *  in the given person record. If a matching contact already exists the existing contact
 *  will be returned.
 *
 *  @param person A person record from the user's iPhone Address Book
 *
 *  @return A Contact object with properties matching the person record.
 */
- (Contact*)createContactWithPersonRecord:(ABRecordRef)person;

/**
 *  Removes the given Contact object from the user's object graph
 *
 *  @param contact The Contact object to be removed
 */
- (void)removeAAContact:(Contact*)contact;

/**-----------------------------------------------------------------------------
 *  @name Fetching Contacts
 *------------------------------------------------------------------------------
 */
/**
 *  Fetches all of the user's Contacts
 *
 *  @return Array of the user's contacts sorted by last, first name, and contact ID
 */
- (NSArray*)fetchUserAAContacts;

/**
 *  Fetches the Contact object most closely matching the given person record. The Contact
 *  and person record are matched first by using the contact ID, then names, then phone
 *  numbers and emails of person record. If no acceptable match is found the method
 *  returns nil. If a matching record is found the Contact object will be updated to
 *  match the person record before being returned.
 *
 *  @param person The person record to use for fetching a matching Contact object.
 *
 *  @return A Contact object with its values set to match the person record, or nil
 *          if no matching Contact could be found.
 */
- (Contact*)fetchContactForPersonRecord:(ABRecordRef)person;

/**
 *  Fetches the address book record matching the given contact. The method for matching
 *  contacts is similar to that described by fetchContactForPersonRecord:, however the
 *  person record will not be modified to match the given Contact.
 *
 *  @param contact The contact to be matched against the user's address book.
 *
 *  @return The matching person record or nil if no match could be found.
 */
- (ABRecordRef)fetchPersonRecordForContact:(Contact*)contact;

/**
 *  Returns all the person records from the user's address book
 *
 *  @return An array of person records sorted according to the Apple documentation
 *          for ABAddressBook.
 */
- (NSArray*)fetchPersonRecords;

/**-----------------------------------------------------------------------------
 *  @name Syncing With User Address Book
 *------------------------------------------------------------------------------
 */
/**
 *  Sets the Contact's properties to match the given person record. This method does
 *  not match the records prior to synchronization. Use the syncContactWithAssociatedPersonRecord:
 *  to perform matching prior to synchronization.
 *
 *  @param contact The Contact to be synchronized.
 *  @param person  The person record to draw values from for the Contact record.
 */
- (void)syncContact:(Contact*)contact withPersonRecord:(ABRecordRef)person;

/**
 *  Matches the given Contact object with a matching person record according to the methods
 *  described by fetchContactForPersonRecord: method. Then performs a sync of the object's 
 *  values with the matching record.
 *
 *  @param contact The Contact to be synced
 *
 *  @return YES if matching and sync were successful, NO otherwise. Check console for error message.
 */
- (BOOL)syncContactWithAssociatedPersonRecord:(Contact*)contact;

/**-----------------------------------------------------------------------------
 *  @name Sponsor
 *------------------------------------------------------------------------------
 */
/**
 *  Fetches the Contact object set as the user's sponsor
 *
 *  @return The Contact set as the user's sponsor or nil if no such Contact exists.
 */
- (Contact*)fetchSponsor;

/**
 *  Sets the given contact as the user's sponsor. The current sponsor will be overwritten
 *  if it is a contact record different from the given contact.
 *
 *  @param contact The contact to be set as the user's sponsor.
 */
- (void)setContactAsSponsor:(Contact*)contact;
@end
