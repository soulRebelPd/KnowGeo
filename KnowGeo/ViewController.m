//
//  ViewController.m
//  KnowGeo
//
//  Created by Corey Norford on 4/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "ViewController.h"
#import "KGMapOverlayView.h"
#import "SBPark.h"
#import "UIColor+KGColors.h"
#import "TestObject.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.map.delegate = self;
    
    [self testPlacingImage];
    [self testPlacingLine];
    [self testCoreDataSave];
    [self testCoreDataFind];
    
    NSArray *nibCallout = [[NSBundle mainBundle] loadNibNamed:@"KGCalloutView" owner:self options:nil];
    KGCalloutView *callout = [nibCallout objectAtIndex:0];
    self.callout = callout;
    self.callout.frame = CGRectMake(35, 300, 300, 275);
    [self.view addSubview:callout];
    
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

    NSArray *nibContentsForTester = [[NSBundle mainBundle] loadNibNamed:@"KGCalloutTesterView" owner:self options:nil];
    KGCalloutTesterView *tester = [nibContentsForTester objectAtIndex:0];
    self.tester = tester;
    self.tester.frame = CGRectMake(400, 300, 350, 350);
    [self.view addSubview:tester];
    self.tester.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
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
