//
//  DiskOperations.m
//  KnowGeo
//
//  Created by Corey Norford on 6/10/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "DiskOperations.h"

@implementation DiskOperations

+ (void)createFileWithFullPath:(NSString *)fullPath{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager createFileAtPath:fullPath contents:nil attributes:nil]) {
        NSLog(@"Created the File Successfully.");
    } else {
        NSLog(@"Failed to Create the File");
    }
}

+ (void)saveToDiskWithFullPath:(NSString *)fullPath andDataString:(NSString *)dataString{
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fullPath contents:nil attributes:nil];
    }

    NSLog(@"writeString :%@",dataString);
    
    //say to handle where's the file fo write
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:fullPath];
    
    //position handle cursor to the end of file
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
