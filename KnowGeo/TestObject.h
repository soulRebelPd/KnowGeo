//
//  Note.h
//  BlocNotes
//
//  Created by Corey Norford on 3/19/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TestObject : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

-(void)insert;
-(void)save;
-(void)delete;
- (id)initWithEntity:(NSEntityDescription*)entity insertIntoManagedObjectContext:(NSManagedObjectContext*)context;

//+(Note *)findFirstMatchByText:(NSString *)note;
+(NSMutableArray *)findAll;

@end

