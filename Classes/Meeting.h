#import "_Meeting.h"


@interface Meeting : _Meeting {}

/**
 *  Calculates the end of the meeting based on the start date and duration
 *
 *  @return The date at which the meeting ends
 */
- (NSDate*)endDate;

@end
