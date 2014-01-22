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

#define UI_READING_TABLEVIEW_INIT_IPAD       CGRectMake(0, 0, UI_IPAD_SCREEN_WIDTH, UI_IPAD_SCREEN_HEIGHT)
#define UI_READING_TABLEVIEW_NEXT_IPAD       CGRectMake(UI_IPAD_SCREEN_WIDTH, 0, UI_IPAD_SCREEN_WIDTH, UI_IPAD_SCREEN_HEIGHT)
#define SWITCH_VIEW_THRESHOLD                40
#define UI_BOLD_FONT_BIAS                    5
#define READING_POETRY_NAME_INDEX            1


@interface iPadReadingTableViewController : UIViewController <  UIGestureRecognizerDelegate,
                                                                UITableViewDataSource,
                                                                UITableViewDelegate>

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


@end
