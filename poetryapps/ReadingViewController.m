//
//  ReadingViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "ReadingViewController.h"

@interface ReadingViewController (){
    
    CGSize _LabelSizeInit;

    
    CGPoint _TouchInit;
    CGPoint _NextLabLocation;
    CGPoint _PreviousLabLocation;
    
    CURRENT_LABEL   _CurrentLab;
    SLIDE_DIRECTION _SlideDirection;
    
    NSDictionary    *_NewDataDic;
    BOOL            _DataFlag;
    BOOL            _GetSlideInLabel;

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
    NSLog(@"ViewDidDisappear - save reading");
    
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
        NSLog(@"READING EXIST");

        
    } else {
        
        NSLog(@"NO READING POETRY, GET THE 1st POETRY in GUARD READING");
        _PoetryNowReading = (NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:GUARD_READING] objectAtIndex:0];
        
    }

    // Setup Scroll View
    [_Scroller setContentSize:CGSizeMake(320, 1000)];
    [_Scroller setScrollEnabled:YES];

    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ReadingScroller" owner:self options:nil];
    if (subviewArray == nil) {
        NSLog(@"CANNOT FIND ReadingScroller");
    }

    // Add Content
    if (_Label1 == nil) {
        _Label1 = [[UILabel alloc] init];
    }
    
    CGPoint DefaultLabelLocation = CGPointMake(10, 10);
    _Label1.frame = CGRectMake(DefaultLabelLocation.x, DefaultLabelLocation.y, _LabelSizeInit.width, 0);
    
    _Label1 = [self DisplayLabelHandlingWithData:_PoetryNowReading onLabel:_Label1];
    [_Scroller addSubview: _Label1];
    
}

