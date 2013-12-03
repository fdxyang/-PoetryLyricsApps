//
//  ReadingViewController.h
//  poetryapps
//
//  Created by Goda on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"
@interface ReadingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *Scroller;

@property (nonatomic, strong) PoetryCoreData            *PoetryDatabase;
@property (nonatomic, strong) PoetrySettingCoreData     *PoetrySetting;
@property (nonatomic, strong) NSDictionary              *PoetryNowReading;

@property THEME_SETTING DisplayTheme;
@property (nonatomic) UILabel *ContentLab;
@end
