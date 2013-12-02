//
//  GotoTableViewController.h
//  poetryapps
//
//  Created by Goda on 2013/12/2.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GotoTableViewController : UITableViewController
{
    NSInteger tableViewType;
    NSMutableArray *guideAttr;
    NSMutableArray *poetryAttr;
    NSMutableArray *responseAttr;
}
@property (strong, nonatomic) IBOutlet UITableView *detailTableView;

- (id) initWithStyle:(UITableViewStyle)style TYPE:(NSInteger)type;
- (void) setTableViewType:(NSInteger)type;
@end
