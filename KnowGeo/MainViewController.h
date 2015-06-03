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
#import "SBCalloutTesterView.h"
#import "KGMenuButton.h"
#import "SBOverlay.h"
#import "SBOverlayRenderer.h"
#import "KGAnnotationView.h"
#import "KGPointAnnotation.h"
#import "KGMapView.h"

#import "SBPark.h"
#import "SBPin.h"
#import "KGCalloutTail.h"
#import "CallViewController.h"

#import "SBObject.h"
#import "Pin.h"
#import "KGPintoAnnotationConverter.h"

#import "UIColor+KGColors.h"

@interface MainViewController : UIViewController <KGCalloutTesterDelegate, MenuViewDelegate, MKMapViewDelegate, KGMapViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet KGMapView *map;
@property (weak, nonatomic) IBOutlet KGMenuView *menu;
@property (strong, nonatomic) IBOutlet KGMenuButton *button;
@property (weak, nonatomic) IBOutlet KGCalloutView *callout;
@property (strong, nonatomic) IBOutlet SBCalloutTesterView *tester;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIView *pulloutMenu;
@property (weak, nonatomic) IBOutlet UIView *menuPlaceholder;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;

@property (strong, nonatomic) NSArray *mapItems;
@property (strong, nonatomic) NSArray *searchItems;
@property (strong, nonatomic) NSMutableArray *localPins;
@property (strong, nonatomic) NSMutableArray *localAnnotations;
@property (strong, nonatomic) NSArray *cloudAnnotations;
@property (strong, nonatomic) NSMutableArray *cloudPins;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *testPins;
@property (strong, nonatomic) SBPin *testPin;
@property (strong, nonatomic) KGAnnotationView *activeAnnotationView;
@property NSEntityDescription *pinEntityDescription;
@property NSNumber *counter;
@property bool isPullingOutMenu;
@property NSString *pulloutMenuVisibility;

-(void)uploadToCloud;
-(void)reloadData;
-(bool)reloadCloudData;
-(void)addedAnnotationView;
-(void)showLogViewController;
-(void)toggledDeleteWarnings;

- (IBAction)locationPressed:(id)sender;
- (IBAction)mapTypePressed:(id)sender;
- (IBAction)menuPulled:(id)sender;

@end
