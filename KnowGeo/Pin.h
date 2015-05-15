//
//  Pin.h
//  KnowGeo
//
//  Created by Corey Norford on 5/12/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Pins.h"

@interface Pin : NSManagedObject

@property (nonatomic, retain) NSNumber * isCloudSaved;
@property (nonatomic, retain) NSNumber * isLocallySaved;
@property (nonatomic, retain) NSNumber * locationTypeId;
@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@property (strong, nonatomic) NSManagedObjectContext *objectContext;

-(void)save;
-(void)delete;

+(NSMutableArray *)fetchAllWithContext:(NSManagedObjectContext *)context;
+(void)delete:(NSArray*)pins;
    
@end
