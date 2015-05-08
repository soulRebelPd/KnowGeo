//
//  Note.m
//  BlocNotes
//
//  Created by Corey Norford on 3/19/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "TestObject.h"
#import "AppDelegate.h"


@implementation TestObject

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
    // NOTE: create method to create a new instance of a note?
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSManagedObject *newNote = [NSEntityDescription
                                insertNewObjectForEntityForName:@"TestObject"
                                inManagedObjectContext:context];
    
    [newNote setValue: self.name forKey:@"name"];
    [newNote setValue: self.latitude forKey:@"latitude"];
    [newNote setValue: self.longitude forKey:@"longitude"];
    
    NSError *error;
    [context save:&error];
}

-(void)save{
    // NOTE: should be created with context as class variable?
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
//    if(self.name == nil || [self.name isEqualToString:@""]){
//        return;
//    }
    
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
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"TestObject" inManagedObjectContext:context];
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

//TODO: make mutable
+(NSMutableArray *)findAll{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"TestObject" inManagedObjectContext:context];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    NSMutableArray *mutableObjects = [(NSArray*)objects mutableCopy];
    
    return mutableObjects;
}

//+(Note *)findFirstMatchByText:(NSString *)searchText{
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
//    [request setEntity:entityDesc];
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(text = %@)", searchText];
//    [request setPredicate:pred];
//    
//    NSError *error;
//    NSArray *objects = [context executeFetchRequest:request error:&error];
//    
//    Note *note;
//    if ([objects count] > 0) {
//        note = objects[0];
//    }
//    
//    return note;
//}


@end
