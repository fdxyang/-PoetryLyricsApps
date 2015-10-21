//
//  GotoViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/29.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "GotoViewController.h"


@interface GotoViewController ()

@property (strong, nonatomic) UISearchBar                   *searchBar;
@property (strong, nonatomic) UISearchDisplayController     *searchBarController;
@property (strong,nonatomic)  UITableView                   *searchlist;

@property BOOL isSearchTextViewEditing;

@property (nonatomic, strong) NSArray *SearchResultDisplayArray;
@property (nonatomic, strong) NSMutableArray *SearchHistoryData;
@property (nonatomic, strong) NSMutableArray *SearchGuidedReading;
@property (nonatomic, strong) NSMutableArray *SearchPoetryData;
@property (nonatomic, strong) NSMutableArray *SearchRespose;

@end


@implementation GotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,64,self.view.frame.size.width,50)];
    _searchBar.delegate = self;
    _searchBar.barTintColor = [UIColor colorWithRed:(32.0/255.0f) green:(159.0/255.0f) blue:(191.0/255.0f) alpha:0.8];
    [self.view addSubview:_searchBar];
    
    _TableView = [[UITableView alloc]initWithFrame:CGRectMake(0,_searchBar.frame.origin.y+_searchBar.frame.size.height, self.view.frame.size.width,self.view.frame.size.height-_searchBar.frame.origin.y-_searchBar.frame.size.height-48)];
    
    list = [[NSArray alloc] initWithObjects:@"基督基石", @"詩歌", @"啟應文", nil];
    
    
    _TableView.dataSource = self;
    _TableView.delegate = self;
    _historyArr = [PoetryDataBase Poetry_CoreDataFetchDataInHistory];
    _TableView.tag = 1;
    [_TableView reloadData];
    [self.view addSubview:_TableView];
    
    if (PoetryDataBase == nil) {
        PoetryDataBase = [[PoetryCoreData alloc] init];
    }
    
    _searchlist = [[UITableView alloc]initWithFrame:CGRectMake(0,_searchBar.frame.origin.y+_searchBar.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-_searchBar.frame.origin.y-_searchBar.frame.size.height)];
    _searchlist.delegate = self;
    _searchlist.dataSource = self;
    [_searchlist setBackgroundColor:[UIColor whiteColor]];
    _searchlist.separatorColor = [UIColor grayColor];
    [_searchlist setHidden:YES];
    _searchlist.tag = 2;
    [self.view addSubview:_searchlist];
    
    _isSearchTextViewEditing = NO;
    [self RegisteKeyboardNotification];
    
    // Kevin 20140124 set title background color
    [self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                            green:(159/255.0f)
                                                             blue:(191/255.0f)
                                                            alpha:0.8]];
    
    self.navigationItem.title = @"快速查詢";
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFun)];
    //設定行為
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _historyArr = [PoetryDataBase Poetry_CoreDataFetchDataInHistory];
    [_TableView reloadData];
    
    self.navigationItem.title = @"快速查詢";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_searchlist setHidden:YES];
    
    [_SearchGuidedReading removeAllObjects];
    [_SearchPoetryData removeAllObjects];
    [_SearchRespose removeAllObjects];
    
    _searchBar.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        return [[_SearchResultDisplayArray objectAtIndex:section] count];
    }
    else{
        GotoPageAreaSection viewsection = (GotoPageAreaSection)section;
        
        if (viewsection == BASICGUIDE)
        {
            return 3;
        }
        else if(viewsection == HISTORY)
            return [_historyArr count];//history array count
        else
        {
            GOTO_VIEW_ERROR_LOG(@"It is a bug !!!!!!!");
            return 0;
        }
    }
    
    NSLog(@" numberOfRowsInSection error !!! ");
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 2) {
        return 40.0f;
    }
    else{
        if (indexPath.section == BASICGUIDE)
        {
            return 80;
        }
        else
            return 45;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        return 30.0f;
    }
    else{
        if (section == BASICGUIDE) {
            return 0;
        }
        else
            return 30;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionStr = [[NSString alloc] init];
    
    if (tableView.tag == 2) {
        
        switch (section) {
            case 0:
                sectionStr = @"基督基石";
                break;
                
            case 1:
                sectionStr = @"詩歌";
                break;
                
            case 2:
                sectionStr = @"啟應文";
                break;
                
            default:
                sectionStr = @"";
                break;
        }
    }
    else{
        switch (section)
        {
            case 0:
                sectionStr = @"";
                break;
                
            case 1:
                sectionStr = @"歷史記錄";
                break;
                
            default:
                break;
        }
    }
    return sectionStr;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    
    if (tableView.tag == 1) {
    
        if (section == 1)
        {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,30)];
            /* Create custom view to display section header... */
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-10,30)];
            [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
            label.textAlignment = NSTextAlignmentLeft;
            
            NSString *string = @"歷史記錄";
            
            [label setText:string];
            label.textColor = [UIColor whiteColor];
            [view addSubview:label];
            [view setBackgroundColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                            green:(159/255.0f)
                                                             blue:(191/255.0f)
                                                            alpha:1]];
            [label setBackgroundColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                             green:(159/255.0f)
                                                              blue:(191/255.0f)
                                                             alpha:1]]; //your background color...
        }
        
        return view;
    }
    else{
    
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,30)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-10,30)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
        label.textAlignment = NSTextAlignmentLeft;
        
        NSString *string;
        
        if (section == 0) {
            string = @"基督基石";
        }
        else if(section == 1){
            string = @"詩歌";
        }
        else{
            string = @"啟應文";
        }
        
        [label setText:string];
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
        [view setBackgroundColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                        green:(159/255.0f)
                                                         blue:(191/255.0f)
                                                        alpha:1]];
        [label setBackgroundColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                         green:(159/255.0f)
                                                          blue:(191/255.0f)
                                                         alpha:1]];
        return view;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 2) {
        return [_SearchResultDisplayArray count];
    }
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        
        NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.row,(long)indexPath.section];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        if(indexPath.section == BASICGUIDE)
        {
            cell.textLabel.text = [list objectAtIndex:indexPath.row];//[_TableView.TableData objectAtIndex:indexPath.row];
        }
        else
        {
            _historyArr = [PoetryDataBase Poetry_CoreDataFetchDataInHistory];
            _historyArr = [NSMutableArray arrayWithArray:[[_historyArr reverseObjectEnumerator] allObjects]];
            cell.textLabel.text = [[_historyArr objectAtIndex:indexPath.row] valueForKey:POETRY_CORE_DATA_NAME_KEY];
        }
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        NSManagedObject *Poetry = [[_SearchResultDisplayArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [Poetry valueForKey:POETRY_CORE_DATA_NAME_KEY]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [Poetry valueForKey:POETRY_CORE_DATA_CONTENT_KEY]];
        
        [cell.textLabel setTextAlignment:(NSTextAlignmentLeft | NSTextAlignmentCenter)];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 1) {
        
        GOTO_VIEW_LOG(@"section = %d",indexPath.section);
        if (indexPath.section == BASICGUIDE)
        {
            switch (indexPath.row) {
                case 0: // guide
                    if(!_detailTableView)
                    {
                        _detailTableView = [[GotoTableViewController alloc]initWithStyle:UITableViewStylePlain TYPE:0];
                    }
                    else
                    {
                        [_detailTableView setTableViewType:0];
                    }
                    
                    gotoType = 0;

                    [self performSegueWithIdentifier: @"detailTableView" sender: self];
                    break;
                case 1: // poetry
                    if(!_detailTableView)
                    {
                        _detailTableView = [[GotoTableViewController alloc]initWithStyle:UITableViewStylePlain TYPE:1];
                    }
                    else
                    {
                        [_detailTableView setTableViewType:1];
                    }
                    
                    gotoType = 1;
                    
                    [self performSegueWithIdentifier: @"detailTableView" sender: self];
                    break;
                case 2: // response
                    if(!_detailTableView)
                    {
                        _detailTableView = [[GotoTableViewController alloc]initWithStyle:UITableViewStylePlain TYPE:2];
                    }
                    else
                    {
                        [_detailTableView setTableViewType:2];
                    }
                    
                    gotoType = 2;
                    
                    [self performSegueWithIdentifier: @"detailTableView" sender: self];
                    break;
                    
                default:
                    break;
            }
        }
        else //histroy
        {
            NSDictionary *SelectedDic = [_historyArr objectAtIndex:indexPath.row];
            GOTO_VIEW_LOG(@"history = %@", SelectedDic);
        
            [PoetryDataBase PoetryCoreDataSaveIntoNowReading:SelectedDic];
            [_TableView reloadData];
            [self.tabBarController setSelectedIndex:0];
        }
    }
    else{
        
        NSDictionary *SelectedDic;
        
        if (indexPath.section == 0) {
            
            // Guard Reading
            SelectedDic = [_SearchGuidedReading objectAtIndex:indexPath.row];
            
            
        } else if (indexPath.section == 1) {
            
            // Poetry
            SelectedDic = [_SearchPoetryData objectAtIndex:indexPath.row];
            
            
        } else if (indexPath.section == 2) {
            
            // Responsive prayer
            SelectedDic = [_SearchRespose objectAtIndex:indexPath.row];
            
        }
        
        [PoetryDataBase PoetryCoreDataSaveIntoNowReading:SelectedDic];
         [self.tabBarController setSelectedIndex:0];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailTableView"])
    {
        _detailTableView = segue.destinationViewController;
        
        [_detailTableView setTableViewType:gotoType];
    }
}

