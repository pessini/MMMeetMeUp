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
@property (weak, nonatomic) IBOutlet UILabel *cityStateLabel;

@property Profile *profile;
@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.profile = [Profile retrieveMemberProfileWithID:self.memberID];
    [self loadInfo];
}

-(void)loadInfo
{
    self.memberNameLabel.text = self.profile.memberName;

    [self.profile getImageDataWithCompletion:^(NSData *imageData, NSError *error)
    {
        self.profilePhotoImageView.image = [UIImage imageWithData:imageData];
        self.profilePhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }];

    self.cityStateLabel.text = [NSString stringWithFormat:@"%@, %@", self.profile.city, self.profile.state];
}


@end
