//
//  ReadingViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "ReadingViewController.h"

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
 
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    _PoetryDatabase = [[PoetryCoreData alloc] init];
    _PoetrySetting = [[PoetrySettingCoreData alloc] init];
    
    if (_Scroller == nil) {
        _Scroller = [[UIScrollView alloc] init];
    }
    
    _Scroller.frame = CGRectMake(0, UI_IOS7_NAV_BAR_HEIGHT, screenRect.size.width, screenRect.size.height - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT);
    [self.view addSubview:_Scroller];
    
    
    // GestureRecognize
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    
    [self.view addGestureRecognizer:panRecognizer];
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;

}



-(void)viewWillAppear:(BOOL)animated
{
    [_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
    
    // Read Setting
    _font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_PoetrySetting.SettingFontSize];
    _DisplayTheme = _PoetrySetting.SettingTheme;
    _SlideDirection = SlideLabelNone;
    _LabelSizeInit = CGSizeMake(UI_DEFAULT_LABEL_WIDTH, 0);
    _CurrentView = VIEW1;
    _GetSlideInLabel = NO;
    _DataFlag = NO;
    _CrossCategoryFlag = NO;
    _HeadAndTailFlag = NO;
    _ConfirmToSwitch = NO;
    [self InitReadingViewSetupScroller];

    
    //_CurrentLab = LABEL1;
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    READING_VIEW_LOG(@"ViewDidDisappear - save reading");
    
    [_ReadingView1 removeFromSuperview];
    [_ReadingView2 removeFromSuperview];
    
    /*
    [_Label1 removeFromSuperview];
    [_Label2 removeFromSuperview];
*/
    [_PoetryDatabase PoetryCoreDataSaveIntoNowReading:_PoetryNowReading];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

        //READING_VIEW_LOG(@"READING EXIST  = %@", [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY]);
        

        
    } else {
        
        READING_VIEW_LOG(@"NO READING POETRY, GET THE 1st POETRY in GUARD READING");
        _PoetryNowReading = (NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS] objectAtIndex:0];
        
        //TODO: Modify the Category after all poetry ready.
        POETRY_CATEGORY Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
        _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
        _CurrentIndex = 0;

    }
    READING_VIEW_LOG(@"_CurrentIndex = %d", _CurrentIndex);
    // Setup Scroll View
    [_Scroller setContentSize:CGSizeMake(UI_DEFAULT_SCREEN_WIDTH, 1000)];
    [_Scroller setScrollEnabled:YES];

    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ReadingScroller" owner:self options:nil];
    if (subviewArray == nil) {
        READING_VIEW_ERROR_LOG(@"CANNOT FIND ReadingScroller");
    }
    
    // Init View1 for first launch
    if (_ReadingView1 == nil) {
        _ReadingView1 = [[PoetryReadingView alloc] init];
    }
    
    if (_ReadingView2 == nil) {
        _ReadingView2 = [[PoetryReadingView alloc] init];
    }
    
    _ReadingView1 = [self DisplayHandlingWithData:_PoetryNowReading onView:_ReadingView1];
    READING_VIEW_LOG(@"init _ReadingView1 = %@", _ReadingView1);
    
    [_Scroller setContentSize:CGSizeMake(UI_DEFAULT_SCREEN_WIDTH, _LabelSizeInit.height + 40)];
    
    self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
    [_ReadingView1 setBackgroundColor:[UIColor clearColor]];

    [_Scroller addSubview: _ReadingView1];

    
}

#pragma mark - Display view handling

