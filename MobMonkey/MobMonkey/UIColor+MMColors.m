//
//  UIColor+MMColors.m
//  MobMonkey
//
//  Created by Michael Kral on 5/22/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "UIColor+MMColors.h"

@implementation UIColor (MMColors)

+(UIColor *)MMEggShell {
    return [UIColor colorWithWhite:0.933 alpha:1.000];
}
+(UIColor*)MMMaroon {
    return [UIColor colorWithRed:0.227 green:0.067 blue:0.110 alpha:1.000];
}
+(UIColor*)MMGreyPurple {
    return [UIColor colorWithRed:0.341 green:0.286 blue:0.318 alpha:1.000];
}
+(UIColor*)MMPaleGreen {
    return [UIColor colorWithRed:0.514 green:0.596 blue:0.557 alpha:1.000];
}
+(UIColor*)MMLightGreen {
    return [UIColor colorWithRed:0.737 green:0.871 blue:0.647 alpha:1.000];
}
+(UIColor*)MMYellowGreen {
    return [UIColor colorWithRed:0.902 green:0.976 blue:0.737 alpha:1.000];
}
+(UIColor *)defaultGroupedCellBGColor{
    return [UIColor colorWithWhite:0.969 alpha:1.000];
}
+(UIColor *)oceanBlue {
    return [UIColor colorWithRed:0.250 green:0.456 blue:0.927 alpha:1.000];
}



+(UIColor *)MMDarkMainColor{
    return [self MMMaroon];
}
+(UIColor *)MMDarkAccentColor {
    return [self MMGreyPurple];
}
+(UIColor *)MMLightAccentColor {
    return [self MMYellowGreen];
}
+(UIColor *)MMLightMainColor {
    return [self MMLightGreen];
}
+(UIColor *)MMBackgroundColor {
    return [self MMEggShell];
}
+(UIColor *)MMMainTextColor {
    return [UIColor colorWithRed:0.181 green:0.217 blue:0.204 alpha:1.000];
}
+(UIColor *)MMSecondaryTextColor {
    return [UIColor colorWithRed:0.309 green:0.371 blue:0.349 alpha:1.000];
}
+(UIColor *)MMMainAccentColor {
    return [self MMPaleGreen];
}
@end
