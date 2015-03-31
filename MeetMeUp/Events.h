//
//  Articles.h
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/26/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Events : NSObject

@property NSString *eventDescription;
@property NSString *eventURL;
@property NSString *eventName;
@property NSString *eventID;
@property NSString *rsvpCount;
@property NSString *groupName;
@property NSString *venueAddress;
@property NSString *venueCity;
@property NSString *venueState;
@property NSString *venueName;
@property NSString *fullAddress;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (void)retrieveEventsUsingKeyword:(NSString *)keyword withCompletionHandler:(void (^)(NSMutableArray *events))completionHandler;

@end
