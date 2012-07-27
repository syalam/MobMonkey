//
//  ImageDetailViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/27/12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageDetailViewController : UIViewController {
    
}

@property (nonatomic, retain)IBOutlet UIWebView *webView;

- (void)loadImage:(PFObject*)notificationObject;

@end
