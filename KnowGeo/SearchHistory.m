//
//  SearchHistory.m
//  KnowGeo
//
//  Created by Corey Norford on 6/3/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "SearchHistory.h"


@implementation SearchHistory

@dynamic text;
@dynamic timeStamp;
@synthesize objectContext;

- (id)initWithEntity:(NSEntityDescription*)entity insertIntoManagedObjectContext:(NSManagedObjectContext*)context{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (self != nil) {
        self.objectContext = context;
    }
    
    return self;
}

-(id)init{
    self = [super init];
    
    return self;
}

-(void)save{
    NSError *error = nil;
    
    if (![self.objectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(void)delete{
    [self.objectContext deleteObject:(NSManagedObject *)self];
    [self.objectContext save:nil];
}

+(NSMutableArray *)fetchAllWithContext:(NSManagedObjectContext *)context{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SearchHistory" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    for (SearchHistory *searchHistory in objects) {
        NSLog(@"Pin %@ was retrieved, the object count is %lu.", searchHistory.text, (unsigned long)objects.count);
    }
    
    return [(NSArray*)objects mutableCopy];
}

@end
