//
//  MMCoreGraphicsCommon.h
//  MobMonkey
//
//  Created by Michael Kral on 5/24/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMCoreGraphicsCommon : NSObject

CGMutablePathRef createRoundedCornerPath(CGRect rect, CGFloat cornerRadius);
@end
