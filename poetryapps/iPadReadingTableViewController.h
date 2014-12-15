//
//  iPadReadingTableViewController.h
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/21.
//  Copyright (c) 2014年 cc. All rights reserved.
//
//  2014.11.09 [Casper] Replace searching btn img
//  2014.12.10 [Casper] Fixed the new poetry in iPad makes the toc table display error



#import <UIKit/UIKit.h>
#import "PoetryReadingView.h"
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"
#import "Animations.h"
#import "iPadNavTableHeader.h"
#import "SettingViewController.h"
#import "ILTranslucentView.h"
#import <MessageUI/MessageUI.h>



#define UI_READING_TABLEVIEW_INIT_IPAD       CGRectMake(0, 0, UI_IPAD_SCREEN_WIDTH, UI_IPAD_SCREEN_HEIGHT)
#define UI_READING_TABLEVIEW_NEXT_IPAD       CGRectMake(UI_IPAD_SCREEN_WIDTH, 0, UI_IPAD_SCREEN_WIDTH, UI_IPAD_SCREEN_HEIGHT)
#define SWITCH_VIEW_THRESHOLD                40
#define UI_FONT_SIZE_AMP                     10
#define UI_READING_TABLE_AMP                 UI_FONT_SIZE_AMP + 10
#define UI_BOLD_FONT_BIAS                    5
#define READING_POETRY_NAME_INDEX            1

// define for cover view
#define UI_IPAD_TABLEVIEW_WIDTH                     300
#define UI_IPAD_TOC_TABLEVIEW_WIDTH                 300

#define UI_IPAD_COVER_TABLE_CELL_HEIGHT             44
#define UI_IPAD_COVER_TABLE_CELL_HEADER_HEIGHT      30

#define UI_IPAD_COVER_TABLEVIEW_HEIGHT              UI_IPAD_COVER_TABLE_CELL_HEIGHT * 4
// 2014.12.10 [Casper]
// Since the guard reading increased to 6

//#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_GUARD    UI_IPAD_COVER_TABLE_CELL_HEIGHT * 5
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_GUARD    UI_IPAD_COVER_TABLE_CELL_HEIGHT * 6
// 2014.12.10 [Casper] ==


#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY   UI_IPAD_SCREEN_HEIGHT - 160
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_RESPON   UI_IPAD_SCREEN_HEIGHT - 160
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_HISTORY  UI_IPAD_COVER_TABLE_CELL_HEIGHT * POETRY_MAX_NUMBER_IN_HISTORY
#define UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_MAX      UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY

#define UI_IPAD_NAVI_BTN_RECT_INIT                  CGRectMake(40, 140, 70, 70)
#define UI_IPAD_NAVI_BTN_RECT_HIDE                  CGRectMake(-10, 0, 0, 0)
#define UI_IPAD_COVER_SETTING_BTN_RECT_INIT         CGRectMake(UI_IPAD_SCREEN_WIDTH , 40, 0, 0)
#define UI_IPAD_COVER_SETTING_BTN_RECT_ON_COVER     CGRectMake(UI_IPAD_SCREEN_WIDTH - 110, 140, 70, 70)
#define UI_IPAD_COVER_SEARCH_BAR_RECT_INIT          CGRectMake(1024, 300, 350, 50)
#define UI_IPAD_COVER_SEARCH_BAR_RECT_ON_COVER      CGRectMake(1024 - 350 - 10, 300, 350, 50)
#define UI_IPAD_COVER_SETTING_TABLE_RECT_INIT       CGRectMake(1024, 250, 320, 550)

#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_HEADER                 CGRectMake(-300, 95, UI_IPAD_TOC_TABLEVIEW_WIDTH, 50)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_GUARDREADING      CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_GUARD)

#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_POETRY            CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_POETRY)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT_RESPONSIVE        CGRectMake(-300, 150, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TOC_TABLEVIEW_HEIGHT_RESPON)


#define UI_IPAD_COVER_TABLEVIEW_RECT_INIT           CGRectMake(-320, 150, UI_IPAD_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)
#define UI_IPAD_COVER_TABLEVIEW_RECT_ON_COVER       CGRectMake(0, 150, UI_IPAD_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)
#define UI_IPAD_COVER_TOC_TABLEVIEW_RECT_INIT       CGRectMake(-320, 100, UI_IPAD_TOC_TABLEVIEW_WIDTH, UI_IPAD_COVER_TABLEVIEW_HEIGHT)
#define UI_IPAD_READING_SPECIAL_CHAR_IMG_RECT                CGRectMake(0, 0, UI_IPAD_SCREEN_WIDTH, UI_IPAD_SCREEN_HEIGHT)

#define UI_IPAD_READING_TUTORIAL_IMG_RECT                CGRectMake(0, 0, UI_IPAD_SCREEN_HEIGHT * 0.66, UI_IPAD_SCREEN_HEIGHT * 0.66)


#define IPAD_SEARCH_BTN_IMG_NAME    @"ipad_button_search_200_200-01.png" //  2014.11.09 [Casper]

