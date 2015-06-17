//
//  ViewController.m
//  KnowGeo
//
//  Created by Corey Norford on 4/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "MainViewController.h"

@interface  MainViewController ()
#define exportEmail @"info@knowwake.com"
#define exportFileName @"Export"
#define pulloutMenuWidth 300
#define pulloutMenuHeight 300
#define menuPlaceholderHeight 111
@end

@implementation MainViewController

@synthesize managedObjectContext;
@synthesize pinEntityDescription;
@synthesize pulloutMenuVisibility;
@synthesize dataFilePath;
@synthesize annotationViewDeleting;

-(void)handleClearEligibility{
    bool clearablePinsExist = [self checkClearablePinsExist];
    if(clearablePinsExist){
        [self.menu enableClearButton];
    }
    else{
        [self.menu disableClearButton];
    }
}

-(bool)checkClearablePinsExist{
    bool clearablePinsExist = NO;
    for(KGPointAnnotation *annotation in self.map.annotations){
        
        id<MKAnnotation> mkAnnotation = (id<MKAnnotation>)annotation;
        if (mkAnnotation != self.map.userLocation){
            
            MKPinAnnotationColor pinColor = [self.map calculatePinColor:annotation.pin];
            
            if(pinColor == MKPinAnnotationColorPurple || pinColor == MKPinAnnotationColorRed){
                clearablePinsExist = YES;
                break;
            }
        }
    }
    
    return clearablePinsExist;
}

-(void)handleExportEligibilityWithColor:(MKPinAnnotationColor)newColor withAnnotationView:(KGAnnotationView *)annotationView{
    if(newColor == MKPinAnnotationColorRed && annotationView.pinColor != MKPinAnnotationColorRed){
        [self handleExportEligibility];
    }
    else if(newColor == MKPinAnnotationColorPurple){
        [self.menu enableExportButton];
    }
}

-(void)handleExportEligibility{
    bool exportablePinsExist = [self checkExportablePinsExist];
    
    if(exportablePinsExist){
        [self.menu enableExportButton];
    }
    else{
        [self.menu disableExportButton];
    }
}

-(bool)checkExportablePinsExist{
    bool exportablePinsExist = NO;
    for(KGPointAnnotation *annotation in self.map.annotations){
        
        id<MKAnnotation> mkAnnotation = (id<MKAnnotation>)annotation;
        if (mkAnnotation != self.map.userLocation){
            
            MKPinAnnotationColor pinColor = [self.map calculatePinColor:annotation.pin];
            
            if(pinColor == MKPinAnnotationColorPurple){
                exportablePinsExist = YES;
                break;
            }
        }
    }
    
    return exportablePinsExist;
}


#pragma mark ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set properties
    self.map.delegate = self;
    self.map.delegate2 = self;
    self.map.showsUserLocation = YES;
    self.map.mapType = MKMapTypeHybrid;
    self.counter = @0;
    self.pulloutMenuVisibility = @"Virgin";
    
    //instantiate objects
    self.lastExport = [[NSMutableArray alloc] init];
    self.localPins = [[NSMutableArray alloc] init];
    self.historyEntityDescription = [NSEntityDescription entityForName:@"SearchHistory" inManagedObjectContext:self.managedObjectContext];
    self.pinEntityDescription = [NSEntityDescription entityForName:@"Pin" inManagedObjectContext:self.managedObjectContext];
    
    //add gesture recognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    [self.map addGestureRecognizer:longPress];

    //load some nibs
    NSArray *nibContentsForPulloutMenu = [[NSBundle mainBundle] loadNibNamed:@"KGPulloutMenu" owner:self options:nil];
    self.pulloutMenu = [nibContentsForPulloutMenu objectAtIndex:0];
    self.pulloutMenu.delegate = self;
    self.pulloutMenu.managedObjectContext = self.managedObjectContext;
    [self.view addSubview:self.pulloutMenu];
    
    NSArray *nibContentsForMenu = [[NSBundle mainBundle] loadNibNamed:@"KGMenuView" owner:self options:nil];
    self.menu = [nibContentsForMenu objectAtIndex:0];
    self.menu.delegate = self;
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, menuPlaceholderHeight);
    self.menu.frame = frame;
    [self.view addSubview:self.menu];

    // setup observation
    [self addObserver:self forKeyPath:@"localPins" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    //load data
    [self placeLocallySavedPinsWithKvo];
    
    //self.cloudPins = [self fetchDummyCloudPins];
    //self.cloudAnnotations = [KGPinToAnnotationConverter convertToAnnotations:self.cloudPins];
    //[self.map addAnnotations:self.cloudAnnotations];
    
//    [self testPlacingImage];
//    [self testPlacingLine];
//    [self testCoreDataSave];
//    [self testCoreDataFind];
//    [self showTester];
}

