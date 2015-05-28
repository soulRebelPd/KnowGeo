//
//  TestObject.m
//  BlocNotes
//
//  Created by Corey Norford on 3/19/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "SBObject.h"
#import "AppDelegate.h"


@implementation SBObject

@dynamic name;
@dynamic latitude;
@dynamic longitude;

- (id)initWithEntity:(NSEntityDescription*)entity insertIntoManagedObjectContext:(NSManagedObjectContext*)context
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (self != nil) {
        
    }
    
    return self;
}

-(void)insert{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSManagedObject *testObject = [NSEntityDescription
                                insertNewObjectForEntityForName:@"SBObject"
                                inManagedObjectContext:context];
    
    [testObject setValue: self.name forKey:@"name"];
    [testObject setValue: self.latitude forKey:@"latitude"];
    [testObject setValue: self.longitude forKey:@"longitude"];
    
    NSError *error;
    [context save:&error];
}

-(void)save{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSError *error;
    [context save:&error];
}

-(void)delete{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:(NSManagedObject *)self];
    [context save:nil];
}

#pragma mark - Private Methods

-(NSManagedObject *)findFirstObjectMatchByText:(NSString *)searchText{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"SBObject" inManagedObjectContext:context];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)", searchText];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    NSManagedObject *match = nil;
    if ([objects count] > 0) {
        match = objects[0];
    }
    
    return match;
}

#pragma mark - Class Methods

+(NSMutableArray *)findAll{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"SBObject" inManagedObjectContext:context];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    NSMutableArray *mutableObjects = [(NSArray*)objects mutableCopy];
    
    return mutableObjects;
}

@end
