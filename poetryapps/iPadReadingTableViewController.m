//
//  iPadReadingTableViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/21.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "iPadReadingTableViewController.h"

@interface iPadReadingTableViewController () {
    UInt16                  _CurrentIndex;
    UIFont                  *_Font;
    UIFont                  *_BoldFont;
    UIFont                  *_PoetryNameFont;
    NSMutableArray          *_CellHeightArray;
    CURRENT_VIEW            _CurrentView;
    SLIDE_DIRECTION         _SlideDirection;
    GESTURE_MOVE_STATE      _ViewMovementState;
    NSMutableArray          *_TempPoetryList;
    NSDictionary            *_NewPoetryDic;
    
    CGPoint                 _TouchInit;
    BOOL                    _CrossCategoryFlag;
    BOOL                    _HeadAndTailFlag;
    
    UIColor                 *_LightBackgroundColor;
    UIColor                 *_DarkBackgroundColor;
    UIColor                 *_FontThemeColor;
    
    UILabel                 *_NavigationTitleLab;
    UIImage                 *_NaviBtnImgWhiteNormal;
    UIImage                 *_NaviBtnImgWhitePressed;
    UIImage                 *_NaviBtnImgDarkNormal;
    UIImage                 *_NaviBtnImgDarkPressed;
    UIImage                 *_SettingBtnImg;
    UIImage                 *_SearchingBtnImg;
    COVER_VIEW_STATE        _CoverViewState;

    
    BOOL                    _isNavTableOn;
    BOOL                    _isSettingTableOn;
    BOOL                    _isSearchBarOn;
    BOOL                    _isSearching;       //[CASPER] 2013.12.24
    BOOL                    _isTocTableOn;      //[CASPER] 2013.12.27
    BOOL                    _isHandlingTouchSwitch;     // NOT USED YET
    
}

@end

@implementation iPadReadingTableViewController

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
    CGRect Frame  = UI_READING_TABLEVIEW_INIT_IPAD;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handlePanFrom:)];
    
    [self.view addGestureRecognizer:panRecognizer];
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;
    
    _TableView1 = [[UITableView alloc]  initWithFrame:Frame];
    _TableView2 = [[UITableView alloc]  initWithFrame:Frame];
    _TableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_TableView1 setTag:1];
    [_TableView2 setTag:2];
    _TableView1.delegate = self;
    _TableView2.delegate = self;
    _TableView1.dataSource = self;
    _TableView2.dataSource = self;
    
    _PoetryDatabase = [[PoetryCoreData alloc] init];
    _PoetrySetting = [[PoetrySettingCoreData alloc] init];
    _ReadingTableArray1 = [[NSMutableArray alloc] init];
    _ReadingTableArray2 = [[NSMutableArray alloc] init];
    _CellHeightArray = [[NSMutableArray alloc] init];
    
    _HeadAndTailLab = [[UILabel alloc] init];
    [_HeadAndTailLab setBackgroundColor:[UIColor lightGrayColor]];
    
    
    //_LightBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Light_bgiPhone.png"]];
    _LightBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG-GreyNote_paper.png"]];
    _DarkBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Dark_bgiPhone.png"]];
    //_LightBackgroundColor = [[UIColor alloc] initWithRed:(247/255.0f) green:(243/255.0f) blue:(205/255.0f) alpha:1];
    //_LightBackgroundColor = [[UIColor alloc] initWithRed:(32/255.0f) green:(159/255.0f) blue:(191/255.0f) alpha:1];
    
    
    _NaviBtnImgWhiteNormal = [UIImage imageNamed:@"NaviBtnNormal_White_iPad.png"];
    _NaviBtnImgDarkNormal = [UIImage imageNamed:@"NaviBtnNormal_iPad.png"];
    //_NaviBtnImgDarkPressed = [UIImage imageNamed:@"NaviBtnPress_iPad.png"];
    //_NaviBtnImgWhitePressed = [UIImage imageNamed:@"NaviBtnPress_White_iPad.png"];

    _SettingBtnImg = [UIImage imageNamed:@"SettingNormal_White_iPad.png"];
    _SearchingBtnImg = [UIImage imageNamed:@"SearchingNormal_White_iPad.png"];

    _FontThemeColor = [[UIColor alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if  (_PoetrySetting.SettingTheme == THEME_LIGHT_DARK) {
        
        [_TableView1 setBackgroundColor:_LightBackgroundColor];
        [_TableView2 setBackgroundColor:_LightBackgroundColor];
        _FontThemeColor = [UIColor blackColor];
        
    } else {
        
        [_TableView1 setBackgroundColor:_DarkBackgroundColor];
        [_TableView2 setBackgroundColor:_DarkBackgroundColor];
        _FontThemeColor = [UIColor whiteColor];
        
    }
    
    
    _HeadAndTailFlag = NO;
    _CurrentView = VIEW1;
    [_CellHeightArray removeAllObjects];
    [_TableView1 setScrollsToTop:YES];
    _TableView1.contentOffset = CGPointMake(0, 0 - _TableView1.contentInset.top);

    [self GetNowReadingData];
    [_TableView1 setFrame:UI_READING_TABLEVIEW_INIT_IPAD];
    [_TableView1 reloadData];
    [self.view addSubview:_TableView1];
    _Font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_PoetrySetting.SettingFontSize + 15];
    _BoldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:_PoetrySetting.SettingFontSize + 15 + UI_BOLD_FONT_BIAS];
    _PoetryNameFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
    
    [self InitCoverViewItems];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_TableView1 removeFromSuperview];
    [_TableView2 removeFromSuperview];
    [_PoetryDatabase PoetryCoreDataSaveIntoNowReading:_PoetryNowReading];
    
}

-(void) InsertPoetryNameIntoReadingArray : (NSMutableArray *) PoetryReadingTableArray withPoetryName : (NSString *) PoetryName
{
    [PoetryReadingTableArray replaceObjectAtIndex:READING_POETRY_NAME_INDEX withObject:PoetryName];
}


