//
//  KGMyMapView.m
//  KnowGeo
//
//  Created by Corey Norford on 5/14/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGMapView.h"

#define METERS_PER_MILE 0.3f

@implementation KGMapView

@synthesize initialZoomToLocationComplete;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        self.initialZoomToLocationComplete = NO;
        [self.locationManager startUpdatingLocation];
    }

    return self;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        [self removeAnnotation:self.annotationViewDeleting.annotation];
        NSLog(@"Yes Tapped.");
    }
}

-(void)centerOnAnnotationView:(KGAnnotationView *)annotationView{
    MKMapRect mapRect = [self visibleMapRect];
    MKMapPoint mapPoint = MKMapPointForCoordinate([annotationView.annotation coordinate]);
    mapRect.origin.x = mapPoint.x - mapRect.size.width * 0.5;
    mapRect.origin.y = mapPoint.y - mapRect.size.height * 0.75;
    [self setVisibleMapRect:mapRect animated:YES];
}

#pragma mark MapKit Customizations

-(MKPinAnnotationColor)calculatePinColor:(Pin *)pin{
    NSString *defaultTitle = [Pin defaultTitle];
    
    if([pin.isCloudSaved isEqual:@1]){
        return MKPinAnnotationColorGreen;
    }
    else if([pin.title isEqualToString:defaultTitle] ||
            [pin.typeId isEqualToNumber: @0] ||
            [pin.subtypeId isEqualToNumber:@0]){
        return MKPinAnnotationColorRed;
    }
    else{
        return MKPinAnnotationColorPurple;
    }
}

-(void)zoomToLastLocation{
    CLLocation *location = [self getLastLocation];
    
    CLLocationCoordinate2D center;
    center.latitude = location.coordinate.latitude;
    center.longitude= location.coordinate.longitude;
    
    MKCoordinateSpan span;
    span.latitudeDelta = METERS_PER_MILE;
    span.longitudeDelta = METERS_PER_MILE;
    
    MKCoordinateRegion viewRegion;
    viewRegion.center = center;
    viewRegion.span = span;

    [self setRegion:viewRegion animated:YES];
}

- (CLLocation *) getLastLocation{
    return self.locationManager.location;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(self.initialZoomToLocationComplete == NO){
        [self zoomToLastLocation];
        self.initialZoomToLocationComplete = YES;
    }
    
    NSLog(@"Location: %@", [locations lastObject]);
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView
    annotationView:(MKAnnotationView *)annotationView
    didChangeDragState:(MKAnnotationViewDragState)newState
    fromOldState:(MKAnnotationViewDragState)oldState{
    
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:SBOverlay.class]) {
        UIImage *image = [UIImage imageNamed:@"SBPark"];
        SBOverlayRenderer *overlayView = [[SBOverlayRenderer alloc] initWithOverlay:overlay overlayImage:image];
        
        return overlayView;
    } else if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineView.strokeColor = [UIColor kgOrangeColor];
        lineView.lineWidth = 3;
        
        return lineView;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
}

#pragma mark KGAnnotationViewDelegate

-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView updateType:(NSNumber *)newTypeId{
    [self.delegate2 kgMyMapView:self kgAnnotationView:kGAnnotationView updateType:newTypeId];
}

-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView updateSubtype:(NSNumber *)newSubtypeId{
    [self.delegate2 kgMyMapView:self kgAnnotationView:kGAnnotationView updateSubtype:newSubtypeId];
}

-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView updateTitle:(NSString *)newTitle{
    [self.delegate2 kgMyMapView:self kgAnnotationView:kGAnnotationView updateTitle:newTitle];
}

-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView closing:(bool)variable{
    [self deselectAnnotation:kGAnnotationView.annotation animated:YES];
}

-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView delete:(BOOL)variable{
    self.annotationViewDeleting = kGAnnotationView;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete pin?"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes",nil];
    
    [alert show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
