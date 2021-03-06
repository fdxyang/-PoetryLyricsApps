//
//  ReadingViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "ReadingViewController.h"
#import "General.h"


#define UI_READING_SCROLLER_RECT_4_INCH  CGRectMake(0, UI_IOS7_NAV_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)

#define UI_READING_SCROLLER_RECT_3_5_INCH  CGRectMake(0, UI_IOS7_NAV_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)

#define UI_HEAD_TAIL_LAB_RECT_4_INCH     CGRectMake(10, UI_IPHONE_SCREEN_HEIGHT_4_INCH/2, UI_IPHONE_SCREEN_WIDTH, 50)

// 20151017 [Casper] Add bookmark function
//#define READING_BOOKMARK_FRAME CGRectMake(UI_SCREEN_WIDTH - 40.0f - 10.0f, 0, 40.0f, 40.0f)


@interface ReadingViewController (){
    
    CGSize                  _LabelSizeInit;
    CGPoint                 _TouchInit;
    //CURRENT_LABEL           _CurrentLab;
    SLIDE_DIRECTION         _SlideDirection;

    BOOL                    _DataFlag;
    BOOL                    _GetSlideInLabel;
    BOOL                    _CrossCategoryFlag;

    // To indicate that the poetry is the first and the last one, and it can not be executed PREV / NEXT
    BOOL                    _HeadAndTailFlag;
    BOOL                    _ConfirmToSwitch;

    CURRENT_VIEW            _CurrentView;
    UInt16                  _CurrentIndex;
    NSMutableArray          *TempPoetryList;
    
    UIColor                 *_LightBackgroundColor;
    UIColor                 *_DarkBackgroundColor;


}



@end

@implementation ReadingViewController

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
    
    _PoetryDatabase = [[PoetryCoreData alloc] init];
    _PoetrySetting = [[PoetrySettingCoreData alloc] init];
    
    // GestureRecognize
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    
    [self.view addGestureRecognizer:panRecognizer];
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;

}



-(void)viewWillAppear:(BOOL)animated
{
    //[_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
    
    // Read Setting
    _font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_PoetrySetting.SettingFontSize];
    _BoldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:_PoetrySetting.SettingFontSize + 4];

    _DisplayTheme = _PoetrySetting.SettingTheme;
    _SlideDirection = SlideLabelNone;
    _LabelSizeInit = CGSizeMake(UI_DEFAULT_LABEL_WIDTH, 0);
    _CurrentView = VIEW1;
    _GetSlideInLabel = NO;
    _DataFlag = NO;
    _CrossCategoryFlag = NO;
    _HeadAndTailFlag = NO;
    _ConfirmToSwitch = NO;
    
    /*
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    if (_HeadAndTailLabel == nil) {
        _HeadAndTailLabel = [[UILabel alloc] initWithFrame:UI_HEAD_TAIL_LAB_RECT_4_INCH];
    }

    [_HeadAndTailLabel setBackgroundColor:[UIColor clearColor]];
    [_HeadAndTailLabel setTextColor:[UIColor whiteColor]];
    [_HeadAndTailLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:26]];
    [_HeadAndTailLabel setText:@"最前的一首"];
    [_HeadAndTailLabel setTextAlignment:NSTextAlignmentLeft];
    [Animations shadowOnView:_HeadAndTailLabel andShadowType:@"SHADOW"];

    [self.view addSubview:_HeadAndTailLabel];
    NSLog(@"%@", _HeadAndTailLabel);
    */
    _LightBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Light_bgiPhone.png"]];
    _DarkBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Dark_bgiPhone.png"]];

    if (_ReadingView1 == nil) {
        _ReadingView1 = [[PoetryReadingView alloc] init];
        //[_ReadingView1 setBackgroundColor:_LightBackgroundColor];
        //[Animations shadowOnView:_ReadingView1 andShadowType:@"SHADOW"];
    }
    
    if (_ReadingView2 == nil) {
        _ReadingView2 = [[PoetryReadingView alloc] init];
        //[_ReadingView2 setBackgroundColor:_LightBackgroundColor];

        //[Animations shadowOnView:_ReadingView2 andShadowType:@"SHADOW"];
    }
    
    [self InitReadingViewSetupScroller];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    READING_VIEW_LOG(@"ViewDidDisappear - save reading");
    
    [_ReadingView1 removeFromSuperview];
    [_ReadingView2 removeFromSuperview];
    
   
    [_PoetryDatabase PoetryCoreDataSaveIntoNowReading:_PoetryNowReading];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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


