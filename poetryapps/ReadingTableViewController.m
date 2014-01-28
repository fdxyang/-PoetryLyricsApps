//
//  ReadingTableViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/13.
//  Copyright (c) 2014年 cc. All rights reserved.
//
// 20140123 [CASPER] Add poetry parser


#import "ReadingTableViewController.h"
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"
#import "ILTranslucentView.h"

#define UI_READING_TABLEVIEW_INIT_RECT_4_INCH       CGRectMake(0, UI_IOS7_NAV_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)
#define UI_READING_TABLEVIEW_INIT_RECT_3_5_INCH     CGRectMake(0, UI_IOS7_NAV_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)

#define UI_READING_TUTORIAL_IMG_RECT                CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH)
//#define UI_READING_TUORIAL_OK_BTN_RECT              CGRectMake(0, 0, 120, 30)

#define UI_NEXT_READING_TABLEVIEW_INIT_RECT_4_INCH          CGRectMake( UI_SCREEN_WIDTH, \
                                                                        UI_IOS7_NAV_BAR_HEIGHT, \
                                                                        UI_SCREEN_WIDTH, \
                                                                        UI_SCREEN_4_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)

#define UI_NEXT_READING_TABLEVIEW_INIT_RECT_3_5_INCH        CGRectMake( UI_SCREEN_WIDTH, \
                                                                        UI_IOS7_NAV_BAR_HEIGHT, \
                                                                        UI_SCREEN_WIDTH, \
                                                                        UI_SCREEN_4_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)

// 2014.01.25 [CASPER] Add Turorial view
#define UI_TUTORIAL_VIEW_RECT_4_INCH                    CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT)
#define UI_TUTORIAL_VIEW_RECT_3_5_INCH                    CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT)
// 2014.01.25 [CASPER] Add Turorial view ==

#define UI_SMALL_FONT_SIZE_THRESHOLD         14
#define UI_MEDIUM_FONT_SIZE_THRESHOLD        12
#define UI_LARGE_FONT_SIZE_THRESHOLD         9

#define UI_BOLD_SMALL_FONT_SIZE_THRESHOLD    11
#define UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD   10
#define UI_BOLD_LARGE_FONT_SIZE_THRESHOLD    8

#define UI_BOLD_FONT_BIAS                    5
#define SWITCH_VIEW_THRESHOLD                40

@interface ReadingTableViewController () {
    
    UInt16                  _CurrentIndex;
    UIFont                  *_Font;
    UIFont                  *_BoldFont;
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

    ILTranslucentView       *_TutorialView;
    BOOL                    isTutorialShowed;
}

@end

