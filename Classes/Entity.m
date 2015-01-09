#import "Entity.h"

@interface Entity ()

// Private interface goes here.

@end

@implementation Entity

#pragma mark - Lifecycle

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.creationDate = [NSDate date];
    self.modificationDate = self.creationDate;
}

#define MODIFICATION_DATE_DELTA     2000 // 2 seconds
- (void)willSave
{
    [super willSave];
    
    // check if object has unsaved changes
    if (self.isUpdated) {
        NSDate* date = [NSDate date];
        
        // check that modificationDate was not recently set to avoid willSave loop
        if ([date timeIntervalSinceDate:self.modificationDate] > MODIFICATION_DATE_DELTA) {
            self.modificationDate = date;
        }
    }
}


#pragma mark - Properties

- (void)setCreationDate:(NSDate*)date
{
    [self willChangeValueForKey:EntityAttributes.creationDate];
    [self setPrimitiveCreationDate:date];
    [self didChangeValueForKey:EntityAttributes.creationDate];
}

- (void)setModificationDate:(NSDate*)date
{
    [self willChangeValueForKey:EntityAttributes.modificationDate];
    [self setPrimitiveModificationDate:date];
    [self didChangeValueForKey:EntityAttributes.modificationDate];
}

@end
