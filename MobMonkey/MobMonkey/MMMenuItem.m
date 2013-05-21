//
//  MMMenuItem.m
//  MobMonkey_LVF
//
//  Created by Michael Kral on 4/18/13.
//  Copyright (c) 2013 MobMonkey. All rights reserved.
//

#import "MMMenuItem.h"

@implementation MMMenuItem

@synthesize displayOrder, image, title, badgeCount, cellHeight;

+(MMMenuItem *)menuItemWithTitle:(NSString *)title image:(UIImage *)image {
    
    MMMenuItem *menuItem = [[self alloc] init];
    
    menuItem.title = title;
    
    menuItem.image = image;
    
    return menuItem;

}
+(MMMenuItem *)menuItemWithTitle:(NSString *)title image:(UIImage *)image displayOrder:(NSNumber *)displayOrder {
    
    MMMenuItem *menuItem = [self menuItemWithTitle:title image:image];
    
    menuItem.displayOrder = displayOrder;
    
    return menuItem;
    
}
@end
