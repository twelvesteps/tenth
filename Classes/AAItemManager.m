//
//  AAItemManager.m
//  Steps
//
//  Created by Tom on 5/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAItemManager.h"

typedef NS_ENUM(NSInteger, AAStepItemsFileAccessResult) {
    AAStepItemsFileAccessError = 0,
    AAStepItemsFileAccessSuccess = 1,
};

#define AA_ITEMS_FILE_NAME @"StepItems"

@interface AAItemManager ()

@property (strong, nonatomic) NSDictionary* stepItems;

@end

@implementation AAItemManager



+ (AAItemManager*)sharedItemManager
{
    static AAItemManager* sharedItemManager = nil;
    dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedItemManager = [[AAItemManager alloc] init];
    });
    
    return sharedItemManager;
}


- (NSArray*)getItemsForStep:(NSUInteger)step
{
    
    
    return @[];
}


- (NSArray*)getItemsSinceDate:(NSUInteger)date
{
    return @[];
}


- (NSInteger)modifyItem:(AAStepItem *)item
{
    return 0;
}


- (NSInteger)addItem:(AAStepItem *)item
{
    return 0;
}


- (NSInteger)removeItem:(AAStepItem *)item
{
    return 0;
}


- (NSDictionary*)loadDataFromStepsDocument
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString* stepsDocumentPath = [self pathForStepsDocument];
    
    if (![manager fileExistsAtPath:stepsDocumentPath])
        if ([self createStepsDocumentAtPath:stepsDocumentPath] == AAStepItemsFileAccessError) {
            return nil;
        }
    
    NSDictionary* stepItems = [NSKeyedUnarchiver unarchiveObjectWithFile:stepsDocumentPath];
    return stepItems;
}


- (AAStepItemsFileAccessResult)createStepsDocumentAtPath:(NSString*)path
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSData* empty = [NSKeyedArchiver archivedDataWithRootObject:@{}];
    
    if ([manager createFileAtPath:path contents:empty attributes:nil]) {
        DLog(@"<DEBUG> Steps document successfully created");
        return AAStepItemsFileAccessSuccess;
    } else {
        ALog(@"<ERROR> Unable to create Steps document");
        return AAStepItemsFileAccessError;
    }
}

- (NSString*)pathForStepsDocument
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray* paths = [manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* documentsDirectory = [paths firstObject];
    NSURL* stepsDocumentURL = [documentsDirectory URLByAppendingPathComponent:AA_ITEMS_FILE_NAME];
    NSString* stepsDocumentPath = [stepsDocumentURL path];
    
    return stepsDocumentPath;
}

@end
