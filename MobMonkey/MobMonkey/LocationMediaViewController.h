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

@interface LocationMediaViewController : UITableViewController <LocationMediaCellDelegate> {
    NSMutableDictionary *voteTrackerDictionary;
}


@property (nonatomic, retain)NSMutableArray *contentList;
@property (nonatomic, retain)NSString *factualId;

- (void)getLocationItems:(NSString*)mediaType factualId:(NSString*)factualId;

@end
