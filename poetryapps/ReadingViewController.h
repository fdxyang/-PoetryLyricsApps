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

#define UI_IOS7_VERSION_FLOATING   7.0f
#define UI_IOS7_TAB_BAR_HEIGHT     49


@interface ReadingViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong)           UIScrollView                *Scroller;
@property (nonatomic, strong)           PoetryCoreData              *PoetryDatabase;
@property (nonatomic, strong)           PoetrySettingCoreData       *PoetrySetting;
@property (nonatomic, strong)           NSDictionary                *PoetryNowReading;

@property                               THEME_SETTING               DisplayTheme;
@property (nonatomic, strong)           NSMutableArray              *DisplayLabArray; //Number = 2

@property (nonatomic)                   UILabel                     *ContentLab;
@property (nonatomic)                   UILabel                     *NextContentLab;
@property (nonatomic)                   UILabel                     *PreviousContentLab;

@end
