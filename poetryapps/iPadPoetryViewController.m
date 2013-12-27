//
//  iPadPoetryViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2013/12/13.
//  Copyright (c) 2013年 cc. All rights reserved.
//
//  [CASPER] 2013.12.24 Add search funciton
//  [CASPER] 2013.12.27 Add isTocTableOn flag to identify the TOC table state

#import "iPadPoetryViewController.h"

#define UI_IPAD_NAVI_BTN_RECT_INIT                  CGRectMake(30, 30, 70, 60)

#define UI_IPAD_COVER_TABLE_CELL_HEIGHT             44
#define UI_IPAD_COVER_TABLE_CELL_HEADER_HEIGHT      17

#define UI_IPAD_COVER_TABLEVIEW_HEIGHT              44 * 4
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_GUARD    44 * 5
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY   UI_IPAD_SCREEN_HEIGHT - 160
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_RESPON   UI_IPAD_SCREEN_HEIGHT - 160
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_MAX      UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY

#define UI_IPAD_TABLEVIEW_WIDTH                     280
#define UI_IPAD_TOC_TABLEVIEW_WIDTH                 300

#define UI_IPAD_READING_TITLE_RECT_LABEL            CGRectMake(0, 90, UI_IPAD_READINGVIEW_WIDTH, 100);

#define UI_IPAD_NAVI_VIEW_WIDTH                     150
#define UI_IPAD_PREV_VIEW_RECT_INIT                 CGRectMake(0, 0, UI_IPAD_NAVI_VIEW_WIDTH, UI_IPAD_SCREEN_HEIGHT)
#define UI_IPAD_NEXT_VIEW_RECT_INIT                 CGRectMake(UI_IPAD_SCREEN_WIDTH - UI_IPAD_NAVI_VIEW_WIDTH, 0, UI_IPAD_NAVI_VIEW_WIDTH, UI_IPAD_SCREEN_HEIGHT)

#define UI_IPAD_COVER_TABLEVIEW_RECT_INIT           CGRectMake(-320, 100, UI_IPAD_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)
#define UI_IPAD_COVER_TABLEVIEW_RECT_ON_COVER       CGRectMake(0, 100, UI_IPAD_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT       CGRectMake(-320, 100, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)
#define UI_IPAD_COVER_SETTING_BTN_RECT_INIT         CGRectMake(30, 768, 100, 50)
#define UI_IPAD_COVER_SETTING_BTN_RECT_ON_COVER     CGRectMake(30, 668, 100, 50)
#define UI_IPAD_COVER_SEARCH_BAR_RECT_INIT          CGRectMake(1024, 300, 300, 50)
#define UI_IPAD_COVER_SEARCH_BAR_RECT_ON_COVER      CGRectMake(674, 300, 300, 50)
#define UI_IPAD_COVER_SETTING_TABLE_RECT_INIT       CGRectMake(1024, 150, 320, 568)


#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_HEADER                 CGRectMake(-300, 100, UI_IPAD_TOC_TABLEVIEW_WIDTH, 50)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_GUARDREADING      CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_GUARD)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_POETRY            CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_RESPONSIVE        CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_RESPON)



@interface iPadPoetryViewController () {

    CGSize                  _LabelSizeInit;
    CGPoint                 _TouchInit;
    SLIDE_DIRECTION         _SlideDirection;
    
    BOOL                    _DataFlag;
    BOOL                    _GetSlideInLabel;
    BOOL                    _CrossCategoryFlag;
    
    // To indicate that the poetry is the first and the last one, and it can not be executed PREV / NEXT
    BOOL                    _HeadAndTailFlag;
    BOOL                    _ConfirmToSwitch;
    
    COVER_VIEW_STATE        _CoverViewState;
    BOOL                    _isNavTableOn;
    BOOL                    _isSettingTableOn;
    BOOL                    _isSearchBarOn;
    BOOL                    _isSearching;       //[CASPER] 2013.12.24
    BOOL                    _isTocTableOn;      //[CASPER] 2013.12.27
    BOOL                    _isHandlingTouchSwitch;     // NOT USED YET
    
    CURRENT_VIEW            _CurrentView;
    UInt16                  _CurrentIndex;
    NSMutableArray          *TempPoetryList;
    
    
}

@end

@implementation iPadPoetryViewController

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

    _Setting = [[PoetrySettingCoreData alloc] init];
    //[_Setting PoetrySetting_Create];
