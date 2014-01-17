//
//  ReadingTableViewController.h
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/13.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"
#import "PoetryReadingView.h"


//#define DEBUG_READINGVIEW
#ifdef DEBUG_READINGVIEW
#   define READING_VIEW_LOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define READING_VIEW_LOG(...)
#endif

#define READING_VIEW_ERROR_LOG(fmt, ...) NSLog((@"ERROR !! %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


@interface ReadingTableViewController : UIViewController <UIGestureRecognizerDelegate,
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
