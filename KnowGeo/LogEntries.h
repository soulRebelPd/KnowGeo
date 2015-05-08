//
//  LogEntries.h
//  KnowGeo
//
//  Created by Corey Norford on 5/7/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogEntry.h"

@interface LogEntries : NSObject

-(LogEntries *)getLogs;
-(LogEntries *)getLogsOverCapacity;
-(bool)saveToDisk;
-(bool)delete:(LogEntry *)log;

@end
