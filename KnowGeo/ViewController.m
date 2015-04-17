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
    [self.view addSubview:view];

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
@end
