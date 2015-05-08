//
//  LogEntry.h
//  KnowGeo
//
//  Created by Corey Norford on 5/7/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogEntry : NSObject

@property NSString *message;
@property NSString *detailedMessage;
@property NSDate *timeCreated;

-(bool)saveToDisk;
-(bool)delete;

@end


