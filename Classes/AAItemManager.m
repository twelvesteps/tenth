//
//  AAItemManager.m
//  Steps
//
//  Created by Tom on 5/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAItemManager.h"



#define AA_ITEMS_FILE_NAME @"StepItems"

@interface AAItemManager ()

@property (nonatomic) BOOL dataWasModified;
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


- (NSDictionary*)stepItems
{
    if (!_stepItems) _stepItems = [self getDataFromStepsFile];
    return _stepItems;
}


- (NSArray*)getItemsForStep:(NSUInteger)step
{
    if (step < 1 || step > 12) {
        DLog(@"<DEBUG> Step parameter is outside allowed bounds, requested step was: %d", (int)step);
        return nil;
    }
    
    NSArray* requestedStepItems = [self.stepItems objectForKey:[NSString stringWithFormat:@"%d", (int)step]];
    return requestedStepItems;
}


- (void)updateStepItemsForStep:(NSUInteger)step withItems:(NSArray *)items
{
    NSMutableDictionary* mutableStepItems = [self.stepItems mutableCopy];
    NSString* stepNumberKey = [NSString stringWithFormat:@"%d", (int)step];
    
    [mutableStepItems setObject:items forKey:stepNumberKey];
    self.stepItems = [mutableStepItems copy];
    self.dataWasModified = YES;
}

- (AAStepItemsFileAccessResult)synchronize
{
    BOOL result = [NSKeyedArchiver archiveRootObject:self.stepItems toFile:[self pathForStepsDocument]];
    
    if (!result) {
        ALog("<ERROR> Unable to write step items to file");
    } else {
        self.dataWasModified = NO;
    }
    
    return result ? AAStepItemsFileAccessSuccess : AAStepItemsFileAccessError;
}

- (AAStepItemsFileAccessResult)flush
{
    AAStepItemsFileAccessResult result = [self synchronize];
    if (result == AAStepItemsFileAccessSuccess) {
        self.stepItems = nil;
    }
    
    return result;
}

- (NSDictionary*)getDataFromStepsFile
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
    NSMutableDictionary* stepItems = [[NSMutableDictionary alloc] init];
    
    for (int i = 1; i <= 12; i++) {
        NSString* stepNumberKey = [NSString stringWithFormat:@"%d", i];
        [stepItems setObject:@[] forKey:stepNumberKey];
    }
    
    NSData* stepItemsData = [NSKeyedArchiver archivedDataWithRootObject:stepItems];
    
    if ([manager createFileAtPath:path contents:stepItemsData attributes:nil]) {
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
