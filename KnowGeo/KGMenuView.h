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
- (BOOL)menuView:(KGMenuView *)menuView buttonPressed:(UIButton*)button;
@end

@interface KGMenuView : UIView <UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UISwitch *warningSwitch;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIButton *exportButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (nonatomic, weak) NSObject <MenuViewDelegate> *delegate;
@property (nonatomic) IBInspectable NSString *title;

- (IBAction)clearPressed:(UIButton *)sender;
- (IBAction)exportPressed:(UIButton *)sender;
- (void)hideLogo;
- (void)disableExportButton;
- (void)enableExportButton;
- (void)disableClearButton;
- (void)enableClearButton;

@end