/*
    if  (_Setting.DataSaved == NO) {
        IPAD_READING_VIEW_LOG(@"Empty database, try to save all file in database");
        _PoetrySaved = [[PoetrySaveIntoCoreData alloc] init];
        [_PoetrySaved isCoreDataSave];
    }
 */
    _PoetryDatabase = [[PoetryCoreData alloc] init];
    _Scroller = [[UIScrollView alloc] init];
    _Scroller.frame = CGRectMake(0, 0, UI_IPAD_READINGVIEW_WIDTH, UI_IPAD_SCREEN_HEIGHT);
    [_Scroller setScrollEnabled:YES];
    [self.view addSubview:_Scroller];

    
    _ReadingView1 = [[PoetryReadingView alloc] initWithFrame:CGRectMake(UI_READING_VIEW_ORIGIN_X, 0, UI_IPAD_READINGVIEW_WIDTH, UI_IPAD_SCREEN_HEIGHT)];
    _ReadingView2 = [[PoetryReadingView alloc] initWithFrame:CGRectMake(UI_READING_VIEW_ORIGIN_X, 0, UI_IPAD_READINGVIEW_WIDTH, UI_IPAD_SCREEN_HEIGHT)];
    _EmptyReadingView = [[PoetryReadingView alloc] initWithFrame:CGRectMake(UI_READING_VIEW_ORIGIN_X, 0, UI_IPAD_READINGVIEW_WIDTH, UI_IPAD_SCREEN_HEIGHT)];
    [_ReadingView1 setTag:TAG_READING_VIEW_1];
    [_ReadingView2 setTag:TAG_READING_VIEW_2];

    _NowReadingCategoryArray = [[NSMutableArray alloc] init];

    
    // 9. add GestureRecognize on reading view
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [self.view addGestureRecognizer:panRecognizer];
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;
    
    /*
    _PrevTouchView = [[UIView alloc] initWithFrame:UI_IPAD_PREV_VIEW_RECT_INIT];
    _NextTouchView = [[UIView alloc] initWithFrame:UI_IPAD_NEXT_VIEW_RECT_INIT];
    [_PrevTouchView setBackgroundColor:[UIColor redColor]];
    [_NextTouchView setBackgroundColor:[UIColor redColor]];
    [_PrevTouchView setTag:TAG_PREV_TOUCH_VIEW];
    [_NextTouchView setTag:TAG_NEXT_TOUCH_VIEW];
    [self.view addSubview:_PrevTouchView];
    [self.view addSubview:_NextTouchView];
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
    
    // Read Setting
    _font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_Setting.SettingFontSize];
    _DisplayTheme = _Setting.SettingTheme;
    _SlideDirection = SlideLabelNone;
    _LabelSizeInit = CGSizeMake(UI_IPAD_SCREEN_WIDTH, 0);
    _CurrentView = VIEW1;
    
    // Reading view flags
    _GetSlideInLabel = NO;
    _DataFlag = NO;
    _CrossCategoryFlag = NO;
    _HeadAndTailFlag = NO;
    _ConfirmToSwitch = NO;
    
    // Cover view flags
    _isNavTableOn = NO;
    _isSettingTableOn = NO;
    _isSearchBarOn = NO;
    _isSearching = NO;      //[CASPER] 2013.12.24
    _isTocTableOn = NO;     //[CASPER] 2013.12.27
    _isHandlingTouchSwitch = NO;
    [self InitReadingViewSetupScroller];
    [self InitCoverViewItems];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    IPAD_READING_VIEW_LOG(@"ViewDidDisappear - save reading");
    
    [_ReadingView1 removeFromSuperview];
    [_ReadingView2 removeFromSuperview];
    
    [_PoetryDatabase PoetryCoreDataSaveIntoNowReading:_PoetryNowReading];
    
}


-(void) InitCoverViewItems
{
    
    if (_NaviBtn == nil) {
        _NaviBtn = [[UIButton alloc] initWithFrame:UI_IPAD_NAVI_BTN_RECT_INIT];
    }
    [_NaviBtn setTitle:@"GOTO" forState:UIControlStateNormal];
    [_CoverView setTag:TAG_NAVI_BTN];

    _NaviBtn.backgroundColor = [UIColor colorWithRed:(160/255.0f) green:(185/255.0f) blue:(211/255.0f) alpha:0.5];
    _NaviBtn.opaque = YES;
    [_NaviBtn addTarget:self action:@selector(NavigationBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_NaviBtn];
    
    
    if (_SettingBtn == nil) {
        _SettingBtn = [[UIButton alloc] initWithFrame:UI_IPAD_COVER_SETTING_BTN_RECT_INIT];
    }
    
    [_SettingBtn setTitle:@"SETTING" forState:UIControlStateNormal];
    
    _SettingBtn.backgroundColor = [UIColor grayColor];
    _SettingBtn.opaque = YES;
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
    
    if (_TableView == nil) {
        _TableView = [[UITableView alloc] initWithFrame:UI_IPAD_COVER_TABLEVIEW_RECT_INIT];
    }
    _TableData = [NSMutableArray arrayWithObjects:@"導讀", @"聖詩", @"啟應文", @"閱讀歷史", nil];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.scrollEnabled = NO;
    [_TableView setTag:TAG_TABLE_VIEW];
    
    [_TableView reloadData];
   
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

#pragma mark - Reading and Gesture Methods
-(void)InitReadingViewSetupScroller
{
    
    if (_PoetryDatabase.isReadingExist) {
        
        _PoetryNowReading = [_PoetryDatabase Poetry_CoreDataFetchDataInReading];
        POETRY_CATEGORY Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
        _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
        _CurrentIndex = [[_PoetryNowReading valueForKey:POETRY_CORE_DATA_INDEX_KEY] integerValue] - 1; //Since the index in core data starts at 1
        
        
    } else {
        
        IPAD_READING_VIEW_LOG(@"NO READING POETRY, GET THE 1st POETRY in GUARD READING");
        _PoetryNowReading = (NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS] objectAtIndex:0];
        
        POETRY_CATEGORY Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
        _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
        _CurrentIndex = 0;
        
    }
    
    IPAD_READING_VIEW_LOG(@"_CurrentIndex = %d", _CurrentIndex);
    // Setup Scroll View
    [_Scroller setContentSize:CGSizeMake(UI_IPAD_READINGVIEW_WIDTH, 0)];
    [_Scroller setScrollEnabled:YES];
    
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ReadingScroller" owner:self options:nil];
    if (subviewArray == nil) {
        IPAD_READING_VIEW_ERROR_LOG(@"CANNOT FIND ReadingScroller");
    }
    
    // Init View1 for first launch
    if (_ReadingView1 == nil) {
        _ReadingView1 = [[PoetryReadingView alloc] init];
    }
    
    if (_ReadingView2 == nil) {
        _ReadingView2 = [[PoetryReadingView alloc] init];
    }
    
    _ReadingView1 = [self DisplayHandlingWithData:_PoetryNowReading onView:_ReadingView1 ViewExist:NO];
    IPAD_READING_VIEW_LOG(@"init _ReadingView1 = %@", _ReadingView1);
    
    self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
    [_ReadingView1 setBackgroundColor:[UIColor clearColor]];
    
    [_Scroller addSubview: _ReadingView1];
    
    
}

-(void)ReloadReadingView
{
    
    _font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_Setting.SettingFontSize];
    _DisplayTheme = _Setting.SettingTheme;
    if (_CurrentView == VIEW1) {
        
        [self DisplayHandlingWithData:_PoetryNowReading onView:_ReadingView1 ViewExist:YES];
       
    } else {
        
        [self DisplayHandlingWithData:_PoetryNowReading onView:_ReadingView2 ViewExist:YES];
    }
}

// Remove "\n" in the beginning of the article
-(NSString*)ReadingViewCleanUpTextWithTheArticle : (NSString*) Articel
{
    NSRange range;
    range.length = 1;
    range.location = 0;
    
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

-(PoetryReadingView *) DisplayHandlingWithData :(NSDictionary*) PoetryData onView : (PoetryReadingView*) PoetryReadingView ViewExist : (BOOL) Exist
{
    
    // [CASPER] 2013 12 24 iPad Only: Title label
    if (PoetryReadingView.TitleTextLabel == nil) {
        PoetryReadingView.TitleTextLabel = [[UILabel alloc] init];
    }
    [PoetryReadingView.TitleTextLabel setText:[PoetryData valueForKey:POETRY_CORE_DATA_NAME_KEY]];
    [PoetryReadingView.TitleTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:60]];
    [PoetryReadingView.TitleTextLabel setBackgroundColor:[UIColor clearColor]];
    PoetryReadingView.TitleTextLabel.numberOfLines = 0;
    PoetryReadingView.TitleTextLabel.textAlignment = NSTextAlignmentCenter;
    PoetryReadingView.TitleTextLabel.frame = UI_IPAD_READING_TITLE_RECT_LABEL;
    
    
    if (PoetryReadingView.ContentTextLabel == nil) {
        PoetryReadingView.ContentTextLabel = [[UILabel alloc] init];
    }
    
    [PoetryReadingView.ContentTextLabel setText:[PoetryData valueForKey:POETRY_CORE_DATA_CONTENT_KEY]];
    //NSLog(@"content = %@",[PoetryData valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
    [PoetryReadingView.ContentTextLabel setFont:_font];
    [PoetryReadingView.ContentTextLabel setBackgroundColor:[UIColor clearColor]];
    PoetryReadingView.ContentTextLabel.numberOfLines = 0;
    PoetryReadingView.ContentTextLabel.textAlignment = NSTextAlignmentCenter;
    CGSize constraint = CGSizeMake(UI_IPAD_READINGVIEW_WIDTH, 20000.0f);
    
    _LabelSizeInit = [PoetryReadingView.ContentTextLabel sizeThatFits:constraint];
    
    if (_DisplayTheme == THEME_LIGHT_DARK) {
        
        // Font color = Black, Background = White
        PoetryReadingView.TitleTextLabel.textColor = [UIColor blackColor];
        PoetryReadingView.ContentTextLabel.textColor = [UIColor blackColor];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
    } else {
        
        // Font color = White, Background = Black
        PoetryReadingView.TitleTextLabel.textColor = [UIColor whiteColor];
        PoetryReadingView.ContentTextLabel.textColor = [UIColor whiteColor];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
    }
    
    //[PoetryReadingView.ContentTextLabel setFrame:CGRectMake(20, 0, _LabelSizeInit.width, _LabelSizeInit.height)];
    [PoetryReadingView.ContentTextLabel setFrame:CGRectMake(20.0f, UI_IPAD_TEXT_LABEL_TITLE_HEAD_Y, UI_IPAD_READINGVIEW_WIDTH - 50.0f, _LabelSizeInit.height)];
    
    CGFloat ViewHeight = _LabelSizeInit.height;
    CGFloat Header = UI_IPAD_TEXT_LABEL_TITLE_HEAD_Y;

    ViewHeight = ViewHeight + Header + 40;
    if (ViewHeight < UI_IPAD_SCREEN_HEIGHT) {
        ViewHeight = UI_IPAD_SCREEN_HEIGHT;
    }
    
    
    //[PoetryReadingView.ContentTextLabel setBackgroundColor:[UIColor redColor]];
    //IPAD_READING_VIEW_LOG(@"PoetryReadingView.ContentTextLabel = %@", PoetryReadingView.ContentTextLabel);

    if (Exist == NO) {
        [PoetryReadingView addSubview:PoetryReadingView.TitleTextLabel];
        [PoetryReadingView addSubview:PoetryReadingView.ContentTextLabel];
    }
    [PoetryReadingView setFrame:CGRectMake(20, 0, UI_IPAD_READINGVIEW_WIDTH, ViewHeight)];
    [_Scroller setContentSize:CGSizeMake(UI_IPAD_READINGVIEW_WIDTH, ViewHeight)];

    return PoetryReadingView;
    
}

#pragma mark - Cover view state control

-(void) PlaceCoverView
{
    
    [self.view insertSubview:_CoverView belowSubview:_NaviBtn];
    
    // And init all item on the init location
    [_CoverView addSubview:_TableView];
    [_CoverView insertSubview:_TocTableView belowSubview:_TableView];

    [_CoverView insertSubview:_NavigationHeader belowSubview:_TableView];
    [_CoverView addSubview:_SettingBtn];
    [_CoverView addSubview:_SettingTableView];
    [_CoverView addSubview:_SearchBar];
    
    NSString *ShadowType = @"Customized";
    [Animations frameAndShadow:_TableView];
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
                         
                         [_TableView setFrame:UI_IPAD_COVER_TABLEVIEW_RECT_INIT];
                         [_SettingBtn setFrame:UI_IPAD_COVER_SETTING_BTN_RECT_INIT];
                         [_SettingTableView setFrame:UI_IPAD_COVER_SETTING_TABLE_RECT_INIT];
                         [_SearchBar setFrame:UI_IPAD_COVER_SEARCH_BAR_RECT_INIT];
                         [_TocTableView setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT];
                         [_NavigationHeader setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_HEADER];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [_CoverView removeFromSuperview];
                         [_TableView removeFromSuperview];
                         [_SettingTableView removeFromSuperview];
                         [_SearchBar removeFromSuperview];
                         [_TocTableView removeFromSuperview];
                         [_NavigationHeader removeFromSuperview];
                         _SearchBar.text = @"";
                         _SearchResultDisplayArray = nil;
                         
                         //TODO: Force Update Reading View followed Setting
                         [self ReloadReadingView];
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
            
            [self RemoveSettingTableViewAnnimation];
            [self ExecuteSearchBarAnnimation];
            break;
            
        case COVER_SETTING:
            
            _isNavTableOn = YES;
            _isSearchBarOn = NO;
            _isSettingTableOn = YES;
            _isSearching = NO;
            
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
    
    [_TableView reloadData];
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [_TableView setFrame:UI_IPAD_COVER_TABLEVIEW_RECT_ON_COVER];
                         [_SettingBtn setFrame:UI_IPAD_COVER_SETTING_BTN_RECT_ON_COVER];
                         [_SearchBar setFrame:UI_IPAD_COVER_SEARCH_BAR_RECT_ON_COVER];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
    

/*
    
    [Animations moveRight:_TableView andAnimationDuration:0.2 andWait:YES andLength:350.0];
    [Animations moveLeft:_TableView andAnimationDuration:0.2 andWait:YES andLength:20.0];
    [Animations moveRight:_TableView andAnimationDuration:0.1 andWait:YES andLength:20.0];
    [Animations moveLeft:_TableView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    [Animations moveRight:_TableView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    
    [self InitSettingBtn];
    [Animations moveUp:_SettingBtn andAnimationDuration:0.2 andWait:YES andLength:200.0];
    [Animations moveDown:_SettingBtn andAnimationDuration:0.2 andWait:YES andLength:20.0];
    [Animations moveUp:_SettingBtn andAnimationDuration:0.1 andWait:YES andLength:20.0];
    [Animations moveDown:_SettingBtn andAnimationDuration:0.1 andWait:YES andLength:12.0];
    [Animations moveUp:_SettingBtn andAnimationDuration:0.1 andWait:YES andLength:12.0];
    */
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == TAG_TABLE_VIEW) {
        
        if (_isSearching) {
            // Search table
            return 4;
        }
        return 1;
        
    } else if (tableView.tag == TAG_SETTING_TABLE_VIEW) {
        
        return 4;
    }
    
    return 1;
}

