//
//  LocationMediaCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/2/12.
//
//

#import <UIKit/UIKit.h>
#import "TCImageView.h"

@protocol LocationMediaCellDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;

@end

@interface LocationMediaCell : UITableViewCell <UIWebViewDelegate>

@property (nonatomic, retain) TCImageView *cellImageView;
@property (nonatomic, retain) UIWebView *cellWebView;
@property (nonatomic, assign) id<LocationMediaCellDelegate> delegate;

@end
