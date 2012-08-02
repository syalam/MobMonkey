//
//  LocationMediaViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/27/12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "LocationMediaCell.h"

@interface LocationMediaViewController : UITableViewController <LocationMediaCellDelegate>


@property (nonatomic, retain)NSMutableArray *contentList;

- (void)getLocationItems:(NSString*)mediaType factualId:(NSString*)factualId;

@end
