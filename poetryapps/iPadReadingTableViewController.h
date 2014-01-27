//
//  iPadReadingTableViewController.h
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/21.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetryReadingView.h"
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"
#import "Animations.h"
#import "iPadNavTableHeader.h"
#import "SettingViewController.h"
#import "ILTranslucentView.h"


#define UI_READING_TABLEVIEW_INIT_IPAD       CGRectMake(0, 0, UI_IPAD_SCREEN_WIDTH, UI_IPAD_SCREEN_HEIGHT)
#define UI_READING_TABLEVIEW_NEXT_IPAD       CGRectMake(UI_IPAD_SCREEN_WIDTH, 0, UI_IPAD_SCREEN_WIDTH, UI_IPAD_SCREEN_HEIGHT)
#define SWITCH_VIEW_THRESHOLD                40
#define UI_FONT_SIZE_AMP                     10
#define UI_READING_TABLE_AMP                 UI_FONT_SIZE_AMP + 5
#define UI_BOLD_FONT_BIAS                    5
#define READING_POETRY_NAME_INDEX            1

// define for cover view
#define UI_IPAD_TABLEVIEW_WIDTH                     300
#define UI_IPAD_TOC_TABLEVIEW_WIDTH                 300

#define UI_IPAD_COVER_TABLE_CELL_HEIGHT             44
#define UI_IPAD_COVER_TABLE_CELL_HEADER_HEIGHT      20

#define UI_IPAD_COVER_TABLEVIEW_HEIGHT              UI_IPAD_COVER_TABLE_CELL_HEIGHT * 4
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_GUARD    UI_IPAD_COVER_TABLE_CELL_HEIGHT * 5

#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY   UI_IPAD_SCREEN_HEIGHT - 160
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_RESPON   UI_IPAD_SCREEN_HEIGHT - 160
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_HISTORY  UI_IPAD_COVER_TABLE_CELL_HEIGHT * POETRY_MAX_NUMBER_IN_HISTORY
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_MAX      UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY

#define UI_IPAD_NAVI_BTN_RECT_INIT                  CGRectMake(40, 140, 70, 70)
#define UI_IPAD_NAVI_BTN_RECT_HIDE                  CGRectMake(-10, 0, 0, 0)
#define UI_IPAD_COVER_SETTING_BTN_RECT_INIT         CGRectMake(UI_IPAD_SCREEN_WIDTH , 40, 0, 0)
#define UI_IPAD_COVER_SETTING_BTN_RECT_ON_COVER     CGRectMake(UI_IPAD_SCREEN_WIDTH - 110, 140, 70, 70)
#define UI_IPAD_COVER_SEARCH_BAR_RECT_INIT          CGRectMake(1024, 300, 350, 50)
#define UI_IPAD_COVER_SEARCH_BAR_RECT_ON_COVER      CGRectMake(574, 300, 350, 50)
#define UI_IPAD_COVER_SETTING_TABLE_RECT_INIT       CGRectMake(1024, 250, 320, 550)

#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_HEADER                 CGRectMake(-300, 95, UI_IPAD_TOC_TABLEVIEW_WIDTH, 50)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_GUARDREADING      CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_GUARD)

#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_POETRY            CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_RESPONSIVE        CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_RESPON)


#define UI_IPAD_COVER_TABLEVIEW_RECT_INIT           CGRectMake(-320, 150, UI_IPAD_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)
#define UI_IPAD_COVER_TABLEVIEW_RECT_ON_COVER       CGRectMake(0, 150, UI_IPAD_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT       CGRectMake(-320, 100, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)




#define TAG_COVER_VIEW                  3
#define TAG_NAVI_BTN                    6
#define TAG_CATEGORY_TABLE_VIEW         4
#define TAG_TOC_TABLE_VIEW              7
#define TAG_SETTING_TABLE_VIEW          5


@interface iPadReadingTableViewController : UIViewController <  UIGestureRecognizerDelegate,
                                                                UITableViewDataSource,
                                                                UITableViewDelegate,
                                                                UISearchBarDelegate>

@property (strong, nonatomic)   UITableView                 *TableView1;
@property (strong, nonatomic)   UITableView                 *TableView2;
@property (strong, nonatomic)   NSMutableArray              *ReadingTableArray1;
@property (strong, nonatomic)   NSMutableArray              *ReadingTableArray2;

@property (nonatomic, strong)   PoetryCoreData              *PoetryDatabase;
@property (nonatomic, strong)   PoetrySettingCoreData       *PoetrySetting;
@property (nonatomic, strong)   NSDictionary                *PoetryNowReading;
@property (nonatomic, strong)   NSMutableArray              *NowReadingCategoryArray;
@property (nonatomic, strong)   UILabel                     *HeadAndTailLab;

typedef enum {
    VIEW1 = 0x00,
    VIEW2,
}CURRENT_VIEW;


typedef enum {
    SlideLabelNone,
    SlideLabelLeftToRigth,
    SlideLabelRightToLegt,
}SLIDE_DIRECTION;

typedef enum {
    None,
    DirectionJudgement,
    ViewMoving,
    ConfirmedSwitch,
}GESTURE_MOVE_STATE;


#pragma mark - Menu Cover members

typedef enum {
    COVER_IDLE,
    COVER_INIT,
    COVER_SEARCH,
    COVER_SETTING,
} COVER_VIEW_STATE;


@property (nonatomic, strong)   ILTranslucentView       *CoverView;
@property (nonatomic, strong)   UITableView             *CategoryTableView;

@property (nonatomic, strong)   NSMutableArray          *TableData;
@property (nonatomic, strong)   NSMutableArray          *TocTableData;
@property (nonatomic, strong)   UITableView             *TocTableView;
@property (nonatomic, strong)   iPadNavTableHeader      *NavigationHeader;
@property (nonatomic, strong)   UIButton                *NaviBtn;
@property (nonatomic, strong)   UIButton                *SettingBtn;
@property (nonatomic, strong)   UITableView             *SettingTableView;


#pragma mark - Search function members

@property (nonatomic, strong)   UISearchBar             *SearchBar;

@property (nonatomic, strong)   NSMutableArray          *SearchHistoryData;
@property (nonatomic, strong)   NSMutableArray          *SearchGuidedReading;
@property (nonatomic, strong)   NSMutableArray          *SearchPoetryData;
@property (nonatomic, strong)   NSMutableArray          *SearchRespose;
@property (nonatomic, strong)   NSArray                 *SearchResultDisplayArray;

#pragma mark - Setting function members
@property (nonatomic, strong)   FontSizeSetting         *FontSizeSettingView;
@property (nonatomic, strong)   ThemeSetting            *ThemeSettingView;
@property (nonatomic, strong)   UILabel                 *ThemePreViewLab;
@property (nonatomic, strong)   UILabel                 *FontSizeLab;
@property (nonatomic, strong)   NSString                *NowReadingText;


@end
