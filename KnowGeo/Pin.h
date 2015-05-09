//
//  Pin.h
//  KnowGeo
//
//  Created by Corey Norford on 5/7/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@interface Pin : NSManagedObject

@property (copy, nonatomic) NSString *title;
@property NSString *subTitle;
@property NSNumber *latitude;
@property NSNumber *longitude;
@property NSNumber *locationTypeId;
@property bool isCloudSaved;
@property bool isLocallySaved;

-(void)initWithPin:(Pin *)pin;
-(bool)saveToCloud;
-(bool)saveToDisk;
-(bool)delete;

//NOTE: created for tutorial
//- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end


