//
//  LocationViewController.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
