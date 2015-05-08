//
//  Pin.h
//  KnowGeo
//
//  Created by Corey Norford on 5/7/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Pin : NSObject

@property NSString *name;
@property CLLocationCoordinate2D coordinate;
@property NSNumber *locationTypeId;

-(void)initWithPin:(Pin *)pin;
-(bool)isLocallySaved;
-(bool)isCloudSaved;
-(bool)saveToCloud;
-(bool)saveToDisk;
-(bool)delete;

@end


