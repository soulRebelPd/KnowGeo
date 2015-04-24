//
//  KGCalloutTesterView.h
//  KnowGeo
//
//  Created by Corey Norford on 4/21/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGCalloutTesterView;

@protocol KGCalloutTesterDelegate <NSObject>
- (BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView clearStatePressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testRegularLocationAnyPressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testRegularLineDroppedPressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testDrawingLineDroppedPressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testColoringLineSelectedPressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testRegularLineSelected_WithParentPressed:(BOOL)variable;
- (BOOL)kGCalloutTesterView:(KGCalloutTesterView *)kGCalloutTesterView testRegularLineSelected_NoParentPressed:(BOOL)variable;
@end

@interface KGCalloutTesterView : UIView{
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
