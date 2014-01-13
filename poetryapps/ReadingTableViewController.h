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

@interface ReadingTableViewController : UIViewController <UIGestureRecognizerDelegate,
                                                            UITableViewDataSource,
                                                            UITableViewDelegate>
@property (strong, nonatomic)   UITableView     *TableView1;
@property (strong, nonatomic)   UITableView     *TableView2;
@property (strong, nonatomic)   NSMutableArray  *TableDataTest;

@end
