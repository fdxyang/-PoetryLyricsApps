//
//  iPadMainPoetryViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2013/12/26.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "iPadMainPoetryViewController.h"

@interface iPadMainPoetryViewController (){
    UInt16      _TimerCount;
    NSTimer     *_Timer;
    UILabel     *_CountDownLab;
}

@end

@implementation iPadMainPoetryViewController

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
    UILabel *WelcomeLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 800, 100)];
    _CountDownLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 600, 200, 100)];
    [_CountDownLab setCenter:CGPointMake(1024/2, 600)];
    
    [WelcomeLab setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:70]];
    [_CountDownLab setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:50]];

    WelcomeLab.text = @"This is welcome view";
    WelcomeLab.textAlignment = NSTextAlignmentCenter;
    _CountDownLab.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:WelcomeLab];
    [self.view addSubview:_CountDownLab];
    
    _TimerCount = 0;
    _Setting = [[PoetrySettingCoreData alloc] init];
    [_Setting PoetrySetting_Create];
    
    if  (_Setting.DataSaved == NO) {
        _PoetrySaved = [[PoetrySaveIntoCoreData alloc] init];
        [_PoetrySaved isCoreDataSave];
    }
    _CountDownLab.text = [NSString stringWithFormat:@"%d", MAIN_PAGE_LOADING_TIME];

    
    _Timer = [NSTimer scheduledTimerWithTimeInterval: 1
                                             target: self
                                           selector: @selector(handleTimer:)
                                           userInfo: nil
                                            repeats: YES];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleTimer: (NSTimer *) timer
{
    _TimerCount++;
    //NSLog(@"%d", TimerCount);
    if (_TimerCount == MAIN_PAGE_LOADING_TIME) {
        
        UIViewController *View = [self.storyboard instantiateViewControllerWithIdentifier:@"iPadViewController"];

        [self presentViewController:View animated:YES completion:^{
            [_Timer invalidate];
        }];
    } else {
        
        _CountDownLab.text = [NSString stringWithFormat:@"%d", (MAIN_PAGE_LOADING_TIME - _TimerCount)];
    }
    
    
}


@end