#pragma mark - About Me Items
#define ABOUNT_BACKGROUND  [UIColor colorWithRed:(242.0f/255) green:(242.0f/255) blue:(242.0f/255) alpha:0.95]
#define IPAD_ABOUT_HIPPO_IMG_NAME   @"iPadAboutMe_Hippo.png"
#define IPAD_ABOUT_CPR_1_IMG_NAME   @"iPadAboutMe_CopyRight1.png"
#define IPAD_ABOUT_CPR_2_IMG_NAME   @"iPadAboutMe_CopyRight2.png"
#define IPAD_ABOUT_CPR_3_IMG_NAME   @"iPadAboutMe_CopyRight3.png"
#define IPAD_ABOUT_TITLE_IMG_NAME   @"iPadAboutMe_AboutTitle.png"
#define IPAD_ABOUT_FB_BTN_IMG_NAME  @"iPad_fbfans.png"
#define IPAD_ABOUT_BG_BTN_IMG_NAME  @"iPad_blogicon.png"
#define IPAD_ABOUT_RA_BTN_IMG_NAME  @"iPad_rateicon.png"
#define IPAD_ABOUT_EM_BTN_IMG_NAME  @"iPad_emailicon.png"

#define IPAD_ABOUT_HIPPO_IMG_SIZE  CGSizeMake(166.25 * 1.8, 175 * 1.8)
#define IPAD_ABOUT_TITLE_IMG_SIZE  CGSizeMake(230, 129.5)
#define IPAD_ABOUT_CPR_1_IMG_SIZE  CGSizeMake(500, 143.75)
#define IPAD_ABOUT_CPR_2_IMG_SIZE  CGSizeMake(500, 110)
#define IPAD_ABOUT_CPR_3_IMG_SIZE  CGSizeMake(500, 105)
#define IPAD_ABOUT_BTNS_IMG_SIZE   CGSizeMake(100, 100)

#define IPAD_ABOUT_HIPPO_IMG_LOCA_INIT  CGPointMake(0, UI_IPAD_SCREEN_WIDTH)
#define IPAD_ABOUT_TITLE_IMG_LOCA_INIT  CGPointMake(90, UI_IPAD_SCREEN_WIDTH)
#define IPAD_ABOUT_CPR_1_IMG_LOCA_INIT  CGPointMake(340, UI_IPAD_SCREEN_WIDTH)
#define IPAD_ABOUT_CPR_2_IMG_LOCA_INIT  CGPointMake(340, UI_IPAD_SCREEN_WIDTH)
#define IPAD_ABOUT_CPR_3_IMG_LOCA_INIT  CGPointMake(340, UI_IPAD_SCREEN_WIDTH)
#define IPAD_ABOUT_BTN_1_IMG_LOCA_INIT  CGPointMake(870, UI_IPAD_SCREEN_WIDTH)



#define IPAD_ABOUT_HIPPO_IMG_LOCA  CGPointMake(IPAD_ABOUT_HIPPO_IMG_LOCA_INIT.x, 270)
#define IPAD_ABOUT_TITLE_IMG_LOCA  CGPointMake(IPAD_ABOUT_TITLE_IMG_LOCA_INIT.x, 80)
#define IPAD_ABOUT_CPR_1_IMG_LOCA  CGPointMake(IPAD_ABOUT_CPR_1_IMG_LOCA_INIT.x, 110)
#define IPAD_ABOUT_CPR_2_IMG_LOCA  CGPointMake(IPAD_ABOUT_CPR_1_IMG_LOCA_INIT.x, 110 + IPAD_ABOUT_CPR_1_IMG_SIZE.height)
#define IPAD_ABOUT_CPR_3_IMG_LOCA  CGPointMake(IPAD_ABOUT_CPR_1_IMG_LOCA_INIT.x, 110 + IPAD_ABOUT_CPR_1_IMG_SIZE.height + IPAD_ABOUT_CPR_2_IMG_SIZE.height)
#define IPAD_ABOUT_BTN_1_IMG_LOCA  CGPointMake(IPAD_ABOUT_BTN_1_IMG_LOCA_INIT.x, 110)



#define TAG_COVER_VIEW                  3
#define TAG_NAVI_BTN                    6
#define TAG_CATEGORY_TABLE_VIEW         4
#define TAG_TOC_TABLE_VIEW              7
#define TAG_SETTING_TABLE_VIEW          5
#define TAG_TUTORIAL_VIEW               10


@interface iPadReadingTableViewController : UIViewController <  UIGestureRecognizerDelegate,
                                                                UITableViewDataSource,
                                                                UITableViewDelegate,
                                                                UISearchBarDelegate,
                                                                MFMailComposeViewControllerDelegate>

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
    COVER_ABOUT_ME,
} COVER_VIEW_STATE;


@property (nonatomic, strong)   UIView                  *CoverView;
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


#pragma mark - About Me Items members
@property (retain)   UIImageView             *About_HippoImgView;
@property (retain)   UIImageView             *About_CopyRightImgView1;
@property (retain)   UIImageView             *About_CopyRightImgView2;
@property (retain)   UIImageView             *About_CopyRightImgView3;
@property (retain)   UIImageView             *About_TitleImgView;
@property (retain)   UIButton                *About_fbfansBtn;
@property (retain)   UIButton                *About_blogBtn;
@property (retain)   UIButton                *About_emailBtn;
@property (retain)   UIButton                *About_rateBtn;
@end
