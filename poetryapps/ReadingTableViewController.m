//
//  ReadingTableViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/13.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "ReadingTableViewController.h"
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"

#define UI_READING_TABLEVIEW_INIT_RECT_4_INCH       CGRectMake(0, UI_IOS7_NAV_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)
#define UI_READING_TABLEVIEW_INIT_RECT_3_5_INCH     CGRectMake(0, UI_IOS7_NAV_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)

#define UI_NEXT_READING_TABLEVIEW_INIT_RECT_4_INCH          CGRectMake( UI_SCREEN_WIDTH, \
                                                                        UI_IOS7_NAV_BAR_HEIGHT, \
                                                                        UI_SCREEN_WIDTH, \
                                                                        UI_SCREEN_4_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT - 10)

#define UI_NEXT_READING_TABLEVIEW_INIT_RECT_3_5_INCH        CGRectMake( UI_SCREEN_WIDTH, \
                                                                        UI_IOS7_NAV_BAR_HEIGHT, \
                                                                        UI_SCREEN_WIDTH, \
                                                                        UI_SCREEN_4_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT - 10)
// -10 is the buffer for the bottom of the table view

#define UI_SMALL_FONT_SIZE_THRESHOLD         14
#define UI_MEDIUM_FONT_SIZE_THRESHOLD        12
#define UI_LARGE_FONT_SIZE_THRESHOLD         10

#define UI_BOLD_SMALL_FONT_SIZE_THRESHOLD    11
#define UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD   10
#define UI_BOLD_LARGE_FONT_SIZE_THRESHOLD    8

#define UI_BOLD_FONT_BIAS               5
#define SWITCH_VIEW_THRESHOLD           40

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
    BOOL                    _DataFlag;
    BOOL                    _GetSlideInLabel;
    BOOL                    _CrossCategoryFlag;
    BOOL                    _HeadAndTailFlag;
    BOOL                    _ConfirmToSwitch;

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
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    
    [self.view addGestureRecognizer:panRecognizer];
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;
    
    _TableView1 = [[UITableView alloc]  initWithFrame:Frame];
    _TableView2 = [[UITableView alloc]  initWithFrame:Frame];
    //_TableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_TableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _CurrentView = VIEW1;
    [_CellHeightArray removeAllObjects];
    [_TableView1 setScrollsToTop:YES];
    [self GetNowReadingData];
    if (IS_IPHONE5) {
        [_TableView1 setFrame:UI_READING_TABLEVIEW_INIT_RECT_4_INCH];
    } else {
        [_TableView1 setFrame:UI_READING_TABLEVIEW_INIT_RECT_3_5_INCH];
    }
    [_TableView1 reloadData];
    [self.view addSubview:_TableView1];
    _Font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_PoetrySetting.SettingFontSize];
    _BoldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:_PoetrySetting.SettingFontSize + UI_BOLD_FONT_BIAS];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_TableView1 removeFromSuperview];
    [_TableView2 removeFromSuperview];
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
    
    _ReadingTableArray1 = [NSMutableArray arrayWithArray:
                                [[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY] componentsSeparatedByString:@"\n"]];

}