-(void)InitReadingViewSetupScroller
{
    
    if (_PoetryDatabase.isReadingExist) {
        
        _PoetryNowReading = [_PoetryDatabase Poetry_CoreDataFetchDataInReading];
        POETRY_CATEGORY Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
        _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
        _CurrentIndex = [[_PoetryNowReading valueForKey:POETRY_CORE_DATA_INDEX_KEY] integerValue] - 1; //Since the index in core data starts at 1
        
    } else {
        
        READING_VIEW_LOG(@"NO READING POETRY, GET THE 1st POETRY in GUARD READING");
        _PoetryNowReading = (NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS] objectAtIndex:0];
        
        //TODO: Modify the Category after all poetry ready.
        POETRY_CATEGORY Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
        _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
        _CurrentIndex = 0;

    }
    READING_VIEW_LOG(@"_CurrentIndex = %d", _CurrentIndex);

    // Init View1 for first launch
    _ReadingView1 = [self DisplayHandlingWithData:_PoetryNowReading onView:_ReadingView1];
    self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
    //[_ReadingView1 setBackgroundColor:[UIColor clearColor]];
    READING_VIEW_LOG(@"init _ReadingView1 = %@", _ReadingView1);
    
    
    [self.view addSubview: _ReadingView1];

    
}

#pragma mark - Display view handling
-(NSMutableAttributedString *) SetupStringAttrForDisplayWithContentText : (NSString*) ContentText
{
    READING_VIEW_LOG(@"SetupStringAttrForDisplayWithContentText");
    
    //TODO : Find @@ line
    UIFont *BoldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:_PoetrySetting.SettingFontSize];
    NSArray *Lines = [ContentText componentsSeparatedByString:@"\n"];
    
    NSRange AttrRange = NSMakeRange(0, 0);
    NSRange StringRange = NSMakeRange(0, 0);
    NSRange KeyWord2Range = NSMakeRange(0, 0);
    NSMutableArray *RangeArray = [[NSMutableArray alloc] init];
    
    NSString *KeyWord1 = @"@@";
    NSString *KeyWord2 = @"（";
    //NSString *KeyWord2 = @"亻因";
    // Find "@@" and save range
    
    UInt16 KeyWord2Count = 0;
    
    for (int i = 0; i < [Lines count]; i++) {
        
        StringRange = NSMakeRange(0, 0);
        StringRange = [[Lines objectAtIndex:i] rangeOfString:KeyWord1];
        
        if (StringRange.length != 0) {
            
            //[CASPER] 2013.12.25 Fix Bold font bug
            StringRange.location = StringRange.location + AttrRange.location + 2;

            // To Handle "("
            KeyWord2Range = [[Lines objectAtIndex:i] rangeOfString:KeyWord2];
            
            if (KeyWord2Range.length != 0) {
                KeyWord2Count ++;
                
                StringRange.location = StringRange.location - 2;
                StringRange.length = ([[Lines objectAtIndex:i] length]);
                AttrRange.location = AttrRange.location - 1;
                
            } else {
                
                StringRange.length = ([[Lines objectAtIndex:i] length] - 1 + KeyWord2Count);
                
            }
            
            

            //[CASPER] 2013.12.25 Fix Bold font bug ==
            [RangeArray addObject:[NSValue valueWithRange:StringRange]];
            
        }
        
        AttrRange.location = AttrRange.location + ([[Lines objectAtIndex:i] length]);
        
    }

    // Remove @@ and add attribute
    ContentText = [ContentText stringByReplacingOccurrencesOfString:KeyWord1 withString:@""];
        //ContentText = [ContentText stringByReplacingOccurrencesOfString:@"[" withString:@""];
        //ContentText = [ContentText stringByReplacingOccurrencesOfString:@"]" withString:@""];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:ContentText];
    
    // Add General Attribute
    AttrRange = NSMakeRange(0, [ContentText length]);
    [string addAttribute:NSKernAttributeName value:[NSNumber numberWithInt:1]range:AttrRange];
