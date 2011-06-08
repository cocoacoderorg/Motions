//
//  ScreenshotWebView.h
//  Screenshots
//
//  Created by James Hillhouse on 3/28/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MotionsWebViewControllerDelegate;


@interface MotionsWebViewController : UIViewController <UIWebViewDelegate>
{
    id <MotionsWebViewControllerDelegate>           __unsafe_unretained delegate;
    UIWebView                                       *documentationWebView;
    NSURL                                           *documentationURL;
}

@property (nonatomic, assign)       id              <MotionsWebViewControllerDelegate>      delegate;
@property (nonatomic, retain)       IBOutlet        UIWebView                               *documentationWebView;
@property (nonatomic, retain)                       NSURL                                   *documentationURL;

- (IBAction)done;

@end


@protocol MotionsWebViewControllerDelegate

- (void)screenshotWebViewControllerDidFinish:(MotionsWebViewController *)controller;

@end

