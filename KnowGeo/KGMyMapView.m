//
//  KGMyMapView.m
//  KnowGeo
//
//  Created by Corey Norford on 5/14/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGMyMapView.h"

@implementation KGMyMapView

-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView delete:(BOOL)variable{
    self.annotationViewDeleting = kGAnnotationView;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete pin?"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes",nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        [self removeAnnotation:self.annotationViewDeleting.annotation];
        NSLog(@"OK Tapped. Hello World!");
    }
}

-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView updateCategory:(NSNumber *)newCategoryId{
    [self.delegate2 kgMyMapView:self kgAnnotationView:kGAnnotationView updateCategory:newCategoryId];
}

-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView updateSubtype:(NSNumber *)newSubtypeId{
    [self.delegate2 kgMyMapView:self kgAnnotationView:kGAnnotationView updateSubtype:newSubtypeId];
}

-(void)kgAnnotationView:(KGAnnotationView *)kGAnnotationView updateTitle:(NSString *)newTitle{
    [self.delegate2 kgMyMapView:self kgAnnotationView:kGAnnotationView updateTitle:newTitle];
}

-(void)centerOnAnnotationView:(KGAnnotationView *)annotationView{
    MKMapRect mapRect = [self visibleMapRect];
    MKMapPoint mapPoint = MKMapPointForCoordinate([annotationView.annotation coordinate]);
    mapRect.origin.x = mapPoint.x - mapRect.size.width * 0.5;
    mapRect.origin.y = mapPoint.y - mapRect.size.height * 0.75;
    [self setVisibleMapRect:mapRect animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
