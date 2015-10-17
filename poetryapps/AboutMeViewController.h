//
//  AboutMeViewController.h
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/11.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutMeViewController : UIViewController<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIButton      *blogBtn;
@property (nonatomic, strong) UIButton      *fbfansBtn;
@property (nonatomic, strong) UIButton      *emailBtn;
//@property (nonatomic, strong) UIButton      *rateBtn;
@property (nonatomic) NSInteger     buttonState;



- (IBAction)blogStartBtn:(id)sender;
- (IBAction)fbfansStartBtn:(id)sender;
- (IBAction)emailStartBtn:(id)sender;
//- (IBAction)rateStartBtn:(id)sender;

@end