-(void) GetNowReadingData
{
    if (_PoetryDatabase.isReadingExist) {
        
        _PoetryNowReading = [_PoetryDatabase Poetry_CoreDataFetchDataInReading];
        POETRY_CATEGORY Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
        _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
        _CurrentIndex = [[_PoetryNowReading valueForKey:POETRY_CORE_DATA_INDEX_KEY] integerValue] - 1; //Since the index in core data starts at 1
        
    } else {
        
        NSLog(@"NO READING POETRY, GET THE 1st POETRY in GUARD READING");
        _PoetryNowReading = (NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS] objectAtIndex:0];
        
        POETRY_CATEGORY Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
        _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
        _CurrentIndex = 0;
        
    }
    
    //self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
    
    _ReadingTableArray1 = [NSMutableArray arrayWithArray:
                           [[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY] componentsSeparatedByString:@"\n"]];
    [self InsertPoetryNameIntoReadingArray : _ReadingTableArray1 withPoetryName:[_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY]];
    
}

#pragma mark - Table view data source
/*
//
// Calculating line number for each cell in table view
// accroding to the threshold for every kind of font size
//
- (NSInteger) CalculateLineNumberWithContentString : (NSString *) ContentStr
{
    NSInteger   LineNumber = 1;
    NSString    *Keyword = @"@@";
    UInt16      TextLength;
    BOOL        isAttrCell = NO;
    
    TextLength = [ContentStr length];
    
    if ([ContentStr hasPrefix:Keyword]) {
        ContentStr = [ContentStr stringByReplacingOccurrencesOfString:@"@@" withString:@""];
        TextLength = TextLength - [Keyword length];
        isAttrCell = YES;
    }
    
    if (isAttrCell) {
        
        switch (_PoetrySetting.SettingFontSize) {
            case POETRY_SETIING_FONT_SIZE_SMALL:
                if (( TextLength >= UI_BOLD_SMALL_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    LineNumber = ((TextLength / UI_BOLD_SMALL_FONT_SIZE_THRESHOLD) + 1);
                    
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_MEDIUM:
                if (( TextLength >= UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    LineNumber = ((TextLength / UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD) + 1);
                    
                    
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_LARGE:
                if (( TextLength >= UI_BOLD_LARGE_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    LineNumber = ((TextLength / UI_BOLD_LARGE_FONT_SIZE_THRESHOLD) + 1);
                }
                break;
                
            default:
                break;
        }
        
    } else {
        
        switch (_PoetrySetting.SettingFontSize) {
            case POETRY_SETIING_FONT_SIZE_SMALL:
                if (( TextLength >= UI_SMALL_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    LineNumber = ((TextLength / UI_SMALL_FONT_SIZE_THRESHOLD) + 1);
                    
                    
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_MEDIUM:
                if (( TextLength >= UI_MEDIUM_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    LineNumber = ((TextLength / UI_MEDIUM_FONT_SIZE_THRESHOLD) + 1);
                    
                    
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_LARGE:
                if (( TextLength >= UI_LARGE_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    LineNumber = ((TextLength / UI_LARGE_FONT_SIZE_THRESHOLD) + 1);
                    
                }
                break;
                
            default:
                break;
        }
        
    }
    return LineNumber;
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return [_ReadingTableArray1 count];
    } else if (tableView.tag == 2) {
        return [_ReadingTableArray2 count];
    } else if (tableView.tag == TAG_CATEGORY_TABLE_VIEW) {
        
        if (_isSearching) {
            return [[_SearchResultDisplayArray objectAtIndex:section] count];
        } else {
            NSLog(@"[_TableData count] = %d", [_TableData count]);
            return [_TableData count];
        }
    } else if (tableView.tag == TAG_TOC_TABLE_VIEW) {
        return [_TocTableData count];
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == TAG_CATEGORY_TABLE_VIEW) {
        
        if (_isSearching) {
            // Search table
            return 4;
        }
        return 1;
        
    } else if (tableView.tag == TAG_SETTING_TABLE_VIEW) {
        
        // Setting table
        return 4;
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSString    *ContentStr;
    NSString    *PoetryNameStr;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"tag = %d", tableView.tag);
    if (tableView.tag == 1) {
        
        
        PoetryNameStr = [_ReadingTableArray1 objectAtIndex:READING_POETRY_NAME_INDEX];
        ContentStr = [_ReadingTableArray1 objectAtIndex:indexPath.row];
        
        if ([ContentStr isEqualToString:PoetryNameStr]) {
            
            NSLog(@"PoetryNameStr = %@", [_ReadingTableArray1 objectAtIndex:1]);
            cell.textLabel.font = _PoetryNameFont;
            ContentStr = @"";
            
        } else {
            
            if ([ContentStr hasPrefix:@"@@"]) {
                
                ContentStr = [ContentStr stringByReplacingOccurrencesOfString:@"@@" withString:@""];
                cell.textLabel.font = _BoldFont;
                
            } else {
                
                cell.textLabel.font = _Font;
                
            }

        }
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = ContentStr;
        cell.textLabel.textColor = _FontThemeColor;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    } else if (tableView.tag == 2) {
        
        PoetryNameStr = [_ReadingTableArray2 objectAtIndex:READING_POETRY_NAME_INDEX];
        ContentStr = [_ReadingTableArray2 objectAtIndex:indexPath.row];
        
        if ([ContentStr isEqualToString:PoetryNameStr]) {
            
            NSLog(@"PoetryNameStr = %@", [_ReadingTableArray2 objectAtIndex:1]);
            cell.textLabel.font = _PoetryNameFont;
            ContentStr = @"";
            
        } else {
            
            if ([ContentStr hasPrefix:@"@@"]) {
                
                ContentStr = [ContentStr stringByReplacingOccurrencesOfString:@"@@" withString:@""];
                cell.textLabel.font = _BoldFont;
                
            } else {
                
                cell.textLabel.font = _Font;
                
            }
            
        }
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = ContentStr;
        cell.textLabel.textColor = _FontThemeColor;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    } else if (tableView.tag == TAG_CATEGORY_TABLE_VIEW) {
        
        NSLog(@"!! %@", [_TableData objectAtIndex:indexPath.row]);
        cell.textLabel.text = [_TableData objectAtIndex:indexPath.row];
        
    } else if (tableView.tag == TAG_TOC_TABLE_VIEW) {

        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.text = [[_TocTableData objectAtIndex:indexPath.row] valueForKey:POETRY_CORE_DATA_NAME_KEY];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat     Height = 60;

    if ((tableView.tag == TAG_CATEGORY_TABLE_VIEW) ||
        (tableView.tag == TAG_TOC_TABLE_VIEW)) {
        Height = UI_IPAD_COVER_TABLE_CELL_HEIGHT;
    }
    
    return Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    CGFloat     Height = 120;
    
    if ((tableView.tag == TAG_CATEGORY_TABLE_VIEW) ||
        (tableView.tag == TAG_TOC_TABLE_VIEW) ||
        (tableView.tag == TAG_SETTING_TABLE_VIEW)) {
        Height = 0;
    }

    return Height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view;
    
    if ((tableView.tag == 1) || (tableView.tag == 2)) {
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 120)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, tableView.frame.size.width - 20, 80)];
        [label setFont:_PoetryNameFont];
        label.textAlignment = NSTextAlignmentCenter;
        
        NSString *string;
        
        if (tableView.tag == 1) {
            string = [_ReadingTableArray1 objectAtIndex:READING_POETRY_NAME_INDEX];
        } else {
            string =  [_ReadingTableArray2 objectAtIndex:READING_POETRY_NAME_INDEX];
        }
        
        [label setText:string];
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
        //[view setBackgroundColor:_LightBackgroundColor];
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


-(void) GenerateNewReadingViewFollowSelectedBy:(NSDictionary *) NewReadingData andSaveIntoHistory : (BOOL) SaveIntoHistory
{
    
    // Update reading array
    _PoetryNowReading = NewReadingData;
    
    // Save into Coredata
    if (SaveIntoHistory) {
        [_PoetryDatabase PoetryCoreDataSaveIntoHistory:_PoetryNowReading];
    }
    [_PoetryDatabase PoetryCoreDataSaveIntoNowReading:_PoetryNowReading];
    
    POETRY_CATEGORY Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
    _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
    _CurrentIndex = [[_PoetryNowReading valueForKey:POETRY_CORE_DATA_INDEX_KEY] integerValue] - 1; //Since the index in core data starts at 1
    
    // To get idle view
    if (_CurrentView == VIEW1) {
        
        //_ReadingView2 = [self DisplayHandlingWithData:NewReadingData onView:_ReadingView2 ViewExist:NO];
        
    } else {
        
        //_ReadingView1 = [self DisplayHandlingWithData:NewReadingData onView:_ReadingView1 ViewExist:NO];
        
    }
    
}


// TODO: Handle selected on the table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TAG_CATEGORY_TABLE_VIEW) {
        if (_isSearching) {
            // For Searching
            if ([_SearchBar.text length] != 0) {
                if (indexPath.section == 0) {
                    // HISTORY, Ignore
                } else if (indexPath.section == 1) {
                    
                    // Guard reading
                    _CoverViewState = COVER_IDLE;
                    [self CoverViewStateMachine];
                    //[self GenerateNewReadingViewFollowSelectedBy:[_SearchGuidedReading objectAtIndex:indexPath.row] andSaveIntoHistory:YES];
                    
                    
                } else if (indexPath.section == 2) {
                    
                    // Poetry
                    _CoverViewState = COVER_IDLE;
                    [self CoverViewStateMachine];
                    //[self GenerateNewReadingViewFollowSelectedBy:[_SearchPoetryData objectAtIndex:indexPath.row] andSaveIntoHistory:YES];
                    
                } else if (indexPath.section == 3) {
                    
                    // responsive
                    _CoverViewState = COVER_IDLE;
                    [self CoverViewStateMachine];
                    //[self GenerateNewReadingViewFollowSelectedBy:[_SearchRespose objectAtIndex:indexPath.row] andSaveIntoHistory:YES];
                    
                }
            }
            
        } else {
            
            switch (indexPath.row) {
                    
                case 0:
                    
                    [_TocTableData removeAllObjects];
                    _TocTableData = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:GUARD_READING];
                    [_TocTableView reloadData];
                    [_TocTableView setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_GUARDREADING];
                    _NavigationHeader.TitleLab.text = @"導讀";
                    _TocTableView.scrollEnabled = NO;
                    [self ExecuteTocTableViewAnimation];
                    
                    break;
                    
                case 1:
                    
                    [_TocTableData removeAllObjects];
                    _TocTableData = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS];
                    [_TocTableView reloadData];
                    [_TocTableView setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_POETRY];
                    _NavigationHeader.TitleLab.text = @"聖詩";
                    _TocTableView.scrollEnabled = YES;
                    [self ExecuteTocTableViewAnimation];
                    
                    break;
                    
                case 2:
                    
                    [_TocTableData removeAllObjects];
                    _TocTableData = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:RESPONSIVE_PRAYER];
                    [_TocTableView reloadData];
                    [_TocTableView setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_RESPONSIVE];
                    _NavigationHeader.TitleLab.text = @"啟應文";
                    _TocTableView.scrollEnabled = YES;
                    [self ExecuteTocTableViewAnimation];
                    
                    break;
                    
                case 3:
                    
                    [_TocTableData removeAllObjects];
                    _TocTableData = [_PoetryDatabase Poetry_CoreDataFetchDataInHistory];
                    UInt16 TableHeight = [_TocTableData count] * UI_IPAD_COVER_TABLE_CELL_HEIGHT;
                    [_TocTableView reloadData];
                    
                    if (TableHeight == 0) {
                        
                        [_TocTableView setFrame:CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, TableHeight)];
                        _NavigationHeader.TitleLab.text = @"還沒有";
                        
                    } else {
                        
                        [_TocTableView setFrame:CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, TableHeight)];
                        _NavigationHeader.TitleLab.text = @"閱讀歷史";
                        _TocTableView.scrollEnabled = YES;
                        
                    }
                    
                    [self ExecuteTocTableViewAnimation];
                    
                    break;
                    
                default:
                    break;
            }
        }
    } else if (tableView.tag == TAG_TOC_TABLE_VIEW) {
        
        _CoverViewState = COVER_IDLE;
        [self CoverViewStateMachine];
        if ([_NavigationHeader.TitleLab.text isEqualToString:@"閱讀歷史"]) {
            
            //[self GenerateNewReadingViewFollowSelectedBy:[_TocTableData objectAtIndex:indexPath.row] andSaveIntoHistory:NO];
            
        } else {
            
            //[self GenerateNewReadingViewFollowSelectedBy:[_TocTableData objectAtIndex:indexPath.row] andSaveIntoHistory:YES];
            
        }
        
        
    }
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"titleForHeaderInSection");
    if (tableView.tag == 1) {
        return [_ReadingTableArray1 objectAtIndex:READING_POETRY_NAME_INDEX];
    } else {
        return [_ReadingTableArray2 objectAtIndex:READING_POETRY_NAME_INDEX];
    }
}
*/

