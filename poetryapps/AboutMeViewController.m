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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)blogStartBtn:(id)sender
{
     _buttonState = 1;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"是否要開啟Safari?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"確認", nil];
    alertView.delegate = self;
    [alertView show];
}

- (IBAction)fbfansStartBtn:(id)sender
{
    _buttonState = 2;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"是否要開啟Safari?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"確認", nil];
    alertView.delegate = self;
    [alertView show];
}

- (IBAction)emailStartBtn:(id)sender
{
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未設定信箱"
                                                        message:@"請確認信箱設定，或寄email至 hippocolors@gmail.com 謝謝！"
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    else
    {
        _buttonState = 3;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"是否要開啟Email?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"確認", nil];
        alertView.delegate = self;
        [alertView show];
    }
}

- (IBAction)rateStartBtn:(id)sender
{
    _buttonState = 4;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"訊息" message:@"來去評分，給我們一點鼓勵吧！！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"確認", nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"取消"])
    {
        NSLog(@"do nothing");
    }
    else if([title isEqualToString:@"確認"])
    {
        NSLog(@"do it");
        
        switch (_buttonState) {
            case 1://blog
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://hippocolors.blogspot.tw"]];
                break;
            case 2: // fb
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://m.facebook.com/hippocolors"]];
                break;
            case 3: //email
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:hippocolors@gmail.com?subject=Hi,HippoColors:poetry_2009_version_problems"]];
                break;
            case 4: // rate
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=819339914&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"]];
                break;
            default:
                break;
        }
    }
}

@end
