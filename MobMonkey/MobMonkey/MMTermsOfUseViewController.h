//
//  MMTermsOfUseViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 1/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMTermsOfUseViewController : UIViewController {
    void (^ acceptAction)(void);
    void (^ rejectAction)(void);
}

@property (copy, nonatomic) void (^ acceptAction)(void);
@property (copy, nonatomic) void (^ rejectAction)(void);
@property (nonatomic, assign) BOOL requiresResponse;

@end
