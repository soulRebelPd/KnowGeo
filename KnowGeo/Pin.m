//
//  Pin.m
//  KnowGeo
//
//  Created by Corey Norford on 5/7/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "Pin.h"
#import "AppDelegate.h"

@implementation Pin

@synthesize locationTypeId;
@synthesize subTitle;
@synthesize title;
@synthesize latitude;
@synthesize longitude;
@synthesize isCloudSaved;
@synthesize isLocallySaved;

//-(id)init{
//    self = [super init];
//    
//    return self;
//}

-(void)initWithPin:(Pin *)pin{
}

-(bool)saveToCloud{
    return YES;
}

-(bool)saveToDisk{
    // NOTE: should be created with context as class variable?
    // NOTE: should pass in through constructor?
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    self.isLocallySaved = YES;
    
    NSError *error;
    [context save:&error];
    
    //TODO: check if error before returning YES
    return YES;
}

-(bool)delete{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    //TODO: add error object
    [context deleteObject:(NSManagedObject *)self];
    [context save:nil];
    
    return YES;
}

//NOTE: added for tutorial
//- (NSString *)subtitle{
//    return nil;
//}
//
//- (NSString *)title{
//    return nil;
//}

//-(id)initWithCoordinate:(CLLocationCoordinate2D)coord {
//    coordinate=coord;
//    return self;
//}

//-(CLLocationCoordinate2D)coord
//{
//    return coordinate;
//}

//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
//    coordinate = newCoordinate;
//}

@end