#pragma mark - Search Handling Methods

// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing  set _isSearching YES");
    
    if (_isTocTableOn) {    //[CASPER] 2013.12.27
        [self RemoveTocTableViewAnimation];
    }
    // TODO: Setup Table frame
    if (_isSearching == NO) {
        _isSearching = YES;     //[CASPER] 2013.12.24
        
        [_NavigationHeader.TitleLab setText:@"搜尋"];
        [Animations moveRight:_NavigationHeader andAnimationDuration:0.3 andWait:NO andLength:UI_IPAD_TOC_TABLEVIEW_WIDTH];
        CGFloat TableHeight = (3 * UI_IPAD_COVER_TABLE_CELL_HEADER_HEIGHT);
        _CategoryTableView.frame = CGRectMake(_CategoryTableView.frame.origin.x,
                                      _CategoryTableView.frame.origin.y,
                                      _CategoryTableView.frame.size.width,
                                      TableHeight);
        
        [_CategoryTableView reloadData];
        
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText];
}

- (void)filterContentForSearchText:(NSString*)searchText {
    
    _SearchHistoryData = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryNameInHistory:searchText]];
    
    _SearchGuidedReading = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryName:searchText InCategory:GUARD_READING]];
    
    _SearchPoetryData = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryName:searchText InCategory:POETRYS]];
    
    _SearchRespose = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryName:searchText InCategory:RESPONSIVE_PRAYER]];
    
    
    
    if ([searchText length] > 3 ) {
        
        [_SearchGuidedReading addObjectsFromArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryContent:searchText InCategory:GUARD_READING]];
        [_SearchPoetryData addObjectsFromArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryContent:searchText InCategory:POETRYS]];
        [_SearchRespose addObjectsFromArray:[_PoetryDatabase Poetry_CoreDataSearchWithPoetryContent:searchText InCategory:POETRYS]];
        
    }
    
    
    _SearchResultDisplayArray = [NSArray arrayWithObjects:
                                 _SearchHistoryData,
                                 _SearchGuidedReading,
                                 _SearchPoetryData,
                                 _SearchRespose,
                                 nil];
    
    // Calculate height of table view
    CGFloat TableHeight = ((UI_IPAD_COVER_TABLE_CELL_HEIGHT * [_SearchGuidedReading count]) +
                           (UI_IPAD_COVER_TABLE_CELL_HEIGHT * [_SearchPoetryData count]) +
                           (UI_IPAD_COVER_TABLE_CELL_HEIGHT * [_SearchRespose count]) +
                           3 * UI_IPAD_COVER_TABLE_CELL_HEADER_HEIGHT);
    
    if (TableHeight > UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_MAX) {
        
        TableHeight = UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_MAX;
        _CategoryTableView.scrollEnabled = YES;
        
    } else {
        
        _CategoryTableView.scrollEnabled = NO;
        
    }
    
    _CategoryTableView.frame = CGRectMake(_CategoryTableView.frame.origin.x,
                                  _CategoryTableView.frame.origin.y,
                                  _CategoryTableView.frame.size.width,
                                  TableHeight);
    
    [_CategoryTableView reloadData];
    
}


