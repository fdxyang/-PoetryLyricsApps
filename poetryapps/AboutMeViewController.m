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
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationItem.title = @"關於我";
    
    NSUInteger contactPos=0;
    
    CGRect Frame;
    if (IS_IPHONE5) {
        Frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT);
        contactPos = UI_SCREEN_4_INCH_HEIGHT-100;
    } else {
        Frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT);
        contactPos = UI_SCREEN_3_5_INCH_HEIGHT-100;
    }
    [_Scroller setFrame:Frame];
    [self.view addSubview:_Scroller];

    CGSize Size = CGSizeMake(UI_SCREEN_WIDTH, 2000.0f);
    
    [_Scroller setContentSize:Size];
    
    float teamlogo_x = 70.0;
    float teamlogo_y = 80.0;
    float teamlogo_width = 180.0;
    float teamlogo_height = 135.0;

    //logo
    UIImageView *teamLogo = [[UIImageView alloc] initWithFrame:CGRectMake(teamlogo_x, teamlogo_y, teamlogo_width, teamlogo_height)];
    [teamLogo setImage:[UIImage imageNamed:@"teamlogo.png"]];
    [_Scroller addSubview:teamLogo];
    
    UILabel *teamName = [[UILabel alloc]initWithFrame:CGRectMake(teamlogo_x+10, teamlogo_y+teamlogo_height,320, 60)];
    [teamName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30.0]];
    [teamName setText:@"Hippos Color"];
    [_Scroller addSubview:teamName];
    
    
    UILabel *teamYear = [[UILabel alloc]initWithFrame:CGRectMake(teamlogo_x+10+10, teamlogo_y+teamlogo_height+5+30+5, teamlogo_width-20-20, 30)];
    [teamYear setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]];
    teamYear.textColor = [UIColor grayColor];
    [teamYear setText:@"Since 2014"];
    [_Scroller addSubview:teamYear];
    
    UILabel *teamContact = [[UILabel alloc]initWithFrame:CGRectMake(5, contactPos, 310, 30)];
    [teamContact setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]];
    teamContact.backgroundColor = [UIColor grayColor];
    teamContact.textColor = [UIColor whiteColor];
    [teamContact setText:@"聯絡我們：hipposcolor@gmail.com"];
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