-(void)viewWillAppear:(BOOL)animated{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    }
    else{
        [self.menu hideLogo];
    }
}

-(void)viewDidLayoutSubviews{
    if([self.pulloutMenuVisibility isEqualToString: @"Virgin"]){
        [self hidePulloutMenu:NO];
    }
    else if([self.pulloutMenuVisibility isEqualToString: @"Visible"]){
        [self showPulloutMenu:NO];
    }
    
    [self handleClearEligibility];
    [self handleExportEligibility];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self removeObserver:self forKeyPath:@"localPins"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardDidHide:(NSNotification *)notification{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    }
}

-(void)keyboardDidShow:(NSNotification *)notification{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        // The device is an iPad running iOS 3.2 or later.
    }
}

-(void)orientationChanged{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = 111;
    
    CGRect frame = CGRectMake(0, 0, width, height);
    self.menu.frame = frame;
    
    [self hidePulloutMenu:YES];
}

#pragma mark Export

-(void)sendExport{
    if(self.dataFilePath == nil){
        [self setDataFilePath];
    }
    
    [DiskOperations createFileWithFullPath:self.dataFilePath];
    NSString *dataString = [self convertElgibleAnnotationsToExportString];
    [DiskOperations saveToDiskWithFullPath:self.dataFilePath andDataString:dataString];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:self.dataFilePath];
    [self emailExportWithData:data];
}

-(void)setDataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:exportFileName];
    self.dataFilePath = filePath;
}

-(NSString *)convertElgibleAnnotationsToExportString{
    self.lastExport = [[NSMutableArray alloc] init];
    NSNumber *zero = @0;
    NSMutableString *dataString = [NSMutableString stringWithCapacity:0];
    
    for(KGPointAnnotation *annotation in self.map.annotations){
        id<MKAnnotation> mkAnnotation = (id<MKAnnotation>)annotation;
        if (mkAnnotation != self.map.userLocation){

            Pin *pin = annotation.pin;

            if(pin.typeId != zero &&
               pin.subtypeId != zero &&
               [pin.isExported isEqualToNumber:zero] &&
               ![pin.title isEqualToString:@""]){

                [self.lastExport addObject:pin];

                [dataString appendString:[NSString stringWithFormat:@"%@, %@, %@, %@, %@ \n", pin.title, pin.latitude, pin.longitude, pin.typeName, pin.subTypeName]];
            }
        }
    }
    
    return dataString;
}