//    [string addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithInt:2]range:AttrRange];
    

    if ([RangeArray count] != 0) {
        
        for (int i = 0; i < [RangeArray count]; i++) {
            AttrRange = NSMakeRange(0, 0);

            AttrRange = [[RangeArray objectAtIndex:i] rangeValue];
            if ((AttrRange.location + AttrRange.length) > [ContentText length]) {
                AttrRange.length = [ContentText length] - AttrRange.location;
            }
            
            [string addAttribute:NSFontAttributeName value:BoldFont range:AttrRange];
        }
    }
    
    
/*
    // Find [亻因]
    [RangeArray removeAllObjects];
    StringRange = NSMakeRange(0, 0);
    AttrRange = NSMakeRange(0, 0);
    
    StringRange = [ContentText rangeOfString:KeyWord2];
    
    if (StringRange.length != 0) {
        for (int i = 0; i < [Lines count]; i++) {
            
            StringRange = NSMakeRange(0, 0);
            StringRange = [[Lines objectAtIndex:i] rangeOfString:KeyWord2];
            if (StringRange.length != 0 ) {
                
                StringRange.location = AttrRange.location + StringRange.location;
                [RangeArray addObject:[NSValue valueWithRange:StringRange]];
                NSLog(@"亻因 location = %d langth = %d", StringRange.location, StringRange.length);
            }
            AttrRange.location = AttrRange.location + [[Lines objectAtIndex:i] length];
        }
    }
 
    if ([RangeArray count] != 0) {
        for (int i = 0; i < [RangeArray count]; i++) {
            
            NSRange TempRange = [[RangeArray objectAtIndex:i] rangeValue];
            [string addAttribute:NSKernAttributeName value:[NSNumber numberWithInt:0] range:TempRange];

        }

    }
 
   */
    
    return string;
}

- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}
-(PoetryReadingView *) DisplayHandlingWithData :(NSDictionary*) PoetryData onView : (PoetryReadingView*) PoetryReadingView
{
 
    // [CASPER] 20131230
    if (PoetryReadingView.Scroller == nil) {
        PoetryReadingView.Scroller = [[UIScrollView alloc] init];
    }
    if (IS_IPHONE5) {
        PoetryReadingView.Scroller.frame = UI_READING_SCROLLER_RECT_4_INCH;
    } else {
        PoetryReadingView.Scroller.frame = UI_READING_SCROLLER_RECT_3_5_INCH;
    }
    
    [PoetryReadingView.Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];

    if (PoetryReadingView.ContentTextLabel == nil) {
        PoetryReadingView.ContentTextLabel = [[UILabel alloc] init];
    }
    
    [PoetryReadingView.ContentTextLabel setFont:_font];
    [PoetryReadingView.ContentTextLabel setBackgroundColor:[UIColor clearColor]];
    PoetryReadingView.ContentTextLabel.numberOfLines = 0;
    [PoetryReadingView.ContentTextLabel setAttributedText:[self SetupStringAttrForDisplayWithContentText:[PoetryData valueForKey:POETRY_CORE_DATA_CONTENT_KEY]]];
    // [CASPER] 2013.12.23 ==
    
    CGSize constraint = CGSizeMake(UI_DEFAULT_LABEL_WIDTH, 20000.0f);
    
    _LabelSizeInit = [PoetryReadingView.ContentTextLabel sizeThatFits:constraint];
    
    if (_DisplayTheme == THEME_LIGHT_DARK) {
        
        // Font color = Black, Background = White
        PoetryReadingView.ContentTextLabel.textColor = [UIColor blackColor];
        [PoetryReadingView setBackgroundColor:_LightBackgroundColor];
        
    } else {
        
        // Font color = Black, Background = White
        PoetryReadingView.ContentTextLabel.textColor = [UIColor whiteColor];
        [PoetryReadingView setBackgroundColor:_DarkBackgroundColor];
        
    }
    CGFloat ViewHeight = _LabelSizeInit.height;
        [PoetryReadingView.ContentTextLabel setFrame:CGRectMake(20, 0, _LabelSizeInit.width, _LabelSizeInit.height)];
    
    READING_VIEW_LOG(@"PoetryReadingView.ContentTextLabel = %@", PoetryReadingView.ContentTextLabel);
   
    if (IS_IPHONE5) {
        if (ViewHeight< (UI_SCREEN_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)) {
            ViewHeight = (UI_SCREEN_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT);
        }
    } else {
        if (ViewHeight< (UI_SCREEN_3_5_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)) {
            ViewHeight = (UI_SCREEN_3_5_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT);
        }
    }
    
    [PoetryReadingView.Scroller setContentSize:CGSizeMake(UI_SCREEN_WIDTH, ViewHeight + 30)]; //[CASPER] For margin buff
    [PoetryReadingView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, ViewHeight)];
    return PoetryReadingView;
    
}

