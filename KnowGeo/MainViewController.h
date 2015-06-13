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
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "AppDelegate.h"
#import "Pin.h"
#import "SearchHistory.h"
#import "UIColor+KGColors.h"
#import "DiskOperations.h"
#import "SBCalloutTesterView.h"

#import "KGMenuView.h"
#import "KGMenuButton.h"
#import "KGPointAnnotation.h"
#import "KGMapView.h"
#import "KGCalloutTail.h"
#import "KGPintoAnnotationConverter.h"
#import "KGPulloutMenu.h"

@interface MainViewController : UIViewController <MenuViewDelegate, MKMapViewDelegate, KGMapViewDelegate, MFMailComposeViewControllerDelegate, KGPulloutMenuDelegate>

@property (weak, nonatomic) IBOutlet KGMapView *map;
@property (weak, nonatomic) IBOutlet KGMenuView *menu;
@property (strong, nonatomic) IBOutlet KGMenuButton *button;
@property (weak, nonatomic) IBOutlet KGCalloutView *callout;
@property (strong, nonatomic) IBOutlet SBCalloutTesterView *tester;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIView *menuPlaceholder;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (weak, nonatomic) IBOutlet KGPulloutMenu *pulloutMenu;

@property (strong, nonatomic) NSArray *mapItems;
@property (strong, nonatomic) NSMutableArray *localPins;
@property (strong, nonatomic) NSMutableArray *localAnnotations;
@property (strong, nonatomic) NSArray *cloudAnnotations;
@property (strong, nonatomic) NSMutableArray *cloudPins;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *testPins;
@property (strong, nonatomic) KGAnnotationView *activeAnnotationView;
@property (strong, nonatomic) NSArray *searchItems;
@property NSEntityDescription *pinEntityDescription;
@property NSEntityDescription *historyEntityDescription;
@property NSNumber *counter;
@property NSString *pulloutMenuVisibility;
@property NSString *dataFilePath;
@property NSData *exportData;
@property NSMutableArray *lastExport;
@property MFMailComposeViewController *mailController;
@property bool isPullingOutMenu;

-(void)uploadToCloud;
-(void)reloadData;
-(bool)reloadCloudData;
-(void)showLogViewController;
-(void)toggledDeleteWarnings;

- (IBAction)locationPressed:(id)sender;
- (IBAction)mapTypePressed:(id)sender;

@end

//#import "SBPark.h"
//#import "SBPin.h"
//#import "SBOverlay.h"
//#import "SBOverlayRenderer.h"
//#import "SBObject.h"
//UITableViewDataSource is an option too
//UISearchBarDelegate
//UITableViewDataSource, UITableViewDelegate
//- (IBAction)menuPulled:(id)sender;
//@property (strong, nonatomic) SBPin *testPin;
//@property (weak, nonatomic) IBOutlet UIView *pulloutMenu;
//@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTableView;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (strong, nonatomic) NSMutableArray *searchHistory;
//-(void)addedAnnotationView;