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

#import "SBPark.h"
#import "SBCalloutView.h"
#import "TestObject.h"
#import "Pin.h"

#import "UIColor+KGColors.h"

@interface ViewController : UIViewController <KGCalloutTesterDelegate, MenuViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet KGCalloutView *callout;
@property (weak, nonatomic) IBOutlet KGMenuView *menu;
@property (strong, nonatomic) IBOutlet KGCalloutTesterView *tester;
@property (strong, nonatomic) IBOutlet KGMenuButton *button;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) NSArray *mapItems;
@property (strong, nonatomic) NSManagedObjectContext *context;

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
