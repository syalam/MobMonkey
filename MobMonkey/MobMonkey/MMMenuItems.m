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
    
    MMMenuItem *whatHappeningMenuItem = [MMMenuItem menuItemWithTitle:@"What's Happening Now!" image:nil];
    whatHappeningMenuItem.cellHeight = @60;
    whatHappeningMenuItem.displayOrder = @1;
    whatHappeningMenuItem.titleTextAlignment = NSTextAlignmentCenter;
    
    MMMenuItem *searchMenuItem = [MMMenuItem menuItemWithTitle:@"Search for Places" image:[UIImage imageNamed:@"searchIcnOff"]];
    searchMenuItem.selectedImage = [UIImage imageNamed:@"searchIcnOff"];
    searchMenuItem.displayOrder = @2;
    
    MMMenuItem *inboxMenuItem = [MMMenuItem menuItemWithTitle:@"Request Inbox" image:[UIImage imageNamed:@"inboxIcnOff"] displayOrder:@3];
    [inboxMenuItem setSelectedImage:[UIImage imageNamed:@"inboxIcn"]];
    inboxMenuItem.displayOrder = @3;
    inboxMenuItem.menuItemType = MMMenuItemTypeInbox;
    
    MMMenuItem *createHotSpotMenuItem = [MMMenuItem menuItemWithTitle:@"Create Hot Spot" image:nil displayOrder:@3];
    //[inboxMenuItem setSelectedImage:[UIImage imageNamed:@"inboxIcn"]];
    createHotSpotMenuItem.displayOrder = @3;
    createHotSpotMenuItem.menuItemType = MMMenuItemTypeInbox;

    
    
    MMMenuItem *locationsMenuItem = [MMMenuItem menuItemWithTitle:@"Locations" image:[UIImage imageNamed:@"LocationIcn"] displayOrder:@1];
    locationsMenuItem.cellHeight = @60;
    [locationsMenuItem setSelectedImage:[UIImage imageNamed:@"LocationIcnSelected"]];
    locationsMenuItem.menuItemType = MMMenuItemTypeLocations;
    
    //Stream Now
    MMMenuItem *trendingNowMenuItem = [MMMenuItem menuItemWithTitle:@"Trending Now" image:[UIImage imageNamed:@"trendingIcnOff"] displayOrder:@2];
    [trendingNowMenuItem setSelectedImage:[UIImage imageNamed:@"trendingIcn"]];
    trendingNowMenuItem.menuItemType = MMMenuItemTypeTrending;
    
    
    
    MMMenuItem *favoritesMenuItem = [MMMenuItem menuItemWithTitle:@"Favorites" image:[UIImage imageNamed:@"favoritesIcon"] displayOrder:@4];
    [favoritesMenuItem setSelectedImage:[UIImage imageNamed:@"favoritesIconOn"]];
    favoritesMenuItem.menuItemType = MMMenuItemTypeFavorites;
    
    MMMenuItem *settingsMenuItem = [MMMenuItem menuItemWithTitle:@"Settings" image:[UIImage imageNamed:@"settingsIcnOff"] displayOrder:@5];
    [settingsMenuItem setSelectedImage:[UIImage imageNamed:@"settingsIcn"]];
    settingsMenuItem.menuItemType = MMMenuItemTypeSettings;
    
    
    
    return @[whatHappeningMenuItem,locationsMenuItem, trendingNowMenuItem, inboxMenuItem, favoritesMenuItem, settingsMenuItem];
    
    
}
-(NSArray *)allMenuItems {
    NSMutableArray *allItems = [NSMutableArray array];
    
    //[allItems addObject:[self profileMenuItem]];
    
    [allItems addObjectsFromArray:[self standardMenuItems]];
    
    return allItems;
    
}
@end
