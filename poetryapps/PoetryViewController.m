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
@interface PoetryViewController ()

@end

@implementation PoetryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PoetrySettingCoreData *setting = [[PoetrySettingCoreData alloc] init];
    [setting PoetrySetting_Create];
    
    PoetryCoreData *PoetryDataBase = [[PoetryCoreData alloc] init];

    NSArray *Search = [PoetryDataBase Poetry_CoreDataSearchWithPoetryName:@"1" InCategory:GUARD_READING];
    if ([Search count] == 0) {
        
        NSLog(@"Add 1.txt");
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *txtPath = [mainBundle pathForResource:@"1" ofType:@"txt"];
        
        NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
        
        NSDictionary *PoetryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"1", POETRY_CORE_DATA_NAME_KEY,
                                   string, POETRY_CORE_DATA_CONTENT_KEY,
                                   [NSNumber numberWithInt:2], POETRY_CORE_DATA_INDEX_KEY,
                                   [NSNumber numberWithInt:0], POETRY_CORE_DATA_CATERORY_KEY,nil];
        [PoetryDataBase PoetryCoreDataSave:PoetryDic inCategory:GUARD_READING];
        

    } else {
    
        NSLog(@"1.txt exist");
    }
    
    Search = [PoetryDataBase Poetry_CoreDataSearchWithPoetryName:@"2" InCategory:GUARD_READING];
    if ([Search count] == 0) {
        
        NSLog(@"Add 2.txt");
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *txtPath = [mainBundle pathForResource:@"2" ofType:@"txt"];
        
        NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
        
        NSDictionary *PoetryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"2", POETRY_CORE_DATA_NAME_KEY,
                                   string, POETRY_CORE_DATA_CONTENT_KEY,
                                   [NSNumber numberWithInt:1], POETRY_CORE_DATA_INDEX_KEY,
                                   [NSNumber numberWithInt:0], POETRY_CORE_DATA_CATERORY_KEY,nil];
        [PoetryDataBase PoetryCoreDataSave:PoetryDic inCategory:GUARD_READING];
        
        
    } else {
        
        NSLog(@"2.txt exist");
    }

    
    
/*
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *txtPath = [mainBundle pathForResource:@"1" ofType:@"txt"];
    
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    
    PoetryCoreData *PoetryDataBase = [[PoetryCoreData alloc] init];
    NSDictionary *PoetryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"2", POETRY_CORE_DATA_NAME_KEY,
                               string, POETRY_CORE_DATA_CONTENT_KEY, nil];
    
    [PoetryDataBase PoetryCoreDataSave:PoetryDic inCategory:GUARD_READING];
    */


    /*
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *txtPath = [mainBundle pathForResource:@"2" ofType:@"txt"];
    
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    
    PoetryCoreData *PoetryDataBase = [[PoetryCoreData alloc] init];
    NSDictionary *PoetryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"2", POETRY_CORE_DATA_NAME_KEY,
                               string, POETRY_CORE_DATA_CONTENT_KEY, nil];
    
    [PoetryDataBase PoetryCoreDataSave:PoetryDic inCategory:GUARD_READING];
    
*/
	// Do any additional setup after loading the view, typically from a nib.
    
    /*
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *txtPath = [mainBundle pathForResource:@"2" ofType:@"txt"];
    
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",string);
    CGRect labelframe = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    UILabel *label = [[UILabel alloc] initWithFrame:labelframe];
    //    将sring内容赋给lable的text属性
    label.text=string;
    //  背景颜色设置成透明色
    label.backgroundColor = [UIColor whiteColor];
    //    字体颜色设置成红色
    label.textColor= [UIColor blackColor];
    
    //等于0表示可根据具实际情况自动变动
    label.numberOfLines = 0;
    
    [self.view addSubview:label];
    
    */
    /*
    
    // [CASPER] 2013.11.26 Sample code for saving into core data
    PoetryCoreData *PoetryDataBase = [[PoetryCoreData alloc] init];
    NSDictionary *PoetryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"data", POETRY_CORE_DATA_NAME_KEY,
                            string, POETRY_CORE_DATA_CONTENT_KEY, nil];
    
    [PoetryDataBase PoetryCoreDataSave:PoetryDic];
    // [CASPER] 2013.11.26 Sample code for saving into core data ==
    
    // [CASPER] 2013.11.26 Sample code for fetching core data
    NSArray *PoetryList = [PoetryDataBase Poetry_CoreDataFetchData];
    NSLog(@"Poetry List Count = %d", [PoetryList count]);
    NSLog(@"Poetry Name = %@", [[PoetryList firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
    NSLog(@"Poetry Content = %@", [[PoetryList firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
    // [CASPER] 2013.11.26 Sample code for fetching core data ==
*/
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
