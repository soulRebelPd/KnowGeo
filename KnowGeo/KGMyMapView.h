//
//  KGMyMapView.h
//  KnowGeo
//
//  Created by Corey Norford on 5/14/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "KGAnnotationView.h"

@class KGMyMapView;

@protocol KGMyMapViewDelegate <NSObject>
//-(void)kgMyMapView:(KGMyMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView delete:(BOOL)variable;
-(void)kgMyMapView:(KGMyMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateCategory:(NSNumber *)newCategoryId;
-(void)kgMyMapView:(KGMyMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateSubtype:(NSNumber *)newSubtypeId;
-(void)kgMyMapView:(KGMyMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateTitle:(NSString *)newTitle;
@end


@interface KGMyMapView : MKMapView <KGAnnotationViewDelegate>

@property (nonatomic, weak) NSObject <KGMyMapViewDelegate> *delegate2;
@property (strong, nonatomic) KGAnnotationView *annotationViewDeleting;

-(void)centerOnAnnotationView:(KGAnnotationView *)annotationView;

@end






