//
//  KGOverlay.m
//  KnowGeo
//
//  Created by Corey Norford on 4/24/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGOverlay.h"
#import "SBPark.h"

@implementation KGOverlay

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

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        //NOTE: this is where coordinate and boundingMapRect were being set
//        [self setBoundingMapRect2];
//    }
//
//    return self;
//}
//
//-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
//    coordinate = newCoordinate;
//}
//
//- (void)setBoundingMapRect2
//{
//
//    MKMapPoint upperLeft = MKMapPointForCoordinate(self.coordinate);
//
//    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, 20000, 20000);
//    boundingMapRect = bounds;
//}

@end
