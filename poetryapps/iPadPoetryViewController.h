//
//  iPadPoetryViewController.h
//  poetryapps
//
//  Created by GIGIGUN on 2013/12/13.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetryReadingView.h"
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"
#import "Animations.h"
#import "PoetrySaveIntoCoreData.h"
#import "SettingViewController.h"
#import "iPadNavTableHeader.h"

#import "GAITrackedViewController.h"
#import "GAI.h"

#define UI_TABLE_WIDTH                  330
#define UI_READING_VIEW_ORIGIN_X        0
#define UI_IPAD_READINGVIEW_WIDTH       UI_IPAD_SCREEN_WIDTH
#define UI_IPAD_TEXT_LABEL_TITLE_HEAD_Y 200.0f // Reserved for header
#define IPAD_SWITCH_VIEW_THRESHOLD      60

#define UI_READING_VIEW_FRAME_RECT_INIT             CGRectMake(0, 0, UI_IPAD_READINGVIEW_WIDTH, 768)

//#define UI_IPAD_NAVI_BTN_RECT_INIT                  CGRectMake(30, 50, 70, 70)
#define UI_IPAD_NAVI_BTN_RECT_INIT                  CGRectMake(40, 90, 70, 70)
#define UI_IPAD_NAVI_BTN_RECT_HIDE                  CGRectMake(-10, 0, 0, 0)


#define UI_IPAD_COVER_TABLE_CELL_HEIGHT             44
#define UI_IPAD_COVER_TABLE_CELL_HEADER_HEIGHT      17

#define UI_IPAD_COVER_TABLEVIEW_HEIGHT              UI_IPAD_COVER_TABLE_CELL_HEIGHT * 4
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_GUARD    UI_IPAD_COVER_TABLE_CELL_HEIGHT * 5
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY   UI_IPAD_SCREEN_HEIGHT - 160
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_RESPON   UI_IPAD_SCREEN_HEIGHT - 160
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_HISTORY  UI_IPAD_COVER_TABLE_CELL_HEIGHT * POETRY_MAX_NUMBER_IN_HISTORY
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_MAX      UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY


#define UI_IPAD_TABLEVIEW_WIDTH                     300
#define UI_IPAD_TOC_TABLEVIEW_WIDTH                 300

#define UI_IPAD_READING_TITLE_RECT_LABEL            CGRectMake(0, 90, UI_IPAD_READINGVIEW_WIDTH, 100);

#define UI_IPAD_NAVI_VIEW_WIDTH                     150
#define UI_IPAD_PREV_VIEW_RECT_INIT                 CGRectMake(0, 0, UI_IPAD_NAVI_VIEW_WIDTH, UI_IPAD_SCREEN_HEIGHT)
#define UI_IPAD_NEXT_VIEW_RECT_INIT                 CGRectMake(UI_IPAD_SCREEN_WIDTH - UI_IPAD_NAVI_VIEW_WIDTH, 0, UI_IPAD_NAVI_VIEW_WIDTH, UI_IPAD_SCREEN_HEIGHT)

#define UI_IPAD_COVER_TABLEVIEW_RECT_INIT           CGRectMake(-320, 150, UI_IPAD_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)
#define UI_IPAD_COVER_TABLEVIEW_RECT_ON_COVER       CGRectMake(0, 150, UI_IPAD_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT       CGRectMake(-320, 100, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)
#define UI_IPAD_COVER_SETTING_BTN_RECT_INIT         CGRectMake(UI_IPAD_SCREEN_WIDTH , 40, 0, 0)
#define UI_IPAD_COVER_SETTING_BTN_RECT_ON_COVER     CGRectMake(UI_IPAD_SCREEN_WIDTH - 110, 90, 70, 70)
#define UI_IPAD_COVER_SEARCH_BAR_RECT_INIT          CGRectMake(1024, 300, 350, 50)
#define UI_IPAD_COVER_SEARCH_BAR_RECT_ON_COVER      CGRectMake(574, 300, 350, 50)
#define UI_IPAD_COVER_SETTING_TABLE_RECT_INIT       CGRectMake(1024, 200, 320, 550)


#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_HEADER                 CGRectMake(-300, 100, UI_IPAD_TOC_TABLEVIEW_WIDTH, 50)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_GUARDREADING      CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_GUARD)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_POETRY            CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_RESPONSIVE        CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_RESPON)




