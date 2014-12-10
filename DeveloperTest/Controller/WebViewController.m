//
//  WebViewController.m
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "WebViewController.h"

#define WEB_VIEW_NIB @"WebViewController"

@interface WebViewController () <UIWebViewDelegate>
@property (retain, nonatomic) NSURL *url;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIButton *forwardButton;
@property (retain, nonatomic) IBOutlet UIButton *stopButton;
@property (retain, nonatomic) IBOutlet UIButton *refreshButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation WebViewController


-(instancetype)initWithUrl:(NSURL *)url
{
    self = [super initWithNibName:WEB_VIEW_NIB bundle:nil];
    
    if (self) {
        self.url = url;
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)dealloc {
    [_url release];
    [_webView release];
    [_backButton release];
    [_forwardButton release];
    [_stopButton release];
    [_refreshButton release];
    [_activityIndicator release];
    [super dealloc];
}

#pragma mark - Private methods

-(void)updateControls
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    self.stopButton.enabled = self.webView.isLoading;
    self.refreshButton.enabled = !self.webView.isLoading;
    if (self.webView.isLoading) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    
}

#pragma mark - Actions

- (IBAction)refresh:(id)sender
{
    [self.webView reload];
}

- (IBAction)stop:(id)sender
{
    [self.webView stopLoading];
}
- (IBAction)back:(id)sender
{
    [self.webView goBack];
}

- (IBAction)forward:(id)sender
{
    [self.webView goForward];
}

#pragma mark - UIWebViewDelegate methods

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateControls];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateControls];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateControls];
}

@end