@implementation ReadingTableViewController

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
    CGRect Frame;
    if (IS_IPHONE5) {
        Frame = UI_READING_TABLEVIEW_INIT_RECT_4_INCH;
    } else {
        Frame = UI_READING_TABLEVIEW_INIT_RECT_3_5_INCH;
    }
    
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
    
    _PoetryContentParser = [[Poetryparser alloc] init];
    
    _HeadAndTailLab = [[UILabel alloc] init];
    //[_HeadAndTailLab setBackgroundColor:[UIColor lightGrayColor]];
    [_HeadAndTailLab setBackgroundColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                               green:(159/255.0f)
                                                                blue:(191/255.0f)
                                                               alpha:1]];
    
    _LightBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG-GreyNote_paper.png"]];
    _DarkBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG-GreyNote_paper_Dark.png"]];
    _FontThemeColor = [[UIColor alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    _Font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_PoetrySetting.SettingFontSize];
    _BoldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:_PoetrySetting.SettingFontSize + UI_BOLD_FONT_BIAS];
    

    _HeadAndTailFlag = NO;
    _CurrentView = VIEW1;
    [_CellHeightArray removeAllObjects];
    //[_TableView1 setScrollsToTop:YES];
    _TableView1.contentOffset = CGPointMake(0, 0 - _TableView1.contentInset.top);
    [self GetNowReadingData];
    if (IS_IPHONE5) {
        [_TableView1 setFrame:UI_READING_TABLEVIEW_INIT_RECT_4_INCH];
    } else {
        [_TableView1 setFrame:UI_READING_TABLEVIEW_INIT_RECT_3_5_INCH];
    }
    [_TableView1 reloadData];
    [self.view addSubview:_TableView1];

    // 2014.01.21 [CASPER] color setting
    [self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                                                    green:(159/255.0f)
                                                                                     blue:(191/255.0f)
                                                                                    alpha:0.8]];
    // 2014.01.25 [CASPER] Add Turorial view
    isTutorialShowed = NO;
    if (_PoetrySetting.TutorialShowed == NO) {
        isTutorialShowed = YES;

        //UIButton    *OkayBtn = [[UIButton alloc] initWithFrame:UI_READING_TUORIAL_OK_BTN_RECT];
        UIImageView *TutorImg = [[UIImageView alloc] initWithFrame:UI_READING_TUTORIAL_IMG_RECT];
        
        [TutorImg setImage:[UIImage imageNamed:@"Tutor_White.png"]];

        if (IS_IPHONE5) {
            //_TutorialView = [[ILTranslucentView alloc] initWithFrame:UI_TUTORIAL_VIEW_RECT_4_INCH];
            _TutorialView = [[ILTranslucentView alloc] initWithFrame:UI_TUTORIAL_VIEW_RECT_4_INCH];

            [TutorImg setCenter:CGPointMake(UI_SCREEN_WIDTH / 2, UI_SCREEN_4_INCH_HEIGHT / 2 )];
            //[OkayBtn setCenter:CGPointMake(UI_SCREEN_WIDTH / 2, TutorImg.frame.origin.y - 35)];
        } else {
            _TutorialView = [[ILTranslucentView alloc] initWithFrame:UI_TUTORIAL_VIEW_RECT_3_5_INCH];
            [TutorImg setFrame:CGRectMake(0, 0, UI_READING_TUTORIAL_IMG_RECT.size.width - 40, UI_READING_TUTORIAL_IMG_RECT.size.height - 40)];
            [TutorImg setCenter:CGPointMake(UI_SCREEN_WIDTH / 2, UI_SCREEN_3_5_INCH_HEIGHT / 2)];
            //[OkayBtn setCenter:CGPointMake(UI_SCREEN_WIDTH / 2, TutorImg.frame.origin.y - 30)];
        }
        
        _TutorialView.tag = TAG_TUTORIAL_VIEW;
        
        /*
        OkayBtn.layer.cornerRadius = 5;
        OkayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        OkayBtn.layer.borderWidth = 1.0f;
        [OkayBtn.titleLabel setFrame:CGRectMake(0, 0, OkayBtn.frame.size.width, OkayBtn.frame.size.height)];
        [OkayBtn.titleLabel setText:@"我知道了"];
        OkayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [OkayBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [OkayBtn.titleLabel setHidden:NO];
         
        NSLog(@"%@", OkayBtn.titleLabel);
         */
        
        _TutorialView.userInteractionEnabled = NO; // To pass touch event to the lower level
        _TutorialView.exclusiveTouch = NO;
        _TutorialView.translucentAlpha = 0.9;
        _TutorialView.translucentStyle = UIBarStyleBlack;
        _TutorialView.translucentTintColor = [UIColor clearColor];
        _TutorialView.backgroundColor = [UIColor clearColor];
        NSLog(@"%d", _TutorialView.isExclusiveTouch);

        //[_TutorialView setBackgroundColor:[UIColor whiteColor]];
        
        //[_TutorialView addSubview:OkayBtn];
        [_TutorialView addSubview:TutorImg];
        [self.navigationController.view addSubview:_TutorialView];
        //NSLog(@"%@", _TutorialView);
        //[self.navigationController presentModalViewController:TutorialView animated:YES];

    }
    // 2014.01.25 [CASPER] Add Turorial view ==
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_TableView1 removeFromSuperview];
    [_TableView2 removeFromSuperview];
    
    // 2014.01.25 [CASPER] Add Turorial view
    if (isTutorialShowed == YES) {
        isTutorialShowed = NO;
        [_TutorialView removeFromSuperview];
        [_PoetrySetting PoetrySetting_SetTutorialViewShowed:YES];
    }
    // 2014.01.25 [CASPER] Add Turorial view ==

    
    [_PoetryDatabase PoetryCoreDataSaveIntoNowReading:_PoetryNowReading];

}


-(void) touchesBegan:(NSSet *)touches withEvents:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    NSLog(@"touchesBegan");
}



-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    NSLog(@"TEST TOUCH");
}