#define TAG_READING_VIEW_1              1
#define TAG_READING_VIEW_2              2
#define TAG_COVER_VIEW                  3
#define TAG_TABLE_VIEW                  4
#define TAG_SETTING_TABLE_VIEW          5
#define TAG_NAVI_BTN                    6
#define TAG_TOC_TABLE_VIEW              7
/*
#define TAG_PREV_TOUCH_VIEW             7
#define TAG_NEXT_TOUCH_VIEW             8
*/

//#define DEBUG_IPAD_READINGVIEW
#ifdef DEBUG_IPAD_READINGVIEW
#   define IPAD_READING_VIEW_LOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define IPAD_READING_VIEW_LOG(...)
#endif

#define IPAD_READING_VIEW_ERROR_LOG(fmt, ...) NSLog((@"ERROR !! %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)




@interface iPadPoetryViewController : GAITrackedViewController <UITableViewDelegate,
                                                                UITableViewDataSource,
                                                                UIGestureRecognizerDelegate,
                                                                UISearchBarDelegate>


@property (nonatomic, strong) UIScrollView              *Scroller;
@property (nonatomic, strong) UIView                    *CoverView;

@property (nonatomic, strong) NSMutableArray            *NowReadingCategoryArray;
@property (nonatomic, strong) PoetryReadingView         *ReadingView1;
@property (nonatomic, strong) PoetryReadingView         *ReadingView2;
@property (nonatomic, strong) PoetryReadingView         *EmptyReadingView;
@property (nonatomic, strong) PoetryCoreData            *PoetryDatabase;
//@property (nonatomic, strong) PoetrySaveIntoCoreData    *PoetrySaved;
@property (nonatomic, strong) PoetrySettingCoreData     *Setting;

@property (nonatomic, strong) NSDictionary              *PoetryNowReading;
@property (nonatomic, strong) NSDictionary              *NewDataDic;
@property (nonatomic, strong) UIFont                    *font;
@property                     THEME_SETTING             DisplayTheme;

@property (nonatomic, strong) UIButton                  *NaviBtn;
/*
@property (nonatomic, strong) UIView                    *PrevTouchView; 
@property (nonatomic, strong) UIView                    *NextTouchView;
 */
@property (nonatomic, strong) UIButton                  *SettingBtn;

// Setting members
@property (nonatomic, strong)   UITableView             *SettingTableView;
@property (nonatomic, strong)   NSString                *NowReadingText;
@property (nonatomic)           FONT_SIZE_SETTING       SettingFontSize;

@property (nonatomic, strong)   FontSizeSetting         *FontSizeSettingView;
@property (nonatomic, strong)   ThemeSetting            *ThemeSettingView;
@property (nonatomic, strong)   UILabel                 *ThemePreViewLab;
@property (nonatomic, strong)   UILabel                 *FontSizeLab;

// Search members
@property (nonatomic, strong)   UISearchBar             *SearchBar;

@property (nonatomic, strong)   NSMutableArray          *SearchHistoryData;
@property (nonatomic, strong)   NSMutableArray          *SearchGuidedReading;
@property (nonatomic, strong)   NSMutableArray          *SearchPoetryData;
@property (nonatomic, strong)   NSMutableArray          *SearchRespose;
@property (nonatomic, strong)   NSArray                 *SearchResultDisplayArray;

@property (nonatomic, strong)   NSMutableArray          *TableData;
@property (nonatomic, strong)   UITableView             *TableView;
@property (nonatomic, strong)   NSMutableArray          *TocTableData;
@property (nonatomic, strong)   UITableView             *TocTableView;
@property (nonatomic, strong)   iPadNavTableHeader      *NavigationHeader;

// 2014.01.20 [CASPER] Change reading view to table view
@property (strong, nonatomic)   UITableView                 *TableView1;
@property (strong, nonatomic)   UITableView                 *TableView2;
@property (strong, nonatomic)   NSMutableArray              *ReadingTableArray1;
@property (strong, nonatomic)   NSMutableArray              *ReadingTableArray2;
// 2014.01.20 [CASPER] Change reading view to table view == 

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

typedef enum {
    COVER_IDLE,
    COVER_INIT,
    COVER_SEARCH,
    COVER_SETTING,
} COVER_VIEW_STATE;

@end
