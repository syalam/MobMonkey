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
    whatHappeningMenuItem.cellHeight = @44;
    whatHappeningMenuItem.displayOrder = @1;
    whatHappeningMenuItem.titleTextAlignment = NSTextAlignmentCenter;
    whatHappeningMenuItem.backgroundColor = [UIColor blackColor];
    whatHappeningMenuItem.menuItemType = MMMenuItemTypeHappening;
    
    
    MMMenuItem *searchMenuItem = [MMMenuItem menuItemWithTitle:@"Search for Places" image:[UIImage imageNamed:@"menuMagnify"]];
    searchMenuItem.selectedImage = [UIImage imageNamed:@"menuMagnify"];
    searchMenuItem.displayOrder = @2;
    searchMenuItem.menuItemType = MMMenuItemTypeSearch;
    
    
    MMMenuItem *inboxMenuItem = [MMMenuItem menuItemWithTitle:@"Request Inbox" image:[UIImage imageNamed:@"menuInbox"] displayOrder:@3];
    inboxMenuItem.displayOrder = @3;
    inboxMenuItem.menuItemType = MMMenuItemTypeInbox;
    
    
    MMMenuItem *createHotSpotMenuItem = [MMMenuItem menuItemWithTitle:@"Create Hot Spot" image:[UIImage imageNamed:@"menuFire"] displayOrder:@3];
    createHotSpotMenuItem.displayOrder = @4;
    createHotSpotMenuItem.menuItemType = MMMenuItemCreateHotSpot;
    
    
    MMMenuItem *subscribeMenuItem = [MMMenuItem menuItemWithTitle:@"Subscribe!" image:[UIImage imageNamed:@"menuPinkHeart"] displayOrder:@5];
    subscribeMenuItem.menuItemType = MMMenuItemSubscribe;
    
    
    MMMenuItem *snapShotMenuItem = [MMMenuItem menuItemWithTitle:@"Snap Shot" image:[UIImage imageNamed:@"menuCamera"] displayOrder:@6];
    snapShotMenuItem.menuItemType = MMMenuItemSnapShot;
    
    
    MMMenuItem *trendingNowMenuItem = [MMMenuItem menuItemWithTitle:@"What's Trending Now" image:[UIImage imageNamed:@"menuChart"] displayOrder:@7];
    trendingNowMenuItem.menuItemType = MMMenuItemTypeTrending;
    
    MMMenuItem *favoritesMenuItem = [MMMenuItem menuItemWithTitle:@"Favorite Places" image:[UIImage imageNamed:@"menuStar"] displayOrder:@8];
    favoritesMenuItem.menuItemType = MMMenuItemTypeFavorites;

    MMMenuItem * notificationsMenuItem = [MMMenuItem menuItemWithTitle:@"Notifications" image:[UIImage imageNamed:@"menuSpeechBubble"] displayOrder:@9];
    notificationsMenuItem.menuItemType = MMMenuItemNotifications;
    
    MMMenuItem *settingsMenuItem = [MMMenuItem menuItemWithTitle:@"User Settings" image:[UIImage imageNamed:@"menuGear"] displayOrder:@10];
    settingsMenuItem.menuItemType = MMMenuItemTypeSettings;
    
    MMMenuItem * termsAndConditionsMenuItem = [MMMenuItem menuItemWithTitle:@"Terms & Conditions" image:[UIImage imageNamed:@"menuDocs"] displayOrder:@11];
    termsAndConditionsMenuItem.menuItemType = MMMenuItemTermsAndConditions;

    
    
        
    
    
        
    

    

    
    
    //return @[whatHappeningMenuItem, searchMenuItem,inboxMenuItem, createHotSpotMenuItem, subscribeMenuItem, snapShotMenuItem, trendingNowMenuItem, favoritesMenuItem, notificationsMenuItem, settingsMenuItem, termsAndConditionsMenuItem];
    
    return @[whatHappeningMenuItem, searchMenuItem,inboxMenuItem, createHotSpotMenuItem, subscribeMenuItem, favoritesMenuItem, settingsMenuItem, termsAndConditionsMenuItem];
    
    
}
-(NSArray *)allMenuItems {
    NSMutableArray *allItems = [NSMutableArray array];
    
    //[allItems addObject:[self profileMenuItem]];
    
    [allItems addObjectsFromArray:[self standardMenuItems]];
    
    return allItems;
    
}
@end
