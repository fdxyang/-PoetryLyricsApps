//
//  iPadMainPoetryViewController.h
//  poetryapps
//
//  Created by GIGIGUN on 2013/12/26.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetrySaveIntoCoreData.h"
#import "PoetrySettingCoreData.h"

#define MAIN_PAGE_LOADING_TIME  2

@interface iPadMainPoetryViewController : UIViewController

@property (nonatomic, strong) PoetrySaveIntoCoreData    *PoetrySaved;
@property (nonatomic, strong) PoetrySettingCoreData     *Setting;
@end
