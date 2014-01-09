//
//  GotoViewController.h
//  poetryapps
//
//  Created by Goda on 2013/11/29.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GotoTable.h"
#import "Poetrypicker.h"
#import "Guidepicker.h"
#import "Responsepicker.h"
#import "GotoTableViewController.h"

typedef enum {
    BASICGUIDE = 0,
    HISTORY,
    GOTOPAGECOUNT
}GotoPageAreaSection;

@interface GotoViewController : UIViewController
{
    NSInteger gotoType;
    PoetryCoreData *PoetryDataBase;
    float uiOffset;
}

@property (nonatomic,strong) NSMutableArray *historyArr;
@property (nonatomic,strong) NSMutableArray *guideArray;
@property (nonatomic) BOOL isTreeMode;
@property (nonatomic, strong) GotoTable *TableView;
@property (strong, nonatomic) IBOutlet UIButton *guideBtn;
@property (strong, nonatomic) IBOutlet UIButton *poetryBtn;
@property (strong, nonatomic) IBOutlet UIButton *responseBtn;
@property (strong, nonatomic) IBOutlet UIButton *gotoReading;

@property (strong,nonatomic) Guidepicker *guideView;
@property (strong,nonatomic) Poetrypicker *poetryView;
@property (strong,nonatomic) Responsepicker *responseView;

@property (strong,nonatomic) GotoTableViewController *detailTableView;

- (IBAction)guideBtnClicked:(id)sender;
- (IBAction)poetryBtnClicked:(id)sender;
- (IBAction)responseBtnClicked:(id)sender;
- (IBAction)changeModeBtnClicked:(id)sender;
- (IBAction)changeReadingModeClicked:(id)sender;

@end
