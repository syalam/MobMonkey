//
//  MMMyInfo.m
//  MobMonkey
//
//  Created by Michael Kral on 4/8/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMMyInfo.h"

#define kMyInfoKey @"MyInfo"

#define kFirstNameKey @"firstName"
#define kLastNameKey @"lastName"
#define kEmailKey @"email"
#define kBirthdayKey @"birthday"
#define kGenderKey @"gender"

@implementation MMMyInfo

@synthesize myInfoDictionary = _myInfoDictionary;
@synthesize firstName = _firstName, lastName = _lastName, email = _email, birthday = _birthday, gender = _gender, isEmpty = _isEmpty;

+(id)myInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:kMyInfoKey];
    MMMyInfo *myInfo = (MMMyInfo *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    
    
    
    if((!myInfo) || myInfo.isEmpty ){
        myInfo = [[self alloc] init];
    }
    
    return myInfo;
}
-(void)saveInfo{
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:kMyInfoKey];
}
-(void)eraseInfo{
    
    self.firstName = nil;
    self.lastName = nil;
    self.email = nil;
    self.birthday = nil;
    self.gender = nil;
    self.isEmpty = YES;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMyInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode the properties of the object
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.gender forKey:@"gender"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if ( self != nil )
    {
        //decode the properties
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
    }
    return self;
}

@end
