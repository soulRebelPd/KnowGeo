//
//  KGMenuButton.h
//  KnowGeo
//
//  Created by Corey Norford on 4/22/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGMenuButton;

@protocol KGMenuButtonDelegate <NSObject>
- (void)kgMenuButtonTapped:(KGMenuButton *)kgMenuButton;
@end

@interface KGMenuButton : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, weak) NSObject <KGMenuButtonDelegate> *delegate;
@property (nonatomic) IBInspectable UIImage *image;
@property (nonatomic) IBInspectable NSString *title;

- (IBAction)tapped:(id)sender;

@end