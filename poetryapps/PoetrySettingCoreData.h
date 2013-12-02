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
#define POETRY_CORE_DATA_SETTING_THEME          @"theme"

#define POETRY_SETIING_FONT_SIZE_DEFAULT        24
#define POETRY_SETIING_FONT_SIZE_SMALL          20
#define POETRY_SETIING_FONT_SIZE_MEDIUM         POETRY_SETIING_FONT_SIZE_DEFAULT
#define POETRY_SETIING_FONT_SIZE_LARGE          30

#define POETRY_SETTING_THEME_DEFAULT            0

@interface PoetrySettingCoreData : NSObject

@property (nonatomic, strong)   NSManagedObjectContext  *context;

typedef enum {
    FONT_SIZE_SMALL = 0x00,
    FONT_SIZE_MEDIUM,
    FONT_SIZE_LARGE,
} FONT_SIZE_SETTING;

typedef enum {
    THEME_LIGHT_DARK = 0x00,    // Font color = Black, Background = White
    THEME_DARK_LIGHT,           // Font color = White, Background = Black
} THEME_SETTING;


@property (nonatomic, getter = PoetrySetting_GetFontSizeSetting)    UInt16          SettingFontSize;
@property (nonatomic)                                               THEME_SETTING   SettingTheme;

-(PoetrySettingCoreData*) init;
-(BOOL) PoetrySetting_Create;
-(BOOL) PoetrySetting_SetDefault;

-(NSDictionary*) PoetrySetting_ReadSetting;
-(UInt16) PoetrySetting_GetFontSizeSetting;


@end