#pragma mark - Table view data source
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
                    
                    if (( TextLength == UI_BOLD_SMALL_FONT_SIZE_THRESHOLD)
                        && (LineNumber >= 1)) {
                        LineNumber--;
                    }
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_MEDIUM:
                if (( TextLength >= UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    LineNumber = ((TextLength / UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD) + 1);
                    
                    if (( TextLength == UI_BOLD_MEDIUM_FONT_SIZE_THRESHOLD)
                        && (LineNumber >= 1)) {
                        LineNumber--;
                    }

                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_LARGE:
                if (( TextLength >= UI_BOLD_LARGE_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    LineNumber = ((TextLength / UI_BOLD_LARGE_FONT_SIZE_THRESHOLD) + 1);
                    
                    if (( TextLength == UI_BOLD_LARGE_FONT_SIZE_THRESHOLD)
                        && (LineNumber >= 1)) {
                        LineNumber--;
                    }

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
                    
                    if (( TextLength == UI_SMALL_FONT_SIZE_THRESHOLD)
                        && (LineNumber >= 1)) {
                        LineNumber--;
                    }
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_MEDIUM:
                if (( TextLength >= UI_MEDIUM_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    LineNumber = ((TextLength / UI_MEDIUM_FONT_SIZE_THRESHOLD) + 1);
                    
                    if (( TextLength == UI_MEDIUM_FONT_SIZE_THRESHOLD)
                        && (LineNumber >= 1)) {
                        LineNumber--;
                    }
                }
                break;
                
            case POETRY_SETIING_FONT_SIZE_LARGE:
                if (( TextLength >= UI_LARGE_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                    LineNumber = ((TextLength / UI_LARGE_FONT_SIZE_THRESHOLD) + 1);
                    
                    if (( TextLength == UI_LARGE_FONT_SIZE_THRESHOLD)
                        && (LineNumber >= 1)) {
                        LineNumber--;
                    }
                }
                break;
                
            default:
                break;
        }

    }
    return LineNumber;
}

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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (tableView.tag == 1) {
        
        ContentStr = [_ReadingTableArray1 objectAtIndex:indexPath.row];

        if ([ContentStr hasPrefix:@"@@"]) {

            ContentStr = [ContentStr stringByReplacingOccurrencesOfString:@"@@" withString:@""];
            cell.textLabel.font = _BoldFont;

        } else {
            
            cell.textLabel.font = _Font;
            
        }
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = ContentStr;
        
    } else {
        
       ContentStr = [_ReadingTableArray2 objectAtIndex:indexPath.row];
        
        if ([ContentStr hasPrefix:@"@@"]) {
            
            ContentStr = [ContentStr stringByReplacingOccurrencesOfString:@"@@" withString:@""];
            cell.textLabel.font = _BoldFont;
            
        } else {
            
            cell.textLabel.font = _Font;
            
        }
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = ContentStr;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat     Height = 0;
    NSString    *ContentStr;
    NSString    *Keyword = @"@@";
    
    if (tableView.tag == 1) {
        ContentStr = [_ReadingTableArray1 objectAtIndex:indexPath.row];
    } else {
        ContentStr = [_ReadingTableArray2 objectAtIndex:indexPath.row];
    }
    
    if ([ContentStr hasPrefix:Keyword]) {
        Height = (_PoetrySetting.SettingFontSize + 20) * [self CalculateLineNumberWithContentString:ContentStr];
    } else {
        Height = (_PoetrySetting.SettingFontSize + 10) * [self CalculateLineNumberWithContentString:ContentStr];
    }
    
    return Height;
}

#pragma mark - Table view data source

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
        ContentStr = @"NO MORE";
    }
    
    
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
    
    [self UpdateNewTableViewContentWithNewPoetry:_NewPoetryDic];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
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
               OnCurrentView : (UIView*) CurrentView
             andTheOtherView : (UIView*) TheOtherView
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
                       OnCurrentView : (UIView*) CurrentView
                     andTheOtherView : (UIView*) TheOtherView
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
                [self.view insertSubview:TheOtherView belowSubview:CurrentView];
                _SlideDirection = SlideLabelLeftToRigth;
                
            } else {
                
                // NEXT
                [CurrentView setFrame:DefaultFrame];
                [TheOtherView setFrame:NextPoetryFrame];
                [self.view insertSubview:TheOtherView aboveSubview:CurrentView];
                _SlideDirection = SlideLabelRightToLegt;
                
            }

            [self GetNewPoetryByGestureDirection];
            _ViewMovementState = ViewMoving;
            
            break;
        
        case ViewMoving:
            
            if ((location.x - _TouchInit.x) > 0) {
                
                // PREV
                if ( _SlideDirection != SlideLabelLeftToRigth ) {
                    _ViewMovementState = DirectionJudgement;
                }
                
                [CurrentView setFrame:CGRectMake(abs(location.x - _TouchInit.x),
                                                 DefaultFrame.origin.y,
                                                 CGRectGetWidth(DefaultFrame),
                                                 CGRectGetHeight(DefaultFrame))];

            } else {
                
                // NEXT
                if ( _SlideDirection != SlideLabelRightToLegt ) {
                    
                    _ViewMovementState = DirectionJudgement;
                    
                }
                
                [TheOtherView setFrame:CGRectMake(NextPoetryFrame.origin.x - abs(location.x - _TouchInit.x),
                                                  NextPoetryFrame.origin.y,
                                                  CGRectGetWidth(NextPoetryFrame),
                                                  CGRectGetHeight(NextPoetryFrame))];

            }
            
            
        default:
            break;
    }

}


