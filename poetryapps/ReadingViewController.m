//
//  ReadingViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "ReadingViewController.h"

@interface ReadingViewController (){
    CGPoint _TouchInit;
    CGPoint _NextLabLocation;
    CGPoint _PreviousLabLocation;
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
    UILabel *Label1 = [[UILabel alloc] init];
    UILabel *Label2 = [[UILabel alloc] init];
    
    _DisplayLabArray = [NSMutableArray arrayWithObjects:Label1, Label2, nil];
    
    
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
    [self readingViewSetupScroller];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"ViewDidDisappear - save reading");
    [_PoetryDatabase PoetryCoreDataSaveIntoNowReading:_PoetryNowReading];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)readingViewSetupScroller
{
    
    if (_PoetryDatabase.isReadingExist) {
        
        _PoetryNowReading = [_PoetryDatabase Poetry_CoreDataFetchDataInReading];
        NSLog(@"READING EXIST");

        
    } else {
        
        NSLog(@"NO READING POETRY, GET THE 1st POETRY in GUARD READING");
        _PoetryNowReading = (NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:GUARD_READING] objectAtIndex:0];
        
    }
    
    
    // Read Setting
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_PoetrySetting.SettingFontSize];
    THEME_SETTING ThemeSetting = _PoetrySetting.SettingTheme;
    
    
    
    // Setup Scroll View
    [_Scroller setContentSize:CGSizeMake(320, 1000)];
    [_Scroller setScrollEnabled:YES];
    CGSize LabelSizeInit = CGSizeMake(300, 0);

    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ReadingScroller" owner:self options:nil];
    if (subviewArray == nil) {
        NSLog(@"CANNOT FIND ReadingScroller");
    }
    
    
    //[CASPER TEST]
    UILabel *Label = [self HandleDisplayLabelWithData:_PoetryNowReading Font:font InitSize:LabelSizeInit Theme:ThemeSetting];
    
    [_Scroller setContentSize:CGSizeMake(320, Label.frame.size.height + 40)];
    [_Scroller addSubview: Label];
    // [CASPER TEST] ==
    
    
    /*
    // Add Content
    if (_ContentLab == nil) {
        _ContentLab = [[UILabel alloc] init];
    }
    
    [_ContentLab setText:[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY]];
    [_ContentLab setFont:font];
    _ContentLab.numberOfLines = 0;
    [_ContentLab setBackgroundColor: [UIColor clearColor]];
    CGSize constraint = CGSizeMake(300, 20000.0f);
    
    size = [_ContentLab sizeThatFits:constraint];
    [_ContentLab setFrame:CGRectMake(10, 20, size.width, size.height)];
    
    if (ThemeSetting == THEME_LIGHT_DARK) {
        
        // Font color = Black, Background = White
        _ContentLab.textColor = [UIColor blackColor];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
    } else {
        
        // Font color = Black, Background = White
        _ContentLab.textColor = [UIColor whiteColor];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
    }
    
    
    [_Scroller setContentSize:CGSizeMake(320, size.height + 40)];
    [_Scroller addSubview: _ContentLab];
     */
}

#pragma mark - Display label array handling
-(void) SwapLabelCellInDisplayArray
{
    
    UILabel *Label = [_DisplayLabArray objectAtIndex:0];
    [_DisplayLabArray removeObjectAtIndex:0];
    [_DisplayLabArray addObject:Label];
    
}

-(UILabel*) GetDisplayLabel
{
    UILabel *Label = [_DisplayLabArray objectAtIndex:0];
    [self SwapLabelCellInDisplayArray];
    
    return Label;
}

-(UILabel*) HandleDisplayLabelWithData : (NSDictionary *) PoetryData Font:(UIFont*) font InitSize:(CGSize) size  Theme:(THEME_SETTING) ThemeSetting
{
    
    UILabel *Label = [self GetDisplayLabel];
    
    [Label setText:[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY]];
    [Label setFont:font];
    Label.numberOfLines = 0;
    [Label setBackgroundColor: [UIColor clearColor]];
    CGSize constraint = CGSizeMake(300, 20000.0f);

    size = [Label sizeThatFits:constraint];
    [Label setFrame:CGRectMake(10, 20, size.width, size.height)];
    
    if (ThemeSetting == THEME_LIGHT_DARK) {
        
        // Font color = Black, Background = White
        _ContentLab.textColor = [UIColor blackColor];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
    } else {
        
        // Font color = Black, Background = White
        Label.textColor = [UIColor whiteColor];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
    }
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



- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    //拿到手指目前的位置
    
    CGPoint location = [recognizer locationInView:_Scroller];
    NSLog(@"location = %f", location.x);
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        
        // Start to drag
        _TouchInit = location;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        // Gesture Did Move
        if ((location.x - _TouchInit.x) > 0) {
            if (abs(location.x - _TouchInit.x) > 3) {
                
                NSLog(@"Drag to right, use the previous poetry");

            }
            
            
        } else {
            if (abs(location.x - _TouchInit.x) > 3) {
                
                NSLog(@"Drag to left, use the next poetry !!!");
                
            }
            
        }
        
        //_Label1.frame = CGRectMake(((_ViewInit.x) - (_init.x - location.x)), _Label1.frame.origin.y, _Label1.frame.size.width, _Label1.frame.size.height);
        //NSLog(@"%f", (_init.x - location.x));
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
    
        NSLog(@"END");
    }
    
    
    /*
    
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
