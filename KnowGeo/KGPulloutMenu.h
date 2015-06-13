//
//  KGPulloutMenu.h
//  KnowGeo
//
//  Created by Corey Norford on 6/11/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "SearchHistory.h"
#import "UIColor+KGColors.h"

@class KGPulloutMenu;

@protocol KGPulloutMenuDelegate <NSObject>
- (void)kgPulloutMenu:(KGPulloutMenu *)kgPulloutMenu pulled:(bool)wasPulled;
- (void)kgPulloutMenu:(KGPulloutMenu *)kgPulloutMenu searched:(NSString *)searchText;
@end

@interface KGPulloutMenu : UIView <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSObject <KGPulloutMenuDelegate> *delegate;
@property (strong, nonatomic) NSMutableArray *searchHistory;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property NSEntityDescription *historyEntityDescription;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTableView;

- (IBAction)pulled:(id)sender;

@end
