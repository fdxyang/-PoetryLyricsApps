//
//  SettingViewController.h
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetrySettingCoreData.h"

@interface SettingViewController : UIViewController

@property (nonatomic, strong)   PoetrySettingCoreData   *Setting;
@property (nonatomic)           UInt16                  SettingFontSize;
@property (nonatomic)           THEME_SETTING           Theme;

@end