- (void) ExecuteTocTableViewAnimation
{
    _isTocTableOn = YES; //[CASPER] 2013.12.27
    [Animations moveRight:_NavigationHeader andAnimationDuration:0.3 andWait:NO andLength:UI_IPAD_TOC_TABLEVIEW_WIDTH + UI_IPAD_TABLEVIEW_WIDTH];
    [Animations moveRight:_TocTableView andAnimationDuration:0.3 andWait:YES andLength:UI_IPAD_TOC_TABLEVIEW_WIDTH + UI_IPAD_TABLEVIEW_WIDTH];
    
    [Animations moveLeft:_TocTableView andAnimationDuration:0.2 andWait:NO andLength:UI_IPAD_TABLEVIEW_WIDTH];
    [Animations moveLeft:_NavigationHeader andAnimationDuration:0.2 andWait:NO andLength:UI_IPAD_TABLEVIEW_WIDTH];
    [Animations moveLeft:_TableView andAnimationDuration:0.2 andWait:NO andLength:UI_IPAD_TABLEVIEW_WIDTH];
    
}


-(void) RemoveTocTableViewAnimation
{
    _isTocTableOn = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                        [_TableView setFrame:UI_IPAD_COVER_TABLEVIEW_RECT_ON_COVER];
                        [_TocTableView setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT];
                        [_NavigationHeader setFrame:UI_IPAD_COVER_TOC_TABLEVIEW_RECT_HEADER];
                     }
                     completion:^(BOOL finished) {
                         
                    }];

}