-(PoetryReadingView *) DisplayHandlingWithData :(NSDictionary*) PoetryData onView : (PoetryReadingView*) PoetryReadingView
{
    
    if (PoetryReadingView.ContentTextLabel == nil) {
        PoetryReadingView.ContentTextLabel = [[UILabel alloc] init];
    }
    
    [PoetryReadingView.ContentTextLabel setText:[self ReadingViewCleanUpTextWithTheArticle:[PoetryData valueForKey:POETRY_CORE_DATA_CONTENT_KEY]]];
    ;
    [PoetryReadingView.ContentTextLabel setFont:_font];
    [PoetryReadingView.ContentTextLabel setBackgroundColor:[UIColor clearColor]];
    PoetryReadingView.ContentTextLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(UI_DEFAULT_LABEL_WIDTH, 20000.0f);
    
    _LabelSizeInit = [PoetryReadingView.ContentTextLabel sizeThatFits:constraint];
    
    if (_DisplayTheme == THEME_LIGHT_DARK) {
        
        // Font color = Black, Background = White
        PoetryReadingView.ContentTextLabel.textColor = [UIColor blackColor];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
    } else {
        
        // Font color = Black, Background = White
        PoetryReadingView.ContentTextLabel.textColor = [UIColor whiteColor];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
    }
    
    [PoetryReadingView.ContentTextLabel setFrame:CGRectMake(20, 0, _LabelSizeInit.width, _LabelSizeInit.height)];
    READING_VIEW_LOG(@"PoetryReadingView.ContentTextLabel = %@", PoetryReadingView.ContentTextLabel);

    CGFloat ViewHeight = _LabelSizeInit.height;
    if (ViewHeight< (UI_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)) {
     ViewHeight = (UI_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT);
    }
    
    [PoetryReadingView addSubview:PoetryReadingView.ContentTextLabel];
    [PoetryReadingView setFrame:CGRectMake(0, 0, UI_DEFAULT_SCREEN_WIDTH, ViewHeight)];
    
    
    return PoetryReadingView;
    
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
        READING_VIEW_LOG(@"The most first poetry, try to init view below");
        
        _EmptyReadingView.frame = CGRectMake(0, 0, UI_DEFAULT_SCREEN_WIDTH, (UI_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT));
        _EmptyReadingView.ContentTextLabel.frame = CGRectMake(10, (UI_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT) / 2, UI_DEFAULT_SCREEN_WIDTH, 50);
        _EmptyReadingView.ContentTextLabel.text = @"最前的一首";
        
    } else {
        //NEXT
        READING_VIEW_LOG(@"The latest poetry, try to init view ");
        
        _EmptyReadingView.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, 0, UI_DEFAULT_SCREEN_WIDTH, (UI_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT));
        _EmptyReadingView.ContentTextLabel.frame = CGRectMake(10, (UI_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT) / 2, UI_DEFAULT_SCREEN_WIDTH, 50);
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
                    _GetSlideInLabel = NO;
                    _DataFlag = NO;
                    
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
                                if (_CurrentView == VIEW1) {
                                    
                                    READING_VIEW_LOG(@"Add view below readingview1");
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
                               
                                
                                READING_VIEW_LOG(@"NO DATA");
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
                            
                            View.frame = CGRectMake(0, 0, UI_DEFAULT_SCREEN_WIDTH, 0);
                            View = [self DisplayHandlingWithData:_NewDataDic onView:View];
                            //READING_VIEW_LOG(@"View Generate = %@", View);
                            
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

                            [_Scroller setContentSize:CGSizeMake(UI_DEFAULT_SCREEN_WIDTH, _LabelSizeInit.height + 20)];
                            // TODO: Add this view between Current view and Scroller
                            //[_Scroller addSubview:View];
                            
                            if (_CurrentView == VIEW1) {
                                
                                READING_VIEW_LOG(@"Add view below readingview1");
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

            } else if ((location.x - _TouchInit.x) < 0) {
            
                if ( _SlideDirection != SlideLabelRightToLegt ) {
                    // Need to reinit new view and data
                    _GetSlideInLabel = NO;
                    _DataFlag = NO;
                    
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
                                if (_CurrentView == VIEW1) {
                                    
                                    READING_VIEW_LOG(@"Add view below readingview1");
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
                            View.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, 0, UI_DEFAULT_SCREEN_WIDTH, 0);
                            View = [self DisplayHandlingWithData:_NewDataDic onView:View];
                            //READING_VIEW_LOG(@"View Generate = %@", View);
                            
                            
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
                            
                            
                            [_Scroller setContentSize:CGSizeMake(UI_DEFAULT_SCREEN_WIDTH, _LabelSizeInit.height + 20)];
                            [_Scroller addSubview:View];

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
            } else if (abs(location.x - _TouchInit.x) == 0) {
            
                READING_VIEW_LOG(@" CHANGE DIRECTION !!! reset all flags");
                _GetSlideInLabel = NO;
                _DataFlag = NO;
                _CrossCategoryFlag = NO;
                _HeadAndTailFlag = NO;
                _SlideDirection = SlideLabelNone;

                
            
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
                            
                        } else if (_SlideDirection == SlideLabelRightToLegt) {
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
                                                     [View setBackgroundColor:[UIColor clearColor]];
                                                     
                                                     _CurrentView = VIEW2;
                                                     _PoetryNowReading = _NewDataDic;
                                                     
                                                     self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
                                                     [_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
                                                     
                                                     _DataFlag = NO;
                                                     _GetSlideInLabel = NO;
                                                     
                                                 } else {
                                                     
                                                     READING_VIEW_LOG(@"move done remove label 2");
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
