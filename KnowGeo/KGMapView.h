//
//  KGMyMapView.h
//  KnowGeo
//
//  Created by Corey Norford on 5/14/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "KGAnnotationView.h"
#import "KGPointAnnotation.h"

@class KGMapView;

@protocol KGMapViewDelegate <NSObject>
-(void)kgMyMapView:(KGMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateType:(NSNumber *)newTypeId;
-(void)kgMyMapView:(KGMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateSubtype:(NSNumber *)newSubtypeId;
-(void)kgMyMapView:(KGMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateTitle:(NSString *)newTitle;
@end


@interface KGMapView : MKMapView <KGAnnotationViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) NSObject <KGMapViewDelegate> *delegate2;
@property (strong, nonatomic) KGAnnotationView *annotationViewDeleting;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property bool initialZoomToLocationComplete;
@property bool intermediateAnimation;
@property MKCoordinateRegion destinationRegion;

-(void)centerOnAnnotationView:(KGAnnotationView *)annotationView;
-(MKPinAnnotationColor)calculatePinColor:(Pin *)pin;
-(void)zoomToLastLocation;
    
@end






