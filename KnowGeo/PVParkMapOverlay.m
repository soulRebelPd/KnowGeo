//
//  PVParkMapOverlay.m
//  Park View
//
//  Created by Corey Norford on 4/23/15.
//  Copyright (c) 2015 Chris Wagner. All rights reserved.
//

#import "PVParkMapOverlay.h"

@implementation PVParkMapOverlay

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)initWithPark:(PVPark *)park {
    self = [super init];
    if (self) {
        //NOTE: commented out because don't have park object
        //boundingMapRect = park.overlayBoundingMapRect;
        //coordinate = park.midCoordinate;
    }
    
    return self;
}

@end
