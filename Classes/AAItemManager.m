//
//  AAItemManager.m
//  Steps
//
//  Created by Tom on 5/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAItemManager.h"

void dispatch_once_on_main_thread(dispatch_once_t *predicate,
                                  dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        dispatch_once(predicate, block);
    } else {
        if (DISPATCH_EXPECT(*predicate == 0L, NO)) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                dispatch_once(predicate, block);
            });
        }
    }
}

#define AA_ITEMS_FILE_NAME @"StepItems"

@interface AAItemManager ()

@property (nonatomic) BOOL dataWasModified;
@property (strong, nonatomic) NSDictionary* stepItems;

@end

@implementation AAItemManager

+ (instancetype)sharedItemManager
{
    static AAItemManager* sharedManager = nil;
    static dispatch_once_t once;
    
    dispatch_once_on_main_thread(&once, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}


- (NSDictionary*)stepItems
{
    if (!_stepItems) _stepItems = [self loadDataFromStepsFile];
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

- (void)synchronize
{
    if (self.dataWasModified) {
        BOOL result = [NSKeyedArchiver archiveRootObject:self.stepItems toFile:[self pathForStepsDocument]];
        
        if (!result) {
            ALog("<ERROR> Unable to write step items to file");
        } else {
            self.dataWasModified = NO;
        }
    }
}

- (void)flush
{
    if (self.dataWasModified) {
        [self synchronize];
    }

    self.stepItems = nil;
}

- (NSDictionary*)loadDataFromStepsFile
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString* stepsDocumentPath = [self pathForStepsDocument];
    
    if (![manager fileExistsAtPath:stepsDocumentPath])
        if ([self createStepsDocumentAtPath:stepsDocumentPath] == AAStepItemsFileAccessError) {
            ALog(@"<ERROR> Unable to create steps document");
        }
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:stepsDocumentPath];
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