#pragma mark - Gesture recognizer



-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (_CoverViewState > COVER_IDLE) {
        
        //if ([_SearchBar.text length] != 0) {
        
        if (_SearchBar.resignFirstResponder) {
            
            [self.view endEditing:YES];
            
        } else {
            
            _CoverViewState = COVER_IDLE;
            [self CoverViewStateMachine];
            
        }
        /*
         } else {
         
         _CoverViewState = COVER_IDLE;
         [self CoverViewStateMachine];
         
         }
         */
    }
}




-(void) SwitchCurrentView
{
    if (_CurrentView == VIEW1) {
        _CurrentView = VIEW2;
    } else {
        _CurrentView = VIEW1;
    }
}

-(void) UpdateNewTableViewContentWithNewPoetry : (NSDictionary*) NewPoetry
{
    NSString *ContentStr;
    
    if (NewPoetry != nil) {
        ContentStr = [NewPoetry valueForKey:POETRY_CORE_DATA_CONTENT_KEY];
    } else {
        
    }
    
    
    if (_CurrentView == VIEW1) {
        
        [_ReadingTableArray2 removeAllObjects];
        _ReadingTableArray2 = [NSMutableArray arrayWithArray:
                               [ContentStr componentsSeparatedByString:@"\n"]];

        // [CASPER] Add for iPad
        [self InsertPoetryNameIntoReadingArray : _ReadingTableArray2 withPoetryName:[NewPoetry valueForKey:POETRY_CORE_DATA_NAME_KEY]];

        [_TableView2 reloadData];
        
    } else {
        
        [_ReadingTableArray1 removeAllObjects];
        _ReadingTableArray1 = [NSMutableArray arrayWithArray:
                               [ContentStr componentsSeparatedByString:@"\n"]];
        
        // [CASPER] Add for iPad
        [self InsertPoetryNameIntoReadingArray : _ReadingTableArray1 withPoetryName:[NewPoetry valueForKey:POETRY_CORE_DATA_NAME_KEY]];

        [_TableView1 reloadData];
    }
    
}

