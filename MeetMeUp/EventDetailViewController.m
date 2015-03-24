//
//  EventDetailViewController.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/23/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "EventDetailViewController.h"
#import "WebViewController.h"


@interface EventDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rsvpCountsLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupInformationLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionTextView;

@end

@implementation EventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.eventNameLabel.text = [self.eventDetails objectForKey:@"name"];
    self.rsvpCountsLabel.text = [NSString stringWithFormat:@"RSVP: %@", [self.eventDetails objectForKey:@"yes_rsvp_count"]];
    self.groupInformationLabel.text = [[self.eventDetails objectForKey:@"group"] objectForKey:@"name"];

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[[self.eventDetails objectForKey:@"description"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                                            options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType }                                            documentAttributes:nil                                            error:nil];
    self.eventDescriptionTextView.attributedText = attributedString;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowWebPageSegue"])
    {
        WebViewController *vc = segue.destinationViewController;
        vc.url = [self.eventDetails objectForKey:@"event_url"];
    }
}


@end
