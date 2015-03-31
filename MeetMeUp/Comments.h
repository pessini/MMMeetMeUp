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
@property NSString *time;
@property NSString *memberID;
@property NSString *groupID;
@property NSString *commentID;
@property NSString *eventID;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)convertStringTimestampToDate:(NSString *)timestamp;

+ (void)retrieveCommentsFromEvent:(NSString *)eventID withCompletionHandler:(void (^)(NSMutableArray *comments))completionHandler;

@end
