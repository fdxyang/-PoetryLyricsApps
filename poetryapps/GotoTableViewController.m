//
//  GotoTableViewController.m
//  poetryapps
//
//  Created by Goda on 2013/12/2.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "GotoTableViewController.h"

@interface GotoTableViewController ()

@end

@implementation GotoTableViewController

- (id)initWithStyle:(UITableViewStyle)style TYPE:(NSInteger)type
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSLog(@"init ");
        tableViewType = type;
        NSString *str;
        
        guideAttr = [[NSMutableArray alloc] init];
        poetryAttr = [[NSMutableArray alloc] init];
        responseAttr = [[NSMutableArray alloc] init];
        
        if (tableViewType == 0) // guide
        {
            for (int i = 0;i<6;i++)
            {
                str = [NSString stringWithFormat:@"g%d",i+1];
                [guideAttr addObject:str];
            }
            
            NSLog(@"guide count = %d",[guideAttr count]);
        }
        else if(tableViewType == 1) //poetry
        {
            for (int i = 0;i<650;i++)
            {
                str = [NSString stringWithFormat:@"p%d",i+1];
                [poetryAttr addObject:str];
            }
        }
        else if(tableViewType == 2) //response
        {
            for (int i = 0;i<650;i++)
            {
                str = [NSString stringWithFormat:@"r%d",i+1];
                [responseAttr addObject:str];
            }
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    if (tableViewType == 0)
    {
        NSLog(@"count = %d",[guideAttr count]);
        return [guideAttr count];
    }
    else if(tableViewType == 1)
        return [poetryAttr count];
    else if(tableViewType == 2)
        return [responseAttr count];
    else
    {
        NSLog(@"gototableview number of rows insection");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellforrow");
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.row,indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (tableViewType == 0)
    {
        cell.textLabel.text = [guideAttr objectAtIndex:indexPath.row];
    }
    else if (tableViewType == 1)
    {
        cell.textLabel.text = [poetryAttr objectAtIndex:indexPath.row];
    }
    else if (tableViewType == 2)
    {
        cell.textLabel.text = [responseAttr objectAtIndex:indexPath.row];
    }
    else
        NSLog(@"cellForRowAtIndexPath error!!");
    
    return cell;
}

- (void) setTableViewType:(NSInteger)type
{
    tableViewType = type;
}
@end
