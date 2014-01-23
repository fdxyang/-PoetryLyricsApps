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
        _tableViewType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    guideAttr = [[NSMutableArray alloc] init];
    poetryAttr = [[NSMutableArray alloc] init];
    responseAttr = [[NSMutableArray alloc] init];
    PoetryDataBase = [[PoetryCoreData alloc] init];
    
    
    UIImageView *tempImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BG-GreyNote_paper.png"]];
    [tempImageView setFrame:_detailTableView.frame];
    _detailTableView.backgroundView = tempImageView;
    
    if (_tableViewType == 0) // guide
    {
        if(![guideAttr count])
        {
            guideAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:GUARD_READING];
            GOTO_VIEW_LOG(@"guideAttr List Count = %d", [guideAttr count]);
            GOTO_VIEW_LOG(@"guideAttr Name = %@", [[guideAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            GOTO_VIEW_LOG(@"guideAttr Content = %@", [[guideAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        
        //NSLog(@"guide count = %d",[guideAttr count]);
    }
    else if(_tableViewType == 1) //poetry
    {
        if(![poetryAttr count])
        {
            poetryAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:POETRYS];
            GOTO_VIEW_LOG(@"Poetry List Count = %d", [poetryAttr count]);
            GOTO_VIEW_LOG(@"Poetry Name = %@", [[poetryAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            GOTO_VIEW_LOG(@"Poetry Content = %@", [[poetryAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        GOTO_VIEW_LOG(@"poetryAttr count = %d",[poetryAttr count]);
    }
    else if(_tableViewType == 2) //response
    {
        if(![responseAttr count])
        {
            responseAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:RESPONSIVE_PRAYER];
            GOTO_VIEW_LOG(@"responseAttr List Count = %d", [responseAttr count]);
            GOTO_VIEW_LOG(@"responseAttr Name = %@", [[responseAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            GOTO_VIEW_LOG(@"responseAttr Content = %@", [[responseAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        //NSLog(@"responseAttr count = %d",[responseAttr count]);
    }
    
    // Kevin 20140124 set title background color 
    [self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                                                    green:(159/255.0f)
                                                                                     blue:(191/255.0f)
                                                                                    alpha:0.8]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableViewType == 0)
    {
        return [guideAttr count];
    }
    else if(_tableViewType == 1)
        return [poetryAttr count];
    else if(_tableViewType == 2)
        return [responseAttr count];
    else
    {
        //NSLog(@"gototableview number of rows insection");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    GotoTableCell *cell = (GotoTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[GotoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    cell.backgroundColor = [UIColor clearColor];
    
    if (_tableViewType == 0)
    {
        cell.textLabel.text = [[guideAttr objectAtIndex:indexPath.row] valueForKey:POETRY_CORE_DATA_NAME_KEY];
    }
    else if (_tableViewType == 1)
    {
        cell.textLabel.text = [[poetryAttr objectAtIndex:indexPath.row] valueForKey:POETRY_CORE_DATA_NAME_KEY];
    }
    else if (_tableViewType == 2)
    {
        cell.textLabel.text = [[responseAttr objectAtIndex:indexPath.row] valueForKey:POETRY_CORE_DATA_NAME_KEY];
    }
    else
        GOTO_VIEW_ERROR_LOG(@"cellForRowAtIndexPath error!!");
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *SelectedDic;
    if(_tableViewType == 0)
    {
        SelectedDic = [guideAttr objectAtIndex:indexPath.row];
    }
    else if(_tableViewType == 1)
    {
        SelectedDic = [poetryAttr objectAtIndex:indexPath.row];
    }
    else if(_tableViewType == 2)
    {
        SelectedDic = [responseAttr objectAtIndex:indexPath.row];
    }
    [PoetryDataBase PoetryCoreDataSaveIntoNowReading:SelectedDic];
    [PoetryDataBase PoetryCoreDataSaveIntoHistory:SelectedDic];
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) setTableViewType:(NSInteger)type
{
    _tableViewType = type;
    
    if (_tableViewType == 0) // guide
    {
        if(![guideAttr count])
        {
            guideAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:GUARD_READING];
            GOTO_VIEW_LOG(@"guideAttr List Count = %d", [guideAttr count]);
            GOTO_VIEW_LOG(@"guideAttr Name = %@", [[guideAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            GOTO_VIEW_LOG(@"guideAttr Content = %@", [[guideAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        
        GOTO_VIEW_LOG(@"guide count = %d",[guideAttr count]);
    }
    else if(_tableViewType == 1) //poetry
    {
        if(![poetryAttr count])
        {
            poetryAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:POETRYS];
            GOTO_VIEW_LOG(@"poetryAttr List Count = %d", [poetryAttr count]);
            GOTO_VIEW_LOG(@"poetryAttr Name = %@", [[poetryAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            GOTO_VIEW_LOG(@"poetryAttr Content = %@", [[poetryAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        GOTO_VIEW_LOG(@"poetryAttr count = %d",[poetryAttr count]);
    }
    else if(_tableViewType == 2) //response
    {
        if(![responseAttr count])
        {
            responseAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:RESPONSIVE_PRAYER];
            GOTO_VIEW_LOG(@"responseAttr List Count = %d", [responseAttr count]);
            GOTO_VIEW_LOG(@"responseAttr Name = %@", [[responseAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            GOTO_VIEW_LOG(@"responseAttr Content = %@", [[responseAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        GOTO_VIEW_LOG(@"responseAttr count = %d",[responseAttr count]);
    }
}
@end
