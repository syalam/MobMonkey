//
//  GetRelativeTime.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/14/12.
//
//

#import "GetRelativeTime.h"

@implementation GetRelativeTime

+ (NSString*)getRelativeTime:(NSDate*)date {
    NSString *time;
    
    NSDate *today = [[NSDate alloc]init];
    NSTimeInterval timeBetween = fabs([today timeIntervalSinceDate:date]);
    int minutes = timeBetween/60;
    int hours = minutes/60;
    int days = hours/24;
    
    if (days >= 1) {
        time = [NSString stringWithFormat:@"%dd", days];
    }
    else if (hours >= 1) {
        time = [NSString stringWithFormat:@"%dh", hours];
    }
    else if (minutes >= 1) {
        time = [NSString stringWithFormat:@"%dm", minutes];
    }
    else {
        time = [NSString stringWithFormat:@"%.0fs", timeBetween];
    }
    
    NSLog(@"%@", time);
    
    return time;
}

@end
