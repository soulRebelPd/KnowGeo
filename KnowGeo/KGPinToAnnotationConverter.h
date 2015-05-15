//
//  PinToAnnotationConverter.h
//  KnowGeo
//
//  Created by Corey Norford on 5/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "Pin.h"
#import "KGPointAnnotation.h"

@interface KGPinToAnnotationConverter : NSObject

+(NSMutableArray*)convertToAnnotations:(NSArray*)pins;
+(KGPointAnnotation*)convertToAnnotation:(Pin*)pin;

@end
