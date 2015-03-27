//
//  EventDetailViewController.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/23/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "EventDetailViewController.h"
#import "WebViewController.h"
#import "CommentsViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface EventDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *rsvpCountsButton;
@property (weak, nonatomic) IBOutlet UILabel *groupInformationLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionTextView;

@end

@implementation EventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadInfo];
    [self updateUI];
}

#pragma mark - Elements

-(void)updateUI
{
    self.rsvpCountsButton.layer.cornerRadius = self.rsvpCountsButton.bounds.size.width / 2.0;
}

-(void)loadInfo
{
    self.navigationItem.title = self.event.eventName;
    self.eventNameLabel.text = self.event.eventName;
    [self.rsvpCountsButton setTitle:[NSString stringWithFormat:@"%@", self.event.rsvpCount] forState:UIControlStateNormal];
    self.groupInformationLabel.text = self.event.groupName;

    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData:[self.event.eventDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                            options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType }                                            documentAttributes:nil                                            error:nil];
    self.eventDescriptionTextView.attributedText = attributedString;
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowWebPageSegue"])
    {
        WebViewController *vc = segue.destinationViewController;
        vc.url = self.event.eventURL;
    }
    else if ([segue.identifier isEqualToString:@"ShowCommentsSegue"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        CommentsViewController *commentsVC = navigationController.viewControllers[0];
        commentsVC.eventID = self.event.eventID;
    }
}

@end
