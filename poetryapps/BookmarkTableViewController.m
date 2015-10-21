//
//  BookmarkTableViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2015/10/21.
//  Copyright © 2015年 cc. All rights reserved.
//

#import "BookmarkTableViewController.h"
#import "PoetryCoreData.h"
@interface BookmarkTableViewController ()

@property (nonatomic, strong) PoetryCoreData *CoreData;
@property (nonatomic, strong) NSMutableArray *BookmarkArray;
@end



@implementation BookmarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _CoreData = [[PoetryCoreData alloc] init];
    _BookmarkArray = [_CoreData Poetry_CoreDataFetchDataInBookmark];
    NSLog(@"Bookmarks = %@", _BookmarkArray);

    UILabel  *_NavigationTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _NavigationTitleLab.text = @"書籤";
    _NavigationTitleLab.backgroundColor = [UIColor clearColor];
    _NavigationTitleLab.font = [UIFont boldSystemFontOfSize:16.0];
    _NavigationTitleLab.textAlignment = NSTextAlignmentCenter;
    _NavigationTitleLab.textColor = [UIColor whiteColor]; // change this color
    
    self.navigationItem.titleView = _NavigationTitleLab;
    CGSize Size = CGSizeMake(280, 200);
    Size = [_NavigationTitleLab sizeThatFits:Size];
    [_NavigationTitleLab setFrame:CGRectMake(0, 0, 280, Size.height)];
    
    [self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                                                    green:(159/255.0f)
                                                                                     blue:(191/255.0f)
                                                                                    alpha:0.8]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    _BookmarkArray = [_CoreData Poetry_CoreDataFetchDataInBookmark];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_BookmarkArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *SelectedDic;
    SelectedDic = [_BookmarkArray objectAtIndex:indexPath.row];
    NSLog(@"%@", SelectedDic);
    [_CoreData PoetryCoreDataSaveIntoNowReading:SelectedDic];
    
    // Jump to Reading View
    [self.tabBarController setSelectedIndex:0];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSManagedObject *Poetry = [_BookmarkArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [Poetry valueForKey:POETRY_CORE_DATA_NAME_KEY]];
    
    // [CASPER] 20140106 replace @@ string with empty char
    cell.detailTextLabel.text = [[NSString stringWithFormat:@"%@", [[Poetry valueForKey:POETRY_CORE_DATA_CONTENT_KEY] stringByReplacingOccurrencesOfString:@"\n" withString:@""]] stringByReplacingOccurrencesOfString:@"@@" withString:@""];
    
    
    return cell;
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
