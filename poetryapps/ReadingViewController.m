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
    CURRENT_VIEW            _CurrentView;
    UInt16                  _CurrentIndex;
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

    _LabelSizeInit = CGSizeMake(UI_DEFAULT_LABEL_WIDTH, 0);
    _CurrentView = VIEW1;
    _GetSlideInLabel = NO;
    _DataFlag = NO;
    
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
        _CurrentIndex = [[_PoetryNowReading valueForKey:POETRY_CORE_DATA_INDEX_KEY] integerValue] + 1; //Since the index in core data starts at 0

        READING_VIEW_LOG(@"READING EXIST  = %@", [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY]);
        

        
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
    
    [PoetryReadingView.ContentTextLabel setFrame:CGRectMake(0, 0, _LabelSizeInit.width, _LabelSizeInit.height)];
    READING_VIEW_LOG(@"PoetryReadingView.ContentTextLabel = %@", PoetryReadingView.ContentTextLabel);

    CGFloat ViewHeight = _LabelSizeInit.height;
    if (ViewHeight< (UI_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)) {
     ViewHeight = (UI_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT);
    }
    
    [PoetryReadingView addSubview:PoetryReadingView.ContentTextLabel];
    [PoetryReadingView setFrame:CGRectMake(0, 0, UI_DEFAULT_SCREEN_WIDTH, ViewHeight)];
    
    
    return PoetryReadingView;
    
}

// Not Used

-(UILabel *) DisplayLabelHandlingWithData :(NSDictionary*) PoetryData onLabel : (UILabel*) Label
{
    [Label setText:[self ReadingViewCleanUpTextWithTheArticle:[PoetryData valueForKey:POETRY_CORE_DATA_CONTENT_KEY]]];
    ;
    //[Label setText:[PoetryData valueForKey:POETRY_CORE_DATA_CONTENT_KEY]];
    [Label setFont:_font];
    //[Label setTextAlignment:NSTextAlignmentCenter];
    Label.numberOfLines = 0;
    CGSize constraint = CGSizeMake(300, 20000.0f);
    
    _LabelSizeInit = [Label sizeThatFits:constraint];
    
    if (_DisplayTheme == THEME_LIGHT_DARK) {
        
        // Font color = Black, Background = White
        Label.textColor = [UIColor blackColor];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
    } else {
        
        // Font color = Black, Background = White
        Label.textColor = [UIColor whiteColor];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
    }
    
    if (_LabelSizeInit.height < (UI_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT)) {
        _LabelSizeInit.height = (UI_4_INCH_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT);
    }
    
    [Label setFrame:CGRectMake(Label.frame.origin.x, UI_DEFAULT_LABEL_ORIGIN_Y, _LabelSizeInit.width, _LabelSizeInit.height)];
    
    return Label;
    
}
#pragma mark - Gesture Recognizer Method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return YES;
}



