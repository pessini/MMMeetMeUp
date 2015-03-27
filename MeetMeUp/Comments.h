//
//  Comments.h
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/26/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "Events.h"

@interface Comments : NSObject

@property NSString *comment;
@property NSString *memberName;
@property NSString *memberID;
@property NSString *time;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)requestCommentsFromEventID: (NSString *)eventID withCompletionHandler:(void (^)(NSMutableArray *searchArray))completionHandler;

@end
