//
//  ViewController.m
//  KnowGeo
//
//  Created by Corey Norford on 4/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "MainViewController.h"

@interface  MainViewController ()
@end

@implementation MainViewController

@synthesize managedObjectContext;
@synthesize pinEntityDescription;
@synthesize pulloutMenuVisibility;
@synthesize searchHistoryTableView;

#pragma - markup UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchHistory count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.backgroundColor = [UIColor kgMediumBrownColor];
    cell.textLabel.textColor = [UIColor kgOrangeColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    SearchHistory *history = [self.searchHistory objectAtIndex:indexPath.row];
    cell.textLabel.text = history.text;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
    
    SearchHistory *history = [self.searchHistory objectAtIndex:indexPath.row];
    [self search:history.text];
    [self hidePulloutMenu:YES];
    
    self.searchBar.text = history.text;
    [self.searchHistoryTableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UIAlertView *alertView = [[UIAlertView alloc]
//                              initWithTitle:@"Alert"
//                              message:[NSString stringWithFormat:@"Selected Value is %@",[self.searchHistory objectAtIndex:indexPath.row]]
//                              delegate:self
//                              cancelButtonTitle:@"Ok"
//                              otherButtonTitles:nil];
//    
//    [alertView show];
}

#pragma mark ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.map.delegate = self;
    self.map.delegate2 = self;
    self.searchBar.delegate = self;
    self.map.showsUserLocation = YES;
    self.map.mapType = MKMapTypeHybrid;
    self.counter = @0;
    
    self.searchHistoryTableView.opaque = YES;
    self.searchHistoryTableView.separatorColor = [UIColor blackColor];
    self.searchHistoryTableView.backgroundColor = [UIColor blackColor];
    
    self.historyEntityDescription = [NSEntityDescription entityForName:@"SearchHistory" inManagedObjectContext:self.managedObjectContext];
    self.searchHistory = [SearchHistory fetchAllWithContext:self.managedObjectContext];
    
//    for(SearchHistory *searchHistory in self.searchHistory){
//        [searchHistory delete];
//    }
    
    [self.pulloutMenu.layer setCornerRadius:10.0f];
    self.pulloutMenuVisibility = @"Virgin";
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    [self.map addGestureRecognizer:longPress];
    
    self.pinEntityDescription = [NSEntityDescription entityForName:@"Pin" inManagedObjectContext:self.managedObjectContext];
    
    self.localPins = [[NSMutableArray alloc] init];
    [self addObserver:self forKeyPath:@"localPins" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self placeLocallySavedPinsWithKvo];
    
    self.cloudPins = [self fetchDummyCloudPins];
    self.cloudAnnotations = [KGPinToAnnotationConverter convertToAnnotations:self.cloudPins];
    [self.map addAnnotations:self.cloudAnnotations];
    
    //NOTE: option #4
    NSArray *nibContentsForMenu = [[NSBundle mainBundle] loadNibNamed:@"KGMenuView" owner:self options:nil];
    KGMenuView *menu = [nibContentsForMenu objectAtIndex:0];
    
    menu.dataSource = @{
                        @"Clear" : @"Clear.png",
                        @"Upload" : @"Upload.png",
                        };
    
    menu.delegate = self;
    [self.menuPlaceholder addSubview:menu];
    
//    [self testPlacingImage];
//    [self testPlacingLine];
//    [self testCoreDataSave];
//    [self testCoreDataFind];
//    [self showTester];
}

-(void)viewWillAppear:(BOOL)animated{
    //NOTE: recently added this to prevent crash on viewWillDisappear
    //[self addObserver:self forKeyPath:@"localPins" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

-(void)viewDidLayoutSubviews{
    if([self.pulloutMenuVisibility isEqualToString: @"Virgin"]){
        [self hidePulloutMenu:NO];
    }
    else if([self.pulloutMenuVisibility isEqualToString: @"Visible"]){
        [self showPulloutMenu:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self removeObserver:self forKeyPath:@"localPins"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
    [self search:self.searchBar.text];
    [self hidePulloutMenu:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = YES;
}

-(void)search:(NSString*)text{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"localPins"];
    
    [self requestNewItemsWithText:text withRegion:self.map.region completion:^{
        
        for (MKMapItem *item in self.searchItems)
        {
            Pin *pin = [[Pin alloc] initWithEntity:self.pinEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            pin.title = item.name;
            pin.isSearchResult = @1;
            pin.latitude = [NSNumber numberWithDouble:item.placemark.coordinate.latitude];
            pin.longitude = [NSNumber numberWithDouble:item.placemark.coordinate.longitude];
            
            bool latitudeExists = [self latitudeExistsInLocalPins:pin.latitude];
            bool longitudeExists = [self longitudeExistsInLocalPins:pin.longitude];
            
            if(latitudeExists && longitudeExists){
            }
            else{
                [mutableArrayWithKVO addObject:pin];
            }
        }
    }];
    
    bool existsInHistory = [self searchHistoryContains:text];
    
    if(!existsInHistory){
        SearchHistory *history = [[SearchHistory alloc] initWithEntity:self.historyEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        history.text = text;
        history.timeStamp = [NSDate date];
        [history save];
        
        self.searchHistory = [SearchHistory fetchAllWithContext:self.managedObjectContext];
        [self.searchHistoryTableView reloadData];
    }
}

-(bool)searchHistoryContains:(NSString *)text{
    for(SearchHistory *history in self.searchHistory){
        if([history.text isEqualToString:text]){
            return YES;
        }
    }
    
    return NO;
}

- (void)requestNewItemsWithText:(NSString *)text withRegion:(MKCoordinateRegion)region completion:(void (^)(void))completionBlock{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = text;
    request.region = region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.searchItems = response.mapItems;
        
        if(response.mapItems != nil && response.mapItems.count > 0){
            completionBlock();
        }
    }];
}

-(bool)latitudeExistsInLocalPins:(NSNumber *)latitude{
    for(Pin *pin in self.localPins){
        if([pin.latitude isEqualToNumber:latitude]){
            return YES;
        }
    }
    
    return NO;
}

-(bool)longitudeExistsInLocalPins:(NSNumber *)longitude{
    for(Pin *pin in self.localPins){
        if([pin.longitude isEqualToNumber:longitude]){
            return YES;
        }
    }
    
    return NO;
}

#pragma mark PulloutMenu

- (IBAction)menuPulled:(id)sender {
    if([self.pulloutMenuVisibility isEqualToString:@"Virgin"]){
        self.pulloutMenuVisibility = @"Hidden";
    }
    
    if(self.isPullingOutMenu == NO){
        self.isPullingOutMenu = YES;
        self.panGestureRecognizer.enabled = NO;
        
        if([self.pulloutMenuVisibility isEqualToString: @"Hidden"]){
            [self showPulloutMenu:YES];
        }
        else{
            [self hidePulloutMenu:YES];
        }
    }
}

-(void)hidePulloutMenu:(bool)animated{
    CGFloat centerX = (self.view.frame.size.width / 2) - (self.pulloutMenu.frame.size.width / 2);
    CGFloat hiddenY = self.view.frame.size.height - (self.pulloutMenu.frame.size.height / 8);
    
    CGFloat width = self.pulloutMenu.frame.size.width;
    CGFloat height = self.pulloutMenu.frame.size.height;
    
    CGRect newFrame = CGRectMake(centerX, hiddenY, width, height);
    
    if(animated == YES){
        [UIView beginAnimations:@"hidePulloutMenu" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        [self.pulloutMenu setFrame:newFrame];
        
        [UIView setAnimationDidStopSelector:@selector(hidePulloutMenuComplete)];
        [UIView commitAnimations];
    }
    else{
        [self.pulloutMenu setFrame:newFrame];
    }
    
    if(![self.pulloutMenuVisibility isEqualToString:@"Virgin"]){
        self.pulloutMenuVisibility = @"Hidden";
    }
}

-(void)hidePulloutMenuComplete{
    self.panGestureRecognizer.enabled = YES;
    self.isPullingOutMenu = NO;
}

-(void)showPulloutMenu:(bool)animated{
    CGFloat centerX = (self.view.frame.size.width / 2) - (self.pulloutMenu.frame.size.width / 2);
    CGFloat visibleY = self.view.frame.size.height - (self.pulloutMenu.frame.size.height * .80);
    
    CGFloat width = self.pulloutMenu.frame.size.width;
    CGFloat height = self.pulloutMenu.frame.size.height;
    
    CGRect newFrame = CGRectMake(centerX, visibleY, width, height);
    
    if(animated == YES){
        [UIView beginAnimations:@"showPulloutMenu" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        [self.pulloutMenu setFrame:newFrame];
        
        [UIView setAnimationDidStopSelector:@selector(showPulloutMenuComplete)];
        [UIView commitAnimations];
    }
    else{
        [self.pulloutMenu setFrame:newFrame];
    }
    
    self.pulloutMenuVisibility = @"Visible";
}

-(void)showPulloutMenuComplete{
    self.panGestureRecognizer.enabled = YES;
    self.isPullingOutMenu = NO;
}

#pragma mark Events

- (IBAction)locationPressed:(id)sender {
    [self.map zoomToLastLocation];
}

- (IBAction)mapTypePressed:(id)sender {
    if(self.map.mapType == MKMapTypeStandard){
        self.map.mapType = MKMapTypeHybrid;
    }
    else{
        self.map.mapType = MKMapTypeStandard;
    }
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.map];
    CLLocationCoordinate2D touchMapCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    
    UIView *view = [self.map hitTest:touchPoint withEvent:nil];
    NSString *className = NSStringFromClass(view.class);
    
    if([className isEqualToString:@"MKAnnotationContainerView"] ||
       [className isEqualToString:@"MKNewAnnotationContainerView"] ){
        
        Pin *pin = [[Pin alloc] initWithEntity:self.pinEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        pin.latitude = [NSNumber numberWithDouble:touchMapCoordinate.latitude];
        pin.longitude = [NSNumber numberWithDouble:touchMapCoordinate.longitude];
        pin.isLocallySaved = @1;
        pin.isCloudSaved = @0;
        [pin setDefaultTitle];
        [pin save];
        
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"localPins"];
        [mutableArrayWithKVO addObject:pin];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        if(self.activeAnnotationView.isDeleting){
            if([self.activeAnnotationView.pin.isCloudSaved isEqual:@1]){
                [self.cloudPins removeObject:self.activeAnnotationView.pin];
            }
            else{
                [self.localPins removeObject:self.activeAnnotationView.pin];
            }
            
            NSLog(@"Deleting Pin:%@", self.activeAnnotationView.pin);
            
            [self.activeAnnotationView.pin delete];
            self.activeAnnotationView = nil;
        }
        
        NSLog(@"OK Tapped. Hello World!");
    }
}

#pragma mark DataLoading

-(void)placeLocallySavedPinsWithKvo{
    NSMutableArray *locallySavedPins = [Pin fetchAllWithContext:self.managedObjectContext];
    
    //NOTE: only this executed if this method executed once from viewDidLoad
    if(self.localPins.count == 0){
        self.localPins = locallySavedPins;
    }
    else{
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"localPins"];
        [mutableArrayWithKVO addObjectsFromArray:locallySavedPins];
    }
}

-(void)placeCloudSavedPins:(NSMutableArray *)pins{
    for(Pin *pin in self.cloudPins){
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([pin.latitude doubleValue], [pin.longitude doubleValue]);
        
        KGPointAnnotation *annotation = [[KGPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = pin.title;
        annotation.subtitle = pin.subTitle;
        annotation.pin = pin;
        
        [self.map addAnnotation:annotation];
    }
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    @try{
        if ([keyPath isEqualToString:@"localPins"]) {
            int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
            
            if (kindOfChange == NSKeyValueChangeSetting) {
                //NOTE: consider observing localAnnotations instead of localPins
                self.localAnnotations = [KGPinToAnnotationConverter convertToAnnotations:(NSMutableArray *)self.localPins];
                [self.map removeAnnotations:self.map.annotations];
                [self.map addAnnotations:self.localAnnotations];
                
                //[self.tableView reloadData];
            } else if (kindOfChange == NSKeyValueChangeInsertion ||
                       kindOfChange == NSKeyValueChangeRemoval ||
                       kindOfChange == NSKeyValueChangeReplacement) {
                
                NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
                
                // Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
                NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
                [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    [indexPathsThatChanged addObject:newIndexPath];
                }];
                
                if (kindOfChange == NSKeyValueChangeInsertion) {
                    NSIndexPath *indexPath = [indexPathsThatChanged objectAtIndex:0];
                    
                    Pin *pin = [self.localPins objectAtIndex:indexPath.row];
                    KGPointAnnotation *annotation = [KGPinToAnnotationConverter convertToAnnotation:pin];
                    
                    if([pin.isSearchResult isEqualToNumber:@1]){
                        annotation.isDropping = NO;
                    }
                    else{
                        annotation.isDropping = YES;
                    }
                    
                    [self.localAnnotations addObject:annotation];
                    [self.map addAnnotation:annotation];
                    
                } else if (kindOfChange == NSKeyValueChangeRemoval) {
                    NSIndexPath *indexPath = [indexPathsThatChanged objectAtIndex:0];
                    NSLog(@"IndexPath: %ld", (long)indexPath.row);
                    
                    KGPointAnnotation *annotation = [self.localAnnotations objectAtIndex:indexPath.row];
                    
                    [self.map removeAnnotation:annotation];
                    [self.localAnnotations removeObject:annotation];
                    
                } else if (kindOfChange == NSKeyValueChangeReplacement) {
                }
            }
        }
    }
    @catch(NSException *theException){
    }
    @finally{
    }
}

#pragma mark MapKit

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if (annotation == self.map.userLocation){
        return nil;
    }
    
    KGAnnotationView *kgAnnotationView = (KGAnnotationView *)[self.map dequeueReusableAnnotationViewWithIdentifier: @"AnnotationView"];
    
    if (kgAnnotationView == nil) {
        kgAnnotationView = [[KGAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: @"AnnotationView"]; // If you use ARC, take out 'autorelease'
    } else {
        kgAnnotationView.annotation = annotation;
    }
    
    KGPointAnnotation *kgPointAnnotation = (KGPointAnnotation *)annotation;
    kgAnnotationView.pin = kgPointAnnotation.pin;
    
    if([kgAnnotationView.pin.title isEqualToString:@"New"]){
        
    }
    
    kgAnnotationView.pinColor = [self.map calculatePinColor:kgAnnotationView.pin];
    
    kgAnnotationView.animatesDrop = YES;
    kgAnnotationView.draggable = YES;
    kgAnnotationView.userInteractionEnabled = YES;
    kgAnnotationView.enabled = YES;
    kgAnnotationView.delegate = self.map;
    
    if(kgPointAnnotation.isDropping){
        [kgAnnotationView openCallout];
        kgPointAnnotation.isDropping = NO;
        
        if(self.activeAnnotationView){
            [self.activeAnnotationView.calloutView removeFromSuperview2];
        }
        
        self.activeAnnotationView = kgAnnotationView;
        [self.map centerOnAnnotationView:kgAnnotationView];
    }
    
    NSLog(@"Annotation:%@", kgAnnotationView.annotation);
    
    return kgAnnotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(KGAnnotationView *)view{
    if (view.annotation != self.map.userLocation){
        if(self.activeAnnotationView){
            [self.activeAnnotationView.calloutView removeFromSuperview2];
        }
        
        [view openCallout];
        self.activeAnnotationView = view;
        [self.map centerOnAnnotationView:view];
        
        NSLog(@"Annotation Selected:%@", view.annotation);
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    if(view.annotation != self.map.userLocation){
        KGAnnotationView *annotationView = (KGAnnotationView *)view;
        
        if(annotationView.isDeleting){
            [self.map deselectAnnotation:[view annotation] animated:NO];
            
            if([annotationView.pin.isCloudSaved isEqual:@1]){
                [self.cloudPins removeObject:annotationView.pin];
            }
            else{
                [self.localPins removeObject:annotationView.pin];
            }
            
            [annotationView.pin delete];
            
            NSLog(@"Deleting Pin:%@", annotationView.pin);
        }
    }
}

#pragma mark KGMyMapView

-(void)kgMyMapView:(KGMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateType:(NSNumber *)newTypeId{
    Pin *pin = annotationView.pin;
    pin.typeId = newTypeId;
    [pin save];
    
    annotationView.pinColor = [self.map calculatePinColor:pin];
}

-(void)kgMyMapView:(KGMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateTitle:(NSString *)newTitle{
    Pin *pin = annotationView.pin;
    pin.title = newTitle;
    [pin save];
    
    annotationView.pinColor = [self.map calculatePinColor:pin];
}

-(void)kgMyMapView:(KGMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateSubtype:(NSNumber *)newSubtypeId{
    Pin *pin = annotationView.pin;
    pin.subtypeId = newSubtypeId;
    [pin save];
    
    annotationView.pinColor = [self.map calculatePinColor:pin];
}

#pragma mark MenuView

-(BOOL)menuView:(KGMenuView *)menuView buttonPressed:(KGMenuButton *)button{
    NSString *buttonTitle = button.title;
    if([buttonTitle isEqualToString:@"Clear"]){
        NSLog(@"%@ Pressed", buttonTitle);
        
        [Pin delete:(NSArray*)self.localPins];
        
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"localPins"];
        [mutableArrayWithKVO removeObjectsInArray:(NSMutableArray *)self.localPins];
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

#pragma mark NotImplemented

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

-(void)showLogViewController{
}

-(void)toggledDeleteWarnings{
}

#pragma mark Tests

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

-(void)doKvoTest{
    self.testPin = [[SBPin alloc] init];
    
    self.testPin.title = @"Test";
    self.testPin.latitude = @15;
    
    NSLog(@"%@, %d", self.testPin.title, [self.testPin.latitude intValue]);
    
    [self.testPin addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.testPin addObserver:self forKeyPath:@"latitude" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self.testPin setValue:@"Successful" forKey:@"title"];
    [self.testPin setValue:[NSNumber numberWithInteger:16] forKey:@"latitude"];
    
    [self.testPin willChangeValueForKey:@"title"];
    self.testPin.title = @"Successful2";
    [self.testPin didChangeValueForKey:@"title"];
}

-(void)testPlacingImage{
    SBPark *park = [[SBPark alloc] initWithFilename:@"BoldBean"];
    
    CLLocationDegrees latDelta = park.overlayTopLeftCoordinate.latitude - park.overlayBottomRightCoordinate.latitude;
    // think of a span as a tv size, measure from one corner to another
    MKCoordinateSpan span = MKCoordinateSpanMake(fabs(latDelta), 4.0);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(park.midCoordinate, span);
    self.map.region = region;
    
    SBOverlay *overlay = [[SBOverlay alloc] initWithPark:park];
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

-(void)showTester{
        NSArray *nibContentsForTester = [[NSBundle mainBundle] loadNibNamed:@"KGCalloutTesterView" owner:self options:nil];
        SBCalloutTesterView *tester = [nibContentsForTester objectAtIndex:0];
        self.tester = tester;
        self.tester.frame = CGRectMake(400, 300, 350, 350);
        [self.view addSubview:tester];
        self.tester.delegate = self;
}

#pragma mark CalloutTesterView

-(BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView clearStatePressed:(BOOL)variable{
    [self.callout moveToState:@"Empty"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testRegularLocationAnyPressed:(BOOL)variable{
    [self.callout moveToState:@"Regular-Location-Dropped"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testRegularLineDroppedPressed:(BOOL)variable{
    [self.callout moveToState:@"Regular-Line-Dropped"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testDrawingLineDroppedPressed:(BOOL)variable{
    [self.callout moveToState:@"Drawing-Line-Dropped"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testColoringLineSelectedPressed:(BOOL)variable{
    [self.callout moveToState:@"Coloring-Line-Selected"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testRegularLineSelected_WithParentPressed:(BOOL)variable{
    [self.callout moveToState:@"Regular-Line-Selected_WithParent"];
    return YES;
}

-(BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testRegularLineSelected_NoParentPressed:(BOOL)variable{
    [self.callout moveToState:@"Regular-Line-Selected_NoParent"];
    return YES;
}

@end