#pragma mark - Now Working
-(PoetryReadingView *) HandleGestureWith:(UIPanGestureRecognizer *)recognizer andHandledView : (PoetryReadingView *) View
{
    CGPoint location = [recognizer locationInView:_Scroller];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            _TouchInit = location;
            break;
            
        case UIGestureRecognizerStateChanged:
            if ((location.x - _TouchInit.x) > 0) {
                
                if (!_GetSlideInLabel) {
                    
                    READING_VIEW_LOG(@"Drag to right, use the previous poetry");
                    // Get the previous data and save into temp _NewDataDic for once (check DataFlag)
                    // Set Lable on the left of the screen and config it
                    
                    if (!_DataFlag) {
                        
                        if (_CurrentIndex == 0) {
                            
                            // Generate empty view to notify user
                            READING_VIEW_LOG(@"NO DATA");
                            
                        } else {
                        
                            _NewDataDic = [_NowReadingCategoryArray objectAtIndex:(_CurrentIndex - 1)];
                            READING_VIEW_LOG(@"_NewDataDic index = %d", _CurrentIndex - 1);
                            // Height of view will be set inside the method
                            View.frame = CGRectMake(UI_DEFAULT_PREVIOUS_ORIGIN_X, 0, UI_DEFAULT_SCREEN_WIDTH, 0);
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

                            
                            _DataFlag = YES;
                            _GetSlideInLabel = YES;
                            _SlideDirection = SlideLabelLeftToRigth;
                            
                            [_Scroller setContentSize:CGSizeMake(UI_DEFAULT_SCREEN_WIDTH, _LabelSizeInit.height + 20)];
                            [_Scroller addSubview:View];
                            
                        }
                    }
                } else {
                    
                    if (_DataFlag) {
                        
                        // Move the label follow gesture
                        View.frame = CGRectMake((UI_DEFAULT_PREVIOUS_ORIGIN_X + abs(location.x - _TouchInit.x)), View.frame.origin.y, View.frame.size.width, View.frame.size.height);
                        
                    }
                    
                }

            } else {
            
                if (!_GetSlideInLabel) {
                    
                    READING_VIEW_LOG(@"Drag to left, use the next poetry");
                    // Get the previous data and save into temp _NewDataDic for once (check DataFlag)
                    // Set Lable on the left of the screen and config it
                    
                    if (!_DataFlag) {
                        
                        if (_CurrentIndex == ([_NowReadingCategoryArray count] - 1)) {
                            
                            // Generate empty view to notify user
                            READING_VIEW_LOG(@"NO DATA");
                            
                        } else {
                            
                            _NewDataDic = [_NowReadingCategoryArray objectAtIndex:(_CurrentIndex + 1)];
                            READING_VIEW_LOG(@"_NewDataDic index = %d", _CurrentIndex + 1);
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
                            
                            
                            _DataFlag = YES;
                            _GetSlideInLabel = YES;
                            _SlideDirection = SlideLabelRightToLegt;
                            
                            [_Scroller setContentSize:CGSizeMake(UI_DEFAULT_SCREEN_WIDTH, _LabelSizeInit.height + 20)];
                            [_Scroller addSubview:View];
                            
                        }
                    }
                } else {
                    
                    if (_DataFlag) {
                        
                        // Move the label follow gesture
                        View.frame = CGRectMake((UI_DEFAULT_NEXT_ORIGIN_X - abs(location.x - _TouchInit.x)), View.frame.origin.y, View.frame.size.width, View.frame.size.height);
                        
                    }
                    
                }

            
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (_DataFlag) {
                
                if (abs(location.x - _TouchInit.x) > 50) {
                    
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         
                                         // Set Label in the normal location
                                         View.frame = CGRectMake(10, View.frame.origin.y, View.frame.size.width, View.frame.size.height);
                                         
                                     }
                                     completion:^(BOOL finished){
                                         
                                         if (_CurrentView == VIEW1) {
                                             
                                             READING_VIEW_LOG(@"move done remove label 1");
                                             
                                             [_ReadingView1 removeFromSuperview];
                                             [View setBackgroundColor:[UIColor clearColor]];
                                             
                                             _CurrentView = VIEW2;
                                             _PoetryNowReading = _NewDataDic;
                                             
                                             if (_SlideDirection == SlideLabelLeftToRigth) {
                                                 _CurrentIndex--;
                                             } else {
                                                 _CurrentIndex++;
                                             }
                                             
                                             self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
                                             //[_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
                                             _DataFlag = NO;
                                             _GetSlideInLabel = NO;
                                             
                                         } else {
                                             
                                             READING_VIEW_LOG(@"move done remove label 2");
                                             [_ReadingView2 removeFromSuperview];
                                             [View setBackgroundColor:[UIColor clearColor]];
                                             
                                             _CurrentView = VIEW1;
                                             _PoetryNowReading = _NewDataDic;
                                             
                                             if (_SlideDirection == SlideLabelLeftToRigth) {
                                                 _CurrentIndex--;
                                             } else {
                                                 _CurrentIndex++;
                                             }
                                             
                                             self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
                                             //[_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
                                             _DataFlag = NO;
                                             _GetSlideInLabel = NO;
                                             
                                         }
                                    }];
                    
                    
                } else {
                    
                    READING_VIEW_LOG(@"back to out of screen!!!");
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         if (_SlideDirection == SlideLabelLeftToRigth) {
                                             
                                             View.frame = CGRectMake(UI_DEFAULT_PREVIOUS_ORIGIN_X, View.frame.origin.y, View.frame.size.width, View.frame.size.height);
                                             
                                         } else {
                                             
                                             View.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, View.frame.origin.y, View.frame.size.width, View.frame.size.height);
                                         }
                                         
                                         
                                     }
                                     completion:^(BOOL finished){
                                         
                                         _GetSlideInLabel = NO;
                                         _DataFlag = NO;
                                         
                                     }];
                    
                }
            }
            break;
            
        default:
            break;
    }
    return View;
}

