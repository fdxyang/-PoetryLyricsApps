//
//  SeachViewController.h
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/29.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetryCoreData.h"
@interface SeachViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *HistoryData;

@property (nonatomic, strong) PoetryCoreData *PoetryDatabase;
@end