-(void)emailExportWithData:(NSData *)data{
    if([MFMailComposeViewController canSendMail]) {
        self.mailController = [[MFMailComposeViewController alloc] init];
        self.mailController.mailComposeDelegate = self;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH_mm_ss"];
        NSString *nowFull = [formatter stringFromDate:[NSDate date]];
        
        NSString *subject = [NSString stringWithFormat: @"Interest Point Export"];
        [self.mailController setToRecipients:[NSArray arrayWithObject:exportEmail]];
        [self.mailController setSubject:subject];
        [self.mailController setMessageBody:@"Attached KnowWake Utility Interest Point Export" isHTML:NO];
        
        NSString *fileName = [NSString stringWithFormat:@"%@ %@", exportFileName, nowFull];
        [self.mailController addAttachmentData:data mimeType:@"text/csv" fileName:fileName];
        
        [self presentViewController:self.mailController animated:YES completion:^{
        }];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if(result == MFMailComposeResultSent){
        [self updateExportedPins];
        [self handleClearEligibility];
        
        bool exportablePinsExist = [self checkExportablePinsExist];
        if(exportablePinsExist){
            [self.menu enableExportButton];
        }
        else{
            [self.menu disableExportButton];
        }
    }
    else if(result == MFMailComposeResultCancelled){
        self.lastExport = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)updateExportedPins{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"localPins"];
    
    for(Pin *pin in self.lastExport){
        pin.isExported = @1;
        [pin save];
        
        NSUInteger index = [mutableArrayWithKVO indexOfObject:pin];
        NSNumber *indexNumber = [NSNumber numberWithUnsignedInt:index];
        NSLog(@"Replacing local pin at index: %@", indexNumber);
        [mutableArrayWithKVO removeObjectAtIndex:index];
        [mutableArrayWithKVO addObject:pin];
    }
}

#pragma mark - Search

-(void)search:(NSString*)text{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"localPins"];
    
    [self requestNewItemsWithText:text withRegion:self.map.region completion:^{
        
        for (MKMapItem *item in self.searchItems){
            Pin *pin = [[Pin alloc] initWithEntity:self.pinEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            pin.title = item.name;
            pin.isSearchResult = @1;
            pin.isExported = @0;
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
    if(self.activeAnnotationView){
        [self.activeAnnotationView.calloutView removeFromSuperview2];
        //TODO: add self.activeAnnotationView = nil
    }
    
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
    CGFloat centerX = (self.view.frame.size.width / 2) - (pulloutMenuHeight / 2);
    CGFloat hiddenY = menuPlaceholderHeight - (pulloutMenuHeight * 0.95);
    CGFloat width = pulloutMenuWidth;
    CGFloat height = pulloutMenuHeight;
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
    CGFloat centerX = (self.view.frame.size.width / 2) - (pulloutMenuWidth / 2);
    CGFloat visibleY = menuPlaceholderHeight - (pulloutMenuHeight * 0.05);
    
    CGFloat width = pulloutMenuWidth;
    CGFloat height = pulloutMenuHeight;
    
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

-(void)kgPulloutMenu:(KGPulloutMenu *)kgPulloutMenu pulled:(bool)wasPulled{
    [self menuPulled:kgPulloutMenu];
}

-(void)kgPulloutMenu:(KGPulloutMenu *)kgPulloutMenu searched:(NSString *)searchText{
    [self search:searchText];
    [self hidePulloutMenu:YES];
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
        pin.isExported = @0;
        [pin setDefaultTitle];
        [pin save];
        
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"localPins"];
        [mutableArrayWithKVO addObject:pin];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if([alertView.title isEqualToString:@"Clear pins?"]){
        if (buttonIndex == 0) {
            NSLog(@"No Tapped.");
        }
        else if (buttonIndex == 1) {
            NSLog(@"Yes Tapped.");
            
            NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"localPins"];
            
            for(Pin *pin in self.localPins){
                if([pin.isExported isEqualToNumber:@0]){
                    [pin delete];
                    [mutableArrayWithKVO removeObject:pin];
                }
            }
            
            if(self.activeAnnotationView){
                [self.activeAnnotationView.calloutView removeFromSuperview2];
                self.activeAnnotationView = nil;
            }
            
            bool exportablePinsExist = [self checkExportablePinsExist];
            if(exportablePinsExist){
                [self.menu enableExportButton];
            }
            else{
                [self.menu disableExportButton];
            }
        }
    }
    
    if([alertView.title isEqualToString:@"Delete pin?"]){
        if (buttonIndex == 0) {
            NSLog(@"No Tapped.");
        }
        else if (buttonIndex == 1) {
            NSLog(@"Yes Tapped.");
            
            if(self.activeAnnotationView.isDeleting){
                if([self.activeAnnotationView.pin.isCloudSaved isEqual:@1]){
                }
                else{
                    NSLog(@"Deleting Pin:%@", self.activeAnnotationView.pin);
                    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"localPins"];
                    [mutableArrayWithKVO removeObject:self.activeAnnotationView.pin];
                    
                    [self handleClearEligibility];
                }
            
                [self.activeAnnotationView.calloutView removeFromSuperview2];
                self.activeAnnotationView = nil;
            }
        }
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
                
                NSIndexPath *indexPath = [indexPathsThatChanged objectAtIndex:0];
                
                if (kindOfChange == NSKeyValueChangeInsertion) {
                    Pin *pin = [self.localPins objectAtIndex:indexPath.row];
                    KGPointAnnotation *annotation = [KGPinToAnnotationConverter convertToAnnotation:pin];
                    
                    if([pin.isSearchResult isEqualToNumber:@1]){
                        annotation.isDropping = NO;
                    }
                    else{
                        annotation.isDropping = YES;
                    }
                    
                    if([self.lastExport containsObject:pin]){
                        annotation.isUpdatingColor = YES;
                        annotation.isDropping = NO;
                    }
                    else{
                        annotation.isUpdatingColor = NO;
                    }
                    
                    [self.localAnnotations addObject:annotation];
                    [self.map addAnnotation:annotation];
                    
                    [self.menu enableClearButton];
                }
                else if (kindOfChange == NSKeyValueChangeRemoval) {
                    KGPointAnnotation *annotation = [self.localAnnotations objectAtIndex:indexPath.row];
                    
                    [self.localAnnotations removeObject:annotation];
                    [self.map removeAnnotation:annotation];
                }
                else if (kindOfChange == NSKeyValueChangeReplacement) {
                    //right now NSKeyValueChangeReplacement could only be export process
                    KGPointAnnotation *existingAnnotation = [self.localAnnotations objectAtIndex:indexPath.row];
                    NSLog(@"Replaced Index: %d", indexPath.row);

                    KGPointAnnotation *newAnnotation = [KGPinToAnnotationConverter convertToAnnotation:existingAnnotation.pin];
                    newAnnotation.isDropping = NO;
                    newAnnotation.isUpdatingColor = YES;
                    
                    [self.localAnnotations addObject:newAnnotation];
                    [self.localAnnotations removeObject:existingAnnotation];
                    
                    [self.map addAnnotation:newAnnotation];
                    [self.map removeAnnotation:existingAnnotation];
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
    
    KGAnnotationView *kgAnnotationView = (KGAnnotationView *)[self.map dequeueReusableAnnotationViewWithIdentifier: @"AnnotationV¥iew"];
    
    if (kgAnnotationView == nil) {
        kgAnnotationView = [[KGAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: @"AnnotationView"]; // If you use ARC, take out 'autorelease'
    } else {
        kgAnnotationView.annotation = annotation;
    }
    
    KGPointAnnotation *kgPointAnnotation = (KGPointAnnotation *)annotation;
    kgAnnotationView.pin = kgPointAnnotation.pin;
    kgAnnotationView.pinColor = [self.map calculatePinColor:kgAnnotationView.pin];
    
    if(kgPointAnnotation.isUpdatingColor){
        kgAnnotationView.animatesDrop = NO;
        kgPointAnnotation.isUpdatingColor = NO;
    }
    else{
        kgAnnotationView.animatesDrop = YES;
    }
    
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
        if(self.activeAnnotationView && self.activeAnnotationView != view){
            [self.activeAnnotationView.calloutView removeFromSuperview2];
            self.activeAnnotationView = nil;
        }
        
        if(view.isMoving){
            view.isMoving = NO;
        }
        else{
            [view openCallout];
        }
        
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
    
            [annotationView.pin delete];
        }
    }
}

- (void)mapView:(MKMapView *)mapView
    annotationView:(MKAnnotationView *)annotationView
    didChangeDragState:(MKAnnotationViewDragState)newState
    fromOldState:(MKAnnotationViewDragState)oldState{
    
    KGAnnotationView *kgAnnotationView = (KGAnnotationView *)annotationView;
    kgAnnotationView.isMoving = YES;
    
    if (newState == MKAnnotationViewDragStateEnding){
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
    }
}

#pragma mark KGMyMapView

-(void)kgMyMapView:(KGMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateType:(NSNumber *)newTypeId{
    Pin *pin = annotationView.pin;
    pin.typeId = newTypeId;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Type *type = [appDelegate.types objectAtIndex:[newTypeId integerValue]];
    pin.typeName = type.name;
    
    [pin save];
    
    MKPinAnnotationColor newColor = [self.map calculatePinColor:pin];
    
    if(newColor == MKPinAnnotationColorPurple || newColor == MKPinAnnotationColorRed){
        [self.menu enableClearButton];
    }
    
    [self handleExportEligibilityWithColor:newColor withAnnotationView:annotationView];
    annotationView.pinColor = newColor;
}

-(void)kgMyMapView:(KGMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateTitle:(NSString *)newTitle{
    Pin *pin = annotationView.pin;
    
    if([newTitle isEqualToString:@""]){
        [pin setDefaultTitle];
    }
    else{
        pin.title = newTitle;
    }
    
    pin.title = newTitle;
    [pin save];
    
    MKPinAnnotationColor newColor = [self.map calculatePinColor:pin];
    
    if(newColor == MKPinAnnotationColorPurple || newColor == MKPinAnnotationColorRed){
        [self.menu enableClearButton];
    }
    
    [self handleExportEligibilityWithColor:newColor withAnnotationView:annotationView];
    
    if(annotationView.pinColor != newColor){
        annotationView.pinColor = newColor;
    }
}

-(void)kgMyMapView:(KGMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView updateSubtype:(NSNumber *)newSubtypeId{
    Pin *pin = annotationView.pin;
    pin.subtypeId = newSubtypeId;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Type *type = [appDelegate.subTypes objectAtIndex:[newSubtypeId integerValue]];
    pin.subTypeName = type.name;
    
    [pin save];
    
    MKPinAnnotationColor newColor = [self.map calculatePinColor:pin];
    
    if(newColor == MKPinAnnotationColorPurple || newColor == MKPinAnnotationColorRed){
        [self.menu enableClearButton];
    }
    
    [self handleExportEligibilityWithColor:newColor withAnnotationView:annotationView];
    annotationView.pinColor = newColor;
}

-(void)kgMyMapView:(KGMapView *)mapView kgAnnotationView:(KGAnnotationView *)annotationView deletePin:(bool)pin{
        self.annotationViewDeleting = annotationView;
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete pin?"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes",nil];
    
        [alert show];
}

#pragma mark MenuView

-(BOOL)menuView:(KGMenuView *)menuView buttonPressed:(UIButton *)button{
    NSNumber *tag = [NSNumber numberWithInteger:button.tag];
    NSNumber *clearTag = [NSNumber numberWithInt:1];
    NSNumber *exportTag = [NSNumber numberWithInt:2];

    if([tag isEqualToNumber:clearTag]){
        NSLog(@"Clear Pressed.");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear pins?"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes",nil];
        
        [alert show];
    }
    else if([tag isEqualToNumber:exportTag]){
        NSLog(@"Export Pressed.");
        [self sendExport];
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

@end

//-(NSMutableArray *)fetchDummyCloudPins{
//    SBPin *pin = [[SBPin alloc] init];
//    pin.title = @"Test1";
//    pin.subTitle = @"TestSubtitle1";
//    pin.latitude = @37;
//    pin.longitude = @37;
//    pin.isLocallySaved = @0;
//    pin.isCloudSaved = @1;
//
//    SBPin *pin2 = [[SBPin alloc] init];
//    pin2.title = @"Test2";
//    pin2.subTitle = @"TestSubtitle2";
//    pin2.latitude = @38;
//    pin2.longitude = @38;
//    pin2.isLocallySaved = @0;
//    pin2.isCloudSaved = @1;
//
//    NSMutableArray *pins = [[NSMutableArray alloc] init];
//    [pins addObject:pin];
//    [pins addObject:pin2];
//
//    return pins;
//}

//-(void)testPlacingImage{
//    SBPark *park = [[SBPark alloc] initWithFilename:@"BoldBean"];
//
//    CLLocationDegrees latDelta = park.overlayTopLeftCoordinate.latitude - park.overlayBottomRightCoordinate.latitude;
//    // think of a span as a tv size, measure from one corner to another
//    MKCoordinateSpan span = MKCoordinateSpanMake(fabs(latDelta), 4.0);
//
//    MKCoordinateRegion region = MKCoordinateRegionMake(park.midCoordinate, span);
//    self.map.region = region;
//
////    SBOverlay *overlay = [[SBOverlay alloc] initWithPark:park];
////    [self.map addOverlay:overlay];
//
//    //NOTE: bold bean location +30.31556400,-81.68919900
//}