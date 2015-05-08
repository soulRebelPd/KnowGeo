//
//  KGOverlay.h
//  KnowGeo
//
//  Created by Corey Norford on 4/24/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SBPark.h"

@interface KGOverlay : NSObject <MKOverlay>

- (instancetype)initWithPark:(SBPark *)park;

// coordinate;
//@synthesize boundingMapRect;

@end
