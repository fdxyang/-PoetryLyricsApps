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
    [self.view addSubview:_Scroller];

    CGSize Size = CGSizeMake(UI_SCREEN_WIDTH, 2000.0f);
    
    [_Scroller setContentSize:Size];

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
