//
//  PoetrySettingCoreData.h
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoetryAppDelegate.h"   

#define POETRY_CORE_DATA_SETTING_ENTITY         @"Setting"
#define POETRY_CORE_DATA_SETTING_FONT_SIZE      @"fontSize"

#define POETRY_SETIING_DEFAULT_FONT_SIZE        16

@interface PoetrySettingCoreData : NSObject

@property (nonatomic, strong)   NSManagedObjectContext  *context;

@property (nonatomic, getter = PoetrySetting_GetFontSizeSetting)    UInt16  SettingFontSize;

-(PoetrySettingCoreData*) init;
-(BOOL) PoetrySetting_SetDefault;

-(NSDictionary*) PoetrySetting_ReadSetting;
-(UInt16) PoetrySetting_GetFontSizeSetting;


@end
