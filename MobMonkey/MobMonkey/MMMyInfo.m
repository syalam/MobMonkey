//
//  MMMyInfo.m
//  MobMonkey
//
//  Created by Michael Kral on 4/8/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMMyInfo.h"

#define kMyInfoDictionaryKey @"myInfoDictionary"

#define kFirstNameKey @"firstName"
#define kLastNameKey @"lastName"
#define kEmailKey @"email"
#define kBirthdayKey @"birthday"
#define kGenderKey @"gender"

@implementation MMMyInfo

@synthesize myInfoDictionary = _myInfoDictionary;
@synthesize firstName = _firstName, lastName = _lastName, email = _email, birthday = _birthday, gender = _gender;

-(NSDictionary *)myInfoDictionary{
    if(!_myInfoDictionary){
        _myInfoDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kMyInfoDictionaryKey];
        if(!_myInfoDictionary){
            _myInfoDictionary = [NSMutableDictionary dictionary];
            [[NSUserDefaults standardUserDefaults] setObject:_myInfoDictionary forKey:kMyInfoDictionaryKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return _myInfoDictionary;
}

-(void)synchronize {
    [[NSUserDefaults standardUserDefaults] setObject:_myInfoDictionary forKey:kMyInfoDictionaryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark Setter Methods

-(void)setFirstName:(NSString *)firstName {
    
    [self.myInfoDictionary setObject:firstName forKey:kFirstNameKey];
    _firstName = firstName;
    [self synchronize];
    
}

-(void)setLastName:(NSString *)lastName {
    
    [self.myInfoDictionary setObject:lastName forKey:kLastNameKey];
    _lastName = lastName;
    [self synchronize];

}

-(void)setEmail:(NSString *)email {

    [self.myInfoDictionary setObject:email forKey:kEmailKey];
    _email = email;
    [self synchronize];

}
-(void)setBirthday:(NSDate *)birthday {

    [self.myInfoDictionary setObject:birthday forKey:kBirthdayKey];
    _birthday = birthday;
    [self synchronize];

}
-(void)setGender:(NSString *)gender {

    [self.myInfoDictionary setObject:gender forKey:kGenderKey];
    _gender = gender;
    [self synchronize];

}

#pragma mark Getter Methods

-(NSString *)firstName{
    
    return [self.myInfoDictionary objectForKey:kFirstNameKey];

}

-(NSString *)lastName {

    return [self.myInfoDictionary objectForKey:kLastNameKey];

}

-(NSString *)email {

    return [self.myInfoDictionary objectForKey:kEmailKey];

}

-(NSDate *)birthday {

    return [self.myInfoDictionary objectForKey:kBirthdayKey];

}

-(NSString *)gender {

    return [self.myInfoDictionary objectForKey:kGenderKey];

}

@end
