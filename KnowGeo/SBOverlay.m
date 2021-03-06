//
//  KGOverlay.m
//  KnowGeo
//
//  Created by Corey Norford on 4/24/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "SBOverlay.h"
#import "SBPark.h"

@implementation SBOverlay

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)initWithPark:(SBPark *)park {
    self = [super init];
    if (self) {
        boundingMapRect = park.overlayBoundingMapRect;
        coordinate = park.midCoordinate;
    }
    
    return self;
}

@end
