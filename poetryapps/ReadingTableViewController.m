//
//  ReadingTableViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/13.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "ReadingTableViewController.h"
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"

#define UI_READING_TABLEVIEW_INIT_RECT_4_INCH       CGRectMake(0, UI_IOS7_NAV_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT - 10);
#define UI_READING_TABLEVIEW_INIT_RECT_3_5_INCH     CGRectMake(0, UI_IOS7_NAV_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT - UI_IOS7_NAV_BAR_HEIGHT - UI_IOS7_TAB_BAR_HEIGHT - 10);
// -10 is the buffer for the bottom of the table view

#define UI_SMALL_FONT_SIZE_THRESHOLD    14
#define UI_MEDIUM_FONT_SIZE_THRESHOLD   12
#define UI_LARGE_FONT_SIZE_THRESHOLD    10

@interface ReadingTableViewController () {
    UInt16                  _CurrentIndex;
    UIFont                  *_Font;
    NSMutableArray          *_CellHeightArray;
}

@end

@implementation ReadingTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect Frame;
    if (IS_IPHONE5) {
        Frame = UI_READING_TABLEVIEW_INIT_RECT_4_INCH;
    } else {
        Frame = UI_READING_TABLEVIEW_INIT_RECT_3_5_INCH;
    }
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    
    [self.view addGestureRecognizer:panRecognizer];
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;
    
    _TableView1 = [[UITableView alloc]  initWithFrame:Frame];
    _TableView2 = [[UITableView alloc]  initWithFrame:Frame];
    //_TableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_TableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_TableView1 setTag:1];
    [_TableView2 setTag:2];
    _TableView1.delegate = self;
    _TableView2.delegate = self;
    _TableView1.dataSource = self;
    _TableView2.dataSource = self;
    
    _PoetryDatabase = [[PoetryCoreData alloc] init];
    _PoetrySetting = [[PoetrySettingCoreData alloc] init];
    _NowReadingTableDataArray = [[NSMutableArray alloc] init];
    _ReadingTableDataArrayNew = [[NSMutableArray alloc] init];
    _CellHeightArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_CellHeightArray removeAllObjects];
    [_TableView1 setScrollsToTop:YES];
    [self GetNowReadingData];
    [_TableView1 reloadData];
    [self.view addSubview:_TableView1];
    _Font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_PoetrySetting.SettingFontSize];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_TableView1 removeFromSuperview];
    [_TableView2 removeFromSuperview];
}

-(void) GetNowReadingData
{
    if (_PoetryDatabase.isReadingExist) {
        
        _PoetryNowReading = [_PoetryDatabase Poetry_CoreDataFetchDataInReading];
        POETRY_CATEGORY Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
        _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
        _CurrentIndex = [[_PoetryNowReading valueForKey:POETRY_CORE_DATA_INDEX_KEY] integerValue] - 1; //Since the index in core data starts at 1
        
    } else {
        
        NSLog(@"NO READING POETRY, GET THE 1st POETRY in GUARD READING");
        _PoetryNowReading = (NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS] objectAtIndex:0];
        
        POETRY_CATEGORY Category = (POETRY_CATEGORY)[[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CATERORY_KEY] integerValue];
        _NowReadingCategoryArray = [NSMutableArray arrayWithArray:[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:Category]];
        _CurrentIndex = 0;
        
    }
    NSLog(@"%@", [_PoetryNowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
    _NowReadingCategoryArray = [NSMutableArray arrayWithArray:
                                [[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY] componentsSeparatedByString:@"\n"]];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_NowReadingCategoryArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView.tag == 1) {
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = _Font;
        cell.textLabel.text = [_NowReadingCategoryArray objectAtIndex:indexPath.row];
    } else {
        NSLog(@"222");
        cell.textLabel.text = @"2";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat Height = 0;
    UInt16  TextLength = [[_NowReadingCategoryArray objectAtIndex:indexPath.row] length];
    
    switch (_PoetrySetting.SettingFontSize) {
        case POETRY_SETIING_FONT_SIZE_SMALL:
            Height = POETRY_SETIING_FONT_SIZE_SMALL + 10;
            if (( TextLength >= UI_SMALL_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                Height = Height * ((TextLength / UI_SMALL_FONT_SIZE_THRESHOLD) + 1);
            }
            break;
            
        case POETRY_SETIING_FONT_SIZE_MEDIUM:
            Height = POETRY_SETIING_FONT_SIZE_MEDIUM + 10;
            if (( TextLength >= UI_MEDIUM_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                Height =  Height * ((TextLength / UI_MEDIUM_FONT_SIZE_THRESHOLD) + 1);
            }
            break;
            
        case POETRY_SETIING_FONT_SIZE_LARGE:
            Height = POETRY_SETIING_FONT_SIZE_LARGE + 10;
            if (( TextLength >= UI_LARGE_FONT_SIZE_THRESHOLD) && TextLength != 0) {
                Height = Height * ((TextLength / UI_LARGE_FONT_SIZE_THRESHOLD) + 1);
            }
            break;
            
        default:
        break;
    }
    
    NSLog(@"Length = %d Height = %f", TextLength, Height);
    return Height;
}

#pragma mark - Table view data source

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}


- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    //拿到手指目前的位置
    CGPoint location = [recognizer locationInView:self.view];
    
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateBegan:
        {
            CGRect Frame = CGRectMake(320, 0, 320, 568);
            [_TableView2 setFrame:Frame];
            [self.view addSubview:_TableView2];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            _TableView2.frame = CGRectMake(location.x, 0, 320, 568);
        }
            
            break;
            
        default:
            break;
    }
}

@end
