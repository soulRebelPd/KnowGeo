//
//  KGCalloutView.h
//  KnowGeo
//
//  Created by Corey Norford on 4/17/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreGraphics/CoreGraphics.h>

#import "UIColor+KGColors.h"
#import "CalloutTail.h"

IB_DESIGNABLE

@class KGCalloutView;

@protocol KGCalloutViewDelegate <NSObject>
-(void)kgCalloutView:(KGCalloutView *)kGCalloutView deleteButtonPressed:(BOOL)variable;
-(void)kgCalloutView:(KGCalloutView *)kGCalloutView categoryChanged:(NSNumber *)newCategoryId;
-(void)kgCalloutView:(KGCalloutView *)kGCalloutView subtypeChanged:(NSNumber *)newSubtypeId;
-(void)kgCalloutView:(KGCalloutView *)kGCalloutView titleChanged:(NSString *)newTitle;
-(void)kgCalloutView:(KGCalloutView *)kGCalloutView closeButtonPressed:(BOOL)variable;
@end

@interface KGCalloutView : UIView <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
//displays option to Delete or Choose Parent or Clear Parent or Drop A Child Pin

@property (nonatomic) IBInspectable NSString *title;
@property (nonatomic) NSNumber *subtype;
@property (nonatomic) NSNumber *type;
@property NSArray *types;
@property NSArray *subTypes;
@property (strong, nonatomic) IBOutlet KGCalloutView *view;
@property MKAnnotationView *parent;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIPickerView *typePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *subtypePickerView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) NSObject <KGCalloutViewDelegate> *delegate;
@property (weak, nonatomic) IBOutlet UIImageView *trianglePlaceholder;
@property (strong, nonatomic) CalloutTail *shapeView;

- (void)moveToState:(NSString *)state;
- (IBAction)deletePin:(id)sender;
- (IBAction)closeCallout:(id)sender;
-(void)removeFromSuperview2;
- (IBAction)titleFieldEditingDidEnd:(id)sender;

//NOTE: not yet implemented
- (void)didSetName;
- (void)changeToState;

@end

//@property (weak, nonatomic) IBOutlet UILabel *chooseTypeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *pinTypeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *isLinePinLabel;
//@property (weak, nonatomic) IBOutlet UISwitch *isLinePinSwitch;
//@property (weak, nonatomic) IBOutlet UIButton *startLineButton;
//@property (weak, nonatomic) IBOutlet UIButton *selectParentButton;
//@property (weak, nonatomic) IBOutlet UIButton *endLineButton;
//@property (weak, nonatomic) IBOutlet UIButton *startLineColoring;
//@property (weak, nonatomic) IBOutlet UIButton *endLineColoring;



