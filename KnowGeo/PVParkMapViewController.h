#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface PVParkMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)mapTypeChanged:(id)sender;

@end
