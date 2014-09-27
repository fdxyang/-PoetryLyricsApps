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
    
    _buttonState = 0;
    
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
        scrollHeight = 500.0;
        uiviewHeight = UI_SCREEN_4_INCH_HEIGHT;
    } else {
        Frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_3_5_INCH_HEIGHT);
        contactPos = 10;
        scrollHeight = 500;
        uiviewHeight = UI_SCREEN_3_5_INCH_HEIGHT;
    }
    
    [_Scroller setFrame:Frame];
    [self.view addSubview:_Scroller];
    
    
    Size = CGSizeMake(UI_SCREEN_WIDTH, scrollHeight);
    
    [_Scroller setContentSize:Size];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aboutmebackground.png"]];
    
    UIView *aboutMeView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,uiviewHeight)];
    //[aboutMeView setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:221.0/255.0 blue:120.0/255.0 alpha:1.0]];
    [aboutMeView addSubview:background];
    
    UIImageView *introhippo = [[UIImageView alloc]initWithFrame:CGRectMake(35, 30, 250, 178)];
    [introhippo setImage:[UIImage imageNamed:@"introhippo.png"]];
    [aboutMeView addSubview:introhippo];
    
    UIImageView *abouthippo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 245, 180, 189)];
    [abouthippo setImage:[UIImage imageNamed:@"abouthippo.png"]];
    [aboutMeView addSubview:abouthippo];
    
    _fbfansBtn = [[UIButton alloc]initWithFrame:CGRectMake(230,225,50,50)];
    [_fbfansBtn setImage:[UIImage imageNamed:@"fbfans.png"] forState:UIControlStateNormal];
    [_fbfansBtn addTarget:self action:@selector(fbfansStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [aboutMeView addSubview:_fbfansBtn];
    
    _blogBtn = [[UIButton alloc]initWithFrame:CGRectMake(230,280,50,50)];
    [_blogBtn setImage:[UIImage imageNamed:@"blogicon.png"] forState:UIControlStateNormal];
    [_blogBtn addTarget:self action:@selector(blogStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [aboutMeView addSubview:_blogBtn];
    
    _rateBtn = [[UIButton alloc]initWithFrame:CGRectMake(230,335,50,50)];
    [_rateBtn setImage:[UIImage imageNamed:@"rateicon.png"] forState:UIControlStateNormal];
    [_rateBtn addTarget:self action:@selector(rateStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [aboutMeView addSubview:_rateBtn];
    
    _emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(230,390,50,50)];
    [_emailBtn setImage:[UIImage imageNamed:@"emailicon.png"] forState:UIControlStateNormal];
    [_emailBtn addTarget:self action:@selector(emailStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [aboutMeView addSubview:_emailBtn];
    
    
    
    /*
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
    
    _blogBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,230,70,70)];
    [_blogBtn setImage:[UIImage imageNamed:@"blogicon.png"] forState:UIControlStateNormal];
    [_blogBtn addTarget:self action:@selector(blogStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [aboutMeView addSubview:_blogBtn];
    
    _fbfansBtn = [[UIButton alloc]initWithFrame:CGRectMake(125,230,70,70)];
    [_fbfansBtn setImage:[UIImage imageNamed:@"fbfans.png"] forState:UIControlStateNormal];
    [_fbfansBtn addTarget:self action:@selector(fbfansStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [aboutMeView addSubview:_fbfansBtn];
    
    _emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(230,230,70,70)];
    [_emailBtn setImage:[UIImage imageNamed:@"emailicon.png"] forState:UIControlStateNormal];
    [_emailBtn addTarget:self action:@selector(emailStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [aboutMeView addSubview:_emailBtn];
    
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(100, 305, 120,120)];
    [logo setImage:[UIImage imageNamed:@"Teamlogotm.png"]];
    [aboutMeView addSubview:logo];
    */
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
                                              cancelButtonTitle:@"OK"
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
    
    /*
    // 先檢查是否有信箱帳號
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No e-mail account"
                                                        message:@"Please set your e-mail account first."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    // 建立物件並指定代理
    _mailComposeViewController = [[MFMailComposeViewController alloc] init];
    _mailComposeViewController.mailComposeDelegate = self;
    
    NSArray *toAddressList = @[@"hippocolors@gmail.com"];
    //NSArray *ccAddressList = @[@"happyman.cg@gmail.com"];
    //NSArray *bccAddressList = @[@"happyman.cg@gmail.com"];
    
    _mailComposeViewController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // 設定收件人與主旨等資訊
    [_mailComposeViewController setToRecipients:toAddressList];
    //[_mailComposeViewController setCcRecipients:ccAddressList];
    //[_mailComposeViewController setBccRecipients:bccAddressList];
    [_mailComposeViewController setSubject:@"給Hippo Colors 色河馬"];
    
    // 設定內文並且使用HTML語法
//    NSString *siteLink = @"http://cg2010studio.wordpress.com/";
//    NSString *blogLink = @"http://cg2010studio.wordpress.com/";
//    NSString *emailBody =
//    [NSString stringWithFormat:@"%@\n%@\n", siteLink, blogLink];
    
    [_mailComposeViewController setMessageBody:@"" isHTML:NO];
    
    // 加入圖片
//    UIImage *theImage = [UIImage imageNamed:@"cat pic.jpg"];
//    NSData *imageData = UIImageJPEGRepresentation(theImage, 1.0);
//    [mailComposeViewController addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"image.jpg"];
    
    // 顯示電子郵件畫面
    [self presentViewController:_mailComposeViewController animated:YES completion:nil];
     */
}

- (IBAction)rateStartBtn:(id)sender
{
    _buttonState = 4;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"是否要開啟Safari?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"確認", nil];
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
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:hippocolors@gmail.com?subject=Hi,HippoColors"]];
                break;
            case 4: // rate
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=819339914&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"]];
                break;
            default:
                break;
        }
    }
}

#pragma mark - MFMailComposeViewControllerDelegate Methods
/*
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // 根據回傳的結果決定對應的處理方式
    switch (result)
    {
        case MFMailComposeResultCancelled: // User Cancel 了
            break;
        case MFMailComposeResultSaved:  // User 儲存為草稿
            break;
        case MFMailComposeResultSent:  // Mail 成功寄出
            break;
        case MFMailComposeResultFailed:  // Mail 寄失敗
            break;
            
        default:
        {
            // 這邊你可以顯示一個 Alert 告訴 User 說 Mail 處理過程有問題
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                            message:@"Sending Failed - Unknown Error:("
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            break;
        }
    }
    // !!!!重要!!!! -> 不做這一行的話，Mail 視窗是不會消失的
    [self dismissViewControllerAnimated:YES completion:^{}];
}
 */
@end
