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
    
    CGRect Frame;
    if (IS_IPHONE5) {
        Frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_4_INCH_HEIGHT);
    } else {
        Frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT);
    }
    [_Scroller setFrame:Frame];
    
    _TextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, UI_SCREEN_WIDTH, 0)];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    [_TextLabel setFont:font];
    _TextLabel.text = @"[聖詩本故事]\n聖詩是基督徒會使用到的工具，鑑於行動裝置的普及，推出聖詩本APP，可方便快速查詢聖詩及調節聖詩字體大小，讓基督教徒能夠更便利的使用。\n開發人員：Casper/Kevin/Joey/Lara\nHippos Color 河馬色\n致力於開發iOS APP\n做出我們想做的產品\n聯絡方法: hipposcolor@gmail.com";
    CGSize Size = CGSizeMake(UI_SCREEN_WIDTH, 2000.0f);
    
    Size = [_TextLabel sizeThatFits:Size];
    [_TextLabel setFrame:CGRectMake(_TextLabel.frame.origin.x, _TextLabel.frame.origin.y, UI_SCREEN_WIDTH, Size.height)];
    [_TextLabel setBackgroundColor:[UIColor redColor]];
    [_Scroller setContentSize:Size];
    NSLog(@"%@ - %@", _TextLabel, _Scroller);
/*
    [self.view addSubview:_Scroller];
    [_Scroller addSubview:_TextLabel];
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
