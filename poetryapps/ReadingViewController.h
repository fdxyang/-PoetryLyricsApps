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

#define UI_IOS7_VERSION_FLOATING        7.0f
#define UI_IOS7_TAB_BAR_HEIGHT          49
#define UI_DEFAULT_PREVIOUS_ORIGIN_X    -300
#define UI_DEFAULT_NEXT_ORIGIN_X        320


@interface ReadingViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong)           UIScrollView                *Scroller;
@property (nonatomic, strong)           PoetryCoreData              *PoetryDatabase;
@property (nonatomic, strong)           PoetrySettingCoreData       *PoetrySetting;
@property (nonatomic, strong)           NSDictionary                *PoetryNowReading;
@property (nonatomic, strong)           UIFont                      *font;
@property                               THEME_SETTING               DisplayTheme;
@property (nonatomic, strong)           NSMutableArray              *DisplayLabArray; //Number = 2



typedef enum {
    LABEL1 = 0x00,
    LABEL2,
    LABEL3,
}CURRENT_LABEL;

typedef enum {
    SlideLabelLeftToRigth,
    SlideLabelRightToLegt,
}SLIDE_DIRECTION;

@property (nonatomic)                   UILabel                     *Label1;
@property (nonatomic)                   UILabel                     *Label2;
@property (nonatomic)                   UILabel                     *Label3;



@end
