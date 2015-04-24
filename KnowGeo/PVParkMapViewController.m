#import "PVParkMapViewController.h"
//#import "PVMapOptionsViewController.h"
//#import "PVPark.h"
#import "PVParkMapOverlayView.h"
#import "PVParkMapOverlay.h"
 
@interface PVParkMapViewController ()
 
@property (nonatomic, strong) PVPark *park;
@property (nonatomic, strong) NSMutableArray *selectedOptions;
 
@end

@implementation PVParkMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.selectedOptions = [NSMutableArray array];
    
    //self.park = [[PVPark alloc] initWithFilename:@"MagicMountain"];

    //CLLocationDegrees latDelta = self.park.overlayTopLeftCoordinate.latitude - self.park.overlayBottomRightCoordinate.latitude;
 
    // think of a span as a tv size, measure from one corner to another
    //MKCoordinateSpan span = MKCoordinateSpanMake(fabsf(latDelta), 0.0);
 
    //MKCoordinateRegion region = MKCoordinateRegionMake(self.park.midCoordinate, span);
 
    //self.mapView.region = region;
}

- (void)loadSelectedOptions {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    for (NSNumber *option in self.selectedOptions) {
        
//        switch ([option integerValue]) {
//            case PVMapOverlay:
//                [self addOverlay];
//                break;
//            default:
//                break;
//        }
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //PVMapOptionsViewController *optionsViewController = segue.destinationViewController;
    //optionsViewController.selectedOptions = self.selectedOptions;
}

- (IBAction)closeOptions:(UIStoryboardSegue *)exitSegue {
    //PVMapOptionsViewController *optionsViewController = exitSegue.sourceViewController;
    //self.selectedOptions = optionsViewController.selectedOptions;
    [self loadSelectedOptions];
}

- (IBAction)mapTypeChanged:(id)sender {
    switch (self.mapTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

- (void)addOverlay {
    PVParkMapOverlay *overlay = [[PVParkMapOverlay alloc] initWithPark:self.park];
    [self.mapView addOverlay:overlay];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:PVParkMapOverlay.class]) {
        UIImage *magicMountainImage = [UIImage imageNamed:@"overlay_park"];
        PVParkMapOverlayView *overlayView = [[PVParkMapOverlayView alloc] initWithOverlay:overlay overlayImage:magicMountainImage];
        
        return overlayView;
    }
    
    return nil;
}

@end
