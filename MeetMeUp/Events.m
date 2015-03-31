//
//  Articles.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/26/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "Events.h"

#define APIKey @"679336f676c69291d1f183928375451"
#define APISearch @"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=%@"

@implementation Events

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        // Event Main
        self.eventDescription = [NSString stringWithFormat:@"<html><head></head><body> %@ </body></html>", dictionary[@"description"]];
        self.eventURL = dictionary[@"event_url"];
        self.eventName = dictionary[@"name"];
        self.eventID = dictionary[@"id"];
        self.rsvpCount = dictionary[@"yes_rsvp_count"];

        // Group
        self.groupName = dictionary[@"group"][@"name"];

        // Venue
        self.venueAddress = dictionary[@"venue"][@"address_1"];
        self.venueCity = dictionary[@"venue"][@"city"];
        self.venueState = dictionary[@"venue"][@"state"];
        self.venueName = dictionary[@"venue"][@"name"];

        // Address
        self.fullAddress = [NSString stringWithFormat:@"%@, %@, %@", self.venueAddress, self.venueCity, self.venueState];
    }
    return self;
}

+ (void)retrieveEventsUsingKeyword:(NSString *)keyword withCompletionHandler:(void (^)(NSMutableArray *events))completionHandler
{
    NSString *searchString = [NSString stringWithFormat:APISearch, keyword, APIKey];
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
                Events *model = [[Events alloc] initWithDictionary:searchItems];
                [searchResult addObject:model];
            }
            completionHandler(searchResult);
        }
    }];
}

@end
