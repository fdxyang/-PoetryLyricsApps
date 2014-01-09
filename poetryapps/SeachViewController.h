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


@property (strong, nonatomic)   IBOutlet UITableView *TableView;
@property (weak, nonatomic)     IBOutlet UISearchBar *SearchBar;

@property (nonatomic, strong) NSMutableArray *HistoryData;
@property (nonatomic, strong) NSMutableArray *SearchHistoryData;
@property (nonatomic, strong) NSMutableArray *SearchGuidedReading;
@property (nonatomic, strong) NSMutableArray *SearchPoetryData;
@property (nonatomic, strong) NSMutableArray *SearchRespose;
@property (nonatomic, strong) NSArray        *SearchResultDisplayArray;

@property (nonatomic, strong) PoetryCoreData *PoetryDatabase;


@end
