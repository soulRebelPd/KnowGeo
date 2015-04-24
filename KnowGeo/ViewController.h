//
//  ViewController.h
//  KnowGeo
//
//  Created by Corey Norford on 4/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGCalloutView.h"
#import "KGMenuView.h"
#import "KGCalloutTesterView.h"
#import "KGMenuButton.h"
#import <MapKit/MapKit.h>
#import "KGOverlay.h"

@interface ViewController : UIViewController <KGCalloutTesterDelegate, MenuViewDelegate, MKMapViewDelegate, MKOverlay>

@property (weak, nonatomic) IBOutlet KGCalloutView *callout;
@property (weak, nonatomic) IBOutlet KGMenuView *menu;
@property (strong, nonatomic) IBOutlet KGCalloutTesterView *tester;
@property (strong, nonatomic) IBOutlet KGMenuButton *button;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@property (strong, nonatomic) NSArray *mapItems;

@end
