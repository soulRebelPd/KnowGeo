//
//  PVParkMapOverlayView.m
//  Park View
//
//  Created by Corey Norford on 4/23/15.
//  Copyright (c) 2015 Chris Wagner. All rights reserved.
//

#import "PVParkMapOverlayView.h"

@interface PVParkMapOverlayView ()

@property (nonatomic, strong) UIImage *overlayImage;

@end

@implementation PVParkMapOverlayView

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage {
    self = [super initWithOverlay:overlay];
    if (self) {
        _overlayImage = overlayImage;
    }
    
    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    CGImageRef imageReference = self.overlayImage.CGImage;
    
    MKMapRect theMapRect = self.overlay.boundingMapRect;
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    CGContextDrawImage(context, theRect, imageReference);
}

@end
