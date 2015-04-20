//
//  ViewController.m
//  KnowGeo
//
//  Created by Corey Norford on 4/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"KGCalloutView" owner:self options:nil];
    KGCalloutView *view = [nibContents objectAtIndex:0];
    self.myCustomControl = view;
    self.myCustomControl.frame = CGRectMake(35, 150, 300, 275);
    [self.view addSubview:view];
    
    NSArray *nibContentsForMenu = [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil];
    MenuView *menu = [nibContentsForMenu objectAtIndex:0];
    self.menu = menu;
    [self.view addSubview:menu];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testClearState:(id)sender {
    [self.myCustomControl moveToState:@"Empty"];
}

- (IBAction)testRegularLocationAny:(id)sender {
    [self.myCustomControl moveToState:@"Regular-Location-Dropped"];
}

- (IBAction)testRegularLineDropped:(id)sender {
    [self.myCustomControl moveToState:@"Regular-Line-Dropped"];
}

- (IBAction)testDrawingLineDropped:(id)sender {
    [self.myCustomControl moveToState:@"Drawing-Line-Dropped"];
}

- (IBAction)testRegularLineSelected_NoParent:(id)sender {
        [self.myCustomControl moveToState:@"Regular-Line-Selected_NoParent"];
}

- (IBAction)testRegularLineSelected_WithParent:(id)sender {
    [self.myCustomControl moveToState:@"Regular-Line-Selected_WithParent"];
}

- (IBAction)testColoringLineSelected:(id)sender {
    [self.myCustomControl moveToState:@"Coloring-Line-Selected"];
}
@end
