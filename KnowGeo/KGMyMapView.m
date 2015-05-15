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
    [self removeAnnotation:kGAnnotationView.annotation];
}

//-(void)deleteAnnotation:(MKPointAnnotation *)annotation{
//    [self deselectAnnotation:annotation animated:YES];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
