//
//  KGMapOverlayView.h
//  KnowGeo
//
//  Created by Corey Norford on 4/24/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface KGMapOverlayView : MKOverlayRenderer

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;

@end
