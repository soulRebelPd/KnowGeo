//
//  KGMapOverlayView.m
//  KnowGeo
//
//  Created by Corey Norford on 4/24/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "SBOverlayRenderer.h"

@interface SBOverlayRenderer ()

@property (nonatomic, strong) UIImage *overlayImage;

@end

@implementation SBOverlayRenderer

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
