//
//  KGAnnotationView.m
//  KnowGeo
//
//  Created by Corey Norford on 5/9/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGAnnotationView.h"

@implementation KGAnnotationView

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{    
    NSString *className = NSStringFromClass(gestureRecognizer.class);
    
    if([className isEqualToString:@"UILongPressGestureRecognizer" ]){
        NSLog(@"Is a long press");
        return NO;
    }
    else if([className isEqualToString:@"UITapGestureRecognizer"]){
        NSLog(@"Is a tap");
        return YES;
    }
    else{
        return NO;
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event{
    
    UIView* hitView = [super hitTest:point withEvent:event];
    
    if (hitView != nil){
        [self.superview bringSubviewToFront:self];
    }
    
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    
    if(!isInside){
        for (UIView *view in self.subviews){
            isInside = CGRectContainsPoint(view.frame, point);
            
            if(isInside)
                break;
        }
    }
    
    return isInside;
}

-(void)openCallout{
    self.isDeleting = NO;
    //http://stackoverflow.com/questions/15241340/how-to-add-custom-view-in-maps-annotations-callouts/19404994#19404994
    NSArray *nibCallout = [[NSBundle mainBundle] loadNibNamed:@"KGCalloutView" owner:self options:nil];
    KGCalloutView *callout = [nibCallout objectAtIndex:0];
    callout.center = CGPointMake(self.bounds.size.width*0.5f, -self.bounds.size.height*4);
    callout.title = self.pin.title;
    
    callout.types = @[@"Select Type", @"Boat Ramp", @"Dive Site", @"Dive Shop", @"Marina", @"Marine Fuel", @"Sandbar", @"Services", @"Snorkel"];
    callout.type = self.pin.typeId;
    callout.subTypes = @[@"Select Subtype", @"Bahamas", @"Cali", @"G Lakes", @"Gulf", @"MS River", @"Pac NW", @"S. Atl"];
    callout.subtype = self.pin.subtypeId;
    
    self.calloutView = callout;
    self.calloutView.delegate = self;
    [self addSubview:callout];
}

#pragma mark KGCalloutViewDelegate

-(void)kgCalloutView:(KGCalloutView *)kGCalloutView deleteButtonPressed:(BOOL)variable{
    self.isDeleting = YES;
    [self.delegate kgAnnotationView:self delete:YES];
}

-(void)kgCalloutView:(KGCalloutView *)kGCalloutView typeChanged:(NSNumber *)newTypeId{
    [self.delegate kgAnnotationView:self updateType:newTypeId];
}

-(void)kgCalloutView:(KGCalloutView *)kGCalloutView subtypeChanged:(NSNumber *)newSubtypeId{
    [self.delegate kgAnnotationView:self updateSubtype:newSubtypeId];
}

-(void)kgCalloutView:(KGCalloutView *)kGCalloutView closeButtonPressed:(BOOL)variable{
    [self.calloutView removeFromSuperview2];
    [self.delegate kgAnnotationView:self closing:YES];
}

-(void)kgCalloutView:(KGCalloutView *)kGCalloutView titleChanged:(NSString *)newTitle{
    [self.delegate kgAnnotationView:self updateTitle:newTitle];
}


@end
