//
//  MMInboxCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/1/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMInboxCell.h"
#import "GetRelativeTime.h"

@interface MMInboxCell ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *clockImageView;
@property (strong, nonatomic) UILabel *timeStampLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *requestTimeStamp;
@property (strong, nonatomic) UIView *mediaIconsView;
@property (strong, nonatomic) UIImageView *customBackgroundView;


@end


@implementation MMInboxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [_nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        _timeStampLabel = [[UILabel alloc]initWithFrame: CGRectZero];
        _timeStampLabel.numberOfLines = 1;
        _timeStampLabel.backgroundColor = [UIColor clearColor];
        _timeStampLabel.font = [UIFont boldSystemFontOfSize:12];
        _requestTimeStamp = [[UILabel alloc]initWithFrame: CGRectMake(10, 50, 100, 30)];
        _requestTimeStamp.numberOfLines = 1;
        _requestTimeStamp.backgroundColor = [UIColor clearColor];
        _requestTimeStamp.font = [UIFont boldSystemFontOfSize:10.5];
        _requestTimeStamp.textColor = [UIColor colorWithHex:@"686868" alpha:1.0];
        _clockImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeIcnOverlayBlack"]];
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = UILineBreakModeWordWrap;
        _messageLabel.font = [UIFont systemFontOfSize:12.0];
        _messageLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _distanceLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _distanceLabel.textColor = [UIColor colorWithHex:@"686868" alpha:1.0];
        _mediaIconsView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_nameLabel];
        //[self.contentView addSubview:_timeStampLabel];
        //[self.contentView addSubview:_clockImageView];
        [self.contentView addSubview:_messageLabel];
        [self.contentView addSubview:_addressLabel];
        [self.contentView addSubview:_distanceLabel];
        [self.contentView addSubview:_mediaIconsView];
        [self.contentView addSubview:_requestTimeStamp];
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)setLocation:(NSDictionary *)location
{
    for (UIView *view in _mediaIconsView.subviews) {
        [view removeFromSuperview];
    }
    _location = location;
    if (![[_location valueForKey:@"nameOfLocation"]isKindOfClass:[NSNull class]]) {
        _nameLabel.text = [_location valueForKey:@"nameOfLocation"];
        [_nameLabel sizeToFit];
    }
    if (![[_location valueForKey:@"expiryDate"]isKindOfClass:[NSNull class]]) {
        double unixTime = [[location valueForKey:@"expiryDate"] floatValue]/1000;
        NSDate *expiryDate = [NSDate dateWithTimeIntervalSince1970:
                                (NSTimeInterval)unixTime];
        NSString *expiryDateString = [GetRelativeTime getRelativeTime:expiryDate];
        
        [_timeStampLabel sizeToFit];
    }
    
    _messageLabel.text = @"";
    if (![[_location valueForKey:@"message"]isKindOfClass:[NSNull class]]) {
        _messageLabel.text = [_location valueForKey:@"message"];
        [_messageLabel sizeToFit];
    }
    
    if (![[_location valueForKey:@"latitude"]isKindOfClass:[NSNull class]] && ![[_location valueForKey:@"longitude"] isKindOfClass:[NSNull class]]) {
        CGFloat distance = [[MMUtilities sharedUtilities] calculateDistance:[_location valueForKey:@"latitude"]
                                                                  longitude:[_location valueForKey:@"longitude"]];
        _distanceLabel.text = [NSString stringWithFormat:@"%.2f miles", distance];
        [_distanceLabel sizeToFit];
    }
    
    if(![[_location valueForKey:@"requestDate"]isKindOfClass:[NSNull class]])
    {
        _requestTimeStamp.text = [self convertMillisecondsToDate:[_location valueForKey:@"requestDate"]];
        [_requestTimeStamp sizeToFit];
    }
    
    CGFloat xPosition = CGRectGetMaxX(_mediaIconsView.bounds) - 16;
    UIImageView *imageView;
    if ([[_location valueForKey:@"mediaType"]intValue] == 1) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellPictureBtn"]];
    }
    else if ([[_location valueForKey:@"mediaType"]intValue] == 4) {
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pencilIcn"]];
    }
    else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellVideoBtn"]];
    }
    imageView.frame = CGRectMake(xPosition, 0, 16.0, 16.0);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_mediaIconsView addSubview:imageView];
    xPosition -= 20.0;
}

- (NSString *) convertMillisecondsToDate: (NSString *) actDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval) ([actDate floatValue]/1000)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    NSString *fullString = [dateFormatter stringFromDate:date];
    NSString *month = [fullString substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [fullString substringWithRange:NSMakeRange(8, 2)];
    NSString *time = [fullString substringWithRange:NSMakeRange(11, 5)];
    
    /* Converting Month # into string */
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSDate* myDate = [formatter dateFromString:month];
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"MMM"];
    NSString *stringFromDate = [form stringFromDate:myDate];
    
    /* Converting date into single digit if from it ranges from 1 - 9 */
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    myDate = [formatter dateFromString:day];
    
    form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"d"];
    day = [form stringFromDate:myDate];
    
    /* Converting the time into a 12-hour format */
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    myDate = [formatter dateFromString:time];
    
    form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"hh:mm a"];
    time = [form stringFromDate:myDate];
    
    /* Combining the separate strings */
    stringFromDate = [stringFromDate stringByAppendingString:[NSString stringWithFormat:@" %@ %@", day, time]];
    
    return stringFromDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat inset = 10.0;
    CGRect bounds = [[self contentView] bounds];
    CGFloat height = bounds.size.height;
    CGFloat width = bounds.size.width;
    
    self.contentView.frame = CGRectMake(inset, inset, width - inset * 2.0, height - inset);
    
    height = self.contentView.bounds.size.height;
    width = self.contentView.bounds.size.width;
    inset = 5.0;
    CGRect frame = CGRectMake(inset, 0, width - inset * 2.0, 22.0);
    self.nameLabel.frame = frame;
    
    CGSize distLabelFrameSize = self.distanceLabel.frame.size;
    frame = CGRectMake(width - distLabelFrameSize.width + 10, CGRectGetMaxY(frame) - distLabelFrameSize.height, distLabelFrameSize.width, distLabelFrameSize.height);
    self.distanceLabel.frame = frame;
    
    frame = self.nameLabel.frame;
    frame.size.width = CGRectGetMinX(self.distanceLabel.frame) - inset * 2;
    self.nameLabel.frame = frame;
    
    frame = CGRectMake(inset, height - 35.0, width - inset * 2.0, 30.0);
    self.messageLabel.frame = frame;
    
    frame = CGRectMake(width - 86, height - 21.0, 96.0, 16.0);
    self.mediaIconsView.frame = frame;
}

@end
