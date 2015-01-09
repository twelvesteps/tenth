#import "Meeting.h"

@interface Meeting ()

// Private interface goes here.

@end

@implementation Meeting

#pragma mark - Properties

- (NSDate*)endDate
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* durationComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.duration];
    
    return [calendar dateByAddingComponents:durationComponents toDate:self.startDate options:0];
}

@end
