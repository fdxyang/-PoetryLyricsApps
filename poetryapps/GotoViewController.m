//
//  GotoViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/29.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "GotoViewController.h"

@interface GotoViewController ()

@end

@implementation GotoViewController
@synthesize guideBtn;
@synthesize poetryBtn;
@synthesize responseBtn;
@synthesize picker;
@synthesize gotoReading;

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
	// Do any additional setup after loading the view.
    
    _guideArray = [[NSMutableArray alloc] initWithObjects:@"導讀1", @"導讀2", @"導讀3", @"導讀4", @"導讀5", @"導讀6", nil ];
    _historyArr = [[NSMutableArray alloc] init];
    
    self.guideBtn = [[UIButton alloc]init];
    [self.guideBtn addTarget:self action:@selector(guideBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.guideBtn];
    
    self.poetryBtn = [[UIButton alloc]init];
    [self.poetryBtn addTarget:self action:@selector(poetryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.poetryBtn];
    
    self.responseBtn = [[UIButton alloc]init];
    [self.responseBtn addTarget:self action:@selector(responseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.responseBtn];
    
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,235, 320, 162)];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    _isTreeMode = FALSE;
    
    [self.view addSubview:picker];
    
    [gotoReading setTitle:[_guideArray objectAtIndex:0] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)guideBtnClicked:(id)sender
{
    NSLog(@"guideBtnClicked");
}

- (IBAction)poetryBtnClicked:(id)sender
{
    NSLog(@"poetryBtnClicked");
}

- (IBAction)responseBtnClicked:(id)sender
{
    NSLog(@"responseBtnClicked");
}

- (IBAction)changeModeBtnClicked:(id)sender
{
    CATransition *animation = [CATransition animation];
    if (!_isTreeMode) // tree mode
    {
    
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GotoTable" owner:self options:nil];
        _TableView = (GotoTable *)[subviewArray objectAtIndex:0];
        _TableView.frame = CGRectMake(0, 64, _TableView.frame.size.width, _TableView.frame.size.height);
        _TableView.TableData = [[NSArray alloc] initWithObjects:@"GUARD READING", @"POPETRY", @"RESPONSIVE PRAYER", nil];
    
        [self.view addSubview:_TableView];
    
    
        // set up an animation for the transition between the views
        [animation setDuration:1.0];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromBottom];
    
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
        [[self.view layer] addAnimation:animation forKey:@"GotoTable"];
        _isTreeMode = TRUE;
    }
    else // picker mode
    {
        [_TableView removeFromSuperview];
        
        [animation setDuration:1.0];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromTop];
        
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        [[self.view layer] addAnimation:animation forKey:@"GotoTable"];
        _isTreeMode = FALSE;
    }
}

- (IBAction)changeReadingModeClicked:(id)sender
{
}

//內建的函式回傳UIPicker共有幾組選項
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSLog(@"numberOfComponentsInPickerView");
    return 1;
}

//內建的函式回傳UIPicker每組選項的項目數目
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"numberOfRowsInComponent");
    //第一組選項由0開始
    switch (component)
    {
        case 0:
            return [_guideArray count];
            break;
            
            //如果有一組以上的選項就在這裡以component的值來區分（以本程式碼為例default:永遠不可能被執行
        default:
            return 0;
            break;
    }
}

//內建函式印出字串在Picker上以免出現"?"
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"titleForRow");
    switch (component) {
        case 0:
            return [_guideArray objectAtIndex:row];
            break;
            
            //如果有一組以上的選項就在這裡以component的值來區分（以本程式碼為例default:永遠不可能被執行）
        default:
            return @"Error";
            break;
    }
}

//選擇UIPickView中的項目時會出發的內建函式
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"didSelectRow");
    NSString *str = [NSString stringWithFormat:@"%@", [_guideArray objectAtIndex:row]];
    NSLog(@"str = %@",str);
    
    [gotoReading setTitle:str forState:UIControlStateNormal];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GotoPageAreaSection viewsection = (GotoPageAreaSection)section;
    
    if (viewsection == BASICGUIDE)
    {
        return 3;
    }
    else if(viewsection == HISTORY)
        return [_historyArr count];//history array count
    else
    {
        NSLog(@"It is a bug !!!!!!!");
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == BASICGUIDE)
    {
        return 100;
    }
    else
        return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == BASICGUIDE) {
        return 0;
    }
    else
        return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionStr = [[NSString alloc] init];
    
    switch (section)
    {
        case 0:
            sectionStr = @"";
            break;
            
        case 1:
            sectionStr = @"History";
            break;
            
        default:
            break;
    }
    return sectionStr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_TableView.TableData objectAtIndex:indexPath.row];
    return cell;
}

@end