// TODO: Handle selected on the table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TAG_TABLE_VIEW) {
        if (_isSearching) {
            // For Searching
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
                    NSLog(@"history pressed");
                    break;
                default:
                    break;
            }
        }
    } else if (tableView.tag == TAG_TOC_TABLE_VIEW) {
        // Remember to ignore 1, because index 0 is header.
        NSLog(@"%d", indexPath.row);
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == TAG_TABLE_VIEW) {
        if (_isSearching) {
            return [[_SearchResultDisplayArray objectAtIndex:section] count];
        } else {
            return [_TableData count];
        }
        
        
    } else if (tableView.tag == TAG_SETTING_TABLE_VIEW) {
        
        return 1;
        
    } else if (tableView.tag == TAG_TOC_TABLE_VIEW) {
        
        // TODO : Add 1, after adding title in the first cell
        return [_TocTableData count];
    }
    
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView.tag == TAG_SETTING_TABLE_VIEW) {
        
        if (indexPath.section <= 1) {
            
            return 50;
            
        } else if (indexPath.section == 2) {
            
            return 100;
            
        } else {
            
            return 45;
        }
        
    }
    
    return 44;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionStr = [[NSString alloc] init];
    
    if (tableView.tag == TAG_SETTING_TABLE_VIEW) {
        
        
        switch (section) {
            case 0:
                sectionStr = @"字體大小";
                break;
                
            case 1:
                sectionStr = @"顯示主題";
                break;
                
            case 2:
                sectionStr = @"預覽";
                break;
                
            case 3:
                sectionStr = @"關於我";
                break;
            default:
                break;
        }
        
    } else {
        
        if (_isSearching) {
            switch (section) {
                case 0:
                    sectionStr = nil;
                    break;
                    
                case 1:
                    sectionStr = @"導讀";
                    break;
                    
                case 2:
                    sectionStr = @"聖詩";
                    break;
                    
                case 3:
                    sectionStr = @"啟應文";
                    break;
                default:
                    break;
            }

        } else {
            
            sectionStr = nil;
            
        }
    }
    
    return sectionStr;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (tableView.tag == TAG_TABLE_VIEW) {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        if (_isSearching) {
            
            // Search result handling
            cell.textLabel.text = [[[_SearchResultDisplayArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:POETRY_CORE_DATA_NAME_KEY];
            cell.detailTextLabel.text = [[[_SearchResultDisplayArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:POETRY_CORE_DATA_CONTENT_KEY];
            
        } else {
            
            cell.textLabel.text = [_TableData objectAtIndex:indexPath.row];
        }
        
        
    } else if (tableView.tag == TAG_SETTING_TABLE_VIEW) {
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            
            [self Setting_InitFontSizeViewBtns];
            [cell addSubview:_FontSizeSettingView];
            
        } else if (indexPath.section == 1) {
            
            [self Setting_InitThemeSettingView];
            [cell addSubview:_ThemeSettingView];
            
            
        } else if (indexPath.section == 2) {
            [self InitPreviewLab];
            [self Setting_InitThemeView];
            [cell addSubview:_ThemePreViewLab];
            
        } else if (indexPath.section == 3) {
            cell.textLabel.text = @"About me";
        }
        
    } else if (tableView.tag == TAG_TOC_TABLE_VIEW) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.text = [[_TocTableData objectAtIndex:indexPath.row] valueForKey:POETRY_CORE_DATA_NAME_KEY];
        
        /*if (indexPath.row == 0) {
         
         // [cell setHighlighted:NO];
         [cell addSubview:_NavigationHeader];
         ce ll.selectionStyle = UITableViewCellSelectionStyleNone;
         
         
         } else {
         
         
         }*/
        
    }
    
    return cell;
}



#pragma mark - Search Handling Methods

// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    IPAD_READING_VIEW_LOG(@"searchBarShouldBeginEditing  set _isSearching YES");
    
    if (_isTocTableOn) {    //[CASPER] 2013.12.27
        [self RemoveTocTableViewAnimation];
    }
    // TODO: Setup Table frame
    
    //[_TableView reloadData];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _isSearching = YES;     //[CASPER] 2013.12.24
    
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
    
    CGFloat TableHeight = ((UI_IPAD_COVER_TABLE_CELL_HEIGHT * [_SearchGuidedReading count]) +
                           (UI_IPAD_COVER_TABLE_CELL_HEIGHT * [_SearchPoetryData count]) +
                           (UI_IPAD_COVER_TABLE_CELL_HEIGHT * [_SearchRespose count]) +
                           3 * UI_IPAD_COVER_TABLE_CELL_HEADER_HEIGHT);
    
    if (TableHeight > UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_MAX) {
        
        TableHeight = UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_MAX;
        _TableView.scrollEnabled = YES;
        
    } else {
        
        _TableView.scrollEnabled = NO;

    }
    
    _TableView.frame = CGRectMake(_TableView.frame.origin.x,
                                  _TableView.frame.origin.y,
                                  _TableView.frame.size.width,
                                  TableHeight);
    
    [_TableView reloadData];
    
}




#pragma mark - Gensture recognizer methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    //UITouch *touch = [touches anyObject];
    if (_CoverViewState == COVER_IDLE) {
        /*
        if ((touch.view.tag == TAG_PREV_TOUCH_VIEW) || (touch.view.tag == TAG_NEXT_TOUCH_VIEW)) {
            NSLog(@"TEST!!");
         
        }
         */
    }


}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

}


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


