//
//  KGPulloutMenu.m
//  KnowGeo
//
//  Created by Corey Norford on 6/11/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGPulloutMenu.h"

@implementation KGPulloutMenu

@synthesize delegate;
@synthesize managedObjectContext;

-(void)awakeFromNib{
    self.searchBar.delegate = self;
    
    self.searchHistoryTableView.delegate = self;
    self.searchHistoryTableView.opaque = YES;
    self.searchHistoryTableView.separatorColor = [UIColor blackColor];
    self.searchHistoryTableView.backgroundColor = [UIColor blackColor];
    
    [self.layer setCornerRadius:10.0f];
}

-(void)layoutSubviews{
    self.historyEntityDescription = [NSEntityDescription entityForName:@"SearchHistory" inManagedObjectContext:self.managedObjectContext];
    self.searchHistory = [SearchHistory fetchAllWithContext:self.managedObjectContext];
}

- (IBAction)pulled:(id)sender {
    [self.delegate kgPulloutMenu:self pulled:YES];
}


#pragma mark UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
    [self.delegate kgPulloutMenu:self searched:searchBar.text];
    [self addToHistory:searchBar.text];
    [self removeOldRecordsAboveThresholdWithThreshold:@10];
    [self reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = YES;
}


#pragma - markup UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchHistory count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.backgroundColor = [UIColor kgMediumBrownColor];
    cell.textLabel.textColor = [UIColor kgOrangeColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    SearchHistory *history = [self.searchHistory objectAtIndex:indexPath.row];
    cell.textLabel.text = history.text;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
    
    SearchHistory *history = [self.searchHistory objectAtIndex:indexPath.row];
    [self.delegate kgPulloutMenu:self searched:history.text];
    
    self.searchBar.text = history.text;
    [self.searchHistoryTableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark Data

-(void)addToHistory:(NSString *)searchText{
    bool existsInHistory = [self searchHistoryContains:searchText];
    
    if(!existsInHistory){
        SearchHistory *history = [[SearchHistory alloc] initWithEntity:self.historyEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        
        history.text = searchText;
        history.timeStamp = [NSDate date];
        [history save];
        
        [self reloadData];
    }
}

-(bool)searchHistoryContains:(NSString *)text{
    for(SearchHistory *history in self.searchHistory){
        if([history.text isEqualToString:text]){
            return YES;
        }
    }
    
    return NO;
}

-(void)reloadData{
    self.searchHistory = [SearchHistory fetchAllWithContext:self.managedObjectContext];
    [self.searchHistoryTableView reloadData];
}

-(void)removeOldRecordsAboveThresholdWithThreshold:(NSNumber *)threshold{
    int counter = 1;
    
    for(SearchHistory *history in self.searchHistory){
        if(counter > [threshold integerValue]){
            [history delete];
        }
        
        counter = counter + 1;
    }
}

@end
