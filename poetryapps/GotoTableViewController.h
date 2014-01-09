//
//  GotoTableViewController.h
//  poetryapps
//
//  Created by Goda on 2013/12/2.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GotoTableCell.h"
#import "PoetryCoreData.h"

//#define DEBUG_GOTOVIEW
#ifdef DEBUG_GOTOVIEW
#   define GOTO_VIEW_LOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define GOTO_VIEW_LOG(...)
#endif
#define GOTO_VIEW_ERROR_LOG(fmt, ...) NSLog((@"ERROR !! %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface GotoTableViewController : UITableViewController
{
    NSMutableArray *guideAttr;
    NSMutableArray *poetryAttr;
    NSMutableArray *responseAttr;
    PoetryCoreData *PoetryDataBase;
}
@property (strong, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic) NSInteger tableViewType;

- (id) initWithStyle:(UITableViewStyle)style TYPE:(NSInteger)type;
- (void) setTableViewType:(NSInteger)type;
@end
