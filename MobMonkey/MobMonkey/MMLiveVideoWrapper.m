//
//  MMLiveVideoWrapper.m
//  MobMonkey
//
//  Created by Michael Kral on 6/11/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMLiveVideoWrapper.h"

@implementation MMLiveVideoWrapper

-(id)init{
    if([super init]){
        self.messageStringFont = [UIFont fontWithName:@"Helvetica-LightOblique" size:15];
    }
    return self;
}

-(void)setMessageString:(NSString *)messageString {
    
    _messageStringSize = [messageString sizeWithFont:self.messageStringFont constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    _messageString = messageString;
}
-(CGFloat)cellHeight {
    CGFloat cellHeight = 310;
    
    cellHeight += 30;
    
    cellHeight += self.messageStringSize.height + 36;
    
    
    return cellHeight;
}
@end
