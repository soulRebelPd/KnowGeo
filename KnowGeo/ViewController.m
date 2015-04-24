//
//  ViewController.m
//  KnowGeo
//
//  Created by Corey Norford on 4/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "ViewController.h"
#import "KGMapOverlayView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSArray *nibCallout = [[NSBundle mainBundle] loadNibNamed:@"KGCalloutView" owner:self options:nil];
//    KGCalloutView *callout = [nibCallout objectAtIndex:0];
//    self.callout = callout;
//    self.callout.frame = CGRectMake(35, 300, 300, 275);
//    [self.view addSubview:callout];
    
//    NSArray *nibContentsForMenu = [[NSBundle mainBundle] loadNibNamed:@"KGMenuView" owner:self options:nil];
//    KGMenuView *menu = [nibContentsForMenu objectAtIndex:0];
//    
//    menu.dataSource = @{
//                        @"Clear" : @"Clear.png",
//                        @"Refresh" : @"Refresh.png",
//                        @"Upload" : @"Upload.png",
//                        @"Logs" : @"Logs.png"
//                        };
//    
//    self.menu = menu;
//    self.menu.delegate = self;
//    [self.view addSubview:menu];
    
//    NSArray *nibContentsForTester = [[NSBundle mainBundle] loadNibNamed:@"KGCalloutTesterView" owner:self options:nil];
//    KGCalloutTesterView *tester = [nibContentsForTester objectAtIndex:0];
//    self.tester = tester;
//    self.tester.frame = CGRectMake(400, 300, 350, 350);
//    [self.view addSubview:tester];
//    self.tester.delegate = self;
    
    KGOverlay *overlay = [[KGOverlay alloc] init];
    
    [self requestNewItemsWithText:@"Restaurant" withRegion:self.map.region completion:^{
        for (MKMapItem *item in self.mapItems)
        {
            //overlay.boundingMapRect = park.overlayBoundingMapRect;
            //overlay.coordinate = item.placemark.coordinate;
            overlay.coordinate = item.placemark.coordinate;
            
            break;
        }
        
        [self.map addOverlay:overlay];
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    //if ([overlay isKindOfClass:PVParkMapOverlay.class]) {
        UIImage *magicMountainImage = [UIImage imageNamed:@"overlay_park"];
        KGMapOverlayView *overlayView = [[KGMapOverlayView alloc] initWithOverlay:overlay overlayImage:magicMountainImage];
        
        return overlayView;
    //}
    
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

@end
