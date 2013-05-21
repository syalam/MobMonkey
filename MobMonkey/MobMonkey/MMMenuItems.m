//
//  MMMenuItems.m
//  MobMonkey_LVF
//
//  Created by Michael Kral on 4/18/13.
//  Copyright (c) 2013 MobMonkey. All rights reserved.
//

#import "MMMenuItems.h"
#import "MMMenuItem.h"
@implementation MMMenuItems

+(MMMenuItems *)menuItems{
    MMMenuItems *menuItems = [[self alloc] init];
    return menuItems;
}

-(MMMenuItem *)profileMenuItem {
#warning This needs to fetch actual info, this is static for now
    MMMenuItem *profileMenuItem = [MMMenuItem menuItemWithTitle:@"mkral" image:[UIImage imageNamed:@"mikespic"] displayOrder:@1];
    return profileMenuItem;
}
-(NSArray *)standardMenuItems {
    
    //Stream Now
    MMMenuItem *streamNowMenuItem = [MMMenuItem menuItemWithTitle:@"Stream Now!" image:[UIImage imageNamed:@"videocamera"] displayOrder:@2];
    streamNowMenuItem.cellHeight = @80;
    
    //Live Stream
    MMMenuItem *liveStreamsMenuItem = [MMMenuItem menuItemWithTitle:@"Live Streams" image:[UIImage imageNamed:@"circlePlay"] displayOrder:@3];
    
    MMMenuItem *favoritesMenuItem = [MMMenuItem menuItemWithTitle:@"Favorites" image:[UIImage imageNamed:@"heart"] displayOrder:@4];
    
    MMMenuItem *manageLists = [MMMenuItem menuItemWithTitle:@"Manage Lists" image:[UIImage imageNamed:@"whiteList"] displayOrder:@5];
    
    return @[streamNowMenuItem, liveStreamsMenuItem, favoritesMenuItem, manageLists];
    
    
}
-(NSArray *)allMenuItems {
    NSMutableArray *allItems = [NSMutableArray array];
    
    [allItems addObject:[self profileMenuItem]];
    
    [allItems addObjectsFromArray:[self standardMenuItems]];
    
    return allItems;
    
}
@end
