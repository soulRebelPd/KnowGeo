//
//  SearchHistory.h
//  KnowGeo
//
//  Created by Corey Norford on 6/3/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SearchHistory : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate *timeStamp;

@property (strong, nonatomic) NSManagedObjectContext *objectContext;

- (void)save;
- (void)delete;

+ (NSMutableArray *)fetchAllWithContext:(NSManagedObjectContext *)context;

@end
