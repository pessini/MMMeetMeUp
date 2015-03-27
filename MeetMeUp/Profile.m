//
//  Profile.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/26/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "Profile.h"

#define APIKey @"679336f676c69291d1f183928375451"
#define APIProfile @"https://api.meetup.com/2/event_comments?member_id=%@&offset=0&format=json&comment_id=%@&event_id=%@&group_id=%@&photo-host=public&page=20&fields=member_photo&order=time&desc=desc&sig_id=123701892&sig=%@"

@implementation Profile

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init])
    {
        self.memberName = dictionary[@"member_name"];
        self.memberPhotoLink = dictionary[@"member_photo"][@"photo_link"];
        self.comment = dictionary[@"comment"];
    }
    return self;
}

- (void)requestMemberProfileWithMemberID:(NSString *)memberID
                              andEventID:(NSString *)eventID
                              andGroupID:(NSString *)groupID
                            andCommentID:(NSString *)commentID
                   withCompletionHandler:(void (^)(NSMutableArray *searchArray))completionHandler
{
    NSString *searchString = [NSString stringWithFormat:
                              APIProfile,
                              memberID,
                              commentID,
                              eventID,
                              groupID,
                              APIKey];
    NSLog(@"%@", [NSString stringWithFormat:
                  APIProfile,
                  memberID,
                  commentID,
                  eventID,
                  groupID,
                  APIKey]);

    NSURL *url = [NSURL URLWithString:searchString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (!connectionError)
         {
             NSDictionary *searchDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
             NSArray *array = searchDict[@"results"];
             NSMutableArray *searchResult = [NSMutableArray new];
             for (NSDictionary *searchItems in array)
             {
                 Profile *profile = [[Profile alloc] initWithDictionary:searchItems];
                 [searchResult addObject:profile];
             }
             completionHandler(searchResult);
         }
     }];
}

@end
