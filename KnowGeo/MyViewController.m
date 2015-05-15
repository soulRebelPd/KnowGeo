//
//  ViewController.m
//  KnowGeo
//
//  Created by Corey Norford on 4/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "MyViewController.h"

@interface  MyViewController ()
@end

@implementation MyViewController

@synthesize managedObjectContext;
@synthesize pinEntityDescription;

- (void)viewDidLoad {
    self.pinEntityDescription = [NSEntityDescription entityForName:@"Pin" inManagedObjectContext:self.managedObjectContext];
    self.counter = @0;
    
    [super viewDidLoad];
    self.map.delegate = self;

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5; //user needs to press for half a second.
    [self.map addGestureRecognizer:longPress];
    
    self.localPins = [Pin fetchAllWithContext:self.managedObjectContext];
    self.localAnnotations = [KGPinToAnnotationConverter convertToAnnotations:self.localPins];
    [self.map addAnnotations:self.localAnnotations];
    
    //self.localPinsStrong = [Pins fetchAllWithContext:self.managedObjectContext];
    //[self.localPinsStrong testLoop];
    
    //[self placeLocallySavedPins:self.localPins];
    
    self.cloudPins = [self fetchDummyCloudPins];
    self.cloudAnnotations = [KGPinToAnnotationConverter convertToAnnotations:self.cloudPins];
    [self.map addAnnotations:self.cloudAnnotations];
    
    //[self placeCloudSavedPins:self.cloudPins];

//    NSArray *nibCallout = [[NSBundle mainBundle] loadNibNamed:@"KGCalloutView" owner:self options:nil];
//    KGCalloutView *callout = [nibCallout objectAtIndex:0];
//    self.callout = callout;
//    self.callout.frame = CGRectMake(35, 300, 300, 275);
//    [self.view addSubview:callout];

//    NSArray *nibContentsForTester = [[NSBundle mainBundle] loadNibNamed:@"KGCalloutTesterView" owner:self options:nil];
//    KGCalloutTesterView *tester = [nibContentsForTester objectAtIndex:0];
//    self.tester = tester;
//    self.tester.frame = CGRectMake(400, 300, 350, 350);
//    [self.view addSubview:tester];
//    self.tester.delegate = self;
    
    NSArray *nibContentsForMenu = [[NSBundle mainBundle] loadNibNamed:@"KGMenuView" owner:self options:nil];
    KGMenuView *menu = [nibContentsForMenu objectAtIndex:0];

    menu.dataSource = @{
                        @"Clear" : @"Clear.png",
                        @"Refresh" : @"Refresh.png",
                        @"Upload" : @"Upload.png",
                        @"Logs" : @"Logs.png"
                        };

    self.menu = menu;
    self.menu.delegate = self;
    [self.view addSubview:menu];
    
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self testPlacingImage];
//    [self testPlacingLine];
//    [self testCoreDataSave];
//    [self testCoreDataFind];
}

