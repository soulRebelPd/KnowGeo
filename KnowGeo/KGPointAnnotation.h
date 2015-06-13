//
//  KGPointAnnotation.h
//  KnowGeo
//
//  Created by Corey Norford on 5/13/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Pin.h"

@interface KGPointAnnotation : MKPointAnnotation

@property (nonatomic) Pin *pin;
@property (nonatomic) MKPinAnnotationColor pinColor;
@property bool isDropping;
@property bool isUpdatingColor;

@end
