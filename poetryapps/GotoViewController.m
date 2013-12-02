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

    _poetryView = [[Poetrypicker alloc] initWithFrame:CGRectMake(0,235,320,162) getbtn:gotoReading getState:FALSE];
    _responseView = [[Responsepicker alloc] initWithFrame:CGRectMake(0,235,320,162) getbtn:gotoReading getState:FALSE];
    _guideView = [[Guidepicker alloc] initWithFrame:CGRectMake(0,235,320,162) getbtn:gotoReading getState:TRUE];
    
    _poetryView.hidden = YES;
    _responseView.hidden = YES;
    _guideView.hidden = NO;
    
    [self.view addSubview:_guideView];
    [self.view addSubview:_poetryView];
    [self.view addSubview:_responseView];
    
    [self.view bringSubviewToFront:_guideView];
    [gotoReading setTitle:[_guideView getPickerContent] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)guideBtnClicked:(id)sender
{
    NSLog(@"guideBtnClicked");
    [_guideView setFlag:TRUE];
    [_poetryView setFlag:FALSE];
    [_responseView setFlag:FALSE];
    
    _poetryView.hidden = YES;
    _responseView.hidden=YES;
    _guideView.hidden = NO;
    [self.view bringSubviewToFront:_guideView];
    [gotoReading setTitle:[_guideView getPickerContent] forState:UIControlStateNormal];
}

- (IBAction)poetryBtnClicked:(id)sender
{
    NSLog(@"poetryBtnClicked");
    [_guideView setFlag:FALSE];
    [_poetryView setFlag:TRUE];
    [_responseView setFlag:FALSE];
    _responseView.hidden=YES;
    _guideView.hidden = YES;
    _poetryView.hidden = NO;
    [self.view bringSubviewToFront:_poetryView];
    [gotoReading setTitle:[_poetryView getPickerContent] forState:UIControlStateNormal];
}

- (IBAction)responseBtnClicked:(id)sender
{
    NSLog(@"poetryBtnClicked");
    [_guideView setFlag:FALSE];
    [_poetryView setFlag:FALSE];
    [_responseView setFlag:TRUE];
    _guideView.hidden = YES;
    _poetryView.hidden = YES;
    _responseView.hidden=NO;
    [self.view bringSubviewToFront:_responseView];
    [gotoReading setTitle:[_responseView getPickerContent] forState:UIControlStateNormal];
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
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d%d",indexPath.row,indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_TableView.TableData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == BASICGUIDE)
    {
        switch (indexPath.row) {
            case 0: // guide
                
                break;
            case 1: // poetry
                break;
            case 2: // response
                break;
                
            default:
                break;
        }
    }
    else //histroy
    {
        switch (indexPath.row)
        {
            default:
                break;
        }
    }
}
@end
