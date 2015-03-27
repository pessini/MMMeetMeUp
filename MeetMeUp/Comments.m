//
//  Comments.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/26/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "Comments.h"

#define APIKey @"679336f676c69291d1f183928375451"
#define APIComment @"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=%@&page=20&key=%@"

@implementation Comments

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init])
    {
        self.comment = dictionary[@"comment"];
        self.memberName = dictionary[@"member_name"];
        self.time = dictionary[@"time"];
        self.memberID = dictionary[@"member_id"];
        self.groupID = dictionary[@"group_id"];
        self.eventID = dictionary[@"event_id"];
        self.commentID = dictionary[@"event_comment_id"];
    }
    return self;
}

- (void)requestCommentsFromEventID: (NSString *)eventID withCompletionHandler:(void (^)(NSMutableArray *searchArray))completionHandler
{
    NSString *searchString = [NSString stringWithFormat:APIComment, eventID, APIKey];

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
                Comments *comment = [[Comments alloc] initWithDictionary:searchItems];
                [searchResult addObject:comment];
            }
            completionHandler(searchResult);
        }
    }];
}
@end
