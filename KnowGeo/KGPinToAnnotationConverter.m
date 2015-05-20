//
//  PinToAnnotationConverter.m
//  KnowGeo
//
//  Created by Corey Norford on 5/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGPinToAnnotationConverter.h"

@implementation KGPinToAnnotationConverter

+(NSMutableArray *)convertToAnnotations:(NSArray*)pins{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for(Pin *pin in pins){
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([pin.latitude doubleValue], [pin.longitude doubleValue]);
        
        KGPointAnnotation *annotation = [[KGPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = pin.title;
        annotation.subtitle = pin.subTitle;
        annotation.pin = pin;
        
        [annotations addObject:annotation];
    }
    
    return annotations;
}

+(KGPointAnnotation*)convertToAnnotation:(Pin*)pin{
    KGPointAnnotation *annotation = [[KGPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake([pin.latitude doubleValue], [pin.longitude doubleValue]);
    annotation.title = pin.title;
    annotation.subtitle = pin.subTitle;
    annotation.pin = pin;
    
    return annotation;
}

@end
