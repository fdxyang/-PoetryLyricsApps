//
//  SeachViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/29.
//  Copyright (c) 2013年 cc. All rights reserved.
//
//  2015.01.07 [Kevin] Fix search result bug

#import "SeachViewController.h"

@interface SeachViewController ()

@end

@implementation SeachViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _PoetryDatabase = [[PoetryCoreData alloc] init];
    //self.navigationItem.title = @"搜尋";
    //_HistoryData = [_PoetryDatabase Poetry_CoreDataFetchDataInHistory];
    //_HistoryData = [_PoetryDatabase Poetry_CoreDataFetchData];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    UILabel  *_NavigationTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _NavigationTitleLab.text = @"搜尋";
    _NavigationTitleLab.backgroundColor = [UIColor clearColor];
    _NavigationTitleLab.font = [UIFont boldSystemFontOfSize:16.0];
    _NavigationTitleLab.textAlignment = NSTextAlignmentCenter;
    _NavigationTitleLab.textColor = [UIColor whiteColor]; // change this color
    
    //    _NavigationTitleLab.textColor = [[UIColor alloc] initWithRed:(247/255.0f) green:(243/255.0f) blue:(205/255.0f) alpha:1]; // change this color
    self.navigationItem.titleView = _NavigationTitleLab;
    CGSize Size = CGSizeMake(280, 200);
    Size = [_NavigationTitleLab sizeThatFits:Size];
    [_NavigationTitleLab setFrame:CGRectMake(0, 0, 280, Size.height)];
    
    [self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                                                    green:(159/255.0f)
                                                                                     blue:(191/255.0f)
                                                                                    alpha:0.8]];
    [_SearchBar setBarTintColor:[[UIColor alloc] initWithRed:(147/255.0f)
                                                          green:(208/255.0f)
                                                           blue:(202/255.0f)
                                                          alpha:1]];
    [_SearchBar setBackgroundColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                       green:(159/255.0f)
                                                        blue:(191/255.0f)
                                                       alpha:1]];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _HistoryData = [_PoetryDatabase Poetry_CoreDataFetchDataInHistory];
    _HistoryData = [NSMutableArray arrayWithArray:[[_HistoryData reverseObjectEnumerator] allObjects]];
    [_TableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return [_SearchResultDisplayArray count];

    } else {
        
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return [[_SearchResultDisplayArray objectAtIndex:section] count];

        
    } else {
        
        return [_HistoryData count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        NSManagedObject *Poetry = [[_SearchResultDisplayArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [Poetry valueForKey:POETRY_CORE_DATA_NAME_KEY]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [Poetry valueForKey:POETRY_CORE_DATA_CONTENT_KEY]];

        
    } else {
        
        NSManagedObject *Poetry = [_HistoryData objectAtIndex:indexPath.row];

        cell.textLabel.text = [NSString stringWithFormat:@"%@", [Poetry valueForKey:POETRY_CORE_DATA_NAME_KEY]];
        
        // [CASPER] 20140106 replace @@ string with empty char
        cell.detailTextLabel.text = [[NSString stringWithFormat:@"%@", [[Poetry valueForKey:POETRY_CORE_DATA_CONTENT_KEY] stringByReplacingOccurrencesOfString:@"\n" withString:@""]] stringByReplacingOccurrencesOfString:@"@@" withString:@""];
        
        
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *sectionStr = [[NSString alloc] init];
    
    if ([self.searchDisplayController isActive]) {
        
        switch (section) {
            case 0:
                sectionStr = nil;
                break;
                
            case 1:
                sectionStr = @"基督基石";
                break;
                
            case 2:
                sectionStr = @"詩歌";
                break;
                
            case 3:
                sectionStr = @"啟應文";
                break;
            default:
                break;
        }
        
    } else {
        
        return @"歷史紀錄";
        
    }
    return sectionStr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *SelectedDic;
    if ([self.searchDisplayController isActive]) {
    
        if (indexPath.section == 0) {
            // History
            SelectedDic = [_SearchHistoryData objectAtIndex:indexPath.row];
            
        } else if (indexPath.section == 1) {
            
            // Guard Reading
            SelectedDic = [_SearchGuidedReading objectAtIndex:indexPath.row];
            
            
        } else if (indexPath.section == 2) {
            
            // Poetry
            SelectedDic = [_SearchPoetryData objectAtIndex:indexPath.row];
            
            
        } else if (indexPath.section == 3) {
            
            // Responsive prayer
            SelectedDic = [_SearchRespose objectAtIndex:indexPath.row];
            
        }
        
    } else {
        
        SelectedDic = [_HistoryData objectAtIndex:indexPath.row];
        NSLog(@"%@", SelectedDic);
    }

    [_PoetryDatabase PoetryCoreDataSaveIntoNowReading:SelectedDic];
    
    // Jump to Reading View
    [self.tabBarController setSelectedIndex:0];
    
    
}

#pragma mark - SearchBar Method
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    _SearchGuidedReading = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryName:searchText InCategory:GUARD_READING]];
    
    _SearchPoetryData = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryName:searchText InCategory:POETRYS]];
    
    _SearchRespose = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryName:searchText InCategory:RESPONSIVE_PRAYER]];
    
    _SearchHistoryData = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryNameInHistory:searchText]];
    

    //if ([searchText length] > 3 ) {
        
        [_SearchGuidedReading addObjectsFromArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryContent:searchText InCategory:GUARD_READING]];
        [_SearchPoetryData addObjectsFromArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryContent:searchText InCategory:POETRYS]];
        [_SearchRespose addObjectsFromArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryContent:searchText InCategory:RESPONSIVE_PRAYER]];

    //}
    
    
    _SearchResultDisplayArray = [NSArray arrayWithObjects:
                                 _SearchHistoryData,
                                 _SearchGuidedReading,
                                 _SearchPoetryData,
                                 _SearchRespose,
                                 nil];

}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    
    return YES;
}


// Remove "\n" in the beginning of the article
-(NSString*)ReadingViewCleanUpTextWithTheArticle : (NSString*) Articel
{
    NSRange range;
    range.length = 1;
    range.location = 0;
    [Articel stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    
    for (int index = 0; index < [Articel length]; index++) {
        
        if ([Articel characterAtIndex:index] == 10) {
            
            if (index <= 1) {
                
                if (index == 1) {
                    range.location = index;
                    Articel = [Articel stringByReplacingCharactersInRange:range withString:@""];
                    
                    
                }
                
            } else {
                
                break;
            }
            
        } else {
            
            break;
        }
    }
    
    return Articel;
}



@end