-(void) GetNewPoetryByGestureDirection
{
    
    if (_SlideDirection == SlideLabelLeftToRigth) {
        // PREV
        NSLog(@"GetNewPoetryByGestureDirection - PREV");
        
        if (_CurrentIndex == 0) {
            
            // This is the first poetry in this category
            // Check the Category
            NSNumber *CategoryNum = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY];
            [_TempPoetryList removeAllObjects];
            
            if (GUARD_READING != (POETRY_CATEGORY)[CategoryNum integerValue]) {
                
                // To get the previous category list as temp.
                if (POETRYS == (POETRY_CATEGORY)[CategoryNum integerValue]) {
                    
                    NSLog(@"Get Guard Reading list");
                    _TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:GUARD_READING];
                    
                } else if (RESPONSIVE_PRAYER == (POETRY_CATEGORY)[CategoryNum integerValue]) {
                    
                    NSLog(@"Get Poetry list");
                    _TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS];
                    
                } else {
                    
                    NSLog(@"Reading view has some error, plz check");
                    
                }
                
                if (_TempPoetryList != nil) {
                    
                    _CrossCategoryFlag = YES;
                    _NewPoetryDic = [_TempPoetryList lastObject];
                    NSLog(@"Get Poetry at cross category");
                }
                
            } else {
                
                
                // Generate empty view to notify user
                NSLog(@"NO DATA");
                _HeadAndTailFlag = YES;
                _NewPoetryDic = nil;
                
            }
            
        } else {
            
            // To get the previous poetry of this category
            _NewPoetryDic = [_NowReadingCategoryArray objectAtIndex:(_CurrentIndex - 1)];
            NSLog(@"_NewDataDic index = %d", _CurrentIndex - 1);
            
        }
    } else {
        
        // NEXT
        NSLog(@"GetNewPoetryByGestureDirection - NEXT");
        
        if (_CurrentIndex == ([_NowReadingCategoryArray count] - 1)) {
            
            [_TempPoetryList removeAllObjects];
            
            // Check the Category
            NSNumber *CategoryNum = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY];
            if (RESPONSIVE_PRAYER != (POETRY_CATEGORY)[CategoryNum integerValue]) {
                // To get the previous category list as temp.
                
                if (GUARD_READING == (POETRY_CATEGORY)[CategoryNum integerValue]) {
                    
                    NSLog(@"Get Petry Reading list");
                    _TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS];
                    
                } else if (POETRYS == (POETRY_CATEGORY)[CategoryNum integerValue]) {
                    
                    NSLog(@"Get Responsive list");
                    _TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:RESPONSIVE_PRAYER];
                    
                } else {
                    
                    NSLog(@"Reading view has some error, plz check");
                }
                
                if (_TempPoetryList != nil) {
                    
                    _CrossCategoryFlag = YES;
                    _NewPoetryDic = [_TempPoetryList firstObject];
                    NSLog(@"Get Poetry at cross category");
                    
                }
                
                
            } else {
                
                // Generate empty view to notify user
                NSLog(@"NO DATA");
                _HeadAndTailFlag = YES;
                _NewPoetryDic = nil;
            }
            
        } else {
            
            _NewPoetryDic = [_NowReadingCategoryArray objectAtIndex:(_CurrentIndex + 1)];
            NSLog(@"_NewDataDic index = %d", _CurrentIndex + 1);
        }
        
    }
    
    if (!_HeadAndTailFlag) {
        [self UpdateNewTableViewContentWithNewPoetry:_NewPoetryDic];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ((touch.view.tag == 1) || (touch.view.tag == 2)) {
        
        return YES;
    } else if (touch.view.tag == TAG_NAVI_BTN) {
        
        return NO;
    }
    

    return YES;
}


- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
    if (_isNavTableOn) {
        return;
    }

    
    if (_CurrentView == VIEW1) {
        //NSLog(@"Current = Table 1 / TheOther = Tabel 2");
        [self HandleGestureByUsing:recognizer OnCurrentView:_TableView1 andTheOtherView:_TableView2];
        
    } else {
        //NSLog(@"Current = Table 2 / TheOther = Tabel 1");
        [self HandleGestureByUsing:recognizer OnCurrentView:_TableView2 andTheOtherView:_TableView1];
        
    }
    
}

-(void) HandleGestureByUsing : (UIPanGestureRecognizer *)recognizer
               OnCurrentView : (UITableView*) CurrentView
             andTheOtherView : (UITableView*) TheOtherView
{
    CGPoint location = [recognizer locationInView:self.view];
    
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateBegan:
            _TouchInit = location;
            _ViewMovementState = DirectionJudgement;
            break;
            
        case UIGestureRecognizerStateChanged:
            [self HandleGestureChangeStateWith:location OnCurrentView:CurrentView andTheOtherView:TheOtherView];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self HandleGestureEndStateWith:location OnCurrentView:CurrentView andTheOtherView:TheOtherView];
            break;
            
        default:
            break;
    }
    
}

-(void) HandleGestureChangeStateWith : (CGPoint) location
                       OnCurrentView : (UITableView*) CurrentView
                     andTheOtherView : (UITableView*) TheOtherView
{
    
    CGRect DefaultFrame;
    CGRect NextPoetryFrame;
    
    DefaultFrame = UI_READING_TABLEVIEW_INIT_IPAD;
    NextPoetryFrame = UI_READING_TABLEVIEW_NEXT_IPAD;
    
    switch (_ViewMovementState) {
            
        case DirectionJudgement:
            
            if ((location.x - _TouchInit.x) > 0) {
                
                // PREV
                [TheOtherView setFrame:DefaultFrame];
                [TheOtherView setScrollsToTop:YES];
                TheOtherView.contentOffset = CGPointMake(0, 0 - TheOtherView.contentInset.top);

                _SlideDirection = SlideLabelLeftToRigth;
                
                [self GetNewPoetryByGestureDirection];
                
                if (_HeadAndTailFlag) {
                    
                    [_HeadAndTailLab setHidden:NO];
                    [_HeadAndTailLab setText:@"MOST PREV"];
                    [_HeadAndTailLab setFrame:DefaultFrame];
                    [self.view insertSubview:_HeadAndTailLab belowSubview:CurrentView];
                    
                } else {
                    
                    [self.view insertSubview:TheOtherView belowSubview:CurrentView];
                }
                
                
            } else {
                
                // NEXT
                [CurrentView setFrame:DefaultFrame];
                _SlideDirection = SlideLabelRightToLegt;
                
                [self GetNewPoetryByGestureDirection];
                
                if (_HeadAndTailFlag) {
                    
                    [_HeadAndTailLab setHidden:NO];
                    [_HeadAndTailLab setText:@"LATEST"];
                    [_HeadAndTailLab setFrame:NextPoetryFrame];
                    [self.view insertSubview:_HeadAndTailLab aboveSubview:CurrentView];
                    
                } else {
                    
                    [TheOtherView setFrame:NextPoetryFrame];
                    [TheOtherView setScrollsToTop:YES];
                    TheOtherView.contentOffset = CGPointMake(0, 0 - TheOtherView.contentInset.top);

                    [self.view insertSubview:TheOtherView aboveSubview:CurrentView];
                    
                }
                
            }
            
            _ViewMovementState = ViewMoving;
            
            break;
            
        case ViewMoving:
            
            if ((location.x - _TouchInit.x) > 0) {
                
                // PREV
                if ( _SlideDirection != SlideLabelLeftToRigth ) {
                    
                    _HeadAndTailFlag = NO;
                    _ViewMovementState = DirectionJudgement;
                    
                }
                
                [CurrentView setFrame:CGRectMake(abs(location.x - _TouchInit.x),
                                                 DefaultFrame.origin.y,
                                                 CGRectGetWidth(DefaultFrame),
                                                 CGRectGetHeight(DefaultFrame))];
                
            } else {
                
                // NEXT
                if ( _SlideDirection != SlideLabelRightToLegt ) {
                    
                    _HeadAndTailFlag = NO;
                    _ViewMovementState = DirectionJudgement;
                    
                }
                
                if (_HeadAndTailFlag) {
                    
                    [_HeadAndTailLab setFrame:CGRectMake(NextPoetryFrame.origin.x - abs(location.x - _TouchInit.x),
                                                         NextPoetryFrame.origin.y,
                                                         CGRectGetWidth(NextPoetryFrame),
                                                         CGRectGetHeight(NextPoetryFrame))];
                    
                } else {
                    
                    [TheOtherView setFrame:CGRectMake(NextPoetryFrame.origin.x - abs(location.x - _TouchInit.x),
                                                      NextPoetryFrame.origin.y,
                                                      CGRectGetWidth(NextPoetryFrame),
                                                      CGRectGetHeight(NextPoetryFrame))];
                    
                }
                
            }
            
            
        default:
            break;
    }
    
}


