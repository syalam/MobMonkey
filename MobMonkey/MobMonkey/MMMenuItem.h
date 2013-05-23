//
//  MMMenuItem.h
//  MobMonkey_LVF
//
//  Created by Michael Kral on 4/18/13.
//  Copyright (c) 2013 MobMonkey. All rights reserved.
//

typedef enum {
    MMMenuItemTypeTrending = 1,
    MMMenuItemTypeInbox,
    MMMenuItemTypeFavorites,
    MMMenuItemTypeSettings,
    MMMenuItemTypeSearch,
    MMMenuItemTypeLocations,
    MMMenuItemCreateHotSpot,
    MMMenuItemSubscribe
}MMMenuItemType;

#import <Foundation/Foundation.h>

@interface MMMenuItem : NSObject

@property (nonatomic, strong) NSNumber * displayOrder;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) UIImage * selectedImage;
@property (nonatomic, strong) NSNumber *badgeCount;
@property (nonatomic, strong) NSNumber *cellHeight;
@property (nonatomic, assign) MMMenuItemType menuItemType;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;
@property (copy, nonatomic) void (^action)();

+(MMMenuItem *)menuItemWithTitle:(NSString *)title image:(UIImage *) image;
+(MMMenuItem *)menuItemWithTitle:(NSString *)title image:(UIImage *) image displayOrder:(NSNumber *)displayOrder;
                                                          

@end
