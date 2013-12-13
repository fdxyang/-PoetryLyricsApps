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

    _poetryView = [[Poetrypicker alloc] initWithFrame:CGRectMake(0,180,320,162) getbtn:gotoReading getState:FALSE];
    _responseView = [[Responsepicker alloc] initWithFrame:CGRectMake(0,180,320,162) getbtn:gotoReading getState:FALSE];
    _guideView = [[Guidepicker alloc] initWithFrame:CGRectMake(0,180,320,162) getbtn:gotoReading getState:TRUE];
    
    _poetryView.hidden = YES;
    _responseView.hidden = YES;
    _guideView.hidden = NO;
    
    gotoType = 0; // default type guide
    
    [self.view addSubview:_guideView];
    [self.view addSubview:_poetryView];
    [self.view addSubview:_responseView];
    
    [self.view bringSubviewToFront:_guideView];
    [gotoReading setTitle:[_guideView getPickerContent] forState:UIControlStateNormal];
    
    PoetryDataBase = [[PoetryCoreData alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)guideBtnClicked:(id)sender
{
    NSLog(@"guideBtnClicked");
    
    gotoType = 0; //guide type
    
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
    
    gotoType = 1; // poetry type
    
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
    NSLog(@"responseBtnClicked");
    
    gotoType = 2; // response type
    
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
        _historyArr = [PoetryDataBase Poetry_CoreDataFetchDataInHistory];
        //NSLog(@"history = %@",_historyArr);
        //_HistoryData = [NSMutableArray arrayWithArray:[[_HistoryData reverseObjectEnumerator] allObjects]];
        
        [_TableView reloadData];
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
    if(gotoType == 0) // guide
    {
        [PoetryDataBase PoetryCoreDataSaveIntoNowReading:[_guideView getGuideContent]];
        [PoetryDataBase PoetryCoreDataSaveIntoHistory:[_guideView getGuideContent]];
    }
    else if(gotoType == 1) // poetry
    {
        [PoetryDataBase PoetryCoreDataSaveIntoNowReading:[_poetryView getPoetryContent]];
        [PoetryDataBase PoetryCoreDataSaveIntoHistory:[_poetryView getPoetryContent]];
    }
    else if(gotoType == 2) // response
    {
        [PoetryDataBase PoetryCoreDataSaveIntoNowReading:[_responseView getResponseContent]];
        [PoetryDataBase PoetryCoreDataSaveIntoHistory:[_responseView getResponseContent]];
    }
    
    [self.tabBarController setSelectedIndex:0];
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
        return 80;
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
    
    if(indexPath.section == BASICGUIDE)
        cell.textLabel.text = [_TableView.TableData objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = [[_historyArr objectAtIndex:indexPath.row] valueForKey:POETRY_CORE_DATA_NAME_KEY];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %d",indexPath.section);
    if (indexPath.section == BASICGUIDE)
    {
        switch (indexPath.row) {
            case 0: // guide
                NSLog(@"guide press");
                if(!_detailTableView)
                {
                    _detailTableView = [[GotoTableViewController alloc]initWithStyle:UITableViewStylePlain TYPE:0];
                }
                else
                {
                    [_detailTableView setTableViewType:0];
                }
                
                gotoType = 0;

                [self performSegueWithIdentifier: @"detailTableView" sender: self];
                break;
            case 1: // poetry
                NSLog(@"poetry press");
                if(!_detailTableView)
                {
                    _detailTableView = [[GotoTableViewController alloc]initWithStyle:UITableViewStylePlain TYPE:1];
                }
                else
                {
                    [_detailTableView setTableViewType:1];
                }
                
                gotoType = 1;
                
                [self performSegueWithIdentifier: @"detailTableView" sender: self];
                break;
            case 2: // response
                NSLog(@"response press");
                if(!_detailTableView)
                {
                    _detailTableView = [[GotoTableViewController alloc]initWithStyle:UITableViewStylePlain TYPE:2];
                }
                else
                {
                    [_detailTableView setTableViewType:2];
                }
                
                gotoType = 2;
                
                [self performSegueWithIdentifier: @"detailTableView" sender: self];
                break;
                
            default:
                break;
        }
    }
    else //histroy
    {
        //NSLog(@" history section = %d , row = %d",indexPath.section,indexPath.row);
        NSDictionary *SelectedDic = [_historyArr objectAtIndex:indexPath.row];
        //NSLog(@"%@", SelectedDic);
    
        [PoetryDataBase PoetryCoreDataSaveIntoNowReading:SelectedDic];
        [_TableView reloadData];
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailTableView"])
    {
        _detailTableView = segue.destinationViewController;
        
        [_detailTableView setTableViewType:gotoType];
    }
}
@end
