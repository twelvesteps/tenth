//
//  Phone.h
//  Steps
//
//  Created by tom on 5/22/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface Phone : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) Contact *contact;

@end
