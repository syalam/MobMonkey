//
//  LocationMediaCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/2/12.
//
//

#import "LocationMediaCell.h"

@implementation LocationMediaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _cellImageView = [[TCImageView alloc]initWithFrame:CGRectMake(85, 5, 150, 150)];
        
        [_cellImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_cellImageView setClipsToBounds:YES];

        
        [self.contentView addSubview:_cellImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIWebview delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    webView.mediaPlaybackRequiresUserAction = YES;
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    webView.mediaPlaybackRequiresUserAction = YES;
    [_delegate webViewDidStartLoad:webView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_delegate webViewDidFinishLoad:webView];
}

@end
