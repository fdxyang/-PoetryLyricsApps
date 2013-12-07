//
//  SettingViewController.h
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetrySettingCoreData.h"
#import "FontSizeSetting.h"
#import "ThemeSetting.h"

@interface SettingViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *TableView;


// ===
@property (nonatomic, strong)   PoetrySettingCoreData   *Setting;
@property (nonatomic, strong)   NSDictionary            *NowReading;
@property (nonatomic)           FONT_SIZE_SETTING       SettingFontSize;
@property (nonatomic)           THEME_SETTING           Theme;

@property (nonatomic, strong)   FontSizeSetting         *FontSizeSettingView;
@property (nonatomic, strong)   ThemeSetting            *ThemeSettingView;
@property (nonatomic, strong)   UILabel                 *ThemePreViewLab;
@property (nonatomic, strong)   UILabel                 *FontSizeLab;

@end
