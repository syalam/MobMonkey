//
//  MMRequestInboxCell.m
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMRequestInboxCell.h"
#import "MMShadowBackground.h"

@interface MMRequestInboxCell()

@property (nonatomic, strong) MMShadowBackground *shadowBackground;

@end

@implementation MMRequestInboxCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        
        self.autoresizesSubviews = YES;
        CGRect placeViewFrame = CGRectMake(0, 0, self.contentView.bounds.size.width , self.contentView.bounds.size.height);
		_requestInboxView = [[MMRequestInboxView alloc] initWithFrame:placeViewFrame];
		_requestInboxView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_requestInboxView.delegate =self;
        
        _shadowBackground = [[MMShadowBackground alloc]  initWithFrame:placeViewFrame];
       
        _shadowBackground.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:_shadowBackground];
        
        [self.contentView addSubview:_requestInboxView];
        
        
        self.clipsToBounds = YES;

    }
    
    return self;
}

-(id)initWithStyle:(MMRequestCellStyle)style mediaType:(MMMediaType)mediaType reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if(self){
        CGRect placeViewFrame = CGRectMake(0, 0, self.contentView.bounds.size.width , self.contentView.bounds.size.height);
		_requestInboxView = [[MMRequestInboxView alloc] initWithFrame:placeViewFrame];
        _requestInboxView.style = style;
        _requestInboxView.delegate = self;
        _requestInboxView.mediaType = mediaType;
		_requestInboxView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:_requestInboxView];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setRequestInboxWrapper:(MMRequestWrapper *)wrapper
{
    [self.requestInboxView setWrapper:wrapper];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)redisplay {
    [self.requestInboxView setNeedsDisplay];
    [self.shadowBackground setNeedsDisplay];
}

#pragma mark - view delegate

-(void)requestInboxViewAcceptTapped:(id)wrapper requestObject:(MMRequestObject *)requestObject{
    NSLog(@"Accept");
}
-(void)requestInboxViewRejectTapped:(id)wrapper requestObject:(MMRequestObject *)requestObject{
    NSLog(@"Reject");
}



@end