-(void) GetNowReadingData
{
    
    NSString *PoetryContentString;
    POETRY_CATEGORY Category;
    
    if (_PoetryDatabase.isReadingExist) {
        
        _PoetryNowReading = [_PoetryDatabase Poetry_CoreDataFetchDataInReading];
        Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
        _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
        _CurrentIndex = [[_PoetryNowReading valueForKey:POETRY_CORE_DATA_INDEX_KEY] integerValue] - 1; //Since the index in core data starts at 1
        
    } else {
        
        NSLog(@"NO READING POETRY, GET THE 1st POETRY in GUARD READING");
        _PoetryNowReading = (NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS] objectAtIndex:0];
        
        Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
        _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
        _CurrentIndex = 0;
        
    }
    
    self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
    
    // 20140123 [CASPER] Add poetry parser
    
    if (Category == POETRYS) {

        PoetryContentString = [_PoetryContentParser parseContentBySymbolAndAdjustFontSize2:[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY] Fontsize:_PoetrySetting.SettingFontSize];


        //NSLog(@"%@", PoetryContentString);
    } else {
        
        PoetryContentString = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY];
        
    }
     

    // 20140123 [CASPER] Add poetry parser ==

    _ReadingTableArray1 = [NSMutableArray arrayWithArray:
                                [PoetryContentString componentsSeparatedByString:@"\n"]];
    
    
    _NavigationTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _NavigationTitleLab.text = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
    _NavigationTitleLab.backgroundColor = [UIColor clearColor];
    _NavigationTitleLab.font = [UIFont boldSystemFontOfSize:16.0];
    _NavigationTitleLab.textAlignment = NSTextAlignmentCenter;
    _NavigationTitleLab.textColor = [UIColor whiteColor]; // change this color

//    _NavigationTitleLab.textColor = [[UIColor alloc] initWithRed:(247/255.0f) green:(243/255.0f) blue:(205/255.0f) alpha:1]; // change this color
    self.navigationItem.titleView = _NavigationTitleLab;
    CGSize Size = CGSizeMake(280, 200);
    Size = [_NavigationTitleLab sizeThatFits:Size];
    [_NavigationTitleLab setFrame:CGRectMake(0, 0, 280, Size.height)];
    
}

