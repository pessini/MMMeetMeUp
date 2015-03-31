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
@property NSURL *memberPhotoLink;
@property NSString *city;
@property NSString *state;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)getImageDataWithCompletion:(void (^)(NSData *imageData, NSError *error))complete;

+ (Profile *)retrieveMemberProfileWithID:(NSString *)memberID;

@end
