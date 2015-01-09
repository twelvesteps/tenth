#import "_MeetingProgram.h"

/**
 *  Describes the type of symbol associated with the given meeting program
 */
typedef NS_ENUM(NSInteger, AAMeetingProgramSymbolType){
    /**
     *  A circle surrounding a triangle, similar to AA's symbol
     */
    AAMeetingProgramSymbolTypeCircleAroundTriangle,
    /**
     *  A triangle surrounding a circle, similar to Alanon's symbol
     */
    AAMeetingProgramSymbolTypeTriangleAroundCircle,
};

@interface MeetingProgram : _MeetingProgram {}


@end
