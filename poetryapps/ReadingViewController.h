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
#import "PoetryReadingView.h"

#define UI_4_INCH_HEIGHT                568
#define UI_3_5_INCH_HEIGHT              480
#define UI_IOS7_VERSION_FLOATING        7.0f
#define UI_IOS7_TAB_BAR_HEIGHT          49
#define UI_IOS7_NAV_BAR_HEIGHT          44

#define UI_DEFAULT_PREVIOUS_ORIGIN_X    -320
#define UI_DEFAULT_NEXT_ORIGIN_X        320
#define UI_DEFAULT_LABEL_ORIGIN_Y       10
#define UI_DEFAULT_LABEL_ORIGIN_X       10
#define UI_DEFAULT_SCREEN_WIDTH         320
#define UI_DEFAULT_LABEL_WIDTH          280

#define SWITCH_VIEW_THRESHOLD           40

//#define DEBUG_READINGVIEW
#ifdef DEBUG_READINGVIEW
#   define READING_VIEW_LOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define READING_VIEW_LOG(...)
#endif

#define READING_VIEW_ERROR_LOG(fmt, ...) NSLog((@"ERROR !! %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)



@interface ReadingViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong)           UIScrollView                *Scroller;
@property (nonatomic, strong)           PoetryCoreData              *PoetryDatabase;
@property (nonatomic, strong)           PoetrySettingCoreData       *PoetrySetting;
@property (nonatomic, strong)           NSDictionary                *PoetryNowReading;
@property (nonatomic, strong)           NSDictionary                *NewDataDic;
@property (nonatomic, strong)           UIFont                      *font;
@property                               THEME_SETTING               DisplayTheme;

//[CASPER] Improve Reading View
@property (nonatomic, strong)           NSMutableArray              *NowReadingCategoryArray;
@property (nonatomic, strong)           PoetryReadingView           *ReadingView1;
@property (nonatomic, strong)           PoetryReadingView           *ReadingView2;
@property (nonatomic, strong)           PoetryReadingView           *EmptyReadingView;

typedef enum {
    VIEW1 = 0x00,
    VIEW2,
}CURRENT_VIEW;
//[CASPER] Improve Reading View ==


typedef enum {
    SlideLabelNone,
    SlideLabelLeftToRigth,
    SlideLabelRightToLegt,
}SLIDE_DIRECTION;

/*
typedef enum {
    LABEL1 = 0x00,
    LABEL2,
}CURRENT_LABEL;


@property (nonatomic)                   UILabel                     *Label1;
@property (nonatomic)                   UILabel                     *Label2;
*/


@end
