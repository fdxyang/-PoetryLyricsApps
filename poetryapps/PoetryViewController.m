//
//  PoetryViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/25.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "PoetryViewController.h"

@interface PoetryViewController ()

@end

@implementation PoetryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    //NSString *dataString = [mainBundle pathForResource:@"data" ofType:@"strings"];
    
    //NSLog(@"data string = %@",dataString);
    
    NSString *txtPath = [mainBundle pathForResource:@"data" ofType:@"txt"];
    
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",string);
    CGRect labelframe = CGRectMake(10, 10, 300, 480);
    UILabel *label = [[UILabel alloc] initWithFrame:labelframe];
    //    将sring内容赋给lable的text属性
    label.text=string;
    //  背景颜色设置成透明色
    label.backgroundColor = [UIColor clearColor];
    //    字体颜色设置成红色
    label.textColor= [UIColor redColor];
    //    设置lable文字左对齐显示
    //label.textAlignment = UITextAlignmentLeft;
    //    自动这行设置
    //label.lineBreakMode = UILineBreakModeCharacterWrap;
    //等于0表示可根据具实际情况自动变动
    label.numberOfLines = 0;
    
    [self.view addSubview:label];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
