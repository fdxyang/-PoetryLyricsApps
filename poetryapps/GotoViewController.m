//
//  GotoViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/29.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "GotoViewController.h"

@interface GotoViewController ()
{
    UIColor *_BackgroundColor;
}
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

    _poetryView = [[Poetrypicker alloc] initWithFrame:CGRectMake(0,165,320,162) getbtn:gotoReading getState:FALSE];
    _responseView = [[Responsepicker alloc] initWithFrame:CGRectMake(0,165,320,162) getbtn:gotoReading getState:FALSE];
    _guideView = [[Guidepicker alloc] initWithFrame:CGRectMake(0,165,320,162) getbtn:gotoReading getState:TRUE];
    
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
    
    self.navigationItem.title = @"快速查詢";
    
    _BackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"GOTOBackground.png"]];
    [self.view setBackgroundColor:_BackgroundColor];
    
    uiOffset = 0.0;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //NSLog(@"height = %f",screenRect.size.height);
    
    if(screenRect.size.height == 568)
    {
        //NSLog(@"this is 4 inch");
        uiOffset = 21.0;
    }
    else if(screenRect.size.height == 480)
    {
        //NSLog(@"this is 3.5 inch");
        uiOffset = 108.0;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _historyArr = [PoetryDataBase Poetry_CoreDataFetchDataInHistory];
    [_TableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)guideBtnClicked:(id)sender
{
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
    UIButton *modeBtn = (UIButton*)sender;
    NSString *imageName;
    CATransition *animation = [CATransition animation];
    if (!_isTreeMode) // tree mode
    {
        if(!_TableView)
        {
            NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GotoTable" owner:self options:nil];
            
            _TableView = (GotoTable *)[subviewArray objectAtIndex:0];
            //NSLog(@"kk height = %f",_TableView.frame.size.height);
            _TableView.frame = CGRectMake(0, 64, _TableView.frame.size.width, _TableView.frame.size.height-uiOffset);
            _TableView.TableData = [[NSArray alloc] initWithObjects:@"基督基石", @"詩歌", @"啟應文", nil];
            _historyArr = [PoetryDataBase Poetry_CoreDataFetchDataInHistory];
            UIImageView *tempImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GOTOBackground.png"]];
            [tempImageView setFrame:_TableView.frame];
            _TableView.backgroundView = tempImageView;
            [_TableView reloadData];
            [self.view addSubview:_TableView];
        }
        else
        {
            [self.view addSubview:_TableView];
            _historyArr = [PoetryDataBase Poetry_CoreDataFetchDataInHistory];
            [_TableView reloadData];
        }
    
        imageName = @"24_24buttonup.png";
        
        // set up an animation for the transition between the views
        [animation setDuration:0.5];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromBottom];
    
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
        [[self.view layer] addAnimation:animation forKey:@"GotoTable"];
        _isTreeMode = TRUE;
    }
    else // picker mode
    {
        [_TableView removeFromSuperview];
        
        [animation setDuration:0.5];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromTop];
        
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        [[self.view layer] addAnimation:animation forKey:@"GotoTable"];
        _isTreeMode = FALSE;
        imageName = @"24_24buttondown.png";
    }
    
    [modeBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
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
        GOTO_VIEW_ERROR_LOG(@"It is a bug !!!!!!!");
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
        return 30;
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
            sectionStr = @"歷史記錄";
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
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.row,indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    if(indexPath.section == BASICGUIDE)
    {
        cell.textLabel.text = [_TableView.TableData objectAtIndex:indexPath.row];
    }
    else
    {
        _historyArr = [PoetryDataBase Poetry_CoreDataFetchDataInHistory];
        _historyArr = [NSMutableArray arrayWithArray:[[_historyArr reverseObjectEnumerator] allObjects]];
        cell.textLabel.text = [[_historyArr objectAtIndex:indexPath.row] valueForKey:POETRY_CORE_DATA_NAME_KEY];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GOTO_VIEW_LOG(@"section = %d",indexPath.section);
    if (indexPath.section == BASICGUIDE)
    {
        switch (indexPath.row) {
            case 0: // guide
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
        NSDictionary *SelectedDic = [_historyArr objectAtIndex:indexPath.row];
        GOTO_VIEW_LOG(@"history = %@", SelectedDic);
    
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