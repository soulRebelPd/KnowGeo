//
//  KGAnnotationView.h
//  KnowGeo
//
//  Created by Corey Norford on 5/9/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

#import "Pin.h"
#import "KGCalloutView.h"
#import "KGAnnotationView.h"

@class KGAnnotationView;

@protocol KGAnnotationViewDelegate <NSObject>
-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView delete:(BOOL)variable;
-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView updateCategory:(NSNumber *)newCategoryId;
-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView updateSubtype:(NSNumber *)newSubtypeId;
-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView updateTitle:(NSString *)newTitle;
@end

@interface KGAnnotationView : MKPinAnnotationView <KGCalloutViewDelegate>

@property (nonatomic, strong) Pin *pin;
@property (nonatomic) KGCalloutView *calloutView;
@property MKMapView *parent;
@property (nonatomic, weak) NSObject <KGAnnotationViewDelegate> *delegate;
@property bool deleting;

-(void)openCallout;

@end