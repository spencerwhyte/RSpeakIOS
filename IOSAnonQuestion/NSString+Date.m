//
//  NSString+Date.m
//  RSpeak
//
//  Created by Spencer Whyte on 2015-01-02.
//  Copyright (c) 2015 Spencer Whyte. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)


- (NSDate*)date
{
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    return [dateFormat dateFromString:self];
    
}

@end
