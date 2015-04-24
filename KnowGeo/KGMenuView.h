//
//  KGCalloutView.h
//  KnowGeo
//
//  Created by Corey Norford on 4/17/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGMenuButton.h"
#import "UIColor+KGColors.h"

IB_DESIGNABLE

@class KGMenuView;

@protocol MenuViewDelegate <NSObject>
- (BOOL)menuView:(KGMenuView *)menuView buttonPressed:(KGMenuButton*)button;
@end

@interface KGMenuView : UIView <UICollectionViewDelegateFlowLayout, KGMenuButtonDelegate>

@property (nonatomic, weak) NSObject <MenuViewDelegate> *delegate;
@property (nonatomic) IBInspectable NSString *title;
@property (strong, nonatomic) NSDictionary *dataSource;

@property (weak, nonatomic) IBOutlet KGMenuButton *menuButton1;
@property (weak, nonatomic) IBOutlet KGMenuButton *menuButton2;
@property (weak, nonatomic) IBOutlet KGMenuButton *menuButton3;
@property (weak, nonatomic) IBOutlet KGMenuButton *menuButton4;
@property (weak, nonatomic) IBOutlet UISwitch *warningSwitch;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@end
