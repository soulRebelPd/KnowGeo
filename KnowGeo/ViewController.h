//
//  ViewController.h
//  KnowGeo
//
//  Created by Corey Norford on 4/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGCalloutView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet KGCalloutView *myCustomControl;

- (IBAction)testClearState:(id)sender;
- (IBAction)testRegularLocationAny:(id)sender;
- (IBAction)testRegularLineDropped:(id)sender;
- (IBAction)testDrawingLineDropped:(id)sender;
- (IBAction)testRegularLineSelected_NoParent:(id)sender;
- (IBAction)testRegularLineSelected_WithParent:(id)sender;
- (IBAction)testColoringLineSelected:(id)sender;

@end