-(NSMutableArray *)fetchDummyCloudPins{
    SBPin *pin = [[SBPin alloc] init];
    pin.title = @"Test1";
    pin.subTitle = @"TestSubtitle1";
    pin.latitude = @37;
    pin.longitude = @37;
    pin.isLocallySaved = @0;
    pin.isCloudSaved = @1;
    
    SBPin *pin2 = [[SBPin alloc] init];
    pin2.title = @"Test2";
    pin2.subTitle = @"TestSubtitle2";
    pin2.latitude = @38;
    pin2.longitude = @38;
    pin2.isLocallySaved = @0;
    pin2.isCloudSaved = @1;
    
    NSMutableArray *pins = [[NSMutableArray alloc] init];
    [pins addObject:pin];
    [pins addObject:pin2];
    
    return pins;
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.map];
    CLLocationCoordinate2D touchMapCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    
    Pin *pin = [[Pin alloc] initWithEntity:self.pinEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    pin.title = @"New Title";
    pin.subTitle = @"New Subtitle";
    pin.latitude = [NSNumber numberWithDouble:touchMapCoordinate.latitude];
    pin.longitude = [NSNumber numberWithDouble:touchMapCoordinate.longitude];
    pin.isLocallySaved = @1;
    pin.isCloudSaved = @0;
    [pin save];
    
    self.localPins = [Pin fetchAllWithContext:self.managedObjectContext];
    
    KGPointAnnotation *annotation = [KGPinToAnnotationConverter convertToAnnotation:pin];

    [self.map addAnnotation:annotation];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    KGAnnotationView *kgAnnotationView = (KGAnnotationView *)[self.map dequeueReusableAnnotationViewWithIdentifier: @"AnnotationView"];
    
    if (kgAnnotationView == nil) {
        kgAnnotationView = [[KGAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: @"AnnotationView"]; // If you use ARC, take out 'autorelease'
    } else {
        kgAnnotationView.annotation = annotation;
    }
    
    KGPointAnnotation *kgPointAnnotation = (KGPointAnnotation *)annotation;
    kgAnnotationView.pin = kgPointAnnotation.pin;
    
    if([kgAnnotationView.pin.isCloudSaved isEqual:@1]){
        kgAnnotationView.pinColor = MKPinAnnotationColorPurple;
    }
    else{
        kgAnnotationView.pinColor = MKPinAnnotationColorRed;
    }
    
    kgAnnotationView.animatesDrop = YES;
    kgAnnotationView.draggable = YES;
    kgAnnotationView.userInteractionEnabled = YES;
    kgAnnotationView.enabled = YES;
    kgAnnotationView.parent = self.map;
    kgAnnotationView.delegate = self.map;
    
    NSLog(@"Annotation:%@", kgAnnotationView.annotation);
    
    return kgAnnotationView;
    
    //NOTE: code for using a custom annotation that displays a callout
//    SBCalloutView *callout = [[SBCalloutView alloc] init];
//    return callout;
    
    //NOTE: code to try to add stuff to left or right accessory view
//    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
//    
//    UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,50,50)];
//    UITextView *textView = [[UITextView alloc] init];
//    textView.text = @"Hello";
//    textView.textColor = [UIColor blackColor];
//    
//    UILabel *label = [[UILabel alloc] init];
//    label.text = @"Hello2";
//    label.textColor = [UIColor blackColor];
//    
//    [leftCAV addSubview:textView];
//    [leftCAV addSubview:label];
//    
//    annotationView.leftCalloutAccessoryView = leftCAV;
//    
//    annotationView.canShowCallout = YES;
//    
//    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(KGAnnotationView *)view{
    [view openCallout];
    
    NSLog(@"Annotation Selected:%@", view.annotation);
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    KGAnnotationView *annotationView = (KGAnnotationView *)view;
    
    if([annotationView.pin.isCloudSaved isEqual:@1]){
        [self.cloudPins removeObject:annotationView.pin];
    }
    else{
        [self.localPins removeObject:annotationView.pin];
    }
    
    [annotationView.pin delete];
    
    NSLog(@"Deleting Pin:%@", annotationView.pin);
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
}

- (void)mapView:(MKMapView *)mapView
    annotationView:(MKAnnotationView *)annotationView
    didChangeDragState:(MKAnnotationViewDragState)newState
    fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
    }
}

-(void)testKvoBinding{
}

-(void)testPlacingImage{
    SBPark *park = [[SBPark alloc] initWithFilename:@"BoldBean"];
    
    CLLocationDegrees latDelta = park.overlayTopLeftCoordinate.latitude - park.overlayBottomRightCoordinate.latitude;
    // think of a span as a tv size, measure from one corner to another
    MKCoordinateSpan span = MKCoordinateSpanMake(fabs(latDelta), 4.0);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(park.midCoordinate, span);
    self.map.region = region;
    
    KGOverlay *overlay = [[KGOverlay alloc] initWithPark:park];
    [self.map addOverlay:overlay];
    
    //NOTE: bold bean location +30.31556400,-81.68919900
}

- (void)testPlacingLine {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"RiversideLine" ofType:@"plist"];
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:thePath];
    
    NSInteger pointsCount = pointsArray.count;
    
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for(int i = 0; i < pointsCount; i++) {
        CGPoint p = CGPointFromString(pointsArray[i]);
        pointsToUse[i] = CLLocationCoordinate2DMake(p.x,p.y);
    }
    
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    
    [self.map addOverlay:myPolyline];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:KGOverlay.class]) {
        UIImage *image = [UIImage imageNamed:@"SBPark"];
        KGMapOverlayView *overlayView = [[KGMapOverlayView alloc] initWithOverlay:overlay overlayImage:image];
        
        return overlayView;
    } else if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineView.strokeColor = [UIColor kgOrangeColor];
        lineView.lineWidth = 3;
        
        return lineView;
    }
    
    return nil;
}