#pragma mark - Table view data source
/*
-(NSString*) JudgeTheFinalMarkShouldBeRemoved : (NSString*) ContentStrInCell
{
    NSString *ContentStr;
    NSUInteger Threshold = 0;
    
    UInt16      TextLength;
    BOOL        isAttrCell = NO;
    
    TextLength = [ContentStr length];
    
    if ([ContentStr hasPrefix:@"@@"]) {
        ContentStr = [ContentStr stringByReplacingOccurrencesOfString:@"@@" withString:@""];
        TextLength = TextLength - [@"@@" length];
        isAttrCell = YES;
    }
    
    if (isAttrCell) {
        
        switch (_PoetrySetting.SettingFontSize) {
            case POETRY_SETIING_FONT_SIZE_SMALL:
                if (( TextLength >= UI_BOLD_SMALL_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_MEDIUM:
                if (( TextLength >= UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    
                    
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_LARGE:
                if (( TextLength >= UI_BOLD_LARGE_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                }
                break;
                
            default:
                break;
        }
        
    } else {
        
        switch (_PoetrySetting.SettingFontSize) {
            case POETRY_SETIING_FONT_SIZE_SMALL:
                if (( TextLength >= UI_SMALL_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_MEDIUM:
                if (( TextLength >= UI_MEDIUM_FONT_SIZE_THRESHOLD) && TextLength != 0) {

                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_LARGE:
                if (( TextLength >= UI_LARGE_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    
                }
                break;
                
            default:
                break;
        }
        
    }
    
    
    return ContentStr;
}
*/
//
// Calculating line number for each cell in table view
// accroding to the threshold for every kind of font size
//
/*
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
                if (( TextLength > UI_BOLD_SMALL_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    
                    if ((TextLength % UI_BOLD_SMALL_FONT_SIZE_THRESHOLD) == 0) {
                        LineNumber = (TextLength / UI_BOLD_SMALL_FONT_SIZE_THRESHOLD);
                    } else {
                        LineNumber = ((TextLength / UI_BOLD_SMALL_FONT_SIZE_THRESHOLD) + 1);
                    }
                    
                    
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_MEDIUM:
                if (( TextLength > UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    
                    if ((TextLength % UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD) == 0) {
                        LineNumber = (TextLength / UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD);
                    } else {
                        LineNumber = ((TextLength / UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD) + 1);
                    }
                    
                    

                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_LARGE:
                if (( TextLength > UI_BOLD_LARGE_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    
                    if ((TextLength % UI_BOLD_LARGE_FONT_SIZE_THRESHOLD) == 0) {
                        LineNumber = (TextLength / UI_BOLD_LARGE_FONT_SIZE_THRESHOLD);
                    } else {
                        LineNumber = ((TextLength / UI_BOLD_LARGE_FONT_SIZE_THRESHOLD) + 1);
                    }
                    
                }
                break;
                
            default:
                break;
        }

    } else {
        
        switch (_PoetrySetting.SettingFontSize) {
            case POETRY_SETIING_FONT_SIZE_SMALL:
                if (( TextLength > UI_SMALL_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    
                    if ((TextLength % UI_SMALL_FONT_SIZE_THRESHOLD) == 0) {
                        LineNumber = (TextLength / UI_SMALL_FONT_SIZE_THRESHOLD);
                    } else {
                        LineNumber = ((TextLength / UI_SMALL_FONT_SIZE_THRESHOLD) + 1);
                    }
                    
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_MEDIUM:
                if (( TextLength > UI_MEDIUM_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    
                    if ((TextLength % UI_MEDIUM_FONT_SIZE_THRESHOLD) == 0) {
                        LineNumber = (TextLength / UI_MEDIUM_FONT_SIZE_THRESHOLD);
                    } else {
                        LineNumber = ((TextLength / UI_MEDIUM_FONT_SIZE_THRESHOLD) + 1);
                    }
                    
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_LARGE:
                if (( TextLength > UI_LARGE_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    
                    if ((TextLength % UI_LARGE_FONT_SIZE_THRESHOLD) == 0) {
                        LineNumber = (TextLength / UI_LARGE_FONT_SIZE_THRESHOLD);
                    } else {
                        LineNumber = ((TextLength / UI_LARGE_FONT_SIZE_THRESHOLD) + 1);
                    }
                    
                    
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
    } else {
        return [_ReadingTableArray2 count];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSString    *ContentStr;
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (tableView.tag == 1) {
        
        ContentStr = [_ReadingTableArray1 objectAtIndex:indexPath.row];

        if ([ContentStr hasPrefix:@"@@"]) {

            ContentStr = [ContentStr stringByReplacingOccurrencesOfString:@"@@" withString:@""];
            cell.textLabel.font = _BoldFont;

        } else {
            
            cell.textLabel.font = _Font;
            
        }
        
        // 20140123 [CASPER]
        //NSLog(@"%@", ContentStr);
        ContentStr = [ContentStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = ContentStr;
        cell.textLabel.textColor = _FontThemeColor;
        
    } else {
        
       ContentStr = [_ReadingTableArray2 objectAtIndex:indexPath.row];
        
        if ([ContentStr hasPrefix:@"@@"]) {
            
            ContentStr = [ContentStr stringByReplacingOccurrencesOfString:@"@@" withString:@""];
            cell.textLabel.font = _BoldFont;
            
        } else {
            
            cell.textLabel.font = _Font;
            
        }
        
        // 20140123 [CASPER]
        //NSLog(@"%@", ContentStr);
        ContentStr = [ContentStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = ContentStr;
        cell.textLabel.textColor = _FontThemeColor;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat     Height = 0;
    NSString    *ContentStr;
    NSString    *Keyword = @"@@";
//    UInt16      LineNumber;

    
    
    UILabel *TempLabel = [[UILabel alloc] init];
    CGSize Size = CGSizeMake(280, 2000);
    
    if (tableView.tag == 1) {
        ContentStr = [_ReadingTableArray1 objectAtIndex:indexPath.row];
    } else {
        ContentStr = [_ReadingTableArray2 objectAtIndex:indexPath.row];
    }
    
    if ([ContentStr hasPrefix:Keyword]) {
        
        
        
        [TempLabel setFont:_BoldFont];
        ContentStr = [ContentStr stringByReplacingOccurrencesOfString:Keyword withString:@""];
        TempLabel.text = ContentStr;
        TempLabel.numberOfLines = 0;
        Size = [TempLabel sizeThatFits:Size];
        //NSLog(@"%@",_Font);
        //NSLog(@"text length = %d Index path = %d Size height = %f", [ContentStr length], indexPath.row, Size.height);
        
        if (Size.height == 0) {
            Height = (_PoetrySetting.SettingFontSize + 10);
        } else {
            Height = Size.height + 10;
        }

    } else {
        
        
        [TempLabel setFont:_Font];
        TempLabel.text = ContentStr;
        TempLabel.numberOfLines = 0;
        Size = [TempLabel sizeThatFits:Size];
        //NSLog(@"%@",_Font);
        //NSLog(@"text length = %d Index path = %d Size height = %f", [ContentStr length], indexPath.row, Size.height);
        
        if (Size.height == 0) {
            Height = (_PoetrySetting.SettingFontSize + 10);
        } else {
            Height = Size.height + 10;
        }

    }
        /*
    LineNumber = [self CalculateLineNumberWithContentString:ContentStr];
    
    if ([ContentStr hasPrefix:Keyword]) {

        Height = (_PoetrySetting.SettingFontSize + 20) * LineNumber;
        if (LineNumber > 1) {
            Height = Height - 10;
        }
        
    } else {
        
        Height = (_PoetrySetting.SettingFontSize + 10) * LineNumber;
        if (LineNumber > 1) {
            Height = Height - 5;
        }
        
    }
     */
    // NSLog(@"Height = %f", Height);
    return Height;
}

