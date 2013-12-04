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


@interface ReadingViewController : UIViewController

@property (nonatomic, strong)           UIScrollView                *Scroller;
@property (nonatomic, strong)           PoetryCoreData              *PoetryDatabase;
@property (nonatomic, strong)           PoetrySettingCoreData       *PoetrySetting;
@property (nonatomic, strong)           NSDictionary                *PoetryNowReading;

@property (nonatomic, strong)           UISwipeGestureRecognizer    *SwipeToNext;
@property (nonatomic, strong)           UISwipeGestureRecognizer    *SwipeToPrevious;


@property                               THEME_SETTING               DisplayTheme;
@property (nonatomic)                   UILabel                     *ContentLab;
@end
