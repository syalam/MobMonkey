//
//  MMMyInfo.h
//  MobMonkey
//
//  Created by Michael Kral on 4/8/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMyInfo : NSObject

@property(nonatomic, strong) NSMutableDictionary *myInfoDictionary;

@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *birthday;
@property(nonatomic, strong) NSString *gender;

@end
