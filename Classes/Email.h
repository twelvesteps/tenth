//
//  Email.h
//  Steps
//
//  Created by tom on 5/22/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface Email : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) Contact *contact;

@end