#pragma mark - Gesture recognizer

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
    POETRY_CATEGORY Category;

    
    if (NewPoetry != nil) {
        ContentStr = [NewPoetry valueForKey:POETRY_CORE_DATA_CONTENT_KEY];
    }
    
    // 20140123 [CASPER] Add poetry parser
    
    Category = (POETRY_CATEGORY)[[NewPoetry valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];

    if (Category == POETRYS) {
        ContentStr = [_PoetryContentParser parseContentBySymbolAndAdjustFontSize2:ContentStr Fontsize:_PoetrySetting.SettingFontSize];

    }
    
    // 20140123 [CASPER] Add poetry parser ==

    
    if (_CurrentView == VIEW1) {
        
        [_ReadingTableArray2 removeAllObjects];
        _ReadingTableArray2 = [NSMutableArray arrayWithArray:
                               [ContentStr componentsSeparatedByString:@"\n"]];
        [_TableView2 reloadData];

    } else {
        
        [_ReadingTableArray1 removeAllObjects];
        _ReadingTableArray1 = [NSMutableArray arrayWithArray:
                               [ContentStr componentsSeparatedByString:@"\n"]];
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
    if (isTutorialShowed) {
        [_PoetrySetting PoetrySetting_SetTutorialViewShowed:YES];
        [_TutorialView removeFromSuperview];
        isTutorialShowed = NO;
        return NO;
    }
    return YES;
}


- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
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
    
    if (IS_IPHONE5) {
        DefaultFrame = UI_READING_TABLEVIEW_INIT_RECT_4_INCH;
        NextPoetryFrame = UI_NEXT_READING_TABLEVIEW_INIT_RECT_4_INCH;
    } else {
        DefaultFrame = UI_READING_TABLEVIEW_INIT_RECT_3_5_INCH;
        NextPoetryFrame = UI_NEXT_READING_TABLEVIEW_INIT_RECT_3_5_INCH;
    }
    
    switch (_ViewMovementState) {
            
        case DirectionJudgement:

            if ((location.x - _TouchInit.x) > 0) {
                
                // PREV
                [TheOtherView setFrame:DefaultFrame];
                //[TheOtherView setScrollsToTop:YES];
                TheOtherView.contentOffset = CGPointMake(0, 0 - TheOtherView.contentInset.top);
                _SlideDirection = SlideLabelLeftToRigth;

                [self GetNewPoetryByGestureDirection];
                
                if (_HeadAndTailFlag) {
                    
                    [_HeadAndTailLab setHidden:NO];
                    [_HeadAndTailLab setText:@" 最前一頁"];
                    [_HeadAndTailLab setFrame:DefaultFrame];
                    [_HeadAndTailLab setFont:_Font];
                    [_HeadAndTailLab setTextColor:[UIColor whiteColor]];
                    [_HeadAndTailLab setShadowColor:[UIColor lightGrayColor]];
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
                    [_HeadAndTailLab setText:@" 最後一頁"];
                    [_HeadAndTailLab setFrame:NextPoetryFrame];
                    [_HeadAndTailLab setFont:_Font];
                    [_HeadAndTailLab setTextColor:[UIColor whiteColor]];
                    [_HeadAndTailLab setShadowColor:[UIColor lightGrayColor]];
                    [self.view insertSubview:_HeadAndTailLab aboveSubview:CurrentView];
                    
                } else {
                    
                    [TheOtherView setFrame:NextPoetryFrame];
                    //[TheOtherView setScrollsToTop:YES];
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
    
    if (IS_IPHONE5) {
        DefaultFrame = UI_READING_TABLEVIEW_INIT_RECT_4_INCH;
        NextPoetryFrame = UI_NEXT_READING_TABLEVIEW_INIT_RECT_4_INCH;
    } else {
        DefaultFrame = UI_READING_TABLEVIEW_INIT_RECT_3_5_INCH;
        NextPoetryFrame = UI_NEXT_READING_TABLEVIEW_INIT_RECT_3_5_INCH;
    }

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
            
            [UIView animateWithDuration:0.1
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
            
            [UIView animateWithDuration:0.1
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

@end
