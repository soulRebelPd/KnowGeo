//
//  KGCalloutTesterView.h
//  KnowGeo
//
//  Created by Corey Norford on 4/21/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBCalloutTesterView;

@protocol KGCalloutTesterDelegate <NSObject>
- (BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView clearStatePressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testRegularLocationAnyPressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testRegularLineDroppedPressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testDrawingLineDroppedPressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testColoringLineSelectedPressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testRegularLineSelected_WithParentPressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(SBCalloutTesterView *)kGCalloutTesterView testRegularLineSelected_NoParentPressed:(BOOL)variable;
@end

@interface SBCalloutTesterView : UIView{
}

@property (nonatomic, weak) NSObject <KGCalloutTesterDelegate> *delegate;

- (IBAction)clearStateClicked:(id)sender;
- (IBAction)testRegularLocationAny:(id)sender;
- (IBAction)testRegularLineDropped:(id)sender;
- (IBAction)testDrawingLineDropped:(id)sender;
- (IBAction)testColoringLineSelected:(id)sender;
- (IBAction)testRegularLineSelected_WithParent:(id)sender;
- (IBAction)testRegularLineSelected_NoParent:(id)sender;

@end
