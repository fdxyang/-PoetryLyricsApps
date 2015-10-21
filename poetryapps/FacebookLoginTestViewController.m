//
//  FacebookLoginTestViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2015/10/21.
//  Copyright © 2015年 cc. All rights reserved.
//

#import "FacebookLoginTestViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FacebookLoginTestViewController ()
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation FacebookLoginTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
