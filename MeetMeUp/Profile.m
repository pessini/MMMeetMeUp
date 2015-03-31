//
//  Profile.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/26/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "Profile.h"

#define APIKey @"679336f676c69291d1f183928375451"
#define APIProfile @"https://api.meetup.com/2/members?&sign=true&photo-host=public&member_id=%@&page=20&key=%@"

@implementation Profile

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.memberName = dictionary[@"name"];
        self.memberPhotoLink = [NSURL URLWithString:dictionary[@"photo"][@"photo_link"]];
        self.city = dictionary[@"city"];
        self.state = dictionary[@"state"];
    }
    return self;
}

+ (Profile *)retrieveMemberProfileWithID:(NSString *)memberID
{
    NSString *urlString =[NSString stringWithFormat:APIProfile, memberID, APIKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data)
    {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *member = jsonDictionary[@"results"];
        NSDictionary *userDictionary = [member firstObject];
        return [[Profile alloc] initWithDictionary:userDictionary];
    }
    else
    {
        return nil;
    }
}

- (void)getImageDataWithCompletion:(void (^)(NSData *imageData, NSError *error))complete
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.memberPhotoLink];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError)
         {
             complete(nil,connectionError);
         }
         else
         {
             complete(data,nil);
         }
     }];
}

@end