-(void) RegisteKeyboardNotification
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification*)notif
{
    NSValue *keyboardBoundsValue = [[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardEndRect = [keyboardBoundsValue CGRectValue];
    CGFloat ScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat KeyBoardHeight = keyboardEndRect.size.height;
    
    [_searchlist setHidden:NO];
    
    if (_isSearchTextViewEditing) {
        
        CGRect TextViewFrame = _searchlist.frame;
        TextViewFrame.size.height = ScreenHeight - KeyBoardHeight - 44.0 - 70.0f;
        [_searchlist setFrame:TextViewFrame];
    }
    else{
        CGRect TextViewFrame = _searchlist.frame;
        TextViewFrame.size.height = ScreenHeight - 44.0 - 70.0f;
        [_searchlist setFrame:TextViewFrame];
    }
    [_searchlist reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText //scope:(NSString*)scope
{
    _SearchGuidedReading = [NSMutableArray arrayWithArray:[PoetryDataBase Poetry_CoreDataSearchWithPoetryName:searchText InCategory:GUARD_READING]];
    
    _SearchPoetryData = [NSMutableArray arrayWithArray:[PoetryDataBase Poetry_CoreDataSearchWithPoetryName:searchText InCategory:POETRYS]];
    
    _SearchRespose = [NSMutableArray arrayWithArray:[PoetryDataBase Poetry_CoreDataSearchWithPoetryName:searchText InCategory:RESPONSIVE_PRAYER]];
    
    [_SearchGuidedReading addObjectsFromArray:[PoetryDataBase Poetry_CoreDataSearchWithPoetryContent:searchText InCategory:GUARD_READING]];
    [_SearchPoetryData addObjectsFromArray:[PoetryDataBase Poetry_CoreDataSearchWithPoetryContent:searchText InCategory:POETRYS]];
    [_SearchRespose addObjectsFromArray:[PoetryDataBase Poetry_CoreDataSearchWithPoetryContent:searchText InCategory:RESPONSIVE_PRAYER]];
    
    _SearchResultDisplayArray = [NSMutableArray arrayWithObjects:
                                 _SearchGuidedReading,
                                 _SearchPoetryData,
                                 _SearchRespose,
                                 nil];
}

#pragma kevin search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchlist reloadData];
    [_searchBar resignFirstResponder];
    [self setRemoveGesture];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    [self setAddGesture];
    _isSearchTextViewEditing = TRUE;
    [_searchlist reloadData];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarShouldEndEditing");
    [_searchBar resignFirstResponder];
    [_searchlist reloadData];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidEndEditing");
    [_searchBar resignFirstResponder];
    
    if ([searchBar.text isEqualToString:@""]) {
        [_searchlist setHidden:YES];
    }
    else{
        [_searchlist setFrame:CGRectMake(0,_searchBar.frame.origin.y+_searchBar.frame.size.height, self.view.frame.size.width,self.view.frame.size.height-_searchBar.frame.origin.y-_searchBar.frame.size.height-48)];
        [_searchlist reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"textDidChange");
    NSLog(@"text Did Change - text = %@",searchText);
    
    [self filterContentForSearchText:searchText];
    [_searchlist reloadData];
}

- (void) tapFun
{
    [_searchBar resignFirstResponder];
    _isSearchTextViewEditing=FALSE;
    [self setRemoveGesture];
}

- (void) setAddGesture
{
    [_searchlist addGestureRecognizer:tapGestureRecognizer];
}

- (void) setRemoveGesture
{
    [_searchlist removeGestureRecognizer:tapGestureRecognizer];
}

@end