-(PoetryReadingView *) PlaceEmptyViewForSlideDirection : (SLIDE_DIRECTION) SlideDirection
{
    if (_EmptyReadingView == nil) {
        _EmptyReadingView = [[PoetryReadingView alloc] init];
    }
    
    //[_EmptyReadingView addSubview:_EmptyReadingView.ContentTextLabel];
    
    [_EmptyReadingView setBackgroundColor:[UIColor colorWithRed:(242/255.0f) green:(243/255.0f) blue:(224/255.0f) alpha:1]];
    
    _EmptyReadingView.ContentTextLabel.backgroundColor = [UIColor clearColor];
    _EmptyReadingView.ContentTextLabel.textColor = [UIColor grayColor];
    _EmptyReadingView.ContentTextLabel.font = _font;
    
    if (SlideDirection == SlideLabelLeftToRigth) {
        
        // PREV
        READING_VIEW_LOG(@"The most first poetry, try to init view below");
        _EmptyReadingView.ContentTextLabel.frame = CGRectMake(10, 200, UI_SCREEN_WIDTH, 50);
        _EmptyReadingView.ContentTextLabel.text = @"最前的一首";
        [_EmptyReadingView addSubview:_EmptyReadingView.ContentTextLabel];
        
    } else {
        //NEXT
        READING_VIEW_LOG(@"The latest poetry, try to init view ");
        if (IS_IPHONE5) {
            _EmptyReadingView.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, 0, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT);
        } else {
            _EmptyReadingView.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, 0, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT);
        }
        _EmptyReadingView.ContentTextLabel.frame = CGRectMake(10, 200, UI_SCREEN_WIDTH, 50);
        [_EmptyReadingView addSubview:_EmptyReadingView.ContentTextLabel];
        _EmptyReadingView.ContentTextLabel.text = @"最後的一首";
    
    }
    
    return _EmptyReadingView;
}


#pragma mark - Gesture Recognizer Method

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return YES;
}


-(PoetryReadingView *) HandleGestureWith:(UIPanGestureRecognizer *)recognizer andHandledView : (PoetryReadingView *) View
{
    CGPoint location = [recognizer locationInView:_Scroller];
    
    
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
                        [_ReadingView1 setFrame:CGRectMake(0, 0, _ReadingView1.frame.size.width, _ReadingView1.frame.size.height)];
                    } else {
                        [_ReadingView2 setFrame:CGRectMake(0, 0, _ReadingView2.frame.size.width, _ReadingView2.frame.size.height)];
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

                            // TODO: Add this view between Current view and Scroller
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

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    //拿到手指目前的位置
    
    
    
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



@end
