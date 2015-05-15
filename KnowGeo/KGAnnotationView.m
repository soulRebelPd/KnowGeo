//
//  KGAnnotationView.m
//  KnowGeo
//
//  Created by Corey Norford on 5/9/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGAnnotationView.h"

@implementation KGAnnotationView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

-(void)openCallout{
    //http://stackoverflow.com/questions/15241340/how-to-add-custom-view-in-maps-annotations-callouts/19404994#19404994
    NSArray *nibCallout = [[NSBundle mainBundle] loadNibNamed:@"KGCalloutView" owner:self options:nil];
    KGCalloutView *callout = [nibCallout objectAtIndex:0];
    callout.center = CGPointMake(self.bounds.size.width*0.5f, -self.bounds.size.height*4);
    
    self.calloutView = callout;
    self.calloutView.delegate = self;
    [self addSubview:callout];
}

-(void)kgCalloutView:(KGCalloutView *)kGCalloutView deleteButtonPressed:(BOOL)variable{
    [self.delegate kgAnnotationView:self delete:YES];
    
//    KGMyMapView *mapView = (KGMyMapView *)self.parent;
//    [mapView deleteAnnotation:self.annotation];

//    KGMyMapView *mapView = (KGMyMapView *)self.parent;
//    [mapView deleteAnnotation:kGCalloutView];
//    [self.parent deleteAnnotation:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
