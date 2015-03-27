//
//  ProfileViewController.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/24/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "ProfileViewController.h"
#import "Profile.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullCommentLabel;
@property NSArray *profileArray;
@property Profile *profile;
@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.profile = [Profile new];
    self.profileArray = [NSArray new];
    [self getDataFromAPI];
    [self loadInfo];

    NSLog(@"%@", self.profileArray);
}

-(void)loadInfo
{
    self.memberNameLabel.text = self.profile.memberName;
    self.profilePhotoImageView.image = [UIImage imageWithData:[self loadImageFromURL:self.profile.memberPhotoLink]];
    self.fullCommentLabel.text = self.profile.comment;
}

- (void)getDataFromAPI
{
    [self.profile requestMemberProfileWithMemberID:self.memberID andEventID:self.eventID andGroupID:self.groupID andCommentID:self.commentID withCompletionHandler:^(NSMutableArray *searchArray)
    {
        self.profileArray = searchArray;
    }];
}

-(NSData *)loadImageFromURL: (NSString *)url
{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
    return imageData;
}



@end