- (void)requestNewItemsWithText:(NSString *)text withRegion:(MKCoordinateRegion)region completion:(void (^)(void))completionBlock{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = text;
    request.region = region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.mapItems = response.mapItems;
        
        if(response.mapItems != nil && response.mapItems.count > 0){
            completionBlock();
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView clearStatePressed:(BOOL)variable{
    [self.callout moveToState:@"Empty"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testRegularLocationAnyPressed:(BOOL)variable{
    [self.callout moveToState:@"Regular-Location-Dropped"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testRegularLineDroppedPressed:(BOOL)variable{
    [self.callout moveToState:@"Regular-Line-Dropped"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testDrawingLineDroppedPressed:(BOOL)variable{
    [self.callout moveToState:@"Drawing-Line-Dropped"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testColoringLineSelectedPressed:(BOOL)variable{
    [self.callout moveToState:@"Coloring-Line-Selected"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testRegularLineSelected_WithParentPressed:(BOOL)variable{
    [self.callout moveToState:@"Regular-Line-Selected_WithParent"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testRegularLineSelected_NoParentPressed:(BOOL)variable{
    [self.callout moveToState:@"Regular-Line-Selected_NoParent"];
    return YES;
}

-(BOOL)menuView:(KGMenuView *)menuView buttonPressed:(KGMenuButton *)button{
    NSString *buttonTitle = button.title;
    if([buttonTitle isEqualToString:@"Clear"]){
        NSLog(@"%@ Pressed", buttonTitle);
        
        [self.map removeAnnotations:self.localAnnotations];
        [Pin delete:self.localPins];
        [self.localPins removeObjectsInArray:self.localPins];
        [self.localAnnotations removeObjectsInArray:self.localAnnotations];
    }
    else if([buttonTitle isEqualToString:@"Refresh"]){
        NSLog(@"%@ Pressed", buttonTitle);
    }
    else if([buttonTitle isEqualToString:@"Upload"]){
        NSLog(@"%@ Pressed", buttonTitle);
    }
    else if([buttonTitle isEqualToString:@"Logs"]){
        NSLog(@"%@ Pressed", buttonTitle);
    }
    
    return YES;
}

-(void)didLongTouch{
    //drops pin and open callout dialog
}

-(void)didTouch{
}

-(void)uploadToCloud{
}

-(void)reloadData{
    //called after uploadToCloud
}

-(bool)reloadCloudData{
    //will resend cloudPinCollection and localPinCollection, looping through each collection and adding things to the map
    return YES;
}

-(void)addedAnnotationView{
    //if isCloudSaved change color
}

-(void)movePin{
}

-(void)clear{
}

-(void)showLogViewController{
}

-(void)toggledDeleteWarnings{
}

-(NSMutableArray *)runCoreDataTest{
    [self createNewAndSave];
    NSMutableArray *pins = [Pin fetchAllWithContext:self.managedObjectContext];
    return pins;
}

-(void)createNewAndSave{
    Pin *pin = [[Pin alloc] initWithEntity:self.pinEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    pin.title = @"Title";
    pin.subTitle = @"Subtitle";
    pin.latitude = @1;
    pin.longitude = @1;
    pin.locationTypeId = @1;
    pin.isCloudSaved = @1;
    pin.isLocallySaved = @0;
    
    [pin save];
}

-(void)placeCloudSavedPins:(NSMutableArray *)pins{
    for(Pin *pin in self.cloudPins){
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([pin.latitude doubleValue], [pin.longitude doubleValue]);
        
        KGPointAnnotation *annotation = [[KGPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = pin.title;
        annotation.subtitle = pin.subTitle;
        annotation.pin = pin;
        //annotation.pinColor = MKPinAnnotationColorRed;
        
        [self.map addAnnotation:annotation];
    }
}

-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView deleteInitiated:(BOOL)variable{
    [self.map removeAnnotation:kGAnnotationView.annotation];
}

//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    if (view.annotation == self.customAnnotation) {
//        if (self.calloutAnnotation == nil) {
//            self.calloutAnnotation = [[CalloutMapAnnotation alloc]
//                                      initWithLatitude:view.annotation.coordinate.latitude
//                                      andLongitude:view.annotation.coordinate.longitude];
//        } else {
//            self.calloutAnnotation.latitude = view.annotation.coordinate.latitude;
//            self.calloutAnnotation.longitude = view.annotation.coordinate.longitude;
//        }
//        [self.mapView addAnnotation:self.calloutAnnotation];
//        self.selectedAnnotationView = view;
//    }
//}
//
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    if (annotation == self.calloutAnnotation) {
//        CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
//        if (!calloutMapAnnotationView) {
//            calloutMapAnnotationView = [[[CalloutMapAnnotationView alloc] initWithAnnotation:annotation
//                                                                             reuseIdentifier:@"CalloutAnnotation"] autorelease];
//        }
//        calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
//        calloutMapAnnotationView.mapView = self.mapView;
//        return calloutMapAnnotationView;
//    } else if (annotation == self.customAnnotation) {
//        MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
//                                                                               reuseIdentifier:@"CustomAnnotation"] autorelease];
//        annotationView.canShowCallout = NO;
//        annotationView.pinColor = MKPinAnnotationColorGreen;
//        return annotationView;
//    } else if (annotation == self.normalAnnotation) {
//        MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
//                                                                               reuseIdentifier:@"NormalAnnotation"] autorelease];
//        annotationView.canShowCallout = YES;
//        annotationView.pinColor = MKPinAnnotationColorPurple;
//        return annotationView;
//    }
//
//    return nil;
//}

//-(void)placeLocallySavedPins:(NSMutableArray *)pins{
//    for(Pin *pin in self.localPins){
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([pin.latitude doubleValue], [pin.longitude doubleValue]);
//
//        KGPointAnnotation *annotation = [[KGPointAnnotation alloc] init];
//        annotation.coordinate = coordinate;
//        annotation.title = pin.title;
//        annotation.subtitle = pin.subTitle;
//        annotation.pin = pin;
//
//        [self.map addAnnotation:annotation];
//    }
//}

@end