-(void) HandleGestureEndStateWith : (CGPoint) location
                       OnCurrentView : (UIView*) CurrentView
                     andTheOtherView : (UIView*) TheOtherView
{
    _ViewMovementState = None;
    CGRect DefaultFrame;
    CGRect NextPoetryFrame;
    
    if (IS_IPHONE5) {
        DefaultFrame = UI_READING_TABLEVIEW_INIT_RECT_4_INCH;
        NextPoetryFrame = UI_NEXT_READING_TABLEVIEW_INIT_RECT_4_INCH;
    } else {
        DefaultFrame = UI_READING_TABLEVIEW_INIT_RECT_3_5_INCH;
        NextPoetryFrame = UI_NEXT_READING_TABLEVIEW_INIT_RECT_3_5_INCH;
    }

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
                             
                             if (_SlideDirection == SlideLabelLeftToRigth) {
                                 
                                 // PREV
                                 _CurrentIndex--;
                                 [CurrentView removeFromSuperview];
                                 
                                 
                             } else {
                                 
                                 // NEXT
                                 _CurrentIndex++;
                                 [CurrentView removeFromSuperview];
                             }
                             
                             NSLog(@"_CurrentIndex = %d", _CurrentIndex);
                             _PoetryNowReading = _NewPoetryDic;
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



#if 0
-(void) HandleGestureWith:(UIPanGestureRecognizer *)recognizer andHandledView : (UIView *) View
{
    CGPoint location = [recognizer locationInView:self.view];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            _TouchInit = location;
            break;
            
        case UIGestureRecognizerStateChanged:
            
            //READING_VIEW_LOG(@"MOVE --- %d" , abs(location.x - _TouchInit.x));
            
            if ((location.x - _TouchInit.x) > 0) {
                
                if ( _SlideDirection != SlideLabelLeftToRigth ) {
                    
                    // Need to reinit new view and data
                    if (_CurrentView == VIEW1) {
                        [_TableView1 setFrame:CGRectMake(0, 0, _ReadingView1.frame.size.width, _ReadingView1.frame.size.height)];
                    } else {
                        [_TableView2 setFrame:CGRectMake(0, 0, _ReadingView2.frame.size.width, _ReadingView2.frame.size.height)];
                    }
                    
                    _GetSlideInLabel = NO;
                    _DataFlag = NO;
                    _HeadAndTailFlag = NO;
                    
                }
                
                _SlideDirection = SlideLabelLeftToRigth;
                
                if (!_GetSlideInLabel) {
                    
                    READING_VIEW_LOG(@"Drag to right, use the previous poetry");
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
                                    
                                    READING_VIEW_LOG(@"Get Guard Reading list");
                                    TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:GUARD_READING];
                                    
                                } else if (RESPONSIVE_PRAYER == (POETRY_CATEGORY)[CategoryNum integerValue]) {
                                    
                                    READING_VIEW_LOG(@"Get Poetry list");
                                    TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS];
                                    
                                } else {
                                    
                                    READING_VIEW_ERROR_LOG(@"Reading view has some error, plz check");
                                    
                                }
                                
                                if (TempPoetryList != nil) {
                                    
                                    _CrossCategoryFlag = YES;
                                    _NewDataDic = [TempPoetryList lastObject];
                                    READING_VIEW_LOG(@"Get Poetry at cross category");
                                }
                                
                            } else {
                                
                                
                                // Generate empty view to notify user
                                
                                
                                READING_VIEW_LOG(@"NO DATA");
                                [self.view insertSubview:[self PlaceEmptyViewForSlideDirection:_SlideDirection] atIndex:0];
                                _HeadAndTailFlag = YES;
                                _NewDataDic = nil;
                                
                            }
                            
                            
                            
                        } else {
                            
                            // To get the previous poetry of this category
                            _NewDataDic = [_NowReadingCategoryArray objectAtIndex:(_CurrentIndex - 1)];
                            READING_VIEW_LOG(@"_NewDataDic index = %d", _CurrentIndex - 1);
                            // Height of view will be set inside the method
                        }
                        
                        if (_NewDataDic) {
                            
                            View.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 0);
                            View = [self DisplayHandlingWithData:_NewDataDic onView:View];
                            //READING_VIEW_LOG(@"View Generate = %@", View);
                            
                            if (_DisplayTheme == THEME_LIGHT_DARK) {
                                
                                // Font color = Black, Background = White
                                View.ContentTextLabel.textColor = [UIColor blackColor];
                                [View setBackgroundColor:_LightBackgroundColor];
                                //[self.view setBackgroundColor:[UIColor whiteColor]];
                                
                            } else {
                                
                                // Font color = Black, Background = White
                                View.ContentTextLabel.textColor = [UIColor whiteColor];
                                [View setBackgroundColor:_DarkBackgroundColor];
                                //[self.view setBackgroundColor:[UIColor blackColor]];
                                
                            }
                            
                            //[_Scroller addSubview:View];
                            
                            if (_CurrentView == VIEW1) {
                                
                                READING_VIEW_LOG(@"Add view below readingview1");
                                if (_DisplayTheme == THEME_LIGHT_DARK) {
                                    [_ReadingView1 setBackgroundColor:_LightBackgroundColor];
                                } else {
                                    [_ReadingView1 setBackgroundColor:_DarkBackgroundColor];
                                }
                                
                                [self.view insertSubview:View belowSubview:_ReadingView1];
                                
                            } else {
                                
                                if (_DisplayTheme == THEME_LIGHT_DARK) {
                                    [_ReadingView2 setBackgroundColor:_LightBackgroundColor];
                                } else {
                                    [_ReadingView2 setBackgroundColor:_DarkBackgroundColor];
                                }
                                
                                [self.view insertSubview:View belowSubview:_ReadingView2];
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
                
            } else if ((location.x - _TouchInit.x) < 0) {
                
                if ( _SlideDirection != SlideLabelRightToLegt ) {
                    
                    
                    // Need to reinit new view and data
                    _GetSlideInLabel = NO;
                    _DataFlag = NO;
                    _HeadAndTailFlag = NO;
                    
                }
                
                _SlideDirection = SlideLabelRightToLegt;
                
                if (!_GetSlideInLabel) {
                    
                    READING_VIEW_LOG(@"Drag to left, use the next poetry");
                    // Get the previous data and save into temp _NewDataDic for once (check DataFlag)
                    // Set Lable on the left of the screen and config it
                    
                    if (!_DataFlag) {
                        
                        if (_CurrentIndex == ([_NowReadingCategoryArray count] - 1)) {
                            
                            // Check the Category
                            NSNumber *CategoryNum = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY];
                            if (RESPONSIVE_PRAYER != (POETRY_CATEGORY)[CategoryNum integerValue]) {
                                // To get the previous category list as temp.
                                
                                if (GUARD_READING == (POETRY_CATEGORY)[CategoryNum integerValue]) {
                                    
                                    READING_VIEW_LOG(@"Get Petry Reading list");
                                    TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS];
                                    
                                } else if (POETRYS == (POETRY_CATEGORY)[CategoryNum integerValue]) {
                                    
                                    READING_VIEW_LOG(@"Get Responsive list");
                                    TempPoetryList = [_PoetryDatabase Poetry_CoreDataFetchDataInCategory:RESPONSIVE_PRAYER];
                                    
                                } else {
                                    READING_VIEW_ERROR_LOG(@"Reading view has some error, plz check");
                                }
                                
                                if (TempPoetryList != nil) {
                                    
                                    _CrossCategoryFlag = YES;
                                    _NewDataDic = [TempPoetryList firstObject];
                                    READING_VIEW_LOG(@"Get Poetry at cross category");
                                    
                                }
                                
                                
                            } else {
                                
                                // Generate empty view to notify user
                                [self.view addSubview:[self PlaceEmptyViewForSlideDirection:_SlideDirection]];
                                READING_VIEW_LOG(@"NO DATA");
                                _HeadAndTailFlag = YES;
                                _NewDataDic = nil;
                            }
                            
                        } else {
                            
                            _NewDataDic = [_NowReadingCategoryArray objectAtIndex:(_CurrentIndex + 1)];
                            READING_VIEW_LOG(@"_NewDataDic index = %d", _CurrentIndex + 1);
                        }
                        
                        
                        if (_NewDataDic) {
                            
                            // Height of view will be set inside the method
                            View.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, 0, UI_SCREEN_WIDTH, 0);
                            View = [self DisplayHandlingWithData:_NewDataDic onView:View];
                            //READING_VIEW_LOG(@"View Generate = %@", View);
                            
                            
                            if (_DisplayTheme == THEME_LIGHT_DARK) {
                                
                                // Font color = Black, Background = White
                                View.ContentTextLabel.textColor = [UIColor blackColor];
                                [View setBackgroundColor:_LightBackgroundColor];
                                //[self.view setBackgroundColor:[UIColor whiteColor]];
                                
                            } else {
                                
                                // Font color = Black, Background = White
                                View.ContentTextLabel.textColor = [UIColor whiteColor];
                                [View setBackgroundColor:_DarkBackgroundColor];
                                //[self.view setBackgroundColor:[UIColor blackColor]];
                                
                            }
                            
                            [self.view addSubview:View];
                            //[_Scroller addSubview:View];
                            
                        }
                        
                        
                        _DataFlag = YES;
                        _GetSlideInLabel = YES;
                        
                    }
                } else {
                    
                    if (_DataFlag) {
                        
                        if (_HeadAndTailFlag) {
                            
                            _EmptyReadingView.frame = CGRectMake((UI_DEFAULT_NEXT_ORIGIN_X - abs(location.x - _TouchInit.x)), _EmptyReadingView.frame.origin.y, _EmptyReadingView.frame.size.width, _EmptyReadingView.frame.size.height);
                            
                        } else {
                            
                            // Move the label follow gesture
                            View.frame = CGRectMake((UI_DEFAULT_NEXT_ORIGIN_X - abs(location.x - _TouchInit.x)), View.frame.origin.y, View.frame.size.width, View.frame.size.height);
                            
                        }
                        
                        
                    }
                }
            } else {
                READING_VIEW_ERROR_LOG(@"(location.x - _TouchInit.x) !!!!!?");
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (_DataFlag) {
                
                if (_HeadAndTailFlag) {
                    
                    // View transtion not complete
                    READING_VIEW_LOG(@"Head and tail flag!!!");
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
                                             
                                             View.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, View.frame.origin.y, View.frame.size.width, View.frame.size.height);
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
                    
                    if (abs(location.x - _TouchInit.x) > SWITCH_VIEW_THRESHOLD) {
                        
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
                            
                            READING_VIEW_LOG(@"_ConfirmToSwitch !!!! ");
                            // View transtion complete
                            [UIView animateWithDuration:0.2
                                             animations:^{
                                                 
                                                 if (_SlideDirection == SlideLabelLeftToRigth) {
                                                     
                                                     // Move view out of the screen
                                                     if (_CurrentView == VIEW1) {
                                                         
                                                         _ReadingView1.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, 0, View.frame.size.width, View.frame.size.height);
                                                         
                                                     } else {
                                                         
                                                         _ReadingView2.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, 0, View.frame.size.width, View.frame.size.height);
                                                     }
                                                     
                                                 } else {
                                                     
                                                     
                                                     // Set Label in the normal location
                                                     View.frame = CGRectMake(0, 0, View.frame.size.width, View.frame.size.height);
                                                     
                                                     
                                                 }
                                                 
                                             }
                                             completion:^(BOOL finished) {
                                                 
                                                 if (_CrossCategoryFlag) {
                                                     
                                                     //[_NowReadingCategoryArray removeAllObjects];
                                                     
                                                     READING_VIEW_LOG(@"!!!!!!!! ASSIGN TempPoetryList to _NowReadingCategoryArray");
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
                                                     
                                                     READING_VIEW_LOG(@"move done remove label 1");
                                                     
                                                     [_ReadingView1 removeFromSuperview];
                                                     //[View setBackgroundColor:[UIColor clearColor]];
                                                     
                                                     _CurrentView = VIEW2;
                                                     _PoetryNowReading = _NewDataDic;
                                                     
                                                     self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
                                                     //[_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
                                                     
                                                     _DataFlag = NO;
                                                     _GetSlideInLabel = NO;
                                                     
                                                 } else {
                                                     
                                                     READING_VIEW_LOG(@"move done remove label 2");
                                                     [_ReadingView2 removeFromSuperview];
                                                     //[View setBackgroundColor:[UIColor clearColor]];
                                                     
                                                     _CurrentView = VIEW1;
                                                     _PoetryNowReading = _NewDataDic;
                                                     
                                                     self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
                                                     //[_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
                                                     _DataFlag = NO;
                                                     _GetSlideInLabel = NO;
                                                     _ConfirmToSwitch = NO;
                                                 }
                                                 [_PoetryDatabase PoetryCoreDataSaveIntoNowReading:_PoetryNowReading];
                                                 
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
                        READING_VIEW_LOG(@"back to out of screen!!!");
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
                                                 
                                                 View.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, View.frame.origin.y, View.frame.size.width, View.frame.size.height);
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
            break;
        case UIGestureRecognizerStateCancelled:
        {
            READING_VIEW_LOG(@"!!!!UIGestureRecognizerStateCancelled");
        }
            
            
        default:
            break;
    }
    return View;
}

#endif
@end
