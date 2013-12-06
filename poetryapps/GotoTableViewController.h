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
