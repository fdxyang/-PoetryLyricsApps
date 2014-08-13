//
//  AboutMeViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/11.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

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
    _Scroller = [[UIScrollView alloc] init];
    
    UILabel  *_NavigationTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _NavigationTitleLab.text = @"關於我";
    _NavigationTitleLab.backgroundColor = [UIColor clearColor];
    _NavigationTitleLab.font = [UIFont boldSystemFontOfSize:16.0];
    _NavigationTitleLab.textAlignment = NSTextAlignmentCenter;
    _NavigationTitleLab.textColor = [UIColor whiteColor]; // change this color
    
    //    _NavigationTitleLab.textColor = [[UIColor alloc] initWithRed:(247/255.0f) green:(243/255.0f) blue:(205/255.0f) alpha:1]; // change this color
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:221.0/255.0 blue:120.0/255.0 alpha:1.0]];
    //[self.view setBackgroundColor:[UIColor yellowColor]];
    self.navigationItem.titleView = _NavigationTitleLab;
    CGSize Size = CGSizeMake(180, 200);
    Size = [_NavigationTitleLab sizeThatFits:Size];
    [_NavigationTitleLab setFrame:CGRectMake(0, 0, 180, Size.height)];
    
    [self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                                                    green:(159/255.0f)
                                                                                     blue:(191/255.0f)
                                                                                    alpha:0.8]];
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"ARROW_Left.png"]];
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG-GreyNote_paper.png"]];
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG-GreyNote_paper_Dark.png"]];
    
    NSUInteger contactPos=0;
    CGRect Frame;
    CGFloat scrollHeight = 0.0;
    CGFloat uiviewHeight = 0.0;
    
    if (IS_IPHONE5) {
        Frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT);
        contactPos = 90;
        scrollHeight = 300.0;
        uiviewHeight = UI_SCREEN_4_INCH_HEIGHT;
    } else {
        Frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT);
        contactPos = 10;
        scrollHeight = 250.0;
        uiviewHeight = UI_SCREEN_3_5_INCH_HEIGHT;
    }
    [_Scroller setFrame:Frame];
    [self.view addSubview:_Scroller];
    
    
    Size = CGSizeMake(UI_SCREEN_WIDTH, scrollHeight);
    
    [_Scroller setContentSize:Size];
    
    UIView *aboutMeView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,uiviewHeight)];
    [aboutMeView setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:221.0/255.0 blue:120.0/255.0 alpha:1.0]];
    
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20,10,300,30)];
    [title setText:@"Hippo Colors 色河馬"];
    [title setFont:[UIFont systemFontOfSize:27]];
    [title setTextColor:[UIColor colorWithRed:193.0/255.0 green:210.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [aboutMeView addSubview:title];
    
    UILabel *introText = [[UILabel alloc]initWithFrame:CGRectMake(20,40,300,180)];
    [introText setText:@"成立於2014年，\n一個年輕且熱血的團隊。\n\n隨著行動裝置普及，\n\n色河馬協助解決您的問題，\n把您的生活變簡單！\n"];
    [introText setFont:[UIFont  fontWithName:@"TrebuchetMS" size:20]];
    introText.numberOfLines = 0;
    [aboutMeView addSubview:introText];
    
    [_Scroller addSubview:aboutMeView];
    
    /*
    float teamlogo_x = 0.0;
    float teamlogo_y = 0.0;
    float teamlogo_width = 200.0;
    float teamlogo_height = 200.0;
    
    //logo
    UIImageView *teamLogo = [[UIImageView alloc] initWithFrame:CGRectMake(teamlogo_x+60, teamlogo_y, teamlogo_width, teamlogo_height)];
    [teamLogo setImage:[UIImage imageNamed:@"teamlogo.png"]];
    [_Scroller addSubview:teamLogo];
    
    UILabel *teamContact = [[UILabel alloc]initWithFrame:CGRectMake(0, teamlogo_y+teamlogo_height+contactPos, 320, 40)];
    [teamContact setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]];
    teamContact.backgroundColor = [UIColor grayColor];
    teamContact.textColor = [UIColor whiteColor];
    teamContact.textAlignment = NSTextAlignmentCenter;
    [teamContact setText:@"聯絡我們：hippocolors@gmail.com"];
    [_Scroller addSubview:teamContact];
     */
}

-(void)viewDidAppear:(BOOL)animated
{
    /*
    NSUInteger contactPos=0;
    CGFloat scrollHeight = 0.0;
    
    CGRect Frame;
    if (IS_IPHONE5) {
        Frame = CGRectMake(0, 100, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT-115);
        contactPos = 90;
        scrollHeight = 300.0;
    } else {
        Frame = CGRectMake(0, 100, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT-115);
        contactPos = 10;
        scrollHeight = 250.0;
    }
    [_Scroller setFrame:Frame];
    [self.view addSubview:_Scroller];

    CGSize Size = CGSizeMake(UI_SCREEN_WIDTH, scrollHeight);
    
    [_Scroller setContentSize:Size];
    
    float teamlogo_x = 0.0;
    float teamlogo_y = 0.0;
    float teamlogo_width = 200.0;
    float teamlogo_height = 200.0;

    //logo
    UIImageView *teamLogo = [[UIImageView alloc] initWithFrame:CGRectMake(teamlogo_x+60, teamlogo_y, teamlogo_width, teamlogo_height)];
    [teamLogo setImage:[UIImage imageNamed:@"teamlogo.png"]];
    [_Scroller addSubview:teamLogo];
    
    UILabel *teamContact = [[UILabel alloc]initWithFrame:CGRectMake(0, teamlogo_y+teamlogo_height+contactPos, 320, 40)];
    [teamContact setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]];
    teamContact.backgroundColor = [UIColor grayColor];
    teamContact.textColor = [UIColor whiteColor];
    teamContact.textAlignment = NSTextAlignmentCenter;
    [teamContact setText:@"聯絡我們：hippocolors@gmail.com"];
    [_Scroller addSubview:teamContact];
     */
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
