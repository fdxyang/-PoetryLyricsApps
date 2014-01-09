//
//  PoetryViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/25.
//  Copyright (c) 2013年 cc. All rights reserved.
//
//  2014.01.06 [CASPER] Add timer 

#import "PoetryViewController.h"
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"
#import "PoetrySaveIntoCoreData.h"

// 2014.01.06 [CASPER]
#define MAIN_PAGE_LOADING_TIME  2

@interface PoetryViewController () {
    NSTimer     *_Timer;
    UInt16      _TimerCount;
}

@end

@implementation PoetryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _TimerCount = 0;
    _Timer = [NSTimer scheduledTimerWithTimeInterval: 1
                                              target: self
                                            selector: @selector(handleTimer:)
                                            userInfo: nil
                                             repeats: YES];

    UIColor *Background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"welcome_page.png"]];

    [self.view setBackgroundColor:Background];
    // Kevin add timer for test
    NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
    long int date1 = (long int)time1;
    //NSLog(@"date1\n%lu", date1);
    // Kevin add timer for test
    
    
    
    PoetrySaveIntoCoreData *saveIntoCoreData = [[PoetrySaveIntoCoreData alloc]init];
    BOOL isSuccessful = [saveIntoCoreData isCoreDataSave];
    if(!isSuccessful)
        NSLog(@"Save into core data Error!!!!!!!!!!");
    
    
    
    // Kevin add timer for test
    NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
    long int date2 = (long int)time2;
    //NSLog(@"date2\n%lu", date2);
    
    long int d3 = date2 - date1;
    NSLog(@"handle core data time difference :%lu", d3);
    // Kevin add timer for test
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 2014.01.06 [CASPER]
- (void) handleTimer: (NSTimer *) timer
{
    _TimerCount++;
    //NSLog(@"%d", TimerCount);
    if (_TimerCount == MAIN_PAGE_LOADING_TIME) {
        
        UIViewController *View = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabView"];
        
        [self presentViewController:View animated:YES completion:^{
            [_Timer invalidate];
        }];
    } else {
        
        NSLog(@"Count down");
        //_CountDownLab.text = [NSString stringWithFormat:@"%d", (MAIN_PAGE_LOADING_TIME - _TimerCount)];
    }
}

// 2014.01.06 [CASPER] ==

@end
