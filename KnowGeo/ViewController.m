//
//  ViewController.m
//  KnowGeo
//
//  Created by Corey Norford on 4/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.map.delegate = self;
    
    //NOTE: pass this in so concerns are separated?
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.context = [appDelegate managedObjectContext];
    
    // Create a gesture recognizer for long presses (for example in viewDidLoad)
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5; //user needs to press for half a second.
    [self.map addGestureRecognizer:longPress];
    
    [self testPinDrop];
//    [self testPlacingImage];
//    [self testPlacingLine];
//    [self testCoreDataSave];
//    [self testCoreDataFind];
    
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
//- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
//    if (self.calloutAnnotation && view.annotation == self.customAnnotation) {
//        [self.mapView removeAnnotation: self.calloutAnnotation];
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

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    KGAnnotationView *pin = (KGAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    
    if (pin == nil) {
        pin = [[KGAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"myPin"]; // If you use ARC, take out 'autorelease'
    } else {
        pin.annotation = annotation;
    }
    
    pin.animatesDrop = YES;
    pin.draggable = YES;
    pin.userInteractionEnabled = YES;
    pin.enabled = YES;
    
    return pin;
    
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    //http://stackoverflow.com/questions/15241340/how-to-add-custom-view-in-maps-annotations-callouts/19404994#19404994
    NSArray *nibCallout = [[NSBundle mainBundle] loadNibNamed:@"KGCalloutView" owner:self options:nil];
    KGCalloutView *callout = [nibCallout objectAtIndex:0];
    self.callout = callout;
    callout.center = CGPointMake(view.bounds.size.width*0.5f, -view.bounds.size.height*4);
    [view addSubview:callout];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.map];
    CLLocationCoordinate2D touchMapCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = touchMapCoordinate;
    point.title = @"BHello";
    point.subtitle = @"Hello2";

//    for (id annotation in self.map.annotations) {
//        [self.map removeAnnotation:annotation];
//    }
    
    [self.map addAnnotation:point];
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

-(void)testPinDrop{
    //Pin *pin = [[Pin alloc] init];
    Pin *pin = [NSEntityDescription insertNewObjectForEntityForName:@"Pin" inManagedObjectContext:self.context];
    pin.title = @"Bold Bean";
    pin.latitude = @30.315564;
    pin.longitude = @-81.689199;
    //pin.coordinate = CLLocationCoordinate2DMake(30.315564, -81.689199);
    [pin saveToDisk];
    
    //CGPoint touchPoint = [gestureRecognizer locationInView:self.map];
    //CLLocationCoordinate2D touchMapCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([pin.latitude doubleValue], [pin.longitude doubleValue]);
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = pin.title;
    
    [self.map addAnnotation:annotation];
}

-(void)testCoreDataSave{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    TestObject *testObject = [NSEntityDescription insertNewObjectForEntityForName:@"TestObject" inManagedObjectContext:context];
    
    testObject.name = @"Bold Bean";
    testObject.latitude = @30.315564;
    testObject.longitude = @-81.689199;
    
    [testObject save];
}

-(void)testCoreDataFind{
    NSArray *testObjects = [TestObject findAll];
}

-(void)testKvoBinding{
    
}

-(void)testPlacingImage{
    //NOTE: make this a shape? later
    //NOTE: remove park in general so can see why it works? no just see how it works
    
    SBPark *park = [[SBPark alloc] initWithFilename:@"BoldBean"];
    
    CLLocationDegrees latDelta = park.overlayTopLeftCoordinate.latitude - park.overlayBottomRightCoordinate.latitude;
    // think of a span as a tv size, measure from one corner to another
    MKCoordinateSpan span = MKCoordinateSpanMake(fabsf(latDelta), 4.0);
    
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


@end