-(PoetryReadingView *) PlaceEmptyViewForSlideDirection : (SLIDE_DIRECTION) SlideDirection
{
    if (_EmptyReadingView == nil) {
        _EmptyReadingView = [[PoetryReadingView alloc] init];
    }
    if (_EmptyReadingView.ContentTextLabel == nil) {
        _EmptyReadingView.ContentTextLabel = [[UILabel alloc] init];
    }
    [_EmptyReadingView addSubview:_EmptyReadingView.ContentTextLabel];
    
    _EmptyReadingView.ContentTextLabel.backgroundColor = [UIColor clearColor];
    _EmptyReadingView.ContentTextLabel.textColor = [UIColor grayColor];
    _EmptyReadingView.ContentTextLabel.font = _font;
    
    if (SlideDirection == SlideLabelLeftToRigth) {
        
        // PREV
        IPAD_READING_VIEW_LOG(@"The most first poetry, try to init view below");
        
        _EmptyReadingView.frame = CGRectMake(0, 0, UI_IPAD_READINGVIEW_WIDTH, UI_IPAD_SCREEN_HEIGHT);
        _EmptyReadingView.ContentTextLabel.frame = CGRectMake(10, UI_IPAD_SCREEN_HEIGHT / 2, UI_IPAD_READINGVIEW_WIDTH, 50);
        _EmptyReadingView.ContentTextLabel.text = @"最前的一首";
        
    } else {
        //NEXT
        IPAD_READING_VIEW_LOG(@"The latest poetry, try to init view ");
        
        _EmptyReadingView.frame = CGRectMake(0, 0, UI_IPAD_READINGVIEW_WIDTH, UI_IPAD_SCREEN_HEIGHT);
        _EmptyReadingView.ContentTextLabel.frame = CGRectMake(10, UI_IPAD_SCREEN_HEIGHT / 2, UI_IPAD_READINGVIEW_WIDTH, 50);
        _EmptyReadingView.ContentTextLabel.text = @"最後的一首";
        _EmptyReadingView.ContentTextLabel.textAlignment = NSTextAlignmentRight;
        
    }
    
    return _EmptyReadingView;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    
    if ((touch.view.tag == TAG_READING_VIEW_1) || (touch.view.tag == TAG_READING_VIEW_2)) {
        
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
        
        if (_ReadingView2 == nil) {
            _ReadingView2 = [[PoetryReadingView alloc] init];
        }
        
        _ReadingView2 = [self HandleGestureWith:recognizer andHandledView:_ReadingView2];
        
        
    } else {
        
        if (_ReadingView1 == nil) {
            _ReadingView1 = [[PoetryReadingView alloc] init];
        }
        
        _ReadingView1 = [self HandleGestureWith:recognizer andHandledView:_ReadingView1];
        
    }
    
}


-(PoetryReadingView *) HandleGestureWith:(UIPanGestureRecognizer *)recognizer andHandledView : (PoetryReadingView *) View
{
    
    CGPoint location = [recognizer locationInView:_Scroller];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            _TouchInit = location;
            break;
            
        case UIGestureRecognizerStateChanged:
            
            [self HandleGestureChangedWithLocation:location andView:View];
            
            break;
            
        case UIGestureRecognizerStateEnded:
            [self HandleGestureEndWithLocation:location andView:View];

            break;
        case UIGestureRecognizerStateCancelled:
        {
            IPAD_READING_VIEW_LOG(@"UIGestureRecognizerStateCancelled");
        }
            
            
        default:
            break;
    }
    
    
    
    return View;
}


