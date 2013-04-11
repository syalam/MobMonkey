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

-(NSMutableDictionary *)myInfoDictionary{
    if(!_myInfoDictionary){
        _myInfoDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kMyInfoDictionaryKey];
        if(!_myInfoDictionary){
            _myInfoDictionary = [NSMutableDictionary dictionary];
            [[NSUserDefaults standardUserDefaults] setObject:_myInfoDictionary forKey:kMyInfoDictionaryKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return _myInfoDictionary.mutableCopy;
}

-(void)synchronize {
    [[NSUserDefaults standardUserDefaults] setObject:_myInfoDictionary forKey:kMyInfoDictionaryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark Setter Methods

-(void)setFirstName:(NSString *)firstName {
    
    [self.myInfoDictionary setValue:firstName forKey:kFirstNameKey];
    _firstName = firstName;
    [self synchronize];
    
}

-(void)setLastName:(NSString *)lastName {
    
    [self.myInfoDictionary setValue:lastName forKey:kLastNameKey];
    _lastName = lastName;
    [self synchronize];

}

-(void)setEmail:(NSString *)email {

    [self.myInfoDictionary setValue:email forKey:kEmailKey];
    _email = email;
    [self synchronize];

}
-(void)setBirthday:(NSString *)birthday {

    [self.myInfoDictionary setValue:birthday forKey:kBirthdayKey];
    _birthday = birthday;
    [self synchronize];

}
-(void)setGender:(NSString *)gender {

    [self.myInfoDictionary setValue:gender forKey:kGenderKey];
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

-(NSString *)birthday {

    return [self.myInfoDictionary objectForKey:kBirthdayKey];

}

-(NSString *)gender {

    return [self.myInfoDictionary objectForKey:kGenderKey];

}

@end
