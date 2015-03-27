//
//  API.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/26/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "API.h"

@implementation API

+(API *)sharedInstance
{
    static dispatch_once_t once;
    static API *instance;
    dispatch_once(&once, ^{
        if (!instance)
        {
            instance = [[API alloc] init];
        }
    });
    return instance;
}

-(void)apiRequestFromURL: (NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (!data)
        {
            NSLog(@"%s: sendAynchronousRequest error: %@", __FUNCTION__, connectionError);
            return;
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"%s: sendAsynchronousRequest status code != 200: response = %@", __FUNCTION__, response);
                return;
            }
        }

        NSError *parseError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!dictionary)
        {
            NSLog(@"%s: JSONObjectWithData error: %@; data = %@", __FUNCTION__, parseError, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            return;
        }

        NSArray *itemArray = dictionary[@"results"];
        for (NSDictionary *items in itemArray) {
            Events *model = [[Events alloc] initWithDictionary:items];
            [self.receivedItems addObject:model];
            NSLog(@"%@", model.eventName);
        }
    }];
}

@end
