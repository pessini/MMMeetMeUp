//
//  WebViewController.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/23/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.webView.delegate = self;

    self.goBackButton.enabled = NO;
    self.goForwardButton.enabled = NO;

    [self loadUrlRequestFromString:self.url];


}

#pragma mark -UIWebView

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.spinner startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];

    if (![self.webView canGoBack])
    {
        self.goBackButton.enabled = NO;
    }
    else
    {
        self.goBackButton.enabled = YES;
    }

    if (![self.webView canGoForward])
    {
        self.goForwardButton.enabled = NO;
    }
    else
    {
        self.goForwardButton.enabled = YES;
    }

//    NSString* title = [self.webView stringByEvaluatingJavaScriptFromString: @"document.title"];
//    self.addressBarNavigationItem.title = title;
}


#pragma mark IBAction

- (IBAction)onBackButtonPressed:(UIBarButtonItem *)sender
{
    [self.webView goBack];

}

- (IBAction)onForwardButtonPressed:(UIBarButtonItem *)sender
{
    [self.webView goForward];
}

- (IBAction)onCloseButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark -Helpers Methods

-(void)loadUrlRequestFromString:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end