/*
-(UILabel *) HandleGestureWith:(UIPanGestureRecognizer *)recognizer andHandledLabel : (UILabel *) Label
{
    CGPoint location = [recognizer locationInView:_Scroller];

    switch (recognizer.state) {
            
        case UIGestureRecognizerStateBegan:
            _TouchInit = location;
            break;
            
            
        case UIGestureRecognizerStateChanged:
            
            if ((location.x - _TouchInit.x) > 0) {
            
                if (!_GetSlideInLabel) {
                    
                    READING_VIEW_LOG(@"Drag to right, use the previous poetry");
                    // Get the previous data and save into temp _NewDataDic for once (check DataFlag)
                    // Set Lable on the left of the screen and config it
                    
                    if (!_DataFlag) {
                        
                        _NewDataDic = [_PoetryDatabase Poetry_GetPreviousWithCurrentData:_PoetryNowReading];
                        
                        if (_NewDataDic != nil) {
                            
                            READING_VIEW_LOG(@"Init PREVIOUS lab");
                            
                            _DataFlag = YES;
                            Label.frame = CGRectMake(UI_DEFAULT_PREVIOUS_ORIGIN_X, 10, _LabelSizeInit.width, 0);
                            Label = [self DisplayLabelHandlingWithData:_NewDataDic onLabel:Label];
                            
                            if (_DisplayTheme == THEME_LIGHT_DARK) {
                                
                                [Label setBackgroundColor:[UIColor whiteColor]];
                                [Label setTextColor:[UIColor blackColor]];
                                
                            } else {
                                
                                [Label setBackgroundColor:[UIColor blackColor]];
                                [Label setTextColor:[UIColor whiteColor]];
                                
                            }
                            
                            //[Label setShadowColor:[UIColor grayColor]];
                            //[Label setShadowOffset:CGSizeMake(30, _LabelSizeInit.height)];
                            
                            _GetSlideInLabel = YES;
                            _SlideDirection = SlideLabelLeftToRigth;

                            [_Scroller setContentSize:CGSizeMake(320, _LabelSizeInit.height + 40)];
                            [_Scroller addSubview:Label];
                            
                        } else {
                            
                            // TO config the label as no data label, and not to put on the scroller in the end
                            READING_VIEW_LOG(@"NO DATA");
                            
                        }
                        
                    }

                } else {
                    
                    if (_DataFlag) {
                        
                        // Move the label follow gesture
                        //NSLog(@"MOVE x = %d", (UI_DEFAULT_PREVIOUS_ORIGIN_X + abs(location.x - _TouchInit.x)));
                        Label.frame = CGRectMake((UI_DEFAULT_PREVIOUS_ORIGIN_X + abs(location.x - _TouchInit.x)), Label.frame.origin.y, Label.frame.size.width, Label.frame.size.height);
                        
                    }
                    
                }
            } else {
                if (!_GetSlideInLabel) {
                    
                    READING_VIEW_LOG(@"Drag to left, use the next poetry");
                    // Get the next data and save into temp _NewDataDic for once (check DataFlag)
                    // Set Lable on the left of the screen and config it
                    
                    if (!_DataFlag) {
                        
                        
                        _NewDataDic = [_PoetryDatabase Poetry_GetNextWithCurrentData:_PoetryNowReading];
                        if (_NewDataDic != nil) {
                            
                            READING_VIEW_LOG(@"Init NEXT label");
                            
                            _DataFlag = YES;
                            Label.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, 10, _LabelSizeInit.width, 0);
                            Label = [self DisplayLabelHandlingWithData:_NewDataDic onLabel:Label];
                            
                            if (_DisplayTheme == THEME_LIGHT_DARK) {
                                
                                [Label setBackgroundColor:[UIColor whiteColor]];
                                [Label setTextColor:[UIColor blackColor]];
                                
                            } else {
                                
                                [Label setBackgroundColor:[UIColor blackColor]];
                                [Label setTextColor:[UIColor whiteColor]];
                                
                            }
                            
                            //[Label setShadowColor:[UIColor grayColor]];
                            //[Label setShadowOffset:CGSizeMake(30, _LabelSizeInit.height)];
                            
                            _GetSlideInLabel = YES;
                            _SlideDirection = SlideLabelRightToLegt;

                            [_Scroller setContentSize:CGSizeMake(320, _LabelSizeInit.height + 40)];
                            [_Scroller addSubview:Label];
                            
                        } else {
                            
                            // TO config the label as no data label, and not to put on the scroller in the end
                            READING_VIEW_LOG(@"NO DATA");
                            
                        }
                        
                    }
                    
                } else {
                    
                    if (_DataFlag) {
                        
                        // Move the label follow gesture
                        Label.frame = CGRectMake((UI_DEFAULT_NEXT_ORIGIN_X - abs(location.x - _TouchInit.x)), Label.frame.origin.y, Label.frame.size.width, Label.frame.size.height);
                        
                    }
                    
                }
            
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            
            if (_DataFlag) {
                
                if (abs(location.x - _TouchInit.x) > 50) {
                    
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         
                                         // Set Label in the normal location
                                         Label.frame = CGRectMake(10, Label.frame.origin.y, Label.frame.size.width, Label.frame.size.height);
                                         
                                     }
                                     completion:^(BOOL finished){
                                         
                                         if (_CurrentLab == LABEL1) {
                                             
                                             READING_VIEW_LOG(@"move done remove label 1");
                                            

                                             [Label setBackgroundColor:[UIColor clearColor]];
                                             [_Label1 removeFromSuperview];
                                             _CurrentLab = LABEL2;
                                             _PoetryNowReading = _NewDataDic;
                                             self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
                                             [_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
                                             _DataFlag = NO;
                                             _GetSlideInLabel = NO;

                                         } else {
                                             
                                             READING_VIEW_LOG(@"move done remove label 2");

                                             [Label setBackgroundColor:[UIColor clearColor]];
                                             [_Label2 removeFromSuperview];
                                            _CurrentLab = LABEL1;
                                             _PoetryNowReading = _NewDataDic;
                                             self.navigationItem.title = [_PoetryNowReading valueForKey:POETRY_CORE_DATA_NAME_KEY];
                                             [_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
                                             _DataFlag = NO;
                                             _GetSlideInLabel = NO;

                                         }

                                         
                                     }];
                    
                    
                } else {
                    
                    READING_VIEW_LOG(@"back to out of screen!!!");
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         if (_SlideDirection == SlideLabelLeftToRigth) {
                                             
                                             Label.frame = CGRectMake(UI_DEFAULT_PREVIOUS_ORIGIN_X, Label.frame.origin.y, Label.frame.size.width, Label.frame.size.height);
                                             
                                         } else {
                                             
                                             Label.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, Label.frame.origin.y, Label.frame.size.width, Label.frame.size.height);
                                         }
                                         
                                         
                                     }
                                     completion:^(BOOL finished){
                                         
                                         _GetSlideInLabel = NO;
                                         _DataFlag = NO;
                                         
                                     }];
                    
                }

            
            
            }
            break;
            
        default:
            break;
    }
    
    return Label;
}
*/
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
/*
    if (_CurrentLab == LABEL1) {
        
        if (_Label2 == nil) {
            _Label2 = [[UILabel alloc] init];
        }
        
        _Label2 = [self HandleGestureWith:recognizer andHandledLabel:_Label2];

        
    } else {
    
        if (_Label1 == nil) {
            _Label1 = [[UILabel alloc] init];
        }

        _Label1 = [self HandleGestureWith:recognizer andHandledLabel:_Label1];
        
    }
 */
    
}



@end