-(void) HandleGestureChangedWithLocation : (CGPoint) location andView : (PoetryReadingView *) View
{

    if (((location.x - _TouchInit.x) > 0) && (abs(location.x - _TouchInit.x) > 10)) {
        
        if ( _SlideDirection != SlideLabelLeftToRigth ) {
            // Need to reinit new view and data
            _GetSlideInLabel = NO;
            _DataFlag = NO;
            
        }
        
        _SlideDirection = SlideLabelLeftToRigth;
        
        if (!_GetSlideInLabel) {
            
            IPAD_READING_VIEW_LOG(@"Drag to right, use the previous poetry");
            // Get the previous data and save into temp _NewDataDic for once (check DataFlag)
            // Set Lable on the left of the screen and config it
            
            if (!_DataFlag) {
                
                if (_CurrentIndex == 0) {
                    
                    // This is the first poetry in this category
                    // Check the Category
                    NSNumber *CategoryNum = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY];
                    if (GUARD_READING != (POETRY_CATEGORY)[CategoryNum integerValue]) {
                        
                        // To get the previous category list as temp.
                        if (POETRYS == (POETRY_CATEGORY)[CategoryNum integerValue]) {
                            
                            IPAD_READING_VIEW_LOG(@"Get Guard Reading list");
                            TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:GUARD_READING];
                            
                        } else if (RESPONSIVE_PRAYER == (POETRY_CATEGORY)[CategoryNum integerValue]) {
                            
                            IPAD_READING_VIEW_LOG(@"Get Poetry list");
                            TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS];
                            
                        } else {
                            
                            IPAD_READING_VIEW_ERROR_LOG(@"Reading view has some error, plz check");
                            
                        }
                        
                        if (TempPoetryList != nil) {
                            
                            _CrossCategoryFlag = YES;
                            _NewDataDic = [TempPoetryList lastObject];
                            IPAD_READING_VIEW_LOG(@"Get Poetry at cross category");
                        }
                        
                    } else {
                        
                        // Generate empty view to notify user
                        if (_CurrentView == VIEW1) {
                            
                            IPAD_READING_VIEW_LOG(@"Add view below readingview1");
                            if (_DisplayTheme == THEME_LIGHT_DARK) {
                                [_ReadingView1 setBackgroundColor:[UIColor whiteColor]];
                            } else {
                                [_ReadingView1 setBackgroundColor:[UIColor blackColor]];
                            }
                            
                            [self PlaceEmptyViewForSlideDirection:_SlideDirection];
                            [_Scroller insertSubview:_EmptyReadingView belowSubview:_ReadingView1];
                            
                            
                        } else {
                            
                            if (_DisplayTheme == THEME_LIGHT_DARK) {
                                [_ReadingView2 setBackgroundColor:[UIColor whiteColor]];
                            } else {
                                [_ReadingView2 setBackgroundColor:[UIColor blackColor]];
                            }
                            
                            [self PlaceEmptyViewForSlideDirection:_SlideDirection];
                            [_Scroller insertSubview:_EmptyReadingView belowSubview:_ReadingView2];
                            
                        }
                        
                        
                        IPAD_READING_VIEW_LOG(@"NO DATA");
                        _HeadAndTailFlag = YES;
                        _NewDataDic = nil;
                        
                    }
                    
                    
                    
                } else {
                    
                    // To get the previous poetry of this category
                    _NewDataDic = [_NowReadingCategoryArray objectAtIndex:(_CurrentIndex - 1)];
                    IPAD_READING_VIEW_LOG(@"_NewDataDic index = %d", _CurrentIndex - 1);
                    // Height of view will be set inside the method
                }
                
                if (_NewDataDic) {
                    
                    View.frame = CGRectMake(0, 0, UI_IPAD_READINGVIEW_WIDTH, 0);
                    View = [self DisplayHandlingWithData:_NewDataDic onView:View ViewExist:NO];
                    //IPAD_READING_VIEW_LOG(@"View Generate = %@", View);
                    
                    if (_DisplayTheme == THEME_LIGHT_DARK) {
                        
                        // Font color = Black, Background = White
                        View.ContentTextLabel.textColor = [UIColor blackColor];
                        [View setBackgroundColor:[UIColor whiteColor]];
                        [self.view setBackgroundColor:[UIColor whiteColor]];
                        
                    } else {
                        
                        // Font color = Black, Background = White
                        View.ContentTextLabel.textColor = [UIColor whiteColor];
                        [View setBackgroundColor:[UIColor blackColor]];
                        [self.view setBackgroundColor:[UIColor blackColor]];
                        
                    }
                    
                    //[_Scroller addSubview:View];
                    
                    if (_CurrentView == VIEW1) {
                        
                        IPAD_READING_VIEW_LOG(@"Add view below readingview1");
                        if (_DisplayTheme == THEME_LIGHT_DARK) {
                            [_ReadingView1 setBackgroundColor:[UIColor whiteColor]];
                        } else {
                            [_ReadingView1 setBackgroundColor:[UIColor blackColor]];
                        }
                        
                        [_Scroller insertSubview:View belowSubview:_ReadingView1];
                        
                    } else {
                        
                        if (_DisplayTheme == THEME_LIGHT_DARK) {
                            [_ReadingView2 setBackgroundColor:[UIColor whiteColor]];
                        } else {
                            [_ReadingView2 setBackgroundColor:[UIColor blackColor]];
                        }
                        
                        [_Scroller insertSubview:View belowSubview:_ReadingView2];
                    }
                    
                    
                }
                
                _DataFlag = YES;
                _GetSlideInLabel = YES;
                
            }
        } else {
            
            if (_DataFlag) {
                
                // Move the view above following gesture
                // View.frame = CGRectMake((UI_DEFAULT_PREVIOUS_ORIGIN_X + abs(location.x - _TouchInit.x)), View.frame.origin.y, View.frame.size.width, View.frame.size.height);
                if (_CurrentView == VIEW1) {
                    
                    _ReadingView1.frame = CGRectMake((0 + abs(location.x - _TouchInit.x)), 0, View.frame.size.width, View.frame.size.height);
                    
                } else {
                    
                    _ReadingView2.frame = CGRectMake((0 + abs(location.x - _TouchInit.x)), 0, View.frame.size.width, View.frame.size.height);
                }
                
            }
            
        }
        
    } else if (((location.x - _TouchInit.x) < 0) && (abs(location.x - _TouchInit.x) > 10)) {
        
        if ( _SlideDirection != SlideLabelRightToLegt ) {
            // Need to reinit new view and data
            _GetSlideInLabel = NO;
            _DataFlag = NO;
            
        }
        
        _SlideDirection = SlideLabelRightToLegt;
        
        if (!_GetSlideInLabel) {
            
            IPAD_READING_VIEW_LOG(@"Drag to left, use the next poetry");
            // Get the previous data and save into temp _NewDataDic for once (check DataFlag)
            // Set Lable on the left of the screen and config it
            
            if (!_DataFlag) {
                
                if (_CurrentIndex == ([_NowReadingCategoryArray count] - 1)) {
                    
                    // Check the Category
                    NSNumber *CategoryNum = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY];
                    if (RESPONSIVE_PRAYER != (POETRY_CATEGORY)[CategoryNum integerValue]) {
                        // To get the next category list as temp.
                        
                        if (GUARD_READING == (POETRY_CATEGORY)[CategoryNum integerValue]) {
                            
                            IPAD_READING_VIEW_LOG(@"Get Petry Reading list");
                            TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS];
                            
                        } else if (POETRYS == (POETRY_CATEGORY)[CategoryNum integerValue]) {
                            
                            IPAD_READING_VIEW_LOG(@"Get Responsive list");
                            TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:RESPONSIVE_PRAYER];
                            
                        } else {
                            IPAD_READING_VIEW_ERROR_LOG(@"Reading view has some error, plz check");
                        }
                        
                        if (TempPoetryList != nil) {
                            
                            _CrossCategoryFlag = YES;
                            _NewDataDic = [TempPoetryList firstObject];
                            IPAD_READING_VIEW_LOG(@"Get Poetry at cross category");
                            
                        }
                        
                        
                    } else {
                        
                        // Generate empty view to notify user
                        if (_CurrentView == VIEW1) {
                            
                            IPAD_READING_VIEW_LOG(@"Add view below readingview1");
                            if (_DisplayTheme == THEME_LIGHT_DARK) {
                                [_ReadingView1 setBackgroundColor:[UIColor whiteColor]];
                            } else {
                                [_ReadingView1 setBackgroundColor:[UIColor blackColor]];
                            }
                            
                            [self PlaceEmptyViewForSlideDirection:_SlideDirection];
                            [_Scroller addSubview:_EmptyReadingView];
                            
                        } else {
                            
                            if (_DisplayTheme == THEME_LIGHT_DARK) {
                                [_ReadingView2 setBackgroundColor:[UIColor whiteColor]];
                            } else {
                                [_ReadingView2 setBackgroundColor:[UIColor blackColor]];
                            }
                            
                            [self PlaceEmptyViewForSlideDirection:_SlideDirection];
                            [_Scroller addSubview:_EmptyReadingView];
                            
                        }
                        
                        IPAD_READING_VIEW_LOG(@"NO DATA");
                        _HeadAndTailFlag = YES;
                        _NewDataDic = nil;
                    }
                    
                } else {
                    
                    _NewDataDic = [_NowReadingCategoryArray objectAtIndex:(_CurrentIndex + 1)];
                    IPAD_READING_VIEW_LOG(@"_NewDataDic index = %d", _CurrentIndex + 1);
                }
                
                
                if (_NewDataDic) {
                    
                    // Height of view will be set inside the method
                    View.frame = CGRectMake(UI_IPAD_SCREEN_WIDTH, 0, UI_IPAD_READINGVIEW_WIDTH, 0);
                    View = [self DisplayHandlingWithData:_NewDataDic onView:View ViewExist:NO];
                    IPAD_READING_VIEW_LOG(@"New View Generate = [%@]", View);
                    
                    
                    if (_DisplayTheme == THEME_LIGHT_DARK) {
                        
                        // Font color = Black, Background = White
                        View.ContentTextLabel.textColor = [UIColor blackColor];
                        [View setBackgroundColor:[UIColor whiteColor]];
                        [self.view setBackgroundColor:[UIColor whiteColor]];
                        
                    } else {
                        
                        // Font color = Black, Background = White
                        View.ContentTextLabel.textColor = [UIColor whiteColor];
                        [View setBackgroundColor:[UIColor blackColor]];
                        [self.view setBackgroundColor:[UIColor blackColor]];
                        
                    }
                    
                    [_Scroller addSubview:View];
                    
                }
                
                
                _DataFlag = YES;
                _GetSlideInLabel = YES;
                
            }
        } else {
            
            if (_DataFlag) {
                
                if (_HeadAndTailFlag) {
                    
                    _EmptyReadingView.frame = CGRectMake((UI_IPAD_SCREEN_WIDTH - abs(location.x - _TouchInit.x)), _EmptyReadingView.frame.origin.y, _EmptyReadingView.frame.size.width, _EmptyReadingView.frame.size.height);
                    
                } else {
                    
                    // Move the label follow gesture
                    View.frame = CGRectMake((UI_IPAD_READINGVIEW_WIDTH - abs(location.x - _TouchInit.x)), View.frame.origin.y, UI_IPAD_READINGVIEW_WIDTH, View.frame.size.height);
                    //IPAD_READING_VIEW_LOG(@"New View Generate = [%@]", View);
                    
                }
                
                
            }
        }
    }

}

