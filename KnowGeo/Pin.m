//
//  Pin.m
//  KnowGeo
//
//  Created by Corey Norford on 5/12/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "Pin.h"

@implementation Pin

@dynamic isCloudSaved;
@dynamic isLocallySaved;
@dynamic locationTypeId;
@dynamic subtypeId;
@dynamic subTitle;
@dynamic title;
@dynamic latitude;
@dynamic longitude;
@synthesize objectContext;

- (id)initWithEntity:(NSEntityDescription*)entity insertIntoManagedObjectContext:(NSManagedObjectContext*)context
{
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
    if([self.isCloudSaved isEqualToNumber:@1]){
    }
    else{
        [self.objectContext deleteObject:(NSManagedObject *)self];
        [self.objectContext save:nil];
    }
}

+(void)delete:(NSArray*)pins{
    for(Pin *pin in pins){
        [pin delete];
    }
}

+(NSMutableArray *)fetchAllWithContext:(NSManagedObjectContext *)context{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Pin" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    for (Pin *pin in objects) {
        NSLog(@"Pin %@ was retrieved, the object count is %d.", pin.title, objects.count);
    }
    
    return [(NSArray*)objects mutableCopy];
}

@end
