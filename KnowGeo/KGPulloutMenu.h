//
//  KGPulloutMenu.h
//  KnowGeo
//
//  Created by Corey Norford on 6/2/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGPulloutMenu : UIView

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property bool menuInHighPosition;

- (IBAction)pulled:(id)sender;

@end
