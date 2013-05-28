//
//  MMShadowCellBackground.h
//  MobMonkey
//
//  Created by Michael Kral on 5/24/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

typedef enum {
    
    MMGroupedCellPositionTop = 1,
    MMGroupedCellPositionMiddle,
    MMGroupedCellPositionBottom
    
} MMGroupedCellPosition;

#import <UIKit/UIKit.h>

@interface MMShadowCellBackground : UIView

@property (nonatomic, assign) MMGroupedCellPosition cellPosition;
@property (nonatomic, assign) BOOL showSeperator;

+(void)addShadowToCellAtIndexPath:(NSIndexPath*)indexPath;

@end
