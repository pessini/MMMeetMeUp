//
//  API.h
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/26/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Events.h"

@interface API : NSObject

+(API *)sharedInstance;

@property NSMutableArray *receivedItems;

-(void)apiRequestFromURL:(NSString *)string;

@end
