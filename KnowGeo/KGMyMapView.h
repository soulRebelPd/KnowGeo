//
//  KGMyMapView.h
//  KnowGeo
//
//  Created by Corey Norford on 5/14/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "KGAnnotationView.h"

@interface KGMyMapView : MKMapView <KGAnnotationViewDelegate>

//-(void)deleteAnnotation:(MKPointAnnotation *)annotationView;

@end