#pragma mark - Display label handling
-(UILabel *) DisplayLabelHandlingWithData :(NSDictionary*) PoetryData onLabel : (UILabel*) Label
{
    
    [Label setText:[PoetryData valueForKey:POETRY_CORE_DATA_CONTENT_KEY]];
    [Label setFont:_font];
    Label.numberOfLines = 0;
    [Label setBackgroundColor: [UIColor clearColor]];
    CGSize constraint = CGSizeMake(300, 20000.0f);
    
    _LabelSizeInit = [Label sizeThatFits:constraint];
    [Label setFrame:CGRectMake(Label.frame.origin.x, Label.frame.origin.y, _LabelSizeInit.width, _LabelSizeInit.height)];
    
    if (_DisplayTheme == THEME_LIGHT_DARK) {
        
        // Font color = Black, Background = White
        Label.textColor = [UIColor blackColor];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
    } else {
        
        // Font color = Black, Background = White
        Label.textColor = [UIColor whiteColor];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
    }
    
//    [_Scroller setContentSize:CGSizeMake(320, _LabelSizeInit.height + 40)];

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
-(UILabel *) HandlePreviousGestureWith:(UIPanGestureRecognizer *)recognizer andHandledLabel : (UILabel *) Label
{
    CGPoint location = [recognizer locationInView:_Scroller];

    switch (recognizer.state) {
            
        case UIGestureRecognizerStateBegan:
            _TouchInit = location;
            break;
            
            
        case UIGestureRecognizerStateChanged:
            
            if ((location.x - _TouchInit.x) > 0) {
            
                if (!_GetSlideInLabel) {
                    
                    NSLog(@"Drag to right, use the previous poetry");
                    // Get the previous data and save into temp _NewDataDic for once (check DataFlag)
                    // Set Lable on the left of the screen and config it
                    
                    if (!_DataFlag) {
                        
                        
                        _NewDataDic = [_PoetryDatabase Poetry_GetPreviousWithCurrentData:_PoetryNowReading];
                        if (_NewDataDic != nil) {
                            
                            NSLog(@"Init lab");
                            
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
                            [_Scroller addSubview:Label];
                            
                        } else {
                            
                            // TO config the label as no data label, and not to put on the scroller in the end
                            NSLog(@"NO DATA");
                            
                        }
                        
                    }

                } else {
                    
                    if (_DataFlag) {
                        // Move the label follow gesture
                        NSLog(@"MOVE x = %d", (UI_DEFAULT_PREVIOUS_ORIGIN_X + abs(location.x - _TouchInit.x)));
                        Label.frame = CGRectMake((UI_DEFAULT_PREVIOUS_ORIGIN_X + abs(location.x - _TouchInit.x)), Label.frame.origin.y, Label.frame.size.width, Label.frame.size.height);
                        
                    }
                    
                }
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            
            NSLog(@"ENDDDDDDD!!!!!!");
            if (_DataFlag) {
                
                if (abs(location.x - _TouchInit.x) > 100) {
                    
                    [UIView animateWithDuration:0.3
                                     animations:^{
                                         
                                         Label.frame = CGRectMake(10, Label.frame.origin.y, Label.frame.size.width, Label.frame.size.height);
                                         
                                     }
                                     completion:^(BOOL finished){
                                         
                                         if (_CurrentLab == LABEL1) {
                                             [_Label1 removeFromSuperview];
                                         } else {
                                             [_Label2 removeFromSuperview];
                                         }
                                         
                                         [Label setBackgroundColor:[UIColor clearColor]];
                                         _PoetryNowReading = _NewDataDic;
                                         
                                     }];
                    
                    
                } else {
                    
                    [UIView animateWithDuration:0.3
                                     animations:^{
                                         
                                         Label.frame = CGRectMake(UI_DEFAULT_PREVIOUS_ORIGIN_X, Label.frame.origin.y, Label.frame.size.width, Label.frame.size.height);
                                         
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
        
        _Label2 = [self HandlePreviousGestureWith:recognizer andHandledLabel:_Label2];

        
    } else {
    
        if (_Label1 == nil) {
            _Label1 = [[UILabel alloc] init];
        }

        _Label1 = [self HandlePreviousGestureWith:recognizer andHandledLabel:_Label1];
        
    }
    
    
    /*
     
     NSDictionary *NewDataDic;
     
     CGPoint location = [recognizer locationInView:_Scroller];
     //NSLog(@"location = %f", location.x);
     
     
     if(recognizer.state == UIGestureRecognizerStateBegan) {
     
     // Start to drag
     _TouchInit = location;
     
     } else if (recognizer.state == UIGestureRecognizerStateChanged) {
     
     // Gesture Did Move
     if ((location.x - _TouchInit.x) > 0) {
     
     if (abs(location.x - _TouchInit.x) > 3) {
     if (_GetSlideInLabel) {
     
     // Move Label
     if (_CurrentLab == LABEL1) {
     
     // Handle Label2
     _Label2.frame = CGRectMake((UI_DEFAULT_PREVIOUS_ORIGIN_X + (abs(location.x - _TouchInit.x))), _Label2.frame.origin.y, _Label2.frame.size.width, _Label2.frame.size.height);
     
     } else {
     
     // Handle Label1
     _Label1.frame = CGRectMake((UI_DEFAULT_PREVIOUS_ORIGIN_X + (abs(location.x - _TouchInit.x))), _Label1.frame.origin.y, _Label1.frame.size.width, _Label1.frame.size.height);
     }
     
     } else {
     
     NSLog(@"Drag to right, use the previous poetry");
     _SlideDirection = SlideLabelLeftToRigth;
     // Previous Label View Location
     CGPoint DefaultLabelLocation = CGPointMake(UI_DEFAULT_PREVIOUS_ORIGIN_X, 10);
     
     if (_CurrentLab == LABEL1) {
     //get label2
     if(_Label2 == nil) {
     _Label2 = [[UILabel alloc] init];
     }
     
     NewDataDic = [_PoetryDatabase Poetry_GetPreviousWithCurrentData:_PoetryNowReading];
     if (NewDataDic != nil) {
     
     _DataFlag = YES;
     _Label2.frame = CGRectMake(DefaultLabelLocation.x, DefaultLabelLocation.y, _LabelSizeInit.width, 0);
     
     [self DisplayLabelHandlingWithData:NewDataDic onLabel:_Label2];
     
     
     } else {
     
     NSLog(@"NO DATA");
     return;
     }
     
     
     if (_DisplayTheme == THEME_LIGHT_DARK) {
     [_Label2 setBackgroundColor:[UIColor whiteColor]];
     } else {
     [_Label2 setBackgroundColor:[UIColor blackColor]];
     }
     
     [_Scroller addSubview:_Label2];
     _GetSlideInLabel = YES;
     
     } else {
     
     //get label1
     if(_Label1 == nil) {
     _Label1 = [[UILabel alloc] init];
     }
     
     _Label1.frame = CGRectMake(DefaultLabelLocation.x, DefaultLabelLocation.y, _LabelSizeInit.width, 0);
     
     NewDataDic = [_PoetryDatabase Poetry_GetPreviousWithCurrentData:_PoetryNowReading];
     if (NewDataDic != nil) {
     
     _DataFlag = YES;
     [self DisplayLabelHandlingWithData:NewDataDic onLabel:_Label1];
     
     } else {
     
     NSLog(@"NO DATA");
     return;
     }
     
     if (_DisplayTheme == THEME_LIGHT_DARK) {
     [_Label1 setBackgroundColor:[UIColor whiteColor]];
     } else {
     [_Label1 setBackgroundColor:[UIColor blackColor]];
     }
     
     [self.view addSubview:_Label1];
     _GetSlideInLabel = YES;
     
     }
     }
     
     }
     
     
     } else {
     
     if (abs(location.x - _TouchInit.x) > 3) {
     if (_GetSlideInLabel) {
     
     // Move Label
     if (_CurrentLab == LABEL1) {
     
     // Handle Label2
     _Label2.frame = CGRectMake((UI_DEFAULT_NEXT_ORIGIN_X - (abs(location.x - _TouchInit.x))), _Label2.frame.origin.y, _Label2.frame.size.width, _Label2.frame.size.height);
     
     } else {
     
     // Handle Label1
     _Label1.frame = CGRectMake((UI_DEFAULT_NEXT_ORIGIN_X - (abs(location.x - _TouchInit.x))), _Label1.frame.origin.y, _Label1.frame.size.width, _Label1.frame.size.height);
     }
     
     } else {
     
     NSLog(@"Drag to right, use the next poetry");
     _SlideDirection = SlideLabelLeftToRigth;
     // Previous Label View Location
     CGPoint DefaultLabelLocation = CGPointMake(UI_DEFAULT_NEXT_ORIGIN_X, 10);
     
     if (_CurrentLab == LABEL1) {
     //get label2
     if(_Label2 == nil) {
     _Label2 = [[UILabel alloc] init];
     }
     
     NewDataDic = [_PoetryDatabase Poetry_GetNextWithCurrentData:_PoetryNowReading];
     if (NewDataDic != nil) {
     
     _Label2.frame = CGRectMake(DefaultLabelLocation.x, DefaultLabelLocation.y, _LabelSizeInit.width, 0);
     
     [self DisplayLabelHandlingWithData:NewDataDic onLabel:_Label2];
     
     
     } else {
     NSLog(@"NO DATA");
     return;
     }
     
     
     if (_DisplayTheme == THEME_LIGHT_DARK) {
     [_Label2 setBackgroundColor:[UIColor whiteColor]];
     } else {
     [_Label2 setBackgroundColor:[UIColor blackColor]];
     }
     
     [_Scroller addSubview:_Label2];
     _GetSlideInLabel = YES;
     
     } else {
     
     //get label1
     if(_Label1 == nil) {
     _Label1 = [[UILabel alloc] init];
     }
     
     _Label1.frame = CGRectMake(DefaultLabelLocation.x, DefaultLabelLocation.y, _LabelSizeInit.width, 0);
     
     NewDataDic = [_PoetryDatabase Poetry_GetNextWithCurrentData:_PoetryNowReading];
     if (NewDataDic != nil) {
     [self DisplayLabelHandlingWithData:NewDataDic onLabel:_Label1];
     
     } else {
     NSLog(@"NO DATA");
     return;
     }
     
     if (_DisplayTheme == THEME_LIGHT_DARK) {
     [_Label1 setBackgroundColor:[UIColor whiteColor]];
     } else {
     [_Label1 setBackgroundColor:[UIColor blackColor]];
     }
     
     [self.view addSubview:_Label1];
     _GetSlideInLabel = YES;
     
     }
     }
     
     }
     
     }
     
     } else if (recognizer.state == UIGestureRecognizerStateEnded) {
     
     _GetSlideInLabel = NO;
     if (_CurrentLab == LABEL1) {
     if (abs(location.x - _TouchInit.x) > 130) {
     // Confirmed to change label to Label2
     
     
     [UIView animateWithDuration:0.5
     animations:^{
     
     _Label2.frame = CGRectMake(10, _Label2.frame.origin.y, _Label2.frame.size.width, _Label2.frame.size.height);
     
     }
     completion:^(BOOL finished){
     
     [_Label1 removeFromSuperview];
     
     }];
     
     _PoetryNowReading = NewDataDic;
     _CurrentLab = LABEL2;
     
     } else {
     
     CGFloat x;
     if (_SlideDirection == SlideLabelLeftToRigth) {
     x = UI_DEFAULT_PREVIOUS_ORIGIN_X;
     } else {
     x = UI_DEFAULT_NEXT_ORIGIN_X;
     }
     
     // Move back Label2
     [UIView animateWithDuration:0.5
     animations:^{
     
     _Label2.frame = CGRectMake(x, _Label2.frame.origin.y, _Label2.frame.size.width, _Label2.frame.size.height);
     
     }
     completion:^(BOOL finished){
     
     [_Label2 removeFromSuperview];
     [_Label2 setBackgroundColor:[UIColor clearColor]];
     
     
     }];
     
     }
     
     } else {
     
     if (abs(location.x - _TouchInit.x) > 130) {
     // Confirmed to change label to Label2
     
     
     [UIView animateWithDuration:0.5
     animations:^{
     
     _Label1.frame = CGRectMake(10, _Label1.frame.origin.y, _Label1.frame.size.width, _Label1.frame.size.height);
     
     }
     completion:^(BOOL finished){
     
     [_Label1 removeFromSuperview];
     
     }];
     
     _PoetryNowReading = NewDataDic;
     _CurrentLab = LABEL1;
     
     } else {
     
     CGFloat x;
     if (_SlideDirection == SlideLabelLeftToRigth) {
     x = UI_DEFAULT_PREVIOUS_ORIGIN_X;
     } else {
     x = UI_DEFAULT_NEXT_ORIGIN_X;
     }
     
     // Move back Label1
     [UIView animateWithDuration:0.5
     animations:^{
     
     _Label1.frame = CGRectMake(x, _Label1.frame.origin.y, _Label1.frame.size.width, _Label1.frame.size.height);
     
     }
     completion:^(BOOL finished){
     
     [_Label1 removeFromSuperview];
     [_Label1 setBackgroundColor:[UIColor clearColor]];
     
     
     }];
     
     }
     
     }
     NSLog(@"END");
     }

    // 如果UIGestureRecognizerStateEnded的話...你是拿不到location的
    // 不判斷的話,底下改frame會讓這個subview消失,因為origin的x和y就不見了!!!
    if(recognizer.state == UIGestureRecognizerStateBegan) {
     
        // Start to drag
        _init = location;
     
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
     
        // Change
     
        _Label1.frame = CGRectMake(((_ViewInit.x) - (_init.x - location.x)), _Label1.frame.origin.y, _Label1.frame.size.width, _Label1.frame.size.height);
        //NSLog(@"%f", (_init.x - location.x));
     
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // End
        if (((_init.x - location.x) > 30) && (_Label1.frame.origin.x < 200)) {
     
            NSLog(@"Move > 30");
            //_Label1.frame = CGRectMake(0, _Label1.frame.origin.y, _Label1.frame.size.width, _Label1.frame.size.height);
     
            [UIView animateWithDuration:0.5
                             animations:^{
     
                                 _Label1.frame = CGRectMake(0, _Label1.frame.origin.y, _Label1.frame.size.width, _Label1.frame.size.height);
     
                             }
                             completion:^(BOOL finished){
     
                             }];
     
     
        } else {
            NSLog(@"Move back");
            [UIView animateWithDuration:0.5
                             animations:^{
     
                                 _Label1.frame = CGRectMake(_ViewInit.x, _Label1.frame.origin.y, _Label1.frame.size.width, _Label1.frame.size.height);
     
                             }
                             completion:^(BOOL finished){
     
                             }];
     
     
        }
        NSLog(@"end");
     
    }
     */
}



@end
