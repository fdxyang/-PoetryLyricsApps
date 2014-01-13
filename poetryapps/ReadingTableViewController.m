//
//  ReadingTableViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/13.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "ReadingTableViewController.h"

#define UI_READING_TABLEVIEW_INIT_RECT_4_INCH       CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT);
#define UI_READING_TABLEVIEW_INIT_RECT_3_5_INCH     CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT);

@interface ReadingTableViewController ()

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
    [_TableView1 setTag:1];
    [_TableView2 setTag:2];
    _TableView1.delegate = self;
    _TableView2.delegate = self;
    _TableView1.dataSource = self;
    _TableView2.dataSource = self;
    [self.view addSubview:_TableView1];
	// Do any additional setup after loading the view, typically from a nib.
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
        cell.textLabel.text = @"1";
    } else {
        cell.textLabel.text = @"2";
        
    }
    
    return cell;
}

#pragma mark - Table view data source

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touc
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
            NSLog(@"!! %f", location.x);
            _TableView2.frame = CGRectMake(location.x, 0, 320, 568);
        }
            
            break;
            
        default:
            break;
    }
}

@end
