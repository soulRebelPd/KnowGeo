//
//  DiskOperations.h
//  KnowGeo
//
//  Created by Corey Norford on 6/10/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiskOperations : NSObject

+ (void)createFileWithFullPath:(NSString *)fullPath;
+ (void)saveToDiskWithFullPath:(NSString *)fullPath andDataString:(NSString *)dataString;

@end
