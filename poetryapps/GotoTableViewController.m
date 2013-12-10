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
        //NSLog(@"init ");
        _tableViewType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"GOTO VIEW viewDidLoad ");
    
    guideAttr = [[NSMutableArray alloc] init];
    poetryAttr = [[NSMutableArray alloc] init];
    responseAttr = [[NSMutableArray alloc] init];
    PoetryDataBase = [[PoetryCoreData alloc] init];
    
    
    if (_tableViewType == 0) // guide
    {
        if(![guideAttr count])
        {
            guideAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:GUARD_READING];
            NSLog(@"guideAttr List Count = %lu", [guideAttr count]);
            NSLog(@"guideAttr Name = %@", [[guideAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            NSLog(@"guideAttr Content = %@", [[guideAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        
        NSLog(@"guide count = %lu",[guideAttr count]);
    }
    else if(_tableViewType == 1) //poetry
    {
        if(![poetryAttr count])
        {
            poetryAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:POETRYS];
            NSLog(@"Poetry List Count = %lu", [poetryAttr count]);
            NSLog(@"Poetry Name = %@", [[poetryAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            NSLog(@"Poetry Content = %@", [[poetryAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        NSLog(@"poetryAttr count = %lu",[poetryAttr count]);
    }
    else if(_tableViewType == 2) //response
    {
        if(![responseAttr count])
        {
            responseAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:RESPONSIVE_PRAYER];
            NSLog(@"responseAttr List Count = %lu", [responseAttr count]);
            NSLog(@"responseAttr Name = %@", [[responseAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            NSLog(@"responseAttr Content = %@", [[responseAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        NSLog(@"responseAttr count = %lu",[responseAttr count]);
    }
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
    if (_tableViewType == 0)
    {
        NSLog(@"count = %lu",[guideAttr count]);
        return [guideAttr count];
    }
    else if(_tableViewType == 1)
        return [poetryAttr count];
    else if(_tableViewType == 2)
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
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    GotoTableCell *cell = (GotoTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[GotoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    
    if (_tableViewType == 0)
    {
        cell.textLabel.text = [guideAttr objectAtIndex:indexPath.row];
    }
    else if (_tableViewType == 1)
    {
        cell.textLabel.text = [poetryAttr objectAtIndex:indexPath.row];
    }
    else if (_tableViewType == 2)
    {
        cell.textLabel.text = [responseAttr objectAtIndex:indexPath.row];
    }
    else
        NSLog(@"cellForRowAtIndexPath error!!");
    
    return cell;
}

- (void) setTableViewType:(NSInteger)type
{
    NSLog(@"type = %lu",type);
    _tableViewType = type;
    
    if (_tableViewType == 0) // guide
    {
        NSLog(@"table view type - guide");
        if(![guideAttr count])
        {
            guideAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:GUARD_READING];
            NSLog(@"guideAttr List Count = %lu", [guideAttr count]);
            NSLog(@"guideAttr Name = %@", [[guideAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            NSLog(@"guideAttr Content = %@", [[guideAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        
        NSLog(@"guide count = %lu",[guideAttr count]);
    }
    else if(_tableViewType == 1) //poetry
    {
        NSLog(@"table view type - poetry");
        
        if(![poetryAttr count])
        {
            poetryAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:POETRYS];
            NSLog(@"poetryAttr List Count = %lu", [poetryAttr count]);
            NSLog(@"poetryAttr Name = %@", [[poetryAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            NSLog(@"poetryAttr Content = %@", [[poetryAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        NSLog(@"poetryAttr count = %lu",[poetryAttr count]);
    }
    else if(_tableViewType == 2) //response
    {
        NSLog(@"table view type - response");
        
        if(![responseAttr count])
        {
            responseAttr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:RESPONSIVE_PRAYER];
            NSLog(@"responseAttr List Count = %lu", [responseAttr count]);
            NSLog(@"responseAttr Name = %@", [[responseAttr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            NSLog(@"responseAttr Content = %@", [[responseAttr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
        }
        NSLog(@"responseAttr count = %lu",[responseAttr count]);
    }
}
@end