-(void) HandleGestureEndStateWith : (CGPoint) location
                    OnCurrentView : (UITableView*) CurrentView
                  andTheOtherView : (UITableView*) TheOtherView
{
    CGRect DefaultFrame;
    CGRect NextPoetryFrame;
    
    DefaultFrame = UI_READING_TABLEVIEW_INIT_IPAD;
    NextPoetryFrame = UI_READING_TABLEVIEW_NEXT_IPAD;
    
    if (_HeadAndTailFlag) {
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             
                             if (_SlideDirection == SlideLabelLeftToRigth) {
                                 
                                 // PREV
                                 [CurrentView setFrame:DefaultFrame];
                                 
                             } else {
                                 
                                 // NEXT
                                 [_HeadAndTailLab setFrame:NextPoetryFrame];
                             }
                             
                         }
                         completion:^(BOOL finished) {
                             
                             _HeadAndTailFlag = NO;
                             [_HeadAndTailLab setHidden:YES];
                             
                         }];
        
    } else {
        
        if (abs(location.x - _TouchInit.x) > SWITCH_VIEW_THRESHOLD) {
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 
                                 if (_SlideDirection == SlideLabelLeftToRigth) {
                                     
                                     // PREV
                                     [CurrentView setFrame:NextPoetryFrame];
                                     
                                 } else {
                                     
                                     // NEXT
                                     [TheOtherView setFrame:DefaultFrame];
                                 }
                                 
                             }
                             completion:^(BOOL finished) {
                                 
                                 if (_CrossCategoryFlag) {
                                     
                                     _NowReadingCategoryArray = [NSMutableArray arrayWithArray:_TempPoetryList];
                                     _CrossCategoryFlag = NO;
                                     
                                     if (_SlideDirection == SlideLabelLeftToRigth) {
                                         
                                         _CurrentIndex = [_NowReadingCategoryArray count] - 1;
                                         
                                     } else {
                                         
                                         _CurrentIndex = 0;
                                         
                                     }
                                     
                                 } else {
                                     
                                     if (_SlideDirection == SlideLabelLeftToRigth) {
                                         
                                         // PREV
                                         _CurrentIndex--;
                                         [CurrentView removeFromSuperview];
                                         
                                     } else {
                                         
                                         // NEXT
                                         _CurrentIndex++;
                                         [CurrentView removeFromSuperview];
                                         
                                     }
                                     
                                 }
                                 
                                 
                                 NSLog(@"_CurrentIndex = %d", _CurrentIndex);
                                 _PoetryNowReading = _NewPoetryDic;
                                 self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
                                 _NavigationTitleLab.text = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
                                 [self SwitchCurrentView];
                                 
                             }];
        } else {
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 
                                 if (_SlideDirection == SlideLabelLeftToRigth) {
                                     
                                     // PREV
                                     [CurrentView setFrame:DefaultFrame];
                                     
                                 } else {
                                     
                                     // NEXT
                                     [TheOtherView setFrame:NextPoetryFrame];
                                 }
                                 
                             }
                             completion:^(BOOL finished) {
                                 
                                 [TheOtherView removeFromSuperview];
                                 
                             }];
        }
    }
    
    
    _ViewMovementState = None;
    
}

#pragma mark - Menu Cover

/*
-(void)ReloadReadingView
{
    
    _font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_PoetrySetting.SettingFontSize];
    _DisplayTheme = _PoetrySetting.SettingTheme;
    if (_CurrentView == VIEW1) {
        
        [self DisplayHandlingWithData:_PoetryNowReading onView:_ReadingView1 ViewExist:YES];
        
    } else {
        
        [self DisplayHandlingWithData:_PoetryNowReading onView:_ReadingView2 ViewExist:YES];
    }
}
*/

-(void) setNaviBtnImage
{
    if (_PoetrySetting.SettingTheme == THEME_LIGHT_DARK) {
        
        [_NaviBtn setBackgroundImage:_NaviBtnImgDarkNormal forState:UIControlStateNormal];
        //[_NaviBtn setBackgroundImage:_NaviBtnImgDarkPressed forState:UIControlStateHighlighted];
        
    } else {
        
        [_NaviBtn setBackgroundImage:_NaviBtnImgWhiteNormal forState:UIControlStateNormal];
        //[_NaviBtn setBackgroundImage:_NaviBtnImgWhitePressed forState:UIControlStateHighlighted];
        
    }
}

