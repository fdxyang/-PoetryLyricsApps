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
    NSLog(@"did load");
    [super viewDidLoad];
    _Scroller = [[UIScrollView alloc] init];
    
    UILabel  *_NavigationTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _NavigationTitleLab.text = @"關於我";
    _NavigationTitleLab.backgroundColor = [UIColor clearColor];
    _NavigationTitleLab.font = [UIFont boldSystemFontOfSize:16.0];
    _NavigationTitleLab.textAlignment = NSTextAlignmentCenter;
    _NavigationTitleLab.textColor = [UIColor whiteColor]; // change this color
    
    //    _NavigationTitleLab.textColor = [[UIColor alloc] initWithRed:(247/255.0f) green:(243/255.0f) blue:(205/255.0f) alpha:1]; // change this color
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
    if (IS_IPHONE5) {
        Frame = CGRectMake(0, 100, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT-115);
        contactPos = 90;
    } else {
        Frame = CGRectMake(0, 100, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT-115);
        contactPos = 50;
    }
    [_Scroller setFrame:Frame];
    [self.view addSubview:_Scroller];
    
    
    
    //CGSize Size = CGSizeMake(UI_SCREEN_WIDTH, 500.0f);
    CGSize Size2 = CGSizeMake(UI_SCREEN_WIDTH, 300.0f);
    
    [_Scroller setContentSize:Size2];
    
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
}

-(void)viewDidAppear:(BOOL)animated
{
    
    NSLog(@"did appear");
    //self.navigationItem.title = @"關於我";
    
    NSUInteger contactPos=0;
    
    CGRect Frame;
    if (IS_IPHONE5) {
        Frame = CGRectMake(0, 100, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT-115);
        contactPos = 90;
    } else {
        Frame = CGRectMake(0, 100, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT-115);
        contactPos = 50;
    }
    [_Scroller setFrame:Frame];
    [self.view addSubview:_Scroller];

    //CGSize Size = CGSizeMake(UI_SCREEN_WIDTH, 500.0f);
    CGSize Size = CGSizeMake(UI_SCREEN_WIDTH, 300.0f);
    
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
