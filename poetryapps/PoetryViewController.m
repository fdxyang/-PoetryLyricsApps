//
//  PoetryViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/25.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "PoetryViewController.h"
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"
#import "PoetrySaveIntoCoreData.h"

@interface PoetryViewController ()

@end

@implementation PoetryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Kevin add timer for test
    NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
    long int date1 = (long int)time1;
    //NSLog(@"date1\n%lu", date1);
    // Kevin add timer for test
    
    
    
    PoetrySaveIntoCoreData *saveIntoCoreData = [[PoetrySaveIntoCoreData alloc]init];
    BOOL isSuccessful = [saveIntoCoreData isCoreDataSave];
    NSLog(@"isSuccessful = %d",isSuccessful);
    
    
    
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

@end
