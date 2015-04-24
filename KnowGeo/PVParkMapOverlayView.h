//
//  PVParkMapOverlayView.h
//  Park View
//
//  Created by Corey Norford on 4/23/15.
//  Copyright (c) 2015 Chris Wagner. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PVParkMapOverlayView : MKOverlayRenderer

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;

@end
