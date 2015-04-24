//
//  PVParkMapOverlay.h
//  Park View
//
//  Created by Corey Norford on 4/23/15.
//  Copyright (c) 2015 Chris Wagner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class PVPark;

@interface PVParkMapOverlay : NSObject <MKOverlay>

- (instancetype)initWithPark:(PVPark *)park;

@end
