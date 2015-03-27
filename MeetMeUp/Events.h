//
//  Articles.h
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/26/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Events : NSObject

+(Events *)sharedInstance;

@property NSString *eventDescription;
@property NSString *eventURL;
@property NSString *eventName;
@property NSString *eventID;
@property NSString *rsvpCount;

@property NSString *groupName;
@property NSString *groupID;
@property NSString *groupURLName;

@property NSString *venueAddress;
@property NSString *venueCity;
@property NSString *venueState;
@property NSString *venueName;

@property NSURL *image;

@property NSArray *comments;

@property NSString *fullAddress;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)searchWithKeyword:(NSString *)keyword withCompletionHandler:(void(^)(NSMutableArray *searchArray))completionHandler;

@end