-(void) HandleGestureEndWithLocation : (CGPoint) location andView : (PoetryReadingView *) View
{
    if (_DataFlag) {
        
        if (_HeadAndTailFlag) {
            
            // View transtion not complete
            IPAD_READING_VIEW_LOG(@"Head and tail flag!!!");
            [UIView animateWithDuration:0.2
                             animations:^{
                                 if (_SlideDirection == SlideLabelLeftToRigth) {
                                     
                                     if (_CurrentView == VIEW1) {
                                         
                                         _ReadingView1.frame = CGRectMake(0, 0, _ReadingView1.frame.size.width, _ReadingView1.frame.size.height);
                                         
                                     } else {
                                         
                                         _ReadingView2.frame = CGRectMake(0, 0, _ReadingView2.frame.size.width, _ReadingView2.frame.size.height);
                                     }
                                     
                                     //View.frame = CGRectMake(0, View.frame.origin.y, View.frame.size.width, View.frame.size.height);
                                     
                                 } else {
                                     
                                     View.frame = CGRectMake(UI_IPAD_SCREEN_WIDTH, View.frame.origin.y, View.frame.size.width, View.frame.size.height);
                                 }
                                 
                                 
                             }
                             completion:^(BOOL finished){
                                 
                                 _GetSlideInLabel = NO;
                                 _DataFlag = NO;
                                 _CrossCategoryFlag = NO;
                                 _HeadAndTailFlag = NO;
                                 
                                 [_EmptyReadingView removeFromSuperview];
                                 
                             }];
            
        } else {
            
            if (abs(location.x - _TouchInit.x) > IPAD_SWITCH_VIEW_THRESHOLD) {
                
                if (_SlideDirection == SlideLabelLeftToRigth) {
                    if ((location.x - _TouchInit.x) > 0) {
                        // Confirm to change view
                        _ConfirmToSwitch = YES;
                        
                    } else {
                        // Failed to change view
                        _ConfirmToSwitch = NO;
                        
                    }
                    
                } else {
                    if ((location.x - _TouchInit.x) < 0) {
                        // Confirm to change view
                        _ConfirmToSwitch = YES;
                    } else {
                        // Failed to change view
                        _ConfirmToSwitch = NO;
                        
                    }
                    
                }
                
                if (_ConfirmToSwitch) {
                    
                    IPAD_READING_VIEW_LOG(@"_ConfirmToSwitch !!!! ");
                    // View transtion complete
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         
                                         if (_SlideDirection == SlideLabelLeftToRigth) {
                                             
                                             // Move view out of the screen
                                             if (_CurrentView == VIEW1) {
                                                 
                                                 _ReadingView1.frame = CGRectMake(UI_IPAD_SCREEN_WIDTH, 0, View.frame.size.width, View.frame.size.height);
                                                 
                                             } else {
                                                 
                                                 _ReadingView2.frame = CGRectMake(UI_IPAD_SCREEN_WIDTH, 0, View.frame.size.width, View.frame.size.height);
                                             }
                                             
                                         } else {
                                             
                                             
                                             // Set Label in the normal location
                                             View.frame = CGRectMake(0, 0, View.frame.size.width, View.frame.size.height);
                                             
                                             
                                         }
                                         
                                     }
                                     completion:^(BOOL finished) {
                                         
                                         if (_CrossCategoryFlag) {
                                             
                                             //[_NowReadingCategoryArray removeAllObjects];
                                             
                                             IPAD_READING_VIEW_LOG(@"!!!!!!!! ASSIGN TempPoetryList to _NowReadingCategoryArray");
                                             _NowReadingCategoryArray = [NSMutableArray arrayWithArray:TempPoetryList];
                                             _CrossCategoryFlag = NO;
                                             
                                             if (_SlideDirection == SlideLabelLeftToRigth) {
                                                 _CurrentIndex = [_NowReadingCategoryArray count] - 1;
                                             } else {
                                                 _CurrentIndex = 0;
                                             }
                                             
                                             
                                         } else {
                                             
                                             if (_SlideDirection == SlideLabelLeftToRigth) {
                                                 _CurrentIndex--;
                                             } else {
                                                 _CurrentIndex++;
                                             }
                                             
                                         }
                                         
                                         if (_CurrentView == VIEW1) {
                                             
                                             IPAD_READING_VIEW_LOG(@"move done remove label 1");
                                             
                                             [_ReadingView1 removeFromSuperview];
                                             [View setBackgroundColor:[UIColor clearColor]];
                                             
                                             _CurrentView = VIEW2;
                                             _PoetryNowReading = _NewDataDic;
                                             
                                             self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
                                             [_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
                                             
                                             _DataFlag = NO;
                                             _GetSlideInLabel = NO;
                                             
                                         } else {
                                             
                                             IPAD_READING_VIEW_LOG(@"move done remove label 2");
                                             [_ReadingView2 removeFromSuperview];
                                             [View setBackgroundColor:[UIColor clearColor]];
                                             
                                             _CurrentView = VIEW1;
                                             _PoetryNowReading = _NewDataDic;
                                             
                                             self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
                                             [_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
                                             _DataFlag = NO;
                                             _GetSlideInLabel = NO;
                                             _ConfirmToSwitch = NO;
                                         }
                                     }];
                } else {
                    
                    _GetSlideInLabel = NO;
                    _DataFlag = NO;
                    _CrossCategoryFlag = NO;
                    _HeadAndTailFlag = NO;
                    _ConfirmToSwitch = NO;
                    
                }
                
                
            } else {
                
                // View transtion not complete
                IPAD_READING_VIEW_LOG(@"back to out of screen!!!");
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     if (_SlideDirection == SlideLabelLeftToRigth) {
                                         
                                         if (_CurrentView == VIEW1) {
                                             
                                             _ReadingView1.frame = CGRectMake(0, 0, View.frame.size.width, View.frame.size.height);
                                             
                                         } else {
                                             
                                             _ReadingView2.frame = CGRectMake(0, 0, View.frame.size.width, View.frame.size.height);
                                         }
                                         
                                         //View.frame = CGRectMake(0, View.frame.origin.y, View.frame.size.width, View.frame.size.height);
                                         
                                     } else {
                                         
                                         View.frame = CGRectMake(UI_IPAD_SCREEN_WIDTH, View.frame.origin.y, View.frame.size.width, View.frame.size.height);
                                     }
                                     
                                     
                                 }
                                 completion:^(BOOL finished){
                                     
                                     _GetSlideInLabel = NO;
                                     _DataFlag = NO;
                                     _CrossCategoryFlag = NO;
                                     _HeadAndTailFlag = NO;
                                     _ConfirmToSwitch = NO;
                                     
                                     
                                 }];
                
            }
        }
    }
}


