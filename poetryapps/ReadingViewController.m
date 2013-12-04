//
//  ReadingViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "ReadingViewController.h"

@interface ReadingViewController ()

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

    _SwipeToNext = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(HangleSwipeToNextPage:)];
    [_SwipeToNext setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_Scroller addGestureRecognizer:_SwipeToNext];
    
    _SwipeToPrevious = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(HangleSwipeToPreviousPage:)];
    [_SwipeToPrevious setDirection:UISwipeGestureRecognizerDirectionRight];
    [_Scroller addGestureRecognizer:_SwipeToPrevious];
    
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


-(void) HangleSwipeToNextPage:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"HangleSwipeToNextPage %@", recognizer);
    
}

-(void) HangleSwipeToPreviousPage:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"HangleSwipeToPreviousPage");
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
    CGSize size = CGSizeMake(300, 0);
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ReadingScroller" owner:self options:nil];
    if (subviewArray == nil) {
        NSLog(@"CANNOT FIND ReadingScroller");
    }
    
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
}

@end
