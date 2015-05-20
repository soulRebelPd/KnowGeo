//
//  ViewController.h
//  KnowGeo
//
//  Created by Corey Norford on 4/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

#import "AppDelegate.h"

#import "KGCalloutView.h"
#import "KGMenuView.h"
#import "KGCalloutTesterView.h"
#import "KGMenuButton.h"
#import "KGOverlay.h"
#import "KGMapOverlayView.h"
#import "KGAnnotationView.h"
#import "KGPointAnnotation.h"
#import "KGMyMapView.h"

#import "SBPark.h"
#import "SBPin.h"

#import "TestObject.h"
#import "Pin.h"
#import "KGPintoAnnotationConverter.h"

#import "UIColor+KGColors.h"

@interface MyViewController : UIViewController <KGCalloutTesterDelegate, MenuViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet KGCalloutView *callout;
@property (weak, nonatomic) IBOutlet KGMenuView *menu;
@property (strong, nonatomic) IBOutlet KGCalloutTesterView *tester;
@property (strong, nonatomic) IBOutlet KGMenuButton *button;
@property (weak, nonatomic) IBOutlet KGMyMapView *map;
@property (strong, nonatomic) NSArray *mapItems;
@property (strong, nonatomic) NSMutableArray *localPins;
@property (strong, nonatomic) NSMutableArray *localAnnotations;
@property (strong, nonatomic) NSArray *cloudAnnotations;
@property (strong, nonatomic) NSMutableArray *cloudPins;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property NSEntityDescription *pinEntityDescription;
@property NSNumber *counter;
@property (strong, nonatomic) SBPin *testPin;
@property (strong, nonatomic) NSMutableArray *testPins;

-(void)didLongTouch;
-(void)didTouch;
-(void)uploadToCloud;
-(void)reloadData;
-(bool)reloadCloudData;
-(void)addedAnnotationView;
-(void)movePin;
-(void)clear;
-(void)showLogViewController;
-(void)toggledDeleteWarnings;

@end