-(void) InitCoverViewItems
{
    
    if (_NaviBtn == nil) {
        _NaviBtn = [[UIButton alloc] initWithFrame:UI_IPAD_NAVI_BTN_RECT_INIT];
    }
    //[_NaviBtn setTitle:@"GOTO" forState:UIControlStateNormal];
    [_CoverView setTag:TAG_NAVI_BTN];
    
    [self setNaviBtnImage];
    
    //_NaviBtn.backgroundColor = [UIColor colorWithRed:(160/255.0f) green:(185/255.0f) blue:(211/255.0f) alpha:0.5];
    _NaviBtn.opaque = YES;
    [_NaviBtn addTarget:self action:@selector(NavigationBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_NaviBtn];
    
    
    if (_SettingBtn == nil) {
        _SettingBtn = [[UIButton alloc] initWithFrame:UI_IPAD_COVER_SETTING_BTN_RECT_INIT];
    }
    
    //[_SettingBtn setTitle:@"SETTING" forState:UIControlStateNormal];
    //_SettingBtn.backgroundColor = [UIColor grayColor];
    
    [_SettingBtn setImage:_SettingBtnImg forState:UIControlStateNormal];
    [_SettingBtn addTarget:self action:@selector(SettingBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (_CoverView == nil) {
        
        _CoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_IPAD_SCREEN_WIDTH, UI_IPAD_SCREEN_HEIGHT)];
        _CoverView.backgroundColor = [UIColor colorWithRed:(40/255.0f) green:(42/255.0f) blue:(54/255.0f) alpha:0.7 ];
        
    }
    [_CoverView setTag:TAG_COVER_VIEW];
    
    if (_SearchBar == nil) {
        _SearchBar = [[UISearchBar alloc] initWithFrame:UI_IPAD_COVER_SEARCH_BAR_RECT_INIT];
        _SearchBar.delegate = self;
    }
    
    if (_CategoryTableView == nil) {
        _CategoryTableView = [[UITableView alloc] initWithFrame:UI_IPAD_COVER_TABLEVIEW_RECT_INIT];
    }
    _TableData = [NSMutableArray arrayWithObjects:@"導讀", @"聖詩", @"啟應文", @"閱讀歷史", nil];
    _CategoryTableView.delegate = self;
    _CategoryTableView.dataSource = self;
    _CategoryTableView.scrollEnabled = NO;
    [_CategoryTableView setTag:TAG_CATEGORY_TABLE_VIEW];
    NSLog(@"%@ \n %@", _CategoryTableView , _TableData);
    [_CategoryTableView reloadData];
    
    _TocTableView = [[UITableView alloc] initWithFrame:UI_IPAD_COVER_TABLEVIEW_RECT_INIT];
    _TocTableView.delegate = self;
    _TocTableView.dataSource = self;
    _TocTableView.scrollEnabled = YES;
    [_TocTableView setTag:TAG_TOC_TABLE_VIEW];
    
    [self InitNavigationHeader];
    
    if (_SettingTableView == nil) {
        _SettingTableView = [[UITableView alloc] initWithFrame:UI_IPAD_COVER_SETTING_TABLE_RECT_INIT style:UITableViewStyleGrouped];
    }
    _SettingTableView.delegate = self;
    _SettingTableView.dataSource = self;
    [_SettingTableView setTag:TAG_SETTING_TABLE_VIEW];
    
    _CoverViewState = COVER_IDLE;
    
}


-(void) PlaceCoverView
{
    
    [self.view insertSubview:_CoverView belowSubview:_NaviBtn];
    
    // And init all item on the init location
    [_CoverView addSubview:_CategoryTableView];
    [_CoverView insertSubview:_TocTableView belowSubview:_CategoryTableView];
    [_CoverView insertSubview:_NavigationHeader aboveSubview:_CategoryTableView];
    [_CoverView addSubview:_SettingBtn];
    [_CoverView addSubview:_SettingTableView];
    [_CoverView addSubview:_SearchBar];
    
    NSString *ShadowType = @"Customized";
    [Animations frameAndShadow:_CategoryTableView];
    [Animations frameAndShadow:_TocTableView];
    
    
    //[Animations shadowOnView:_TableView andShadowType:ShadowType];
    //[Animations shadowOnView:_TocTableView andShadowType:ShadowType];
    [Animations shadowOnView:_SettingBtn andShadowType:ShadowType];
    [Animations shadowOnView:_SettingTableView andShadowType:ShadowType];
    [Animations shadowOnView:_SearchBar andShadowType:ShadowType];
    //    [Animations shadowOnView:_NavigationHeader andShadowType:ShadowType];
    [Animations frameAndShadow:_NavigationHeader];
    
    _SearchBar.text = @"";
    
}



-(void)RemoveCoverViewAnimation
{
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         [_CategoryTableView setFrame:UI_IPAD_COVER_TABLEVIEW_RECT_INIT];
                         [_SettingBtn setFrame:UI_IPAD_COVER_SETTING_BTN_RECT_INIT];
                         [_SettingTableView setFrame:UI_IPAD_COVER_SETTING_TABLE_RECT_INIT];
                         [_SearchBar setFrame:UI_IPAD_COVER_SEARCH_BAR_RECT_INIT];
                         [_TocTableView setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT];
                         [_NavigationHeader setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_HEADER];
                         [_NaviBtn setFrame:UI_IPAD_NAVI_BTN_RECT_INIT];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [_CoverView removeFromSuperview];
                         [_CategoryTableView removeFromSuperview];
                         [_SettingTableView removeFromSuperview];
                         [_SearchBar removeFromSuperview];
                         [_TocTableView removeFromSuperview];
                         [_NavigationHeader removeFromSuperview];
                         _SearchBar.text = @"";
                         _SearchResultDisplayArray = nil;
                         
                         //TODO: Force Update Reading View followed Setting
                         //[self ReloadReadingView];
                     }];
    
}

// All element on cover view should use this SM to control
-(void) CoverViewStateMachine
{
    switch (_CoverViewState) {
        case COVER_IDLE:
            _isNavTableOn = NO;
            _isSearchBarOn = NO;
            _isSettingTableOn = NO;
            _isSearching = NO;  //[CASPER] 2013.12.24
            _isTocTableOn = NO; //[CASPER] 2013.12.27
            //[_SettingBtn setTitle:@"SETTING" forState:UIControlStateNormal];
            [_SettingBtn setImage:_SettingBtnImg forState:UIControlStateNormal];
            [self RemoveCoverViewAnimation];
            break;
            
        case COVER_INIT:
            _isNavTableOn = YES;
            _isSearchBarOn = YES;
            _isSettingTableOn = NO;
            _isSearching = NO; //[CASPER] 2013.12.24
            
            
            [self PlaceCoverView];
            [self ExecuteTableViewAnnimation];
            break;
            
        case COVER_SEARCH:
            _isNavTableOn = YES;
            _isSearchBarOn = YES;
            _isSettingTableOn = NO;
            //_SettingBtn.titleLabel.text = @"SETTING";
            //[_SettingBtn setTitle:@"SETTING" forState:UIControlStateNormal];
            [_SettingBtn setImage:_SettingBtnImg forState:UIControlStateNormal];
            
            [self RemoveSettingTableViewAnnimation];
            [self ExecuteSearchBarAnnimation];
            break;
            
        case COVER_SETTING:
            
            _isNavTableOn = YES;
            _isSearchBarOn = NO;
            _isSettingTableOn = YES;
            _isSearching = NO;
            //_SettingBtn.titleLabel.text = @"SEARCH";
            //[_SettingBtn setTitle:@"SEARCH" forState:UIControlStateNormal];
            [_SettingBtn setImage:_SearchingBtnImg forState:UIControlStateNormal];
            
            [_SettingTableView reloadData];
            
            [self RemoveSearchbarAnimation];
            [self ExecuteSettingTableViewAnnimation];
            
            break;
        default:
            break;
    }
}

