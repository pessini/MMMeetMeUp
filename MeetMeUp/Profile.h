//
//  Profile.h
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/26/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

@property NSString *memberName;
@property NSString *memberPhotoLink;
@property NSString *comment;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)requestMemberProfileWithMemberID:(NSString *)memberID
                              andEventID:(NSString *)eventID
                              andGroupID:(NSString *)groupID
                            andCommentID:(NSString *)commentID
                   withCompletionHandler:(void (^)(NSMutableArray *searchArray))completionHandler;
@end
