//
//  PoetryTabBarController.m
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/21.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "PoetryTabBarController.h"

@interface PoetryTabBarController ()

@end

@implementation PoetryTabBarController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
//    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor yellowColor]];
    //[self.tabBarController.tabBar set:[UIColor yellowColor]];

    [self assignTabColors];
}


- (void)assignTabColors
{
    NSLog(@"assignTabColors");
    self.tabBar.tintColor = [[UIColor alloc] initWithRed:(32/255.0f) green:(159/255.0f) blue:(191/255.0f)alpha:1];
    //self.tabBar.barTintColor = [[UIColor alloc] initWithRed:(32/255.0f) green:(159/255.0f) blue:(191/255.0f)alpha:1];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self assignTabColors];
}

@end