#pragma mark - Font Setting
-(void) Setting_InitFontSizeViewBtns
{
    
    //cell.textLabel.text = @"FONT SIZE";
    if (_FontSizeSettingView == nil) {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"FontSizeSetting" owner:self options:nil];
        _FontSizeSettingView = (FontSizeSetting *)[subviewArray objectAtIndex:0];
        _FontSizeSettingView.frame = CGRectMake(0, 0, _FontSizeSettingView.frame.size.width, _FontSizeSettingView.frame.size.height);
        
        [_FontSizeSettingView.SmallSizeBtn addTarget:self action:@selector(SmallSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_FontSizeSettingView.MidiumSizeBtn addTarget:self action:@selector(MediumSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_FontSizeSettingView.LargeSizeBtn addTarget:self action:@selector(LargeSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self Setting_SetupBtnsInFontSizeViewWithSetting:_Setting.SettingFontSize andSave:NO];
    
}

-(void) Setting_SetupBtnsInFontSizeViewWithSetting : (FONT_SIZE_SETTING) FontSizeSetting andSave:(BOOL) Save
{
    UIColor *DefaultTintColor_iOS7 = [UIColor colorWithRed:0.0f green:(108.f/255.f) blue:(255.f/255.f) alpha:1.0f];
    
    if (Save) {
        [_Setting PoetrySetting_SetFontSize:FontSizeSetting];
    }
    
    _ThemePreViewLab.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FontSizeSetting];
    
    switch (FontSizeSetting) {
            
        case FONT_SIZE_SMALL:
            
            IPAD_READING_VIEW_LOG(@"FONT  = SMALL SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:DefaultTintColor_iOS7];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:[UIColor grayColor]];
            
            
            break;
            
        case FONT_SIZE_MEDIUM:
            
            IPAD_READING_VIEW_LOG(@"FONT  = MEDIUM SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:DefaultTintColor_iOS7];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:[UIColor grayColor]];
            
            break;
            
        case FONT_SIZE_LARGE:
            
            IPAD_READING_VIEW_LOG(@"FONT  = LARGE SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:DefaultTintColor_iOS7];
            
            break;
            
        default:
            break;
    }
}

-(void) SmallSizeBtnClicked
{
    IPAD_READING_VIEW_LOG(@"small");
    [self Setting_SetupBtnsInFontSizeViewWithSetting:FONT_SIZE_SMALL andSave:YES];
}

-(void) MediumSizeBtnClicked
{
    IPAD_READING_VIEW_LOG(@"medium");
    [self Setting_SetupBtnsInFontSizeViewWithSetting:FONT_SIZE_MEDIUM andSave:YES];
}

-(void) LargeSizeBtnClicked
{
    IPAD_READING_VIEW_LOG(@"large");
    [self Setting_SetupBtnsInFontSizeViewWithSetting:FONT_SIZE_LARGE andSave:YES];
}


#pragma mark - Theme Setting

-(void) InitPreviewLab
{
    
    if (_ThemePreViewLab == nil) {
        _ThemePreViewLab = [[UILabel alloc] init];
    }
    
    _ThemePreViewLab.frame = CGRectMake(0, 0, 320.f, 100.f);
    _ThemePreViewLab.textAlignment = NSTextAlignmentCenter;
    _ThemePreViewLab.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_Setting.SettingFontSize];
    
    
}

-(void) Setting_InitThemeSettingView
{
    NSArray *subviewArray2 = [[NSBundle mainBundle] loadNibNamed:@"ThemeSetting" owner:self options:nil];
    _ThemeSettingView = (ThemeSetting *)[subviewArray2 objectAtIndex:0];
    _ThemeSettingView.frame = CGRectMake(0, 0, _ThemeSettingView.frame.size.width, _ThemeSettingView.frame.size.height);
    
    [_ThemeSettingView.LightDarkBtn setTitle:@"白底黑字" forState:UIControlStateNormal];
    [_ThemeSettingView.DarkLightBtn setTitle:@"黑底白字" forState:UIControlStateNormal];
    
    [_ThemeSettingView.LightDarkBtn addTarget:self action:@selector(LightDarkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_ThemeSettingView.DarkLightBtn addTarget:self action:@selector(DarkLightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) Setting_InitThemeView
{
    [self Setting_SetupThemeSettingView : _Setting.SettingTheme andSave:NO];
}

-(void) Setting_SetupThemeSettingView : (THEME_SETTING) ThemeSetting andSave : (BOOL) Save
{
    
    if (Save) {
        [_Setting PoetrySetting_SetTheme:ThemeSetting];
    }
    
    // [CASPER] Add for iPad Ver
    _NowReadingText = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
    
    switch (ThemeSetting) {
            
        case THEME_LIGHT_DARK:
            IPAD_READING_VIEW_LOG(@"THEME_LIGHT_DARK");
            //THEME_LIGHT_DARK = 0x00,    // Font color = Black, Background = White
            _ThemePreViewLab.backgroundColor = [UIColor whiteColor];
            _ThemePreViewLab.textColor = [UIColor blackColor];
            _ThemePreViewLab.text = _NowReadingText;
            break;
            
        case THEME_DARK_LIGHT:
            IPAD_READING_VIEW_LOG(@"THEME_DARK_LIGHT");
            
            //THEME_LIGHT_DARK = 0x01,    // Font color = White, Background = Black
            _ThemePreViewLab.backgroundColor = [UIColor blackColor];
            _ThemePreViewLab.textColor = [UIColor whiteColor];
            _ThemePreViewLab.text = _NowReadingText;
            
            
            break;
            
    }
}



-(void) LightDarkBtnClicked
{
    [self Setting_SetupThemeSettingView:THEME_LIGHT_DARK andSave:YES];
}

-(void) DarkLightBtnClicked
{
    [self Setting_SetupThemeSettingView:THEME_DARK_LIGHT andSave:YES];
}



@end
