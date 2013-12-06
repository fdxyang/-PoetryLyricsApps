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
    CURRENT_LABEL           _CurrentLab;
    SLIDE_DIRECTION         _SlideDirection;

    BOOL                    _DataFlag;
    BOOL                    _GetSlideInLabel;

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
 
	// Do any additional setup after loading the view.
    _PoetryDatabase = [[PoetryCoreData alloc] init];
    _PoetrySetting = [[PoetrySettingCoreData alloc] init];
    
        if (_Scroller == nil) {
        _Scroller = [[UIScrollView alloc] init];
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _Scroller.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height - UI_IOS7_TAB_BAR_HEIGHT);
    [self.view addSubview:_Scroller];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    
    [self.view addGestureRecognizer:panRecognizer];
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;

}


-(void)viewWillAppear:(BOOL)animated
{
    // TODO: Scroll to the top
    [_Scroller scrollRectToVisible:CGRectMake(0, 0, 1, 1)  animated:YES];
    // Read Setting
    _font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_PoetrySetting.SettingFontSize];
    _DisplayTheme = _PoetrySetting.SettingTheme;
    
    _LabelSizeInit = CGSizeMake(300, 0);
    _CurrentLab = LABEL1;
    _GetSlideInLabel = NO;
    _DataFlag = NO;
    

    
    [self InitReadingViewSetupScroller];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    READING_VIEW_LOG(@"ViewDidDisappear - save reading");
    
    [_Label1 removeFromSuperview];
    [_Label2 removeFromSuperview];

    [_PoetryDatabase PoetryCoreDataSaveIntoNowReading:_PoetryNowReading];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)InitReadingViewSetupScroller
{
    
    if (_PoetryDatabase.isReadingExist) {
        
        _PoetryNowReading = [_PoetryDatabase Poetry_CoreDataFetchDataInReading];
        READING_VIEW_LOG(@"READING EXIST  = %@", [_PoetryNowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);

        
    } else {
        
        READING_VIEW_LOG(@"NO READING POETRY, GET THE 1st POETRY in GUARD READING");
        _PoetryNowReading = (NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:GUARD_READING] objectAtIndex:0];
        
    }

    // Setup Scroll View
    [_Scroller setContentSize:CGSizeMake(320, 1000)];
    [_Scroller setScrollEnabled:YES];

    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ReadingScroller" owner:self options:nil];
    if (subviewArray == nil) {
        READING_VIEW_ERROR_LOG(@"CANNOT FIND ReadingScroller");
    }

    // Add Content
    if (_Label1 == nil) {
        _Label1 = [[UILabel alloc] init];
    }
    
    CGPoint DefaultLabelLocation = CGPointMake(10, 10);
    _Label1.frame = CGRectMake(DefaultLabelLocation.x, UI_DEFAULT_LABEL_ORIGIN_Y, _LabelSizeInit.width, 0);
    _Label1 = [self DisplayLabelHandlingWithData:_PoetryNowReading onLabel:_Label1];
    [_Scroller addSubview: _Label1];
    
}

#pragma mark - Display label handling
-(UILabel *) DisplayLabelHandlingWithData :(NSDictionary*) PoetryData onLabel : (UILabel*) Label
{
    
    [Label setText:[PoetryData valueForKey:POETRY_CORE_DATA_CONTENT_KEY]];
    [Label setFont:_font];
    //[Label setTextAlignment:NSTextAlignmentCenter];
    Label.numberOfLines = 0;
//    [Label setBackgroundColor: [UIColor clearColor]];
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
    [Label sizeToFit];

    return Label;
    
}
#pragma mark - Gesture Recognizer Method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    // TODO: Filter some view sould return NO!
    [_Scroller setTag:100];
    if (touch.view != _Scroller) {
        return NO;
    }
    return YES;
}



#pragma mark - Now Working
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
                
                if (abs(location.x - _TouchInit.x) > 100) {
                    
                    [UIView animateWithDuration:0.3
                                     animations:^{
                                         
                                         // Set Label in the normal location
                                         Label.frame = CGRectMake(10, Label.frame.origin.y, Label.frame.size.width, Label.frame.size.height);
                                         
                                     }
                                     completion:^(BOOL finished){
                                         
                                         if (_CurrentLab == LABEL1) {
                                             
                                             READING_VIEW_LOG(@"move done remove label 1");
                                             [_Label1 removeFromSuperview];
                                             _CurrentLab = LABEL2;
                                         } else {
                                             
                                             READING_VIEW_LOG(@"move done remove label 2");
                                             [_Label2 removeFromSuperview];
                                            _CurrentLab = LABEL1;
                                         }
                                         
                                         [Label setBackgroundColor:[UIColor clearColor]];
                                         _PoetryNowReading = _NewDataDic;
                                         _DataFlag = NO;
                                         _GetSlideInLabel = NO;
                                         
                                     }];
                    
                    
                } else {
                    
                    READING_VIEW_LOG(@"back to out of screen!!!");
                    [UIView animateWithDuration:0.3
                                     animations:^{
                                         if (_SlideDirection == SlideLabelLeftToRigth) {
                                             
                                             Label.frame = CGRectMake(UI_DEFAULT_PREVIOUS_ORIGIN_X, Label.frame.origin.y, Label.frame.size.width, Label.frame.size.height);
                                             
                                         } else {
                                             
                                             Label.frame = CGRectMake(UI_DEFAULT_NEXT_ORIGIN_X, Label.frame.origin.y, Label.frame.size.width, Label.frame.size.height);
                                         }
                                         
                                         
                                     }
                                     completion:^(BOOL finished){
                                         
                                         
                                     }];
                    
                }

            
            
            }
            break;
            
        default:
            break;
    }
    
    return Label;
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    //拿到手指目前的位置
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
    
}



@end