-(void) InitNavigationHeader
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"iPadNavTableHeader" owner:self options:nil];
    _NavigationHeader = (iPadNavTableHeader *)[subviewArray objectAtIndex:0];
    [_NavigationHeader setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_HEADER];
    [_NavigationHeader.BackBtn addTarget:self action:@selector(RemoveTocTableViewAnimation) forControlEvents:UIControlEventTouchUpInside];
}

-(void) ExecuteTableViewAnnimation
{
    
    [_CategoryTableView reloadData];
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         [_CategoryTableView setFrame:UI_IPAD_COVER_TABLEVIEW_RECT_ON_COVER];
                         [_SettingBtn setFrame:UI_IPAD_COVER_SETTING_BTN_RECT_ON_COVER];
                         [_SearchBar setFrame:UI_IPAD_COVER_SEARCH_BAR_RECT_ON_COVER];
                         [_NaviBtn setFrame:UI_IPAD_NAVI_BTN_RECT_HIDE];
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}




-(void) ExecuteSearchBarAnnimation
{
    [_SearchBar setFrame:UI_IPAD_COVER_SEARCH_BAR_RECT_INIT];
    [_CoverView addSubview:_SearchBar];
    
    [Animations moveLeft:_SearchBar andAnimationDuration:0.2 andWait:YES andLength:450.0];
    [Animations moveRight:_SearchBar andAnimationDuration:0.2 andWait:YES andLength:20.0];
    [Animations moveLeft:_SearchBar andAnimationDuration:0.05 andWait:YES andLength:20.0];
    [Animations moveRight:_SearchBar andAnimationDuration:0.05 andWait:YES andLength:12.0];
    [Animations moveLeft:_SearchBar andAnimationDuration:0.05 andWait:YES andLength:12.0];
    
}
-(void) RemoveSearchbarAnimation
{
    [Animations moveRight:_SearchBar andAnimationDuration:0.2 andWait:YES andLength:450.0];
    [_SearchBar removeFromSuperview];
}

-(void) ExecuteSettingTableViewAnnimation
{
    [_SettingTableView setFrame:UI_IPAD_COVER_SETTING_TABLE_RECT_INIT];
    [_CoverView addSubview:_SettingTableView];
    
    [Animations moveLeft:_SettingTableView andAnimationDuration:0.2 andWait:YES andLength:350.0];
    [Animations moveRight:_SettingTableView andAnimationDuration:0.2 andWait:YES andLength:20.0];
    [Animations moveLeft:_SettingTableView andAnimationDuration:0.1 andWait:YES andLength:20.0];
    [Animations moveRight:_SettingTableView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    [Animations moveLeft:_SettingTableView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    
}


-(void)RemoveSettingTableViewAnnimation
{
    [Animations moveRight:_SettingTableView andAnimationDuration:0.2 andWait:YES andLength:350.0];
    [_SettingTableView removeFromSuperview];
}



-(void) ReinitSearchBar
{
    _SearchBar.text = @"";
    [_SearchBar setFrame:UI_IPAD_COVER_SEARCH_BAR_RECT_INIT];
}


-(void)NavigationBtnHandler
{
    if (_isNavTableOn == NO) {
        
        _CoverViewState = COVER_INIT;
        [self CoverViewStateMachine];
        
    } else {
        
        _CoverViewState = COVER_IDLE;
        [self CoverViewStateMachine];
        
    }
    
}

-(void)SettingBtnHandler
{
    
    if (_isSettingTableOn == NO) {
        
        _CoverViewState = COVER_SETTING;
        [self CoverViewStateMachine];
        
    } else {
        
        _CoverViewState = COVER_SEARCH;
        [self CoverViewStateMachine];
        
    }
    
}

- (void) ExecuteTocTableViewAnimation
{
    _isTocTableOn = YES; //[CASPER] 2013.12.27
    [Animations moveRight:_NavigationHeader andAnimationDuration:0.3 andWait:NO andLength:UI_IPAD_TOC_TABLEVIEW_WIDTH + UI_IPAD_TABLEVIEW_WIDTH];
    [Animations moveRight:_TocTableView andAnimationDuration:0.3 andWait:YES andLength:UI_IPAD_TOC_TABLEVIEW_WIDTH + UI_IPAD_TABLEVIEW_WIDTH];
    
    [Animations moveLeft:_TocTableView andAnimationDuration:0.2 andWait:NO andLength:UI_IPAD_TABLEVIEW_WIDTH];
    [Animations moveLeft:_NavigationHeader andAnimationDuration:0.2 andWait:NO andLength:UI_IPAD_TABLEVIEW_WIDTH];
    [Animations moveLeft:_CategoryTableView andAnimationDuration:0.2 andWait:NO andLength:UI_IPAD_TABLEVIEW_WIDTH];
    
}


-(void) RemoveTocTableViewAnimation
{
    if (_isSearching) {
        _isSearching = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             [_NavigationHeader setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_HEADER];
                         }
                         completion:^(BOOL finished) {
                             [self.view endEditing:YES];
                             _SearchResultDisplayArray = nil;
                             [_SearchBar setText:@""];
                             [_CategoryTableView setFrame:UI_IPAD_COVER_TABLEVIEW_RECT_ON_COVER];
                             [_CategoryTableView reloadData];
                         }];
        
        
        
    } else {
        _isTocTableOn = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             [_CategoryTableView setFrame:UI_IPAD_COVER_TABLEVIEW_RECT_ON_COVER];
                             [_TocTableView setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT];
                             [_NavigationHeader setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_HEADER];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
    }
    
}

@end
